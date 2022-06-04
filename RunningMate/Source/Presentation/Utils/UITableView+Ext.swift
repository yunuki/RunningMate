//
//  UITableView+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/30.
//

import UIKit

extension UITableView {
    func handleLoading(_ isLoading: Bool) {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            self.tableFooterView = activityIndicator
        } else {
            self.tableFooterView = UIView()
        }
    }
}
