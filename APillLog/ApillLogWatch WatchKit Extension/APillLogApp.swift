//
//  APillLogApp.swift
//  ApillLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/30.
//

import SwiftUI

@main
struct APillLogApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .onAppear {
                        ConnectionModelWatch.shared.session.sendMessage(["message":"active"], replyHandler: nil)
                    }
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
