//
//  SceneDelegate.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/16.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        let coreDataManager = CoreDataManager()
        var primaryPillList: [ShowPrimaryPill] = []
        var primaryPillListMorning: [ShowPrimaryPill] = []
        var primaryPillListLunch: [ShowPrimaryPill] = []
        var primaryPillListDinner: [ShowPrimaryPill] = []
        primaryPillList = coreDataManager.fetchShowPrimaryPill(selectedDate: Date())
        primaryPillListMorning = coreDataManager.fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListLunch = coreDataManager.fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: primaryPillList)
        primaryPillListDinner = coreDataManager.fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: primaryPillList)
        
        if primaryPillListMorning.count >= 2{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListMorning[0].name, forKey: "morning1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListMorning[1].name, forKey: "morning2")
        }
        else if primaryPillListMorning.count == 1{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListMorning[0].name, forKey: "morning1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "morning2")
        }
        else{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "morning1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "morning2")
        }
        
        if primaryPillListLunch.count >= 2{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListLunch[0].name, forKey: "lunch1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListLunch[1].name, forKey: "lunch2")
        }
        else if primaryPillListLunch.count == 1{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListLunch[0].name, forKey: "lunch1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "lunch2")
        }
        else{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "lunch1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "lunch2")
        }
        
        if primaryPillListDinner.count >= 2{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListDinner[0].name, forKey: "dinner1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListDinner[1].name, forKey: "dinner2")
        }
        else if primaryPillListDinner.count == 1{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(primaryPillListDinner[0].name, forKey: "dinner1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "dinner2")
        }
        else{
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "dinner1")
            UserDefaults(suiteName:
                            "group.com.varcode.APillLog.ApilogWidget")!.set(" ", forKey: "dinner2")
        }
            WidgetCenter.shared.reloadAllTimelines()
        
        WidgetCenter.shared.reloadAllTimelines()
        print("save success -------------- ")
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    

}

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            print(url.absoluteString)
                if url.absoluteString.starts(with: "Apillog://DiaryView") {
                    (self.window?.rootViewController as? UITabBarController)?.selectedIndex = 1
                }

        
    }
}
}
