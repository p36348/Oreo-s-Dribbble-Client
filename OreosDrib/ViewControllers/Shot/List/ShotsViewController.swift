//
//  ShotsViewController.swift
//  RacSwift
//
//  Created by P36348 on 27/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit
import RxSwift
import RxCocoa
import Kingfisher

class NormalShotsSectionController: ListSectionController, ListDisplayDelegate {
    
    var viewModels: [NormalShotCellViewModel] = []
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.minimumLineSpacing = 5
        self.minimumInteritemSpacing = 5
        self.displayDelegate = self
    }
    
    override func numberOfItems() -> Int {
        return self.viewModels.count
    }
    
    override func didUpdate(to object: Any) {
        guard let sectionViewModel = object as? NormalShotsSectionViewModel else {return}
        self.viewModels = sectionViewModel.normalCellViewModels
    }
    
    // MARK: ShotsController: ListSectionController
    override func sizeForItem(at index: Int) -> CGSize {
        return self.viewModels[index].size
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return self.collectionContext?.dequeueReusableCell(of: ShotNormalCell.classForCoder(), withReuseIdentifier: "ShotNormalCell", for: self, at: index) ?? ShotNormalCell()
    }
    
    // MARK: ShotsController: ListDisplayDelegate
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        if let _cell = cell as? ShotNormalCell {
            let _viewModel = self.viewModels[index]
            _cell.title_label.attributedText = _viewModel.title
            _cell.title_label.frame = _viewModel.title_frame
            _cell.image.kf.setImage(with: URL(string: _viewModel.imageUrl))
            _cell.image.frame = _viewModel.image_frame
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {

    }
    
    
}

class LargeShotsSectionController: ListSectionController, ListDisplayDelegate {
    var viewModels: [ShotLargeCellViewModel] = []
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.minimumLineSpacing = 5
        self.displayDelegate = self
    }
    
    override func didUpdate(to object: Any) {
        guard let sectionViewModel = object as? LargeShotsSectionViewModel else {return}
        self.viewModels = sectionViewModel.largeCellViewModels
    }
    
    override func numberOfItems() -> Int {
        return self.viewModels.count
    }
    
    // MARK: ShotsController: ListSectionController
    
    
    override func sizeForItem(at index: Int) -> CGSize {
            return self.viewModels[index].size
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return self.collectionContext?.dequeueReusableCell(of: ShotNormalCell.classForCoder(), withReuseIdentifier: "ShotLargeCell", for: self, at: index) ?? ShotLargeCell()
    }
    
    // MARK: ShotsController: ListDisplayDelegate
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        if let _cell = cell as? ShotLargeCell {
            let _viewModel = self.viewModels[index]
            _cell.title_label.attributedText = _viewModel.title
            _cell.title_label.frame = _viewModel.title_frame
            _cell.image.kf.setImage(with: URL(string: _viewModel.imageUrl))
            _cell.image.frame = _viewModel.image_frame
            _cell.comment_label.attributedText = _viewModel.comment
            _cell.comment_label.frame = _viewModel.comment_frame
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        
    }
}

enum ShotsDataType: Int {
    case popular = 0, oauthcated = 1
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



/**
 快照列表:
 用一个collection view来显示两种类型的快照, 需要考虑 <页面操作状态, 页面加载状态, 数据状态> 来更新界面;
 追求场景严谨, 使用RxSwift进行模块之间的数据通信.
 */
class ShotsViewController: UIViewController {
    
    let segmented: UISegmentedControl = {
        // let item = UISegmentedControl(items: ["Pop Shots", "My Shots"])
        let item = UISegmentedControl(items: ["Pop Shots"])
        item.tintColor = UIColor.Dribbble.pink
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
        _item.setAttributedTitle("Signin from Dribbble.".attributed([.textColor(UIColor.Dribbble.pink)]), for: UIControlState.normal)
        return _item
    }()
    
    let signoutButton: UIButton = {
        let _item = UIButton(type: UIButtonType.system)
        _item.setAttributedTitle("Signout".attributed([.textColor(UIColor.Dribbble.pink)]), for: UIControlState.normal)
        return _item
    }()
    
    var currentType: ShotsDataType {
        return ShotsDataType(rawValue: self.segmented.selectedSegmentIndex)!
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var data: [ListDiffable] = []
    
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
        // 收集最新的认证数据, 根据是否认证更新可操作UI元素
        OAuthService.shared.rx_hasAccessToken
            .startWith(OAuthService.shared.hasAccessToken)
            .subscribe(onNext: {[weak self] in self?.switchUI(hasToken: $0)})
            .disposed(by: self.disposeBag)
        
        // service & view state -> service
        // 收集最新的认证数据, 如果认证通过则刷新数据
        OAuthService.shared.rx_hasAccessToken
            .filter {$0}
            .subscribe(onNext: {[weak self] _ in
                if let _self = self {
                    _self.reloadData(_self.currentType)
                }
            })
            .disposed(by: self.disposeBag)
        
        // service&view -> view
        // 收集shots的最新数据以及用户的最新选择, 匹配则更新列表
//        Observable.combineLatest(ShotService.shared.rx_shots, self.segmented.rx.value)
//            .filter {$0.1 == ShotsDataType.oauthcated.rawValue}
//            .map { [unowned self] params -> [ShotNormalCellViewModel] in
//                self.viewModel.normalCellViewModels = params.0.map{shot in ShotNormalCellViewModel(shot: shot, width: 200)}
//                return self.viewModel.normalCellViewModels
//            }
//            .flatMap { [unowned self] _ in self.updateList() }
//            .flatMap { $0.collectionView.rx_stopLoading() }
//            .subscribe()
//            .disposed(by: self.disposeBag)
        
        // 收集pop shots的最新数据以及用户的最新选择, 匹配则更新列表
        Observable.combineLatest(ShotService.shared.rx_popShots, self.segmented.rx.value)
            .filter {$0.1 == ShotsDataType.popular.rawValue}
            .map { [unowned self] params -> [ListDiffable] in
                self.data = [createSectionViewModel(shots: params.0)]
                return self.data
            }
            .flatMap { [unowned self] _ in self.updateList() }
            .flatMap { $0.collectionView.rx_stopLoading() }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        
        // view -> service
        self.oauthButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in OAuthService.shared.doOAuth() })
            .disposed(by: self.disposeBag)
        
        self.signoutButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { _ in OAuthService.shared.clearToken() })
            .disposed(by: self.disposeBag)
        
        // 单独响应用户切换显示类型的操作, 如果对应的类型没有数据, 要尝试从网络加载. (如果已经有数据, 只需要加载内存中的数据, 已经在上方实现)
        self.segmented.rx.value
            .map { ShotsDataType(rawValue: $0)!}
            .subscribe(onNext: { [weak self] type in
                if
                    type == ShotsDataType.oauthcated && ShotService.shared.shots.count == 0
                        ||
                        type == ShotsDataType.popular && ShotService.shared.shots.count == 0
                {
                    self?.collectionView.mj_header?.beginRefreshing()
                }
            })
            .disposed(by: self.disposeBag)
        
        // 当前正在刷新数据的时候让类型切换交互关闭
        self.collectionView.rx_refreshing
            .map{!$0}.bind(to: self.segmented.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx_pullToRefresh()
            .subscribe(onNext: { [unowned self] in
                self.reloadData(self.currentType)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx_pullToLoadMore()
            .subscribe(onNext: { [unowned self] in
                self.loadMoreData(self.currentType)
            })
            .disposed(by: self.disposeBag)
    }
    
    func switchUI(hasToken: Bool) {
        self.oauthButton.isHidden = hasToken
        self.collectionView.isHidden = !hasToken
        self.navigationItem.titleView = hasToken ? self.segmented : nil
        self.navigationItem.leftBarButtonItem = hasToken ? UIBarButtonItem(customView: self.signoutButton) : nil
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: nil, action: nil)
        item.tintColor = UIColor.Dribbble.pink
        self.navigationItem.rightBarButtonItem = item
    }
    
    func reloadData(_ type: ShotsDataType) {
        _ = reloader(with: type).subscribe(onError: { [weak self] _ in
            self?.collectionView.stopLoading()
        })
    }
    
    func loadMoreData(_ type: ShotsDataType) {
        _ = loadMoreder(with: type)
            .subscribe(onError: { [weak self] _ in
                self?.collectionView.stopLoading()
            })
    }
    
    func updateList() -> Observable<ShotsViewController> {
        
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

private var normalCellWidth: CGFloat {
    let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    if screenWidth <= 500 {return (screenWidth-10-5)/2}
    else if screenWidth <= 1024 {return (screenWidth-10-15)/4}
    else {return 200}
}


func createSectionViewModel(shots: [Shot]) -> NormalShotsSectionViewModel {
    let item = NormalShotsSectionViewModel()
    item.normalCellViewModels = shots.map{NormalShotCellViewModel(shot: $0, width: normalCellWidth)}
    return item
}

// MARK: - ShotsViewController extension ListAdapterDataSource
extension ShotsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is NormalShotsSectionViewModel {
            return NormalShotsSectionController()
        }
        if object is LargeShotsSectionViewModel {
            return NormalShotsSectionController()
        }
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel()
        label.attributedText = "No Data Yet.".attributed([.paragraphStyle(lineSpacing: 0, alignment: .center)])
        return label
    }
}

class NormalShotsSectionViewModel: ListDiffable {
    
    var normalCellViewModels: [NormalShotCellViewModel] = []
    
    func diffIdentifier() -> NSObjectProtocol {
        return "shots" as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let _obj = object as? NormalShotsSectionViewModel else {
            return false
        }
        guard self.normalCellViewModels.count == _obj.normalCellViewModels.count else {return false}
        for (index, viewModel) in _obj.normalCellViewModels.enumerated() {
            if self.normalCellViewModels[index] != viewModel {
                return false
            }
        }
        return true
    }
}


struct NormalShotCellViewModel: Equatable {
    var id: String
    // 4:3
    var imageUrl: String
    
    var image_frame: CGRect
    
    var title: NSAttributedString
    
    var title_frame: CGRect
    
    var comment: NSAttributedString
    
    var comment_frame: CGRect
    
    var size: CGSize

    init(shot: Shot, width: CGFloat) {
        self.id = shot.id
        self.imageUrl = shot.images?.teaser ?? ""
        self.image_frame = CGRect(x: 0, y: 0, width: width, height: width*3/4)
        self.title = shot.title.attributed()
        let title_height = self.title.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
        self.title_frame = CGRect(x: 0, y: self.image_frame.maxY+10, width: width, height: title_height)
        
        self.comment = shot.comment.attributed()
        let comment_height = self.comment.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
        self.comment_frame = CGRect(x: 0, y: self.title_frame.maxY+10, width: width, height: comment_height)
        self.size = CGSize(width: width, height: self.title_frame.maxY+10)
    }
    public static func == (lhs: NormalShotCellViewModel, rhs: NormalShotCellViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.imageUrl == rhs.imageUrl && lhs.title == rhs.title && lhs.size == rhs.size
    }
}

class LargeShotsSectionViewModel: ListDiffable {
    
    var largeCellViewModels: [ShotLargeCellViewModel] = []
    
    func diffIdentifier() -> NSObjectProtocol {
        return "shots" as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let _obj = object as? LargeShotsSectionViewModel else {
            return false
        }
        guard self.largeCellViewModels.count == _obj.largeCellViewModels.count else {return false}
        for (index, viewModel) in _obj.largeCellViewModels.enumerated() {
            if self.largeCellViewModels[index] != viewModel {
                return false
            }
        }
        return true
    }
}

struct ShotLargeCellViewModel: Equatable {
    var id: String
    // 4:3
    var imageUrl: String
    
    var image_frame: CGRect
    
    var title: NSAttributedString
    
    var title_frame: CGRect
    
    var comment: NSAttributedString
    
    var comment_frame: CGRect
    
    var size: CGSize
}
