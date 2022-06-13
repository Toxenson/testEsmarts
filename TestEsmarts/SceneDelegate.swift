//
//  SceneDelegate.swift
//  TestEsmarts
//
//  Created by Тоха on 10.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let presenter = BluetoothPresenter()
        let controller = BluetoothViewController()
        presenter.output = controller
        controller.presenter = presenter
        window?.rootViewController = controller
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
