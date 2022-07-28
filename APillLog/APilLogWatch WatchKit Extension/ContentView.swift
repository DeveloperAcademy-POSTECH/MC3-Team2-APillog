//
//  ContentView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by 이영준 on 2022/07/27.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var connectionModel = ConnectionModelWatch()
    
    @State var messageText = "test중"
    
    var body: some View {
        VStack {
            Text("Text Here")
                .padding()
            Button {
                let pillName = "콘서타"
                let dosage = "18mg"
                let isMainPill = true
                let pillNames: [String] = []
                let dosages: [String] = []
                let sideEffect: [String] = ["목이 칼칼해요", "피곤해요", "잠을 못자요"]
                let medicinalEffect: [String] = []
                let detailContext: String = "살려주세요"
                
                
                self.connectionModel.session.sendMessage(["message" : ["아파요"],
                                                          "pillName": pillName,
                                                          "dosage": dosage,
                                                          "isMainPill": isMainPill,
                                                          "pillNames": pillNames,
                                                          "dosages": dosages,
                                                          "sideEffect": sideEffect,
                                                          "medicinalEffect": medicinalEffect,
                                                          "detailContext": detailContext
                                                         ], replyHandler: nil) { (error) in
                    print(error.localizedDescription)
                }
            } label: {
                Text("Send Button")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
