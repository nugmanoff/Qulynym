/*
 * Qulynym
 * AppDelegate.swift
 *
 * Created by: Metah on 2/24/19
 *
 * Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit
import CoreData

#warning("** means code can be refactored and improved")
/*
 Bugs, which are already found:
  1) Memory Leak with Audio
  2) Auto Layout on IPad: Karaoke Module(video view & Titles), closeBtn
  3) audio leak of the manager at the beginning(maybe is relatable to 1)
  4) Karaoke & Story Audio sliders optimization: sound slider is freezing
 Solutions, which will be integrated further:
  1) TimerController, AudioManager, Videos on another queue
  2) Back segue falling leaves
  3) Concurrency at Quiz: can't scroll while audio is playing
  4) Shuffle animation of cards
  5) ModuleView protocol properties get acccessor
  6) Sound slider animations
  7) Torgai loading is slow at first launch 
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var orientationLock = UIInterfaceOrientationMask.landscape
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupWindow()
        window?.makeKeyAndVisible()
        AudioPlayer.turnOnBackgroundMusic()
        
        return true
    }
    
    func setupWindow() {
        let rootVC = MenuViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock 
    }
}
