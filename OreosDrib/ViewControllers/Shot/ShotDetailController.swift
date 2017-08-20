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
    
    fileprivate var viewModel: ViewModel!
    
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
        alertActionSheet(sheetTitles: ["Share"], sheetActions: [shareAction])
    }
    
    private func bindViewModel() {
        viewModel.updateSignal.observeCompleted { [weak self] in
            guard let _self = self else { return }
            
            _self.tableHeader.setImage(urlString: _self.viewModel.headerImageUrl)
            
        }
    }
}

extension ShotDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellViewModels[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellViewModels[indexPath.row].cellClass.description(), for: indexPath)
        
        cell.viewModel = viewModel.cellViewModels[indexPath.row]
        
        return cell
    }
}

extension ShotDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.update()
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
        
        var cellViewModels: [TableCellViewModel] = []
        
        var (updateSignal, updateObserver) = Signal<Shot, NoError>.pipe()
        
        init(shot: Shot) {
            self.shot = shot
            
            cellViewModels.append(AuthorInfoCell.ViewModel(shot: shot))
            cellViewModels.append(DescriptionCell.ViewModel(string: shot.descriptionStr))
        }
        
        func loadData() {
            
            headerImageUrl = shot.images?.hidpi ?? (shot.images?.normal ?? (shot.images?.teaser ?? ""))
            
            updateObserver.sendCompleted()
        }
    }
}
