//
//  ConnectionModelPhone.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/28.
//
//  참고자료 : https://github.com/kimsehee827/ConnectivityWatch

import Foundation
import WatchConnectivity

class ConnectionModelPhone : NSObject,  ObservableObject, WCSessionDelegate{
    static let shared: ConnectionModelPhone = ConnectionModelPhone()
    
    var coreDataManager: CoreDataManager = CoreDataManager()
    
    @Published var messageText = ""
    var session: WCSession
    
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
        
            // 메세지에서 데이터 받아오기
            let isAddingHistory = message["isAddingHistory"] as? Bool
            
            
            let pillName =  message["pillName"] as? String ?? "ERROR"
            let dosage =  message["dosage"] as? String ?? nil
            let isMainPill = message["isMainPill"] as! Bool ?? false
            let pillNames: [String]? = message["pillNames"] as? [String] ?? nil
            let dosages: [String]? = message["dosages"] as? [String] ?? nil
            let sideEffect: [String]? = message["sideEffect"] as? [String] ?? nil
            let medicinalEffect: [String]? = message["medicinalEffect"] as? [String] ?? nil
            let detailContext: String? = message["detailContext"] as? String ?? nil
            
            self.coreDataManager.addHistory(pillId: UUID(), pillName: pillName, dosage: dosage, isMainPill: isMainPill, pillNames: pillNames, dosages: dosages, sideEffect: sideEffect, medicinalEffect: medicinalEffect, detailContext: detailContext)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
}
