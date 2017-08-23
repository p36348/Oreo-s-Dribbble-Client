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
    
    fileprivate var viewModel: ViewModel = ViewModel(userService: UserService.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        
        bindViewModel()
        
        viewModel.loadUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configureSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "sign out", style: UIBarButtonItemStyle.done, target: self, action: #selector(UserInfoController.clickSignOut(sender:)))
    }
    
    private func bindViewModel() {
        
        viewModel.updateSignal.observeCompleted { [weak self] in
            guard let _self = self else { return }
            
            _self.tableView.reloadData()
        }
        
    }
    
    dynamic func clickSignOut(sender: UIBarButtonItem) {
        OAuthService.shared.resetToken()
        
        UserService.shared.logOut()
    }
    
}

// MARK: - UITableViewDataSource
extension UserInfoController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: UITableViewCell.description())
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
}

// MARK: - UITableViewDelegate
extension UserInfoController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        (view as? UITableViewHeaderFooterView)?.update()
        viewModel.sectionHeaderViewModel.update(reusableView: view)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.cellViewModels[indexPath.row].title
        
        cell.detailTextLabel?.text = viewModel.cellViewModels[indexPath.row].detail
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private let dateFormatter: DateFormatter = {
    
    let _formatter = DateFormatter()
    
    _formatter.dateFormat = "MMM d, yyyy"
    
    return _formatter
}()

fileprivate class SectionHeader: UITableViewHeaderFooterView {
    
    let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    let nameLabel: UILabel = UILabel()
    
    let dateLabel: UILabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        
        imageView.layer.masksToBounds = true
        
        nameLabel.textColor = UIColor.Dribbble.charcoal
        
        dateLabel.textColor = UIColor.Dribbble.slate
        
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
    
//    override func update() {
//        guard let _viewModel = viewModel as? ViewModel else { return }
//                
//        imageView.setImage(urlString: _viewModel.imageUrl, placeholder: #imageLiteral(resourceName: "DefaultAvator"))
//        
//        nameLabel.text = _viewModel.name
//        
//        dateLabel.text = _viewModel.date
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class ViewModel: ReusableViewModel {
        
        var viewClass: AnyClass = SectionHeader.self
        
        var identifier: String = SectionHeader.description()
        
        var date: String = ""
        
        var name: String = ""
        
        var imageUrl: String = ""
        
        init(with user: User) {
            self.update(with: user)
        }
        
        func update(with user: User) {
            imageUrl = user.avator
            
            name    = user.name
            
            guard let _date = Date.dribbbleDate(string: user.createdAt)?.dateAtCurrentZone else { return }
            
            date    = "Member Since: " + dateFormatter.string(from: _date)
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
        
        var sectionHeaderViewModel: SectionHeader.ViewModel 
        
        var cellViewModels: [CellModel]
        
        init(userService: UserService) {
            avatorSignal = userService.userInfoSignal.map({ (user) -> String in
                return user.avator
            })
            
            nameSignal = userService.userInfoSignal.map({ (user) -> String? in
                return user.name
            })
            
            sectionHeaderViewModel = SectionHeader.ViewModel(with: userService.currentUser)
            
            cellViewModels = [CellModel(title: "Likes", detail: "\(userService.currentUser.likesCount)"),
                              CellModel(title: "Following", detail: "\(userService.currentUser.followingsCount)")]
            
            userService.userInfoSignal.observeValues { [weak self] (user) in
                
                guard let _self = self else { return }
                
                _self.sectionHeaderViewModel.update(with: user)
                
                _self.cellViewModels[0].detail = "\(user.likesCount)"
                
                _self.cellViewModels[1].detail = "\(user.followingsCount)"
                
                _self.updateObserver.sendCompleted()
            }
        }
        
        func loadUserInfo() {
            let _ = UserService.shared.getCurrentUser()
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            var header: SectionHeader?
            
            if let _header = tableView.headerView(forSection: section) {
                
                header = _header as? SectionHeader
                
            } else {
                tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: SectionHeader.description())
                
                header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeader.description()) as? SectionHeader
            }
            
//            header?.viewModel = sectionHeaderViewModel
            
            return header
        }
        
    }
    
    struct CellModel {
        var title: String = ""
        
        var detail: String = ""
    }
}
