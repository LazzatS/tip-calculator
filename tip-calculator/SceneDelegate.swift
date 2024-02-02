//
//  SceneDelegate.swift
//  tip-calculator
//
//  Created by Lazzat Seiilova on 01.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = CalculatorVC()
        self.window = window
        window.makeKeyAndVisible()
    }
}
