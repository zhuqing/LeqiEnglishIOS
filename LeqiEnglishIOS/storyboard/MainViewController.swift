//
//  MainViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit
class MainViewController:UIViewController{
    
    override func viewDidLoad() {
        setupMainUI()
    }
}

// MARK setUI
extension MainViewController{
    private func setupMainUI(){
        setupNavigationBar()
    }
    private func setupNavigationBar(){
        
       // navigationItem.leftBarButtonItem = UIBarButtonItem(imageName:"leqienglish_log128")
        let size = CGSize(width: 40, height: 40)
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName:"search_normal",highLightImageName:"search_selected",size:size)
        
    }
}
