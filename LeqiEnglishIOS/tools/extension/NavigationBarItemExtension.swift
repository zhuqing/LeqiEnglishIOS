//
//  NavigationBarItemExtension.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/7.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    convenience init(imageName:String) {
        let uiButton = UIButton();
        uiButton.setImage(UIImage(named:"leqienglish"), for: .normal)
        uiButton.sizeToFit()
        uiButton.layer.cornerRadius = 20
       self.init(customView:uiButton)
        
    }
    
    convenience init(imageName:String,highLightImageName:String,size:CGSize){
         let uiButton = UIButton();
        
        uiButton.setImage(UIImage(named:imageName), for: .normal)
       uiButton.setImage(UIImage(named:highLightImageName),for:.highlighted)
        uiButton.frame = CGRect(origin: CGPoint.zero, size: size)
        
        self.init(customView:uiButton)
    }
}
