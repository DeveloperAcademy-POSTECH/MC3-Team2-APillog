//
//  ConnectionModelWatch.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import Foundation
import WatchConnectivity
import SwiftUI

class ConnectionModelWatch: NSObject,  WCSessionDelegate, ObservableObject {
    
    static let shared = ConnectionModelWatch()
    
    var session: WCSession
    @Published var messageText = ""
    @Published var sessionState = "idle"
    
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
        
        switch task {
        case "reset":
            DispatchQueue.main.sync {
                sessionState = "reset"
            }
            
            CoreDataManager.shared.deleteEntireShowPrimaryPill()
            
        case "pillData":
            DispatchQueue.main.sync {
                sessionState = "addingData"
            }
            let cycle: Int16 = message["cycle"] as? Int16 ?? 0
            let dosage: String = message["dosage"] as? String ?? ""
            let id: UUID = UUID(uuidString: message["id"] as? String ?? "") ?? UUID()
            let isTaking: Bool = message["isTaking"] as? Bool ?? false
            let name: String = message["name"] as? String ?? ""
            let selectDate: String = message["selectDate"] as? String ?? "2000-01-01"
            let takeTime: Date = message["takeTime"] as? Date ?? Date()
            
            CoreDataManager.shared.addShowPrimaryPill(id: id, name: name, dosage: dosage, isTaking: isTaking, cycle: cycle, selectDate: selectDate, takeTime: takeTime)
            
        case "update":
            DispatchQueue.main.sync {
                sessionState = "idle"
            }
        default:
            print("not proper message")
        }
    }
}

