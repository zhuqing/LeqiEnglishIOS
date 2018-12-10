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
    
    func checkUpdate(){
        VersionDataCache.instance.checkUpdate(){
            (version) in
            guard let ver = version else{
                return
            }
            let alert = UIAlertController(title: "是否更新", message: ver.message ?? "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "忽略", style: .cancel, handler:{
                (_) in
               VersionDataCache.instance.cacheData(data: version)
                
            }))
            
           
            
            alert.addAction(UIAlertAction(title: "下次更新", style:.default, handler: nil))
            alert.addAction(UIAlertAction(title: "更新", style: .default, handler: {
                (_) in
                self.updateApp(appId: ver.versionCode ?? "")
                  VersionDataCache.instance.cacheData(data: version)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //调用更新APP
    func updateApp(appId:String) {
        let updateUrl:URL = URL.init(string: "http://itunes.apple.com/app/id" + appId)!
        UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
    }

}
