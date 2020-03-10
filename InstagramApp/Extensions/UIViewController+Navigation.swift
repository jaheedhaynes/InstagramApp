//
//  UIViewController+Navigation.swift
//  InstagramApp
//
//  Created by Jaheed Haynes on 3/10/20.
//  Copyright © 2020 Jaheed Haynes. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private static func resetWindow(with rootviewcontroller: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first,
        let sceneDelegate = scene.delegate as? SceneDelegate,
            let window = sceneDelegate.window else {
                fatalError("could not reset window rootViewController")
        }
        window.rootViewController = rootviewcontroller
    }
    
    public static func showViewController(storyboardName: String, viewControllerId: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        resetWindow(with: newVC)
    }
    
}
