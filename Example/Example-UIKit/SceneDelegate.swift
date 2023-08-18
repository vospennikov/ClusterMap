//
//  SceneDelegate.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let newScene = (scene as? UIWindowScene) else { return }
        let newWindow = UIWindow(windowScene: newScene)

        let outlineViewController = OutlineViewController()
        let navigationController = UINavigationController(rootViewController: outlineViewController)

        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController.navigationBar.tintColor = .label
        navigationController.navigationItem.standardAppearance = navigationBarAppearance
        navigationController.setNeedsStatusBarAppearanceUpdate()

        newWindow.rootViewController = navigationController

        window = newWindow
        window?.makeKeyAndVisible()
    }
}
