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
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableHeaderView = tableHeader
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
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
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellViewModels[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DescriptionCell(style: UITableViewCellStyle.default, reuseIdentifier: DescriptionCell.description())
        
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
    fileprivate class DescriptionCell: UITableViewCell {
        let textView: UITextView = UITextView()
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            textView.isEditable = false
            
            textView.isScrollEnabled = false
            
            textView.textContainerInset = .zero
            
            contentView.addSubview(textView)
            
            textView.snp.makeConstraints { (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func update() {
            guard let _viewModel = viewModel as? ViewModel else { return }
            
            textView.attributedText = _viewModel.parser.attrString
        }
        
        class ViewModel: TableCellViewModel {
            var cellClass: AnyClass = DescriptionCell.self
            
            var height: CGFloat = 200
            
            var parser: HTMLParser = HTMLParser()
            
            init(string: String) {
                parser.parse(html: string)
                
               
                self.height = parser.attrString.boundingRect(with: CGSize(width: kScreenWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
                
            }
        }
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
            
            cellViewModels.append(DescriptionCell.ViewModel(string: shot.descriptionStr))
        }
        
        func loadData() {
            headerImageUrl = shot.images?.hidpi ?? (shot.images?.normal ?? "")
            
            updateObserver.sendCompleted()
        }
    }
}
