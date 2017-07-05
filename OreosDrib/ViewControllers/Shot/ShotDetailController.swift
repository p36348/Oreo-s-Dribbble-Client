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
    
    fileprivate var tableHeader: AnimatedImageView = AnimatedImageView(frame: CGRect(x: 0, y: 0, width: SystemInfo.screenSize.width, height: SystemInfo.screenSize.width * 3 / 4))
    
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
    
    func configure(with shot: Shot) {
        viewModel = ViewModel(shot: shot)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()

        configureSubview()
        
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
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableHeaderView = tableHeader
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    dynamic private func clickRightItem(sender: UIBarButtonItem){
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: UITableViewCell.description())
    }
}

extension ShotDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.shot.descriptionStr
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
        }
        
        func loadData() {
            headerImageUrl = shot.images?.hidpi ?? (shot.images?.normal ?? "")
            
            updateObserver.sendCompleted()
        }
    }
}
