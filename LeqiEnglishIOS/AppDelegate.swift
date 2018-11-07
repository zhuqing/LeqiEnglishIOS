//
//  AppDelegate.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/3/26.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.orange;
        
        ShareSDK.registPlatforms { register in
            
//            register?.setupWeChat(withAppId: "wx617c77c82218ea2c", appSecret: "c7253e5289986cf4c4c74d1ccc185fb1")
//            register?.setupSinaWeibo(withAppkey: "568898243", appSecret: "38a4f8204cc784f81f9f0daaf31e02e3", redirectUrl: "http://www.sharesdk.cn")
            register?.setupQQ(withAppId: "101515797", appkey: "efe34c73fd1182ffcbded86368aef2b6")
        }
        return true
    }

   

}

