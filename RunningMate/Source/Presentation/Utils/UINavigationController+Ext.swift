//
//  UINavigationController+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/05.
//

import UIKit

extension UINavigationController {
    private var backButtonImage: UIImage? {
        return Asset.Image.Back.resizeImage(to: CGSize(width: 10.5, height: 21))
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0))
    }
    
    private var backButtonAppearance: UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance()

        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0.0)
        ]

        return backButtonAppearance
    }
    
    func initNaviBarWithBackButton(tintColor: UIColor = .black) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor : tintColor
        ]
        
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = tintColor
    }
    
    func initNavigationBar(navigationItem: UINavigationItem?,
                            leftButtonImages: [UIImage]? = nil,
                            rightButtonImages: [UIImage]? = nil,
                            leftActions: [Selector]? = nil,
                            rightActions: [Selector]? = nil,
                            tintColor: UIColor = .black) {
         
         initNaviBarWithBackButton(tintColor: tintColor)
         
         makeBarButtons(navigationItem: navigationItem,
                        buttonImage: leftButtonImages,
                        actions: leftActions,
                        isLeft: true)
         
         makeBarButtons(navigationItem: navigationItem,
                        buttonImage: rightButtonImages,
                        actions: rightActions,
                        isLeft: false)
         
         let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
         navigationItem?.backBarButtonItem = backBarButtton
     }
    
    func makeBarButtons(navigationItem: UINavigationItem?,
                        buttonImage: [UIImage]?,
                        actions: [Selector]?,
                        isLeft: Bool
    ) {
        guard let buttonImage = buttonImage,
              let actions = actions else { return }
        
        var barButtonItems: [UIBarButtonItem] = []
        buttonImage.enumerated().forEach { index, image in
            guard let button = navigationItem?.makeCustomBarItem(self.topViewController, action: actions[index], image: image) else {return}
            barButtonItems.append(button)
        }
        
        if isLeft {
            navigationItem?.leftBarButtonItems = barButtonItems
        } else {
            navigationItem?.rightBarButtonItems = barButtonItems
        }
    }
}
