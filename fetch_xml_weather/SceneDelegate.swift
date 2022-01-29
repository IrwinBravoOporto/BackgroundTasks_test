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
    //    e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.fetch.xml.weather.refresh"]
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        registerTask()
        registerLocalNotification()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
        
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
//        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
        cancelAllPandingBGTask()
        scheduleAppRefresh()
    }


}

extension SceneDelegate {
    func registerTask(){
        print("registerTask")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.fetch.xml.weather.refresh", using: nil) { task in
            //print("bgtask実行されたよ")//この実行は登録だけなので起動時にはプリントされない→よって、起動時はregisterTaskのみプリントされる
            self.handleRefresh(task: task as! BGAppRefreshTask)
            self.scheduleLocalNotification()
        }
    }
    
    
    
    func scheduleAppRefresh() {
        print("scheduleAppRefresh")
        let request = BGAppRefreshTaskRequest(identifier: "com.fetch.xml.weather.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // App Refresh after 2 minute.
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
        
        task.setTaskCompleted(success: true)
//        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
    }
    
    func cancelAllPandingBGTask() {
        print("cancelAllPandingBGTask")
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
}

//MARK:- Notification Helper

extension SceneDelegate {
    
    func registerLocalNotification() {
        print("ローカル通知登録")
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
//        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
    }
    
    func scheduleLocalNotification() {
        print("ローカル通知スケジュール")
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification()
            }
        }
//        NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
    }
    
    func fireNotification() {
        print("ローカル通知発火")
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "テスト"
        notificationContent.body = "Weather Notifications."
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
}
