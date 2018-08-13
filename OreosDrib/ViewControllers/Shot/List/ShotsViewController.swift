//
//  ShotsViewController.swift
//  RacSwift
//
//  Created by P36348 on 27/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import SnapKit
import AsyncDisplayKit
import IGListKit
import RxSwift
import RxCocoa


class ShotsController: ListSectionController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext?.cellForItem(at: index, sectionController: self) ?? ShotNormalCell()
    }
    
    override func didUpdate(to object: Any) {
        
    }
    
}

enum ShotsDataType: Int {
    case oauthcated = 0, popular
}

func reloader(with type: ShotsDataType) -> Observable<ShotService> {
    switch type {
    case .oauthcated:
        return ShotService.shared.reloadShots()
    case .popular:
        return ShotService.shared.reloadPopShots()
    }
}

func loadMoreder(with type: ShotsDataType) -> Observable<ShotService> {
    switch type {
    case .oauthcated:
        return ShotService.shared.loadMoreShots()
    case .popular:
        return ShotService.shared.loadMorePopShots()
    }
}

class ShotsViewController: UIViewController {
    
    let segmented: UISegmentedControl = {
        let item = UISegmentedControl(items: ["My Shots", "Pop Shots"])
        item.selectedSegmentIndex = 0
        return item
    }()
    
    let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
       let _item = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        _item.backgroundColor = UIColor.white
        return _item
    }()
    
    let updater = ListAdapterUpdater()
    
    lazy var adapter: ListAdapter = {
        let _adapter = ListAdapter(updater: self.updater, viewController: self)
        _adapter.collectionView = self.collectionView
        _adapter.dataSource = self
        return _adapter
    }()
    
    let oauthButton: UIButton = {
       let _item = UIButton(type: UIButtonType.system)
        _item.setTitle("Signin from Dribbble.", for: UIControlState.normal)
        return _item
    }()
    
    let signoutButton: UIButton = {
        let _item = UIButton(type: UIButtonType.system)
        _item.setTitle("Signout", for: UIControlState.normal)
        return _item
    }()
    
    var currentType: ShotsDataType = .oauthcated
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.bindObservables()
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadData() {
        if OAuthService.shared.hasAccessToken {
            _ = reloader(with: ShotsDataType(rawValue: self.segmented.selectedSegmentIndex)!).subscribe()
        }
    }
}

extension ShotsViewController {
    func setupUI() {
        
        self.navigationItem.titleView = self.segmented
        
        self.view.addSubview(self.oauthButton)
        self.view.addSubview(self.collectionView)
        
        self.oauthButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    /// bind observables with service service
    func bindObservables() {

        // service -> view
        OAuthService.shared.rx_hasAccessToken
            .startWith(OAuthService.shared.hasAccessToken)
            .subscribe(onNext: {[weak self] in self?.switchContent(hasToken: $0)})
            .disposed(by: self.disposeBag)
        
        ShotService.shared.rx_shots
            .flatMap { [unowned self] in self.updateList(shots: $0) }
            .flatMap { $0.collectionView.rx_stopLoading() }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        ShotService.shared.rx_popShots
            .flatMap { [unowned self] in self.updateList(shots: $0) }
            .flatMap { $0.collectionView.rx_stopLoading() }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        // service&view -> service
        Observable.combineLatest(OAuthService.shared.rx_hasAccessToken, self.segmented.rx.value)
            .filter {$0.0}
            .subscribe(onNext: {[weak self] in self?.reloadList(ShotsDataType(rawValue: $0.1)!)})
            .disposed(by: self.disposeBag)
        
        // view -> service
        self.oauthButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in OAuthService.shared.doOAuth() })
            .disposed(by: self.disposeBag)
        
        self.signoutButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in
                OAuthService.shared.clearToken()
            })
            .disposed(by: self.disposeBag)
        
        self.segmented.rx.value
            .subscribe(onNext: { index in
                
            })
            .disposed(by: self.disposeBag)
        
//        self.segmented.rx.isEnabled
        
        self.collectionView.rx_pullToRefresh()
            .subscribe(onNext: { [unowned self] in
                self.reloadList(ShotsDataType(rawValue: self.segmented.selectedSegmentIndex)!)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx_pullToLoadMore()
            .subscribe(onNext: { [unowned self] in
                self.loadMoreList(ShotsDataType(rawValue: self.segmented.selectedSegmentIndex)!)
            })
            .disposed(by: self.disposeBag)
        
        
        
    }
    
    func switchContent(hasToken: Bool) {
        self.oauthButton.isHidden = hasToken
        self.collectionView.isHidden = !hasToken
        self.navigationItem.titleView = hasToken ? self.segmented : nil
        self.navigationItem.rightBarButtonItem = hasToken ? UIBarButtonItem(customView: self.signoutButton) : nil
    }
    
    func reloadList(_ type: ShotsDataType) {
        _ = reloader(with: type).subscribe()
    }
    
    func loadMoreList(_ type: ShotsDataType) {
        _ = loadMoreder(with: type).subscribe()
    }
    
    func updateList(shots: [Shot]) -> Observable<ShotsViewController> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            self?.adapter.performUpdates(animated: true) { (finished) in
                
                if let _self = self {
                    return observer.onNext(_self)
                }else {
                    observer.onError(NSError())
                }
            }
            return Disposables.create()
        })
        
    }
}

// MARK: - ShotsViewController extension ListAdapterDataSource
extension ShotsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return ShotService.shared.shots
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ShotsController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel()
        label.text = "No Data Yet."
        return label
    }
}


// MARK: - Shot extension ListDiffable
extension Shot: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let _object = object as? Shot {
            return id == _object.id
        }
        return false
    }
}


/// MARK: - cell config

class ShotNormalCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(frame: CGRect.zero)
    }
}

class ShotLargeCell: UICollectionViewCell {
    
}

/// MARK: - cell node config
class ShotNormalCellNode: ASCellNode {
    
    var image: ASImageNode = ASImageNode()
    
    var like: ASButtonNode = ASButtonNode()
    
    var tag: ASImageNode = ASImageNode()
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.white
    }
}

class ShotLargeCellNode: ASCellNode {
    var image: ASImageNode = ASImageNode()
    
    var like: ASButtonNode = ASButtonNode()
    
    var tag: ASImageNode = ASImageNode()
    
    var title: ASTextNode = ASTextNode()
    override init() {
        super.init()
        self.backgroundColor = UIColor.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 5, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.center, flexWrap: ASStackLayoutFlexWrap.wrap, alignContent: ASStackLayoutAlignContent.start, children: [self.image, self.like, self.tag, self.title])
    }
}