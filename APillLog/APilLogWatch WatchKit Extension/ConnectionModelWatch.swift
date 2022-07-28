//
//  ConnectionModelWatch.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import Foundation
import WatchConnectivity

class ConnectionModelWatch: NSObject,  WCSessionDelegate, ObservableObject{
    
    static let shared: ConnectionModelWatch = ConnectionModelWatch()
    
    var session: WCSession
    @Published var messageText = ""

    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.messageText = message["message"] as? String ?? "Unknown"
        }
    }
    
    /*func sendmessage(){
        self.session.sendMessage(["message" : hello/*self.messageText*/], replyHandler: nil) { (error) in
            print(error.localizedDescription)
        }
    }*/
    
}
