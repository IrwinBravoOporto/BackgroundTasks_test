//
//  SceneDelegate.swift
//  fetch_xml_weather
//
//  Created by Yuki Shinohara on 2021/01/25.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        registerTask()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("さよなら!")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("アクティブ!")
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("resignアクティブ!")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("bgに入るよ!")
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("bg!")
        cancelAllPandingBGTask()
        scheduleAppRefresh()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    func registerTask(){
        print("registerTask")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.fetch.xml.weather.refresh", using: nil) { task in
            // コンテンツの取得などを行う
            print("bgtask登録されたよ")//この実行は登録だけなので起動時にはプリントされない→よって、起動時はregisterTaskのみプリントされる
            self.handleRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    
    
    func scheduleAppRefresh() {
        print("scheduleAppRefresh")
        let request = BGAppRefreshTaskRequest(identifier: "com.fetch.xml.weather.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleRefresh(task: BGAppRefreshTask){
        
        print("handleAppRefreshTask")
        task.expirationHandler = {
            //This Block call by System
            //Canle your all tak's & queues
        }
//        scheduleLocalNotification()
        //
        task.setTaskCompleted(success: true)
    }
    
    func cancelAllPandingBGTask() {
        print("cancelAllPandingBGTask")
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
}
