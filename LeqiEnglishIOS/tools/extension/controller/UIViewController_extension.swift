//
//  UIViewController_extension.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/10.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

extension  UIViewController {
    func  showAlert(message:String,closeHandler:(()->Swift.Void)? = nil)  {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "关闭", style: .cancel, handler:{
            (_) in
            if(closeHandler != nil){
                closeHandler!()
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func returnHome(){
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated: false, completion: nil)
    }

}
