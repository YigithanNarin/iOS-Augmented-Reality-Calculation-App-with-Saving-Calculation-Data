//
//  AppDelegate.swift
//  ARRuler
//
//  Created by Yigithan Narin on 21.04.2019.
//  Copyright © 2019 Yigithan Narin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        
        return true
    }

    
    //*** telefon caldıgında yada bisey oldugunda applicationa ne olucagı
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    //*** home tusuna basınca yada bisekilde appi assagı dusurunce ne olucagı
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    ///*** Uygulama kapatıldıgında ne olucagı
    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }

    
    //*** CoreData gerekli stack fonksiyonu
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CalculationsData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
                
            }
            
        })
        return container
    }()
    
    
    //*** CoraData gerekli saving Support fonksiyonu(app terminate oldugu zaman save etme)
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do
            {
                try context.save()
            }
            catch
            {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

