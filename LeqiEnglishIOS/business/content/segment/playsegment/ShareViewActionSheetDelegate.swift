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
    
    init(segment:Segment) {
        self.segment = segment
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
        
        let title = "\(UserDataCache.instance.getUserName())完成了\"\(segment.title!)\"的背诵"
        switch data.0 {
        case "1":
            SharePlateformUtil.share(.subTypeWechatTimeline, url: url, title: title)
        case "2":
            SharePlateformUtil.share(.subTypeQZone, url:url, title: title)
        default:
            print("ee")
        }
    }
}
