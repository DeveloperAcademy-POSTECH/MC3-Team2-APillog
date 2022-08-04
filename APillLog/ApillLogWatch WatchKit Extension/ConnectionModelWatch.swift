//
//  ConnectionModelWatch.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import Foundation
import WatchConnectivity
import SwiftUI

class ConnectionModelWatch: NSObject,  WCSessionDelegate, ObservableObject{
    
    static let shared = ConnectionModelWatch()
    
    var session: WCSession
    @Published var messageText = ""
    
    private init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let task = message["message"] as? String ?? "Unknown"
    }
}

