////
////  SocketManager.swift
////  OreosDrib
////
////  Created by P36348 on 8/6/2017.
////  Copyright © 2017 P36348. All rights reserved.
////
//
//import Foundation
//import SocketIO
//import SwiftyJSON
//
//private let socketUrl: URL = URL(string: "http://192.168.199.123:3000")!
//
//struct SocketManager {
//    
//    static let shared: SocketManager = SocketManager()
//    
//    init() {
//        self.socket = SocketIOClient(socketURL: socketUrl)
//        
//        socket.on(clientEvent: SocketClientEvent.connect) { (data, ack) in
//            print("socket connected")
//        }
//        socket.on("chat message") { (data, ack) in
//            print("chat message", data, ack)
//        }
//        socket.on("friend login") { (data, ack) in
//            
//        }
//    }
//    
//    private let socket: SocketIOClient
//    
//    func connect() { socket.connect() }
//    
//    func disconnect() { socket.disconnect() }
//    
//    func send() {
//        socket.emit("", with: [])
//    }
//}
