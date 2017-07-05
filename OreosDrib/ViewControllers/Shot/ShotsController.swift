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


/// 基础控制器 有待封装
class ShotsController: UIViewController, ListContainer {
    
    var listView: UIScrollView { return self.collectionView }
    
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
    
    private func configureViews() {
        
        view.backgroundColor = UIColor.white

        collectionView.dataSource = self
        
        collectionView.delegate   = self
        
        collectionView.backgroundColor = UIColor.white
        
        collectionViewLayout.minimumColumnSpacing = 10
        
        collectionViewLayout.minimumInteritemSpacing = 10
        
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, tabBarController?.tabBar.bounds.height ?? 0, 0))
        }
    }
    
    private func bindViewModel() {
        
        collectionView.es.addPullToRefresh { [weak self] in
            guard let _self = self else { return }
            
            _self.viewModel.loadFirstPageData()
        }
        
        collectionView.es.addInfiniteScrolling { [weak self] in
            guard let _self = self else { return }
            
            _self.viewModel.loadMoreData()
        }
        
        viewModel.firstPageSignal.observeResult { [weak self] (result) in
            guard let _self = self else { return }
            /**
             * 错误处理
             */
            if let _error = result.error {
                _self.alert(errorMsg: _error.message)
                return
            }
            
            _self.collectionView.reloadSections([0])
            
            _self.collectionView.es.stopPullToRefresh()
        }
        
        viewModel.loadMoreDataSignal.observeResult { [weak self] (result) in
            guard let _self = self else { return }
            /**
             * 错误处理
             */
            if let _error = result.error {
                _self.alert(errorMsg: _error.message)
                return
            }
            /**
             * 停止加载动画
             */
            _self.collectionView.es.stopLoadingMore()
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
}

extension ShotsController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.endUpdate()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.update()
    }
}

extension ShotsController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return viewModel.cellViewModels[indexPath.row].size
    }

    
}

struct ItemInfo {
    
    static var width: CGFloat {
        return (SystemInfo.screenSize.width - 30) / 2
    }
}

extension ShotsController {
    class ViewModel {
        
        var cellViewModels: [WaterFallCell.ViewModel] = []
        
        var list: ShotService.List = .all
        
        var timeFrame: ShotService.Timeframe = .now
        
        var sort: ShotService.Sort = .popularity
        
        var date: Date = Date()
        
        var currentPage: Int = 1
        
        var (firstPageSignal, firstPageObserver) = Signal<[IndexPath], ReactiveError>.pipe()

        var (loadMoreDataSignal, loadMoreDataObserver) = Signal<[IndexPath], ReactiveError>.pipe()
        
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
                    
                    _self.cellViewModels = result.value!.shots.map({ (shot) -> WaterFallCell.ViewModel in
                        
                        return WaterFallCell.ViewModel(width: ItemInfo.width, shot: shot)
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
                    
                        let originCount: Int = _self.cellViewModels.count
                        
                        let newViewModels: [WaterFallCell.ViewModel] = result.value!.shots.map({ (shot) -> WaterFallCell.ViewModel in
                            return WaterFallCell.ViewModel(width: ItemInfo.width, shot: shot)
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
                collectionView.register(cellViewModels[indexPath.row].cellClass, forCellWithReuseIdentifier: cellViewModels[indexPath.row].cellClass.description())
            }
            let _cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModels[indexPath.row].cellClass.description(), for: indexPath)
            _cell.viewModel = cellViewModels[indexPath.row]
            return _cell
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
