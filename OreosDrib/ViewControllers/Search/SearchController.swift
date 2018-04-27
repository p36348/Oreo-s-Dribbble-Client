////
////  SearchController.swift
////  OreosDrib
////
////  Created by P36348 on 23/6/2017.
////  Copyright © 2017 P36348. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import Result
//import SwiftyJSON
//
//class SearchController: UIViewController {
//
//    @IBOutlet weak var searchBar: UISearchBar!
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    fileprivate var viewModel: ViewModel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        bindViewModel()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    private func bindViewModel() {
//        
//        let searchCompletion: (JSON) -> Void = { [weak self] response in
//            self?.tableView.reloadData()
//        }
//        
//        let searchFaild: (ReactiveError) -> Void = { error in
//            
//        }
//        
//        let suggestCompletion: () -> Void = {
//        
//        }
//        
//        viewModel = ViewModel(searchBarSignal: searchBar.reactive.continuousTextValues.skipNil(),
//                              searchCompletion: searchCompletion,
//                              searchFaild: searchFaild,
//                              suggestCompletion: suggestCompletion)
//        
//        tableView.dataSource = self
//        
//        tableView.delegate = self
//        
//        searchBar.delegate = self
//
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension SearchController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.results.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(), for: indexPath)
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension SearchController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//    }
//}
//
//// MARK: - UISearchBarDelegate
//extension SearchController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        viewModel.searchAction.execute(searchBar)
//    }
//}
//
//extension SearchController {
//    
//    class ViewModel {
//        
//        var searchAction: CocoaAction<UISearchBar>
//        
//        var suggestions: [String] = []
//        
//        var results: [String] = []
//        
//        init(searchBarSignal: Signal<String, NoError>, searchCompletion: @escaping (JSON) -> Void, searchFaild: @escaping (ReactiveError) -> Void, suggestCompletion: () -> Void) {
//            
//            searchBarSignal.observeValues { (value) in
//                //TODO: 建议词请求
//            }
//            
//            let action: Action<String, JSON, ReactiveError> = Action<String, JSON, ReactiveError>.init({ (input) -> SignalProducer<JSON, ReactiveError> in
//                
//                let signal = UserService.shared.get(user: input).signal
//                
//                signal.observeResult({ (result) in
//                    
//                    if let _value = result.value {
//                        searchCompletion(_value)
//                    }
//                    else if let _error = result.error {
//                        searchFaild(_error)
//                    }
//                    
//                })
//                
//                return SignalProducer<JSON, ReactiveError>(signal)
//            })
//            
//            searchAction = CocoaAction<UISearchBar>.init(action, { (searchBar) -> String in
//                return searchBar.text ?? ""
//            })
//        }
//    }
//}
