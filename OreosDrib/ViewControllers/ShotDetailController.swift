//
//  ShotDetailController.swift
//  OreosDrib
//
//  Created by P36348 on 28/6/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

class ShotDetailController: UIViewController {
    
    fileprivate let viewModel: ViewModel = ViewModel()
    
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ShotDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ShotDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension ShotDetailController {
    class ViewModel {
        
    }
}
