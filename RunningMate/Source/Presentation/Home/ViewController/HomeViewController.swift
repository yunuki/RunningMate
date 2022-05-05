//
//  HomeViewController.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/05.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
    }
    
    private func initNavigationBar() {
        self.navigationController?.initNavigationBar(
            navigationItem: navigationItem,
            rightButtonImages: [Asset.Image.Profile, Asset.Image.Ranking],
            rightActions: [#selector(pushProfileVC(_:)), #selector(pushRankingVC(_:))])
    }
    
    @objc func pushRankingVC(_ sender: Any) {
        
    }
    
    @objc func pushProfileVC(_ sender: Any) {
        
    }
}
