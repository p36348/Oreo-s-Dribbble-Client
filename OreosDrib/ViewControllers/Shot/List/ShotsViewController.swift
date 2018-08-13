//
//  ShotsViewController.swift
//  RacSwift
//
//  Created by P36348 on 27/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import SnapKit
import ESPullToRefresh
import AsyncDisplayKit
import IGListKit
import RxSwift
import RxCocoa


class ShotsController: ListSectionController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    override func didSelectItem(at index: Int) {
        
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext?.cellForItem(at: index, sectionController: self) ?? UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
        
    }
    
}

class ShotsViewController: UIViewController {
    
    let layout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
    
    let updater = ListAdapterUpdater()
    lazy var adapter: ListAdapter = {
        let _adapter = ListAdapter(updater: self.updater, viewController: self)
        _adapter.collectionView = self.collectionView
        _adapter.dataSource = self
        return _adapter
    }()
    
    let oauthButton: UIButton = UIButton(type: UIButtonType.system)
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.bindObservables()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShotsViewController {
    func setupUI() {
        self.view.addSubview(self.oauthButton)
        self.view.addSubview(self.collectionView)
    }
    
    func bindObservables() {
        
        // store -> view
        ShotService.shared.rx_shots
            .subscribe(onNext:  { [weak self] in self?.updateList(shots: $0) })
            .disposed(by: self.disposeBag)
        
        OAuthService.shared.rx_hasAccessToken
            .startWith(OAuthService.shared.hasAccessToken)
            .subscribe(onNext: {[weak self] in self?.switchContent(hasToken: $0)})
            .disposed(by: self.disposeBag)
        
        // store -> store
        OAuthService.shared.rx_accessToken
            .startWith(OAuthService.shared.accessToken)
            .flatMap { _ in ShotService.shared.reloadShots() }
            .subscribe()
            .disposed(by: self.disposeBag)
        
        // view -> store
        self.oauthButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .flatMap { _ in ShotService.shared.reloadShots()}
            .subscribe()
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx_pullToRefresh()
            .flatMap { _ in ShotService.shared.reloadShots()}
            .subscribe()
            .disposed(by: self.disposeBag)
    }
    
    func switchContent(hasToken: Bool) {
        self.oauthButton.isHidden = hasToken
        self.collectionView.isHidden = !hasToken
    }
    
    func updateList(shots: [Shot]) {
        self.adapter.performUpdates(animated: true) { (finished) in
            
        }
    }
}

extension ShotsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return ShotService.shared.shots
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ShotsController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


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


class ShotNormalCellNode: ASCellNode {
    
    var image: ASImageNode = ASImageNode()
    
    var like: ASButtonNode = ASButtonNode()
    
    var tag: ASImageNode = ASImageNode()
    
    override init() {
        super.init()
        self.backgroundColor = UIColor.white
    }
}

class ShotBigCellNode: ASCellNode {
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
