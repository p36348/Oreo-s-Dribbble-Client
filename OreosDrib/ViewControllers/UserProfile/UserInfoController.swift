//
//  UserInfoController.swift
//  OreosDrib
//
//  Created by P36348 on 24/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift
import Kingfisher

class UserInfoController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "sign out", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UserInfoController.clickSignOut(sender:)))
    }
    
    private func bindViewModel() {
        
        viewModel.updateSignal.observeValues { [weak self] (user) in
            
            guard let _self = self else { return }
            
            _self.tableView.reloadData()
        }
    }
    
    dynamic func clickSignOut(sender: UIBarButtonItem) {
        OAuthService.shared.resetToken()
        UserService.shared.signOut()
    }
    
}

// MARK: - UITableViewDataSource
extension UserInfoController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.tableView(tableView, viewForHeaderInSection: section)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.update()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: UITableViewCell.description())
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
}

// MARK: - UITableViewDelegate
extension UserInfoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

fileprivate class SectionHeader: UITableViewHeaderFooterView {
    
    let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
    
    let nameLabel: UILabel = UILabel()
    
    let dateLabel: UILabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        
        imageView.layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(nameLabel)
        
        contentView.addSubview(dateLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(10)
            make.size.equalTo(imageView.bounds.size)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }
    
    override func update() {
        guard let _viewModel = viewModel as? ViewModel else { return }
        
        imageView.setImage(urlString: _viewModel.imageUrl)
        
        nameLabel.text = _viewModel.name
        
        dateLabel.text = _viewModel.date
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class ViewModel: SectionHeaderFooterViewModel {
        var date: String = ""
        
        var name: String = ""
        
        var imageUrl: String = ""
        
        init(with user: User) {
            
            imageUrl = user.avator
            
            name    = user.name
            
            date    = user.createdAt
        }
    }
}

extension UserInfoController {
    fileprivate class ViewModel {
        
        /// 头像数据更新
        var avatorSignal: Signal<String, NoError>
        
        /// 用户昵称数据更新
        var nameSignal: Signal<String?, NoError>
        
        var (updateSignal, updateObserver) = Signal<User, NoError>.pipe()
        
        var sectionHeaderViewModel: SectionHeader.ViewModel = SectionHeader.ViewModel(with: UserService.shared.currentUser)
        
        var cellViewModels: [TableCellViewModel] = []
        
        init() {
            avatorSignal = UserService.shared.userInfoSignal.map({ (user) -> String in
                return user.avator
            })
            
            nameSignal = UserService.shared.userInfoSignal.map({ (user) -> String? in
                return user.name
            })
            
            UserService.shared.userInfoSignal.observeValues { [weak self] (user) in
                
                guard let _self = self else { return }
                
                _self.sectionHeaderViewModel = SectionHeader.ViewModel(with: user)
                
                _self.updateObserver.send(value: user)
            }
        }
        
        func loadUserInfo() {
            let _ = UserService.shared.getCurrent()
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            var header: SectionHeader?
            
            if let _header = tableView.headerView(forSection: section) {
                
                header = _header as? SectionHeader
                
            } else {
                tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: SectionHeader.description())
                
                header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeader.description()) as? SectionHeader
            }
            
            header?.viewModel = sectionHeaderViewModel
            
            return header
        }
        
    }
}
