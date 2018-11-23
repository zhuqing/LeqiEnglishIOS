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

            register?.setupWeChat(withAppId: "wxec6cca95f8f8627b", appSecret: "5ad231774720aa3d0d83509211ba7cae")

            register?.setupSinaWeibo(withAppkey: "4272638368", appSecret: "d544c9e0d2f43e9b0029c599326af8a1", redirectUrl: "http://www.leqienglish.com")
            register?.setupQQ(withAppId: "101515797", appkey: "efe34c73fd1182ffcbded86368aef2b6")
            
           
        }
        
    
        
     //   ShareSDKConnector.connectWeibo(<#T##weiboSDKClass: AnyClass!##AnyClass!#>)
        
//        ShareSDK .registerApp("ShareSDKAppKey")
//        //新浪微博
//        ShareSDK.connectSinaWeiboWithAppKey("4071914616", appSecret: "273f52407df87a15cbe06840c64cc0d2", redirectUri: "http://www.weibo.com/balancea")
//        //豆瓣
//        ShareSDK.connectDoubanWithAppKey("02e0393e2cfbecb508a0abba86f3c61f", appSecret: "9a000e648fd0cbce", redirectUri: "http://www.ijilu.com")
//        //QQ空间
//        ShareSDK.connectQZoneWithAppKey("1103527931", appSecret:"WEKkOPW0NJkc1cwS", qqApiInterfaceCls: QQApiInterface.classForCoder(), tencentOAuthCls: TencentOAuth.classForCoder())
//        //QQ
//        ShareSDK.connectQQWithAppId("1103527931", qqApiCls:QQApiInterface.classForCoder())
//        //链接微信
//        ShareSDK.connectWeChatWithAppId("wx5f09f3b56fd1faf7", wechatCls: WXApi.classForCoder())
//        //微信好友
//        ShareSDK.connectWeChatSessionWithAppId("wx5f09f3b56fd1faf7", wechatCls:WXApi.classForCoder())
//        //微信朋友圈
//        ShareSDK.connectWeChatTimelineWithAppId("wx5f09f3b56fd1faf7", wechatCls: WXApi.classForCoder())


        return true
    }
    
    func application(application: UIApplication,didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //设置启动图片停留时间
        Thread.sleep(forTimeInterval: 6.0)
        return true
    }
    
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
//
//        /**
//         *  初始化ShareSDK应用
//         *
//         *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
//         *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
//         *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
//         */
//
//        ShareSDK.registerActivePlatforms(
//            [
//                SSDKPlatformType.typeSinaWeibo.rawValue,
//                SSDKPlatformType.typeWechat.rawValue,
//                SSDKPlatformType.typeQQ.rawValue
//            ],
//            onImport: {(platform : SSDKPlatformType) -> Void in
//                switch platform
//                {
//                case SSDKPlatformType.typeSinaWeibo:
//                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
//                case SSDKPlatformType.typeWechat:
//                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                case SSDKPlatformType.typeQQ:
//                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
//                default:
//                    break
//                }
//        },
//            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
//                switch platform
//                {
//                case SSDKPlatformType.typeSinaWeibo:
//                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "4272638368",
//                                                appSecret: "d544c9e0d2f43e9b0029c599326af8a1",
//                                                redirectUri: "http://www.leqienglish.com",
//                                                authType: SSDKAuthTypeBoth)
//
//                case SSDKPlatformType.typeWechat:
//                    //设置微信应用信息
//                    appInfo?.ssdkSetupWeChat(byAppId: "wxec6cca95f8f8627b",
//                                             appSecret: "5ad231774720aa3d0d83509211ba7cae")
//                case SSDKPlatformType.typeQQ:
//                    //设置QQ应用信息
//                    appInfo?.ssdkSetupQQ(byAppId: "101515797",
//                                         appKey: "efe34c73fd1182ffcbded86368aef2b6",
//                                         authType: SSDKAuthTypeWeb)
//                default:
//                    break
//                }
//        })
//        return true
//    }


   

}

