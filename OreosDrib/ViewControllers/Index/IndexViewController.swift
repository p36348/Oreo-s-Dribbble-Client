//
//  IndexViewController.swift
//  OreosDrib
//
//  Created by P36348 on 14/08/2018.
//  Copyright © 2018 P36348. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

    let segmented: UISegmentedControl = {
        let item = UISegmentedControl(items: ["My Shots", "Pop Shots"])
        item.selectedSegmentIndex = 0
        return item
    }()
    
    let controllers: [ShotsViewController] = [ShotsViewController(), ShotsViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
