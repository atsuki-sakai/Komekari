//
//  SceneDelegate.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/20.
//

import UIKit
import Firebase

public var mainNavigationController: UINavigationController!

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let viewControllers = setUpViewControllers()
        let tabBarController = setUpTabBar(viewControllers: viewControllers)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func setUpViewControllers() -> [UIViewController] {
        
        var viewControllers: [UIViewController] = []

        
        let mainController =  MainController()
        mainController.tabBarItem = UITabBarItem(title: "米一覧", image: UIImage(systemName: "list.dash"), selectedImage: UIImage(systemName: "list.star"))
        mainNavigationController = UINavigationController(rootViewController: mainController)
        viewControllers.append(mainNavigationController)
        
        let favoriteController = FavoriteController()
        favoriteController.tabBarItem = UITabBarItem(title: "お気に入り", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteController)
        viewControllers.append(favoriteNavigationController)
        
        let notificationController = NotificationController()
        notificationController.tabBarItem = UITabBarItem(title: "通知", image: UIImage(systemName: "envelope"), selectedImage: UIImage(systemName: "envelope.fill"))
        let notificationNavigationController = UINavigationController(rootViewController: notificationController)
        viewControllers.append(notificationNavigationController)
        
        let cartController = CartController()
        cartController.tabBarItem = UITabBarItem(title: "カート", image:  UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        let cartNavigationController = UINavigationController(rootViewController: cartController)
        viewControllers.append(cartNavigationController)
        
        let myPageController = MyPageController()
        myPageController.tabBarItem = UITabBarItem(title: "マイページ", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        let myPageNavigationController = UINavigationController(rootViewController: myPageController)
        viewControllers.append(myPageNavigationController)
        
        return viewControllers
    }
    
    fileprivate func setUpTabBar(viewControllers: [UIViewController],
                                 selectedColor: UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
                                 unSelectColor: UIColor = .lightGray,
                                 bgColor: UIColor = .white) -> UITabBarController {
        
        // タブバーコントローラー
        UITabBar.appearance().tintColor = selectedColor
        UITabBar.appearance().unselectedItemTintColor = unSelectColor
        UITabBar.appearance().barTintColor = bgColor
        UITabBar.appearance().isTranslucent = false


        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(viewControllers, animated: false)
        
        return tabBarController
    }


}

