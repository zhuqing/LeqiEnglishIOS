//
//  WelcomeViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/6.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController:UIViewController{
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setImageView()
      
        
    }
//    
//    private func setButton(){
//        button.layer.borderColor = UIColor.white.cgColor
//        
//        button.layer.borderWidth = 2;
//        
//        button.layer.cornerRadius = 16;
//    }
    
    private func setImageView(){
        imageView.layer.cornerRadius = 100
    }
}
