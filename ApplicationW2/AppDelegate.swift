//
//  AppDelegate.swift
//  ApplicationW2
//
//  Created by Vincenzo Cimmino on 21/07/17.
//  Copyright © 2017 Vincenzo Cimmino. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      }

    func applicationDidBecomeActive(_ application: UIApplication) {
      }

    func applicationWillTerminate(_ application: UIApplication) {
      }
    
    lazy var persistentContainer : NSPersistentContainer = {
    
        let conteiner = NSPersistentContainer(name:"Location")
        conteiner.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved Error \(error),\(error.userInfo)")
                
            }})
        return conteiner
    }()

    func saveContext(){
    let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            }
            catch{
                    let nserror = error as NSError
                    fatalError("Unresolved Error \(nserror),\(nserror.userInfo)")
            }
        }
    }
}

