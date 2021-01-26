//
//  AppDelegate.swift
//  fetch_xml_weather
//
//  Created by Yuki Shinohara on 2021/01/25.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
//    確認
//    e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.fetch.xml.weather.refresh"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        print("didFinishLaunchingWithOptions")
//        registerTask()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("applicationDidEnterBackground")
//        cancelAllPandingBGTask()
//        scheduleAppRefresh()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
//        print("sceneDidEnterBackground")
//        cancelAllPandingBGTask()
//        scheduleAppRefresh()
    }
    
    func registerTask(){
        print("registerTask")
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier, using: nil) { task in
//            print("bgtask登録されたよ")//この実行は登録だけなので起動時にはプリントされない→よって、起動時はregisterTaskのみプリントされる
//            self.handleRefresh(task: task as! BGAppRefreshTask)
//        }
    }
    
    
    
    func scheduleAppRefresh() {
        print("scheduleAppRefresh")
//        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // App Refresh after 2 minute.
//        //Note :: EarliestBeginDate should not be set to too far into the future.
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Could not schedule app refresh: \(error)")
//        }
    }
    
    func handleRefresh(task: BGAppRefreshTask){
        
//        print("handleAppRefreshTask")
//        task.expirationHandler = {
//            //This Block call by System
//            //Canle your all tak's & queues
//        }
////        scheduleLocalNotification()
//        //
//        task.setTaskCompleted(success: true)
    }
    
    func cancelAllPandingBGTask() {
        print("cancelAllPandingBGTask")
//        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

