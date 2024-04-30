//  SceneDelegate.swift

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // Display the splash screen initially
        window?.rootViewController = UIHostingController(rootView: SplashScreenView())
        window?.makeKeyAndVisible()
        
        // Transition to the main content after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showMainContent()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
    
    private func showMainContent() {
        window?.rootViewController = UIHostingController(rootView: TabedView())
    }
}
