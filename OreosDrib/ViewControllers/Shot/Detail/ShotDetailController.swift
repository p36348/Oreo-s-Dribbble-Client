//
//  ShotDetailController.swift
//  OreosDrib
//
//  Created by P36348 on 28/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import Kingfisher
import ReactiveSwift
import Result

class ShotDetailController: UIViewController {
    
    public fileprivate(set) var viewModel: ViewModel!
    
    fileprivate var tableHeader: AnimatedImageView = AnimatedImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth * 3 / 4))
    
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    func configure(with shot: Shot) {
        viewModel = ViewModel(shot: shot)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubview()
        
        bindViewModel()
        
        viewModel.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubview() {
        view.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(clickRightItem(sender:)))
        
        tableHeader.needsPrescaling = false
        
        tableHeader.kf.indicatorType = .activity
        
        tableHeader.runLoopMode = .defaultRunLoopMode
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableHeaderView = tableHeader
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.register(AuthorInfoCell.self, forCellReuseIdentifier: AuthorInfoCell.description())
        
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: DescriptionCell.description())
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    dynamic private func clickRightItem(sender: UIBarButtonItem){
        
        let shareAction: ()->Void = {
            
        }
        self.oAlert.alertActionSheet(sheetTitles: ["Share"], sheetActions: [shareAction])
    }
    
    private func bindViewModel() {
        viewModel.updateSignal.observeCompleted { [weak self] in
            guard let _self = self else { return }
            
            _self.tableHeader.setImage(urlString: _self.viewModel.headerImageUrl)
            
            _self.tableView.reloadSections([0], with: UITableViewRowAnimation.automatic)
        }
    }
}

extension ShotDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellViewModels[indexPath]!.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: viewModel.cellViewModels[indexPath]!.identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewModel.tableView(tableView, viewForHeaderInSection: section)
    }
}

extension ShotDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        self.viewModel.cellViewModels[indexPath]?.update(reusableView: cell)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
    }
}



extension ShotDetailController {
    class ViewModel {
        
        weak var shot: Shot!
        
        var headerImageUrl: String = ""
        
        var sectionViewModels: [Int: UIView]?
        
        var cellViewModels: [IndexPath: ReusableViewModel] = [:]
        
        var (updateSignal, updateObserver) = Signal<Shot, NoError>.pipe()
        
        init(shot: Shot) {
            self.shot = shot
        }
        
        func loadData() {
            
            DispatchQueue.global().async { [weak self] in
                guard let _self = self else {return}
                
                _self.cellViewModels = [IndexPath(item: 0, section: 0): AuthorInfoCell.ViewModel(shot: _self.shot),
                                        IndexPath(item: 1, section: 0): DescriptionCell.ViewModel(string: _self.shot.descriptionStr)]
                
                _self.headerImageUrl = _self.shot.images?.hidpi ?? (_self.shot.images?.normal ?? (_self.shot.images?.teaser ?? ""))
                
                DispatchQueue.main.sync {
                    _self.updateObserver.sendCompleted()
                }
            }
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
//            if let _viewModel = sectionViewModels?[section] {
//                return _viewModel
//            }
            
            return nil
        }
    }
}
