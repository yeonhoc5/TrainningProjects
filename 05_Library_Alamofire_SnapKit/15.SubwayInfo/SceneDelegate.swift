//
//  SceneDelegate.swift
//  15.SubwayInfo
//
//  Created by yeonhoc5 on 2022/09/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
        let navigationController = UINavigationController(rootViewController: SubwaySearchViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        // 네비게이션 customizing
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = .orange
        navigationAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.standardAppearance = navigationAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
        navigationController.navigationBar.compactAppearance = navigationAppearance
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

