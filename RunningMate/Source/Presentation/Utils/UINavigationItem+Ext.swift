//
//  UINavigationItem+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/06.
//

import UIKit

extension UINavigationItem {
    func makeCustomBarItem(_ target: Any?, action: Selector? = nil, image: UIImage) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        
        if let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        return barButtonItem
    }
}
