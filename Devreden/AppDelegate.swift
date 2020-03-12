//
//  AppDelegate.swift
//  Devreden
//
//  Created by Engin KUK on 5.06.2019.
//  Copyright © 2019 Silverback Inc. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Foundation
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func sendNotification( ) {
                      
        print("notifyme")
                      let content = UNMutableNotificationContent()
                      content.title = "Devreden:"
                      content.body = "  ;) devretti"
                      
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)

                      let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
                      
                      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                  }
          
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // fetch data once a day
        UIApplication.shared.setMinimumBackgroundFetchInterval(36000) //10h
        return true
    }

    // *** Method performFetchWithCompletionHandler   is deprecated. For apps supporting iOS 13 and higher   BGAppRefreshTask will be used. Will be updated in the future ***

    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        if let ViewController = window?.rootViewController as?
             
            ViewController {
            // update UI
            ViewController.viewDidLoad()
            //  fire notification by checking case background          
                     if ViewController.devir_sayisal  >  Double(ViewController.slider.value) || ViewController.devir_super  >  Double(ViewController.slider.value) {
                                      sendNotification()
                                    }
                }
       
      }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
               if let ViewController = window?.rootViewController as? ViewController {
                   ViewController.viewDidLoad()
               
               }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
        
     }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Devreden")
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

