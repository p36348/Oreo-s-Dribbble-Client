//
//  IndexViewController.swift
//  OreosDrib
//
//  Created by P36348 on 14/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit

class IndexViewController: UIViewController {
    
    let segmented: UISegmentedControl = {
        let item = UISegmentedControl(items: ["Pop Shots", "My Shots"])
        item.selectedSegmentIndex = 0
        item.tintColor = UIColor.Dribbble.pink
        return item
    }()
    
    let signinButton: UIButton = {
        let _item = UIButton(type: UIButtonType.system)
        _item.setAttributedTitle("Signin from Dribbble.".attributed([.textColor(UIColor.Dribbble.pink)]), for: UIControlState.normal)
        return _item
    }()
    
    let signoutButton: UIButton = {
        let _item = UIButton(type: UIButtonType.system)
        _item.setAttributedTitle("Signout".attributed([.textColor(UIColor.Dribbble.pink)]), for: UIControlState.normal)
        return _item
    }()
    
    let actionItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: nil, action: nil)
        item.tintColor = UIColor.Dribbble.pink
        return item
    }()
    
    let popShotsController: ShotsViewController = ShotsViewController()
    
    let oauthcatedUserShotsController: ShotsViewController = ShotsViewController()
    
    lazy var controllers: [ShotsViewController] = [self.popShotsController, self.oauthcatedUserShotsController]
    
    var currentViewController: ShotsViewController {
        return self.controllers[self.segmented.selectedSegmentIndex]
    }
    
    var currentType: ShotsDataType {
        return ShotsDataType(rawValue: self.segmented.selectedSegmentIndex)!
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindObservables()
    }
    
    func setupUI() {
        self.signinButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in OAuthService.shared.doOAuth() })
            .disposed(by: self.disposeBag)
        
        self.signoutButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in OAuthService.shared.clearToken() })
            .disposed(by: self.disposeBag)
        
        self.navigationItem.titleView = self.segmented
        self.navigationItem.rightBarButtonItem = self.actionItem
        self.addChildViewController(self.currentViewController)
        self.currentViewController.didMove(toParentViewController: self)
        self.view.addSubview(self.currentViewController.view)
        
        self.oauthcatedUserShotsController.view.addSubview(self.signinButton)
        self.signinButton.snp.makeConstraints({$0.center.equalToSuperview()})
    }
    
    func bindObservables() {
        // service -> view
        // 收集最新的认证数据, 根据是否认证更新可操作UI元素
        OAuthService.shared.rx_hasAccessToken
            .startWith(OAuthService.shared.hasAccessToken)
            .subscribe(onNext: {[weak self] in self?.switchUI(hasToken: $0)})
            .disposed(by: self.disposeBag)
        
        OAuthService.shared.rx_hasAccessToken
            .bind(to: self.signinButton.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        OAuthService.shared.rx_hasAccessToken.map({!$0})
            .bind(to: self.oauthcatedUserShotsController.collectionView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // view -> service
        self.popShotsController.rx_pullToReload
            .subscribe(onNext: { _ in
                _ = ShotService.shared.reloadPopShots().subscribe()
            })
            .disposed(by: self.disposeBag)
        
        self.popShotsController.rx_pullToLoadMore
            .subscribe(onNext: {_ in
                _ = ShotService.shared.loadMorePopShots().subscribe()
            })
            .disposed(by: self.disposeBag)
        
        self.oauthcatedUserShotsController.rx_pullToReload
            .subscribe(onNext: { _ in
                _ = ShotService.shared.reloadShots().subscribe()
            })
            .disposed(by: self.disposeBag)
        
        self.oauthcatedUserShotsController.rx_pullToLoadMore
            .subscribe(onNext: {_ in
                _ = ShotService.shared.loadMoreShots().subscribe()
            })
            .disposed(by: self.disposeBag)
        
        // service & view state -> service
        // 收集最新的认证数据, 如果认证通过则刷新数据
        OAuthService.shared.rx_hasAccessToken
            .filter({$0})
            .subscribe(onNext: { [weak self] _ in
                _ = self?.currentViewController.performReload().subscribe()
            })
            .disposed(by: self.disposeBag)
        
        // 收集pop shots的最新数据以及用户的最新选择, 匹配则更新列表
        Observable.combineLatest(ShotService.shared.rx_popShots, self.segmented.rx.value)
            .filter { $0.1 == ShotsDataType.popular.rawValue }
            .flatMap { [unowned self] in self.popShotsController.updateList(with: [createNormalSectionViewModel(shots: $0.0)]) }
            .flatMap { $0.collectionView.rx_stopLoading() }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(ShotService.shared.rx_shots, self.segmented.rx.value)
            .filter  { $0.1 == ShotsDataType.oauthcated.rawValue }
            .flatMap { [unowned self] in self.oauthcatedUserShotsController.updateList(with: [createNormalSectionViewModel(shots: $0.0)]) }
            .flatMap { $0.collectionView.rx_stopLoading() }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        self.segmented.rx.value
            .subscribe(onNext: { [weak self] value in
                switch value {
                case ShotsDataType.oauthcated.rawValue:
                    self?.switchList(with: .oauthcated)
                case ShotsDataType.popular.rawValue:
                    self?.switchList(with: .popular)
                default:
                    break
                }
            })
            .disposed(by: self.disposeBag)
        
        // 单独响应用户切换显示类型的操作, 如果对应的类型没有数据, 要尝试从网络加载. (如果已经有数据, 只需要加载内存中的数据, 已经在上方实现)
        self.segmented.rx.value
            .map { ShotsDataType(rawValue: $0)! }
            .filter({ $0 == ShotsDataType.oauthcated && ShotService.shared.shots.count == 0 })
            .subscribe(onNext: { [weak self] _ in
                self?.oauthcatedUserShotsController.collectionView.mj_header?.beginRefreshing()
            })
            .disposed(by: self.disposeBag)
        
        self.segmented.rx.value
            .map { ShotsDataType(rawValue: $0)!}
            .filter({ $0 == ShotsDataType.popular && ShotService.shared.popShots.count == 0 })
            .subscribe(onNext: { [weak self] _ in
                self?.popShotsController.collectionView.mj_header?.beginRefreshing()
            })
            .disposed(by: self.disposeBag)
    }
    
    func switchList(with type: ShotsDataType) {
        var from: UIViewController
        var to: UIViewController
        switch type {
        case .popular:
            from = self.oauthcatedUserShotsController
            to = self.popShotsController
        case .oauthcated:
            from = self.popShotsController
            to = self.oauthcatedUserShotsController
        }
        guard to.parent == nil, from.parent == self else {return}
        self.addChildViewController(to)
        self.transition(from: from, to: to, duration: 0.25, options: UIViewAnimationOptions.autoreverse,
                        animations: {
                            
        },
                        completion: { [weak self] finished in
                            to.didMove(toParentViewController: self)
                            from.willMove(toParentViewController: nil)
                            from.removeFromParentViewController()
        })
    }
    
    func switchUI(hasToken: Bool) {
        self.signinButton.isHidden = hasToken
//        self.collectionView.isHidden = !hasToken
        self.navigationItem.leftBarButtonItem = hasToken ? UIBarButtonItem(customView: self.signoutButton) : nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


private var normalCellWidth: CGFloat {
    let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    if screenWidth <= 500 {return (screenWidth-10-5)/2}
    else if screenWidth <= 1024 {return (screenWidth-10-20)/5}
    else {return 200}
}

func createNormalSectionViewModel(shots: [Shot]) -> NormalShotsSectionViewModel {
    let item = NormalShotsSectionViewModel()
    item.normalCellViewModels = shots.map{NormalShotCellViewModel(shot: $0, width: normalCellWidth)}
    return item
}
