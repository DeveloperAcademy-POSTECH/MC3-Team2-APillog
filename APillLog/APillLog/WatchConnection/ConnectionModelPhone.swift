//
//  ConnectionModelPhone.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/07/28.
//
//  참고자료 : https://github.com/kimsehee827/ConnectivityWatch

import Foundation
import WatchConnectivity

protocol ConnectionModelPhoneDelegate {
    func reloadTableView()
}

class ConnectionModelPhone : NSObject,  ObservableObject, WCSessionDelegate{
    static let shared: ConnectionModelPhone = ConnectionModelPhone()
    
    let watchDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    var delegate: ConnectionModelPhoneDelegate?
    
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
            switch message["message"] as! String {
            case "TakePill":
                let time = message["time"] as! String
                
                switch time{
                case "morning":
                    CoreDataManager.shared.recordHistoryAndChangeAllPrimaryIsTaking(selectDate: Date(), dosingCycle: 1, takingTime: Date())
                case "afternoon":
                    CoreDataManager.shared.recordHistoryAndChangeAllPrimaryIsTaking(selectDate: Date(), dosingCycle: 2, takingTime: Date())
                case "evening":
                    CoreDataManager.shared.recordHistoryAndChangeAllPrimaryIsTaking(selectDate: Date(), dosingCycle: 4, takingTime: Date())
                default:
                    print("Wrong Watch Take Pill Message")
                }
                self.delegate?.reloadTableView()
                
            case "Condition":
                let pillName =  message["pillName"] as? String ?? nil
                let dosage =  message["dosage"] as? String ?? nil
                let isMainPill = message["isMainPill"] as? Bool ?? false
                let pillNames: [String]? = message["pillNames"] as? [String] ?? nil
                let dosages: [String]? = message["dosages"] as? [String] ?? nil
                let sideEffect: [String]? = message["sideEffect"] as? [String] ?? nil
                let medicinalEffect: [String]? = message["medicinalEffect"] as? [String] ?? nil
                let detailContext: String? = message["detailContext"] as? String ?? nil
                
                CoreDataManager.shared.addHistory(pillId: UUID(), pillName: pillName, dosage: dosage, isMainPill: isMainPill, pillNames: pillNames, dosages: dosages, sideEffect: sideEffect, medicinalEffect: medicinalEffect, detailContext: detailContext, takingTime: nil)
            
            case "active":
                print("Watch로부터의 연결 시도 신호")
                
            default :
                print("알 수 없는 통신 - Watch to Phone")
            }
            // 메세지에서 데이터 받아오기
            
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func sendShowPrimaryPillToWatch() {
  
        let pillList = CoreDataManager.shared.fetchShowPrimaryPill(selectedDate: Date())
    
        // 1. 전송 시작 알림 + 초기화 요청
        ConnectionModelPhone.shared.session.sendMessage(["message":"reset"], replyHandler: nil)

        // 2. 데이터 전송
        for pill in pillList {
            let cycle = pill.cycle
            let dosage = pill.dosage ?? "복용량없음"
            let id = pill.id?.uuidString ?? ""
            let isTaking = pill.isTaking
            let name = pill.name ?? "이름없음"
            let selectDate = pill.selectDate ?? watchDateFormatter.string(from: Date())
            let takeTime = pill.takeTime == nil ? Date(timeIntervalSince1970: 0) : pill.takeTime!


            ConnectionModelPhone.shared.session.sendMessage(["message": "pillData",
                                                             "cycle": cycle,
                                                             "dosage": dosage,
                                                             "id": id,
                                                             "isTaking": isTaking,
                                                             "name": name,
                                                             "selectDate": selectDate,
                                                             "takeTime": takeTime
                                                            ], replyHandler: nil)
        }

        // 3. 전송 완료 알림
        ConnectionModelPhone.shared.session.sendMessage(["message":"update"], replyHandler: nil)
    }
}
