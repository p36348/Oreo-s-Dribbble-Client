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


class ShotsViewController: UIViewController {
    
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
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var data: [ListDiffable] = []
    
    var rx_pullToReload: Observable<ShotsViewController?> {
       return self.collectionView.rx_pullToRefresh.map({[weak self] _ in self})
    }
    
    var rx_pullToLoadMore: Observable<ShotsViewController?> {
        return self.collectionView.rx_pullToLoadMore.map({[weak self] _ in self})
    }
    
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
        self.collectionView.mj_header?.beginRefreshing()
    }
}

extension ShotsViewController {
    func setupUI() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// bind observables with service service
    func bindObservables() {
        
    }
    
    func performReload() -> Observable<ShotsViewController> {
        return self.collectionView.rx_beginReload().map({[unowned self] _ in self})
    }

    func performLoadMore() -> Observable<ShotsViewController> {
        return self.collectionView.rx_beginLoadMore().map({[unowned self] _ in self})
    }
    
    func updateList(with _data: [ListDiffable]) -> Observable<ShotsViewController> {
        self.data = _data
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
        return "shots_normal" as NSString
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
    // 4:3
    var imageUrl: String
    
    var image_frame: CGRect
    
    var title: NSAttributedString
    
    var title_frame: CGRect
    
    var size: CGSize

    init(shot: Shot, width: CGFloat) {
        self.imageUrl = shot.images?.teaser ?? ""
        self.image_frame = CGRect(x: 0, y: 0, width: width, height: width*3/4)
        self.title = shot.title.attributed()
        let title_height = self.title.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).height
        self.title_frame = CGRect(x: 0, y: self.image_frame.maxY+10, width: width, height: title_height)

        self.size = CGSize(width: width, height: self.title_frame.maxY+10)
    }
    public static func == (lhs: NormalShotCellViewModel, rhs: NormalShotCellViewModel) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.title == rhs.title && lhs.size == rhs.size
    }
}

class LargeShotsSectionViewModel: ListDiffable {
    
    var largeCellViewModels: [ShotLargeCellViewModel] = []
    
    func diffIdentifier() -> NSObjectProtocol {
        return "shots_large" as NSString
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
    // 4:3
    var imageUrl: String
    
    var image_frame: CGRect
    
    var title: NSAttributedString
    
    var title_frame: CGRect
    
    var comment: NSAttributedString
    
    var comment_frame: CGRect
    
    var size: CGSize
    
    init(shot: Shot, width: CGFloat) {
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
    public static func == (lhs: ShotLargeCellViewModel, rhs: ShotLargeCellViewModel) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.title == rhs.title && lhs.size == rhs.size
    }
}
