//
//  SignController.swift
//  RacSwift
//
//  Created by P36348 on 3/5/2017.
//  Copyright © 2017 P36348. All rights reserved.
//

import UIKit

import SnapKit
import ReactiveCocoa
import ReactiveSwift
import Result
import SwiftyJSON

class SignController: UIViewController {

    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var pwdTf: UITextField!
    @IBOutlet weak var userNameTf: UITextField!
    
    private var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        bindViewModel()
    }
    
    private func initViewModel() {
        let userNameTFOutput = userNameTf.reactive.continuousTextValues.skipNil()
        let pwdTFOutput = pwdTf.reactive.continuousTextValues.skipNil()
        viewModel = ViewModel(userNameTFOutput: userNameTFOutput, pwdTFOutput: pwdTFOutput)
    }
    
    //绑定viewModel和view
    private func bindViewModel() {
        
        commitButton.acceptEventInterval = 1
        
        pwdTf.reactive.isEnabled <~ viewModel.enablePwdTF
        
        commitButton.reactive.isEnabled <~ viewModel.enableCommit
        /*
         绑定确认按钮的点击事件为viewModel的signIn行为,输入参数分别是两个tf的内容
         */
        commitButton.reactive.pressed = CocoaAction(viewModel.signIn) {_ in (self.viewModel.userName.value, self.viewModel.password.value)}
        /*
         登录调用成功的回调
         */
        viewModel.signIn.values.observeValues { (json) in
            print(json)
        }
        /*
         登录调用失败的回调
         */
        viewModel.signIn.errors.observeValues { (error) in
            print(error)
        }
        
        /*
         viewModel绑定用户的2个输入行为信号到对应Property,获取实时输入数据
         */
        viewModel.userName <~ userNameTf.reactive.continuousTextValues.skipNil()

        viewModel.password <~ pwdTf.reactive.continuousTextValues.skipNil()
        
    }
    
    deinit {
        viewModel.cancelSignIn()
    }
}



extension SignController {
    
    class ViewModel {
        
        //signals
        
        var enablePwdTF: Signal<Bool, NoError>
        
        var enableCommit: Signal<Bool, NoError>
        
        var userName: ValidatingProperty<String, ReactiveError>
        
        var password: ValidatingProperty<String, ReactiveError>

        /// 参数是否正确
        private var validParams: Property<Bool>
        
        private var signInResponse: NetworkResponse?
        
        /// 登录行为,输入内容是用户名和密码,无返回
        var signIn: Action<(String, String), JSON, ReactiveError>
                
        init(userNameTFOutput: Signal<String, NoError>, pwdTFOutput: Signal<String, NoError>) {
            
            enablePwdTF = userNameTFOutput.map({ (value) -> Bool in
                return value.isValidMobile
            })

            enableCommit = Signal.combineLatest(enablePwdTF, pwdTFOutput).map({ (value) -> Bool in
                return value.0 && value.1.isValidPassword
            })
            
            userName = ValidatingProperty<String, ReactiveError>.init("") { (input) -> ValidatorOutput<String, ReactiveError> in
                return input.isValidMobile ? .valid : .invalid(ReactiveError(message: "please enter a vaild mobile number", code: -1))
            }
            password = ValidatingProperty<String, ReactiveError>.init("") { (input) -> ValidatorOutput<String, ReactiveError> in
                return input.isValidPassword ? .valid : .invalid(ReactiveError(message: "please enter a vaild mobile number", code: -1))
            }
            
            validParams = Property.combineLatest(userName, password).map({ (values) -> Bool in
                return values.0.isValidMobile && values.1.isValidPassword
            })
            
            signIn = Action<(String, String), JSON, ReactiveError>(enabledIf: validParams) { (input) -> SignalProducer<JSON, ReactiveError> in
                
                let _response = UserService.shared.sign(userName: input.0, password: input.1)
                
                return SignalProducer<JSON, ReactiveError>(_response.signal)
            }
        }
        
        func cancelSignIn() {
            UserService.shared.cancelSignIn()
        }
    }
}
