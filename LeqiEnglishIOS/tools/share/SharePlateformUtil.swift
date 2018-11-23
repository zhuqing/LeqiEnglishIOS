//
//  SharePlaformUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class SharePlateformUtil{
    
    class func shareImage(_ type:SSDKPlatformType,imagePath:String,title:String,content:String){
        
        let params = NSMutableDictionary()
        
        params.ssdkSetupShareParams(byText: content, images: imagePath, url: nil, title: title, type: .image)
        SharePlateformUtil.share(params)
    }
    
    private class func share(_ params:NSMutableDictionary){
        ShareSDK.share(.typeSinaWeibo, parameters: params) { (state, userdata, contentEntity, error) in
            
            switch state
            {
            case .success:
                print("Success");
            case .fail:
                print("Fail:%@",error ?? "");
            case .cancel:
                print("cancel");
            default : break
            }
        }
    }
    
    class func share(_ type:SSDKPlatformType,url:String,title:String){
        
        let params = NSMutableDictionary()
        
        
        params.ssdkSetupShareParams(byText: "test", images: UIImage(named: "leqienglish64"), url: URL(string: url), title: title, type: .webPage)
        //2.进行分享
        ShareSDK.share(type, parameters: params) { (state, userdata, contentEntity, error) in
            
            switch state
            {
            case .success:
                print("Success");
            case .fail:
                print("Fail:%@",error ?? "");
            case .cancel:
                print("cancel");
            default : break
            }
        }
        
    }
    
    //        // 1.创建分享参数
    //        let shareParames = NSMutableDictionary()
    //        shareParames.ssdkSetupShareParams(byText: "分享内容",
    //                                          images : UIImage(named: "shareImg.png"),
    //                                          url : NSURL(string:"http://mob.com") as URL!,
    //                                          title : "分享标题",
    //                                          type : SSDKContentType.image)
    //
    //        //2.进行分享
    //        ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
    //
    //            switch state{
    //
    //            case SSDKResponseState.success: print("分享成功")
    //            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
    //            case SSDKResponseState.cancel:  print("操作取消")
    //
    //            default:
    //                break
    //            }
    //
    //        }
    
}
