//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //ロードされる時に呼び出される
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       //アプリが開いている間に携帯電話に何かしらのアクションが加わった時に呼び出される
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //アプリが終了する際に呼び出される
        self.saveContext()
        
    }

    // MARK: - Core Data stack

    //lazy:　遅延変数　宣言した場合その変数が必要とされる時点でのみ値がロードされる
                //NSPersistentContainer: 基本的にここに全てのデータを保存することになる
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
                //データを変更.または更新できるエリア
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                //永久保存にコミット
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}





