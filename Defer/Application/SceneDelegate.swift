//
//  SceneDelegate.swift
//  Defer
//
//  Created by Иван Лукъянычев on 08.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: FlowCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        appCoordinator = AppAssembly.assemble(window: window)
        appCoordinator?.start()
    }

}

