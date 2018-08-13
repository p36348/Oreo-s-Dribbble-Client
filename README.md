# OreosDrib

 关键三方框架:
 ====
 
 RxSwift 
 -------
 https://github.com/ReactiveX/RxSwift.git

 Moya 
 -------
 https://github.com/Moya/Moya.git
 
 IGListKit 
 -------
 https://github.com/Instagram/IGListKit.git
 
 OAuthSwift 
 -------
 https://github.com/OAuthSwift/OAuthSwift.git

 主要结构:
 ====
 
 API
 ------
 存储DribbbleAPI, 通过Moya实现的网络请求
 
 Service
 ------
 直接调用API以及存放数据
 
 Controller
 ------
 调用Service的副作用函数, 订阅Service数据变化并作出响应. (与Service产生双向通信)
