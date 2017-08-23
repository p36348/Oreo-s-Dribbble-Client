//
//  ShotsController.swift
//  RacSwift
//
//  Created by P36348 on 27/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import SnapKit
import Result
import ReactiveSwift
import CHTCollectionViewWaterfallLayout
import ESPullToRefresh

/// 基础控制器 有待封装
class ShotsController: UIViewController {
    
    
    fileprivate let viewModel: ViewModel = ViewModel()
    
    fileprivate let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: CHTCollectionViewWaterfallLayout())
    
    var collectionViewLayout: CHTCollectionViewWaterfallLayout {
        return collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        
        bindViewModel()
        
        viewModel.loadFirstPageData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShotsController {
    fileprivate func configureViews() {
        
        view.backgroundColor = UIColor.white
        
        collectionView.dataSource = self
        
        collectionView.delegate   = self
        
        collectionView.backgroundColor = UIColor.Dribbble.charcoal
        
        collectionViewLayout.minimumColumnSpacing = 10
        
        collectionViewLayout.minimumInteritemSpacing = 10
        
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, tabBarController?.tabBar.bounds.height ?? 0, 0))
        }
    }
    
    /**
     绑定事件
     */
    fileprivate func bindViewModel() {
        collectionView.es_addPullToRefresh { [weak self] in
            guard let _self = self else { return }
            
            _self.viewModel.loadFirstPageData()
        }
        
        collectionView.es_addInfiniteScrolling { [weak self] in
            guard let _self = self else { return }
            
            _self.viewModel.loadMoreData()
        }
        
        viewModel.firstPageSignal.observeResult { [weak self] (result) in
            guard let _self = self else { return }
            /**
             * 错误处理
             */
            if let _error = result.error { return _self.oAlert.alert(errorMsg: _error.message) }
            
            _self.collectionView.reloadSections([0])
            
            _self.collectionView.es_stopPullToRefresh()
        }
        
        viewModel.loadMoreDataSignal.observeResult { [weak self] (result) in
            guard let _self = self else { return }
            /**
             * 错误处理
             */
            if let _error = result.error { return _self.oAlert.alert(errorMsg: _error.message) }
            /**
             * 停止加载动画
             */
            _self.collectionView.es_stopLoadingMore()
            /**
             * 数据更新
             */
            let updates: () -> Void = {
                _self.collectionView.insertItems(at: result.value!)
            }
            
            let completion: (Bool) -> Void = { (finished) in
                
            }
            
            _self.collectionView.performBatchUpdates(updates, completion: completion)
        }
        
        viewModel.reloadSignal.observeCompleted { [weak self] in
            guard let _self = self else { return }
            
            _self.collectionView.reloadSections([0])
        }
        
        OAuthService.shared.authorizeTokenSignal.observeResult({ [weak self] (result) in
            self?.viewModel.loadFirstPageData()
        })
    }
}

extension ShotsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return self.viewModel.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}

extension ShotsController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _controller = ShotDetailController()
        
        _controller.configure(with: viewModel.shots[indexPath.row])
        
        navigationController?.pushViewController(_controller, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModels[indexPath.row].endUpdate(reusableView: cell)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.cellViewModels[indexPath.row].update(reusableView: cell)
    }
}

extension ShotsController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return viewModel.cellViewModels[indexPath.row].size
    }
}

struct ItemInfo {
    
    static var minimalWidth: CGFloat {
        return 400
    }
    
    static var width: CGFloat {
        return (kScreenWidth - 30) / 2
    }
}

extension ShotsController {
    class ViewModel {
        
        var shots: [Shot] = []
        
        var cellViewModels: [ShotCell.ViewModel] = []
        
        var list: ShotService.List = .all
        
        var timeFrame: ShotService.Timeframe = .now
        
        var sort: ShotService.Sort = .popularity
        
        var date: Date = Date()
        
        var currentPage: Int = 1
        
        var (firstPageSignal, firstPageObserver) = Signal<[IndexPath], ReactiveError>.pipe()

        var (loadMoreDataSignal, loadMoreDataObserver) = Signal<[IndexPath], ReactiveError>.pipe()
        
        var (reloadSignal, reloadObserver) = Signal<String, NoError>.pipe()
        
        init() {
            /**
             * 第一页网络请求完成
             */
            ShotService.shared.shotListSignal.filter { (result) -> Bool in
                return result.page == 1
            }.observeResult { [weak self] (result) in
                guard let _self = self else { return }
                
                if let _error = result.error { return _self.firstPageObserver.send(error: _error) }
                
                DispatchQueue.global(qos: .background).async {
                    
                    _self.shots = result.value!.shots
                    
                    _self.cellViewModels = result.value!.shots.map({ (shot) -> ShotCell.ViewModel in
                        
                        return ShotCell.ViewModel(width: ItemInfo.width, shot: shot)
                    })
                    
                    var indexPaths: [IndexPath] = []
                    
                    (0..<_self.cellViewModels.count).forEach { (index) in
                        indexPaths.append(IndexPath(item: index, section: 0))
                    }
                    
                    DispatchQueue.main.sync {
                        _self.firstPageObserver.send(value: indexPaths)
                    }
                }
                
                
            }
            
            /**
             * 翻页网络请求完成
             */
            ShotService.shared.shotListSignal.filter {(result) -> Bool in
                return result.page != 1
                }.observeResult { [weak self] (result) in
                    guard let _self = self else { return }
                    
                    if let _error = result.error { return _self.loadMoreDataObserver.send(error: _error) }
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        _self.shots = _self.shots + result.value!.shots
                    
                        let originCount: Int = _self.cellViewModels.count
                        
                        let newViewModels: [ShotCell.ViewModel] = result.value!.shots.map({ (shot) -> ShotCell.ViewModel in
                            return ShotCell.ViewModel(width: ItemInfo.width, shot: shot)
                        })
                        
                        var indexPaths: [IndexPath] = []
                        (0..<newViewModels.count).forEach { (index) in
                            indexPaths.append(IndexPath(item: originCount + index, section: 0))
                        }
                        
                        _self.cellViewModels = _self.cellViewModels + newViewModels
                        
                        DispatchQueue.main.sync {
                            _self.loadMoreDataObserver.send(value: indexPaths)
                        }
                    }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView.cellForItem(at: indexPath) == nil {
                collectionView.register(cellViewModels[indexPath.row].viewClass, forCellWithReuseIdentifier: cellViewModels[indexPath.row].identifier)
            }
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModels[indexPath.row].identifier, for: indexPath)
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView  {
            
            
            let _view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "", for: indexPath)
            
            return _view
        }
        
        func loadFirstPageData() {
            self.currentPage = 1
            self.fetchData()
        }
        
        func loadMoreData() {
            self.currentPage += 1
            self.fetchData()
        }
        
        func fetchData() {
            let _ = ShotService.shared.getList(page: currentPage, list: list, timeframe: timeFrame, sort: sort, date: self.date)
        }
    }
}
