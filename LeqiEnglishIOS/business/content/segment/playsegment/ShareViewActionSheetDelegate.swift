//
//  ShareViewActionSheetDelegate.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/19.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class ShareViewActionSheetDelegate: ActionSheetDialogViewControllerDelegate {
 
    private var segment:Segment
    private var title:String = "背诵"
    
    init(segment:Segment,title:String) {
        self.segment = segment
        self.title = title
    }
    
    init(segment:Segment) {
        self.segment = segment
        title = "背诵"
    }
    func getOperation(viewController: ActionSheetDialogViewController) -> [String : () -> ()]? {
       return nil
    }
    
    func getContentViewHeight(viewController: ActionSheetDialogViewController) -> CGFloat? {
        return CGFloat(100)
    }
    
    func getContentView(viewController: ActionSheetDialogViewController) -> UIView? {
        let shareView = ShareView(frame: CGRect.zero)
        shareView.delegate = self
        return shareView
    }
    
    func closeEventHandler(viewController: ActionSheetDialogViewController) {
       
    }
}


//ShareViewDelegate
extension ShareViewActionSheetDelegate:ShareViewDelegate{
    func click(view: ShareView, data: (String, String, UIImage)) {
       
        let url = "\(Service.host)/html/share/shareContent.html?segmentId=\(segment.id ?? "")&userId=\(UserDataCache.instance.getUserId())"
        
        let title = "\(UserDataCache.instance.getUserName())正在\(self.title)演讲\"\(segment.title!)\""
        switch data.0 {
        case "1":
           SharePlateformUtil.share(.subTypeWechatTimeline, url: url, title: title)
        case "2":
           SharePlateformUtil.share(.subTypeQZone, url:url, title: title)
            //SharePlateformUtil.shareImage(.subTypeQZone, imagePath: <#T##String#>, title: <#T##String#>, content: <#T##String#>)
        default:
            print("ee")
        }
    }
}
