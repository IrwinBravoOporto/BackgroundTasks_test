//
//  AppDelegate.swift
//  fetch_xml_weather
//
//  Created by Yuki Shinohara on 2021/01/25.
//

import UIKit
import BackgroundTasks

class RefreshAppContentsOperation: Operation {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    override func main() {
        print("this operation id is \(self.id)")
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let taskIdentifier = "com.fetch.xml.weather.refresh"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerBackgroundTaks()
        return true
    }
    
    //MARK: Register BackGround Tasks
    private func registerBackgroundTaks() {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.SO.imagefetcher", using: nil) { task in
            //This task is cast with processing request (BGProcessingTask)
            self.scheduleLocalNotification()
            self.handleImageFetcherTask(task: task as! BGProcessingTask)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.SO.apprefresh", using: nil) { task in
            //This task is cast with processing request (BGAppRefreshTask)
            self.scheduleLocalNotification()
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
        scheduleImagefetcher()
    }
    
    func scheduleImagefetcher() {
        let request = BGProcessingTaskRequest(identifier: "com.SO.imagefetcher")
        request.requiresNetworkConnectivity = false // Need to true if your task need to network process. Defaults to false.
        request.requiresExternalPower = false
        //If we keep requiredExternalPower = true then it required device is connected to external power.
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // fetch Image Count after 1 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule image fetch: \(error)")
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.SO.apprefresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 2 * 60) // App Refresh after 2 minute.
        //Note :: EarliestBeginDate should not be set to too far into the future.
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func cancelAllPendingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
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

