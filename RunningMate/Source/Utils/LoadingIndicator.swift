//
//  LoadingIndicator.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/17.
//

import UIKit

class LoadingIndicator {
    
    static func handleLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {return}
                
                let loadingIndicatorView: UIActivityIndicatorView
                if let existedView = window.subviews.first(where: {$0 is UIActivityIndicatorView}) as? UIActivityIndicatorView {
                    loadingIndicatorView = existedView
                } else {
                    loadingIndicatorView = UIActivityIndicatorView(style: .large)
                    loadingIndicatorView.frame = window.frame
                    loadingIndicatorView.color = UIColor.setGray(153)
                    window.addSubview(loadingIndicatorView)
                }
                loadingIndicatorView.startAnimating()
            } else {
                guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else { return }
                window.subviews
                    .filter{$0 is UIActivityIndicatorView}
                    .forEach{$0.removeFromSuperview()}
            }
        }
    }
}
