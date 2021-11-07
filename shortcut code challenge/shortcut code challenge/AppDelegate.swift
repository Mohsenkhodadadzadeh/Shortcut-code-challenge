//
//  AppDelegate.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit
import CoreData
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let userNotificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.mohsen.Shortcut-code-challenge2.fetch", using: nil) { task in
                //Logger.shared.info("[BGTASK] Perform bg fetch bgtask")
                let defaults = UserDefaults.standard
                let lastComicId = defaults.integer(forKey: publicNamesEnum.lastComicId.rawValue)
                Network.shared.getData (fileId: nil) { (obj: ComicModel) in
                    if obj.num > lastComicId {
                        
                        
                        let notificationContent = UNMutableNotificationContent()
                        notificationContent.title = "New Comic".uppercased()
                        notificationContent.body = "new comic is published for you"
                        notificationContent.badge = NSNumber(value: 3)
                        
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                                        repeats: false)
                        let request = UNNotificationRequest(identifier: "newComic",
                                                            content: notificationContent,
                                                            trigger: trigger)
                        
                        AppDelegate.userNotificationCenter.add(request) { (error) in
                            if let error = error {
                                print("Notification Error: ", error)
                            }
                        }
                    }
                } failure: { _ in
                    
                }
                
                task.setTaskCompleted(success: true)
                self.scheduleAppRefresh()
            }
            
        }
        return true
    }
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.mohsen.Shortcut-code-challenge2.fetch")
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60) // Refresh after 5 minutes.
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh task \(error.localizedDescription)")
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if #available(iOS 13, *) {
            self.scheduleAppRefresh()
        }
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "shortcut_code_challenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

