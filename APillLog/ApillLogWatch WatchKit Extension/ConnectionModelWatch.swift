//
//  ConnectionModelWatch.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import Foundation
import WatchConnectivity


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
        DispatchQueue.main.sync {
            let task = message["message"] as? String ?? "Unknown"
            
            switch task {
            case "reset":
                CoreDataManager.shared.deleteEntireShowPrimaryPill()
                
            case "pillData":
                let cycle = message["cycle"] as? Int16 ?? 0
                let dosage = message["dosage"] as? String ?? "복용량"
                let id: UUID = UUID(uuidString: message["id"] as! String)!
                let isTaking = message["isTaking"] as? Bool ?? false
                let name = message["name"] as? String ?? "약이름"
                let selectDate = message["selectDate"] as? String ?? "2000-01-01"
                let takeTime = ((message["takeTime"] as? Date == Date(timeIntervalSince1970: 0)) ? message["takeTime"] as! Date : nil)
                
                CoreDataManager.shared.copyShowPrimaryPill(id: id, name: name, dosage: dosage, selectDate: selectDate, isTaking: isTaking, cycle: cycle, takeTime: takeTime)
                
            case "update":
                print("update")
                
            default:
                print("잘못된 메시지")
            }
            
        }
    }
}
