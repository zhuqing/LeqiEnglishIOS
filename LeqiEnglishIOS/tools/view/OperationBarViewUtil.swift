//
//  ViewUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/5.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class OperationBarViewUtil {
    
   static let   instance = OperationBarViewUtil()
    
    //添加操作栏的元素
    class func addOperation(target: Any?,root:UIView,operations:[(String,String,Selector)]){
          root.topBorder(width: 1, borderColor: UIColor.black)
        let count = CGFloat(operations.count)
        var index = CGFloat(0)
        for (title,imageName,action) in operations{
            let rect = CGRect(x: (SCREEN_WIDTH/count)*index, y: 0, width: SCREEN_WIDTH/count, height: 40)
            index += 1
            let operationItem = OperationItemView(frame: rect  , title: title, imageName: imageName)
            root.addSubview(operationItem)
            
            operationItem.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: target, action:action)
            
            operationItem.addGestureRecognizer(tapGesture)
        }
    }
    
    //添加操作栏的元素
     func addOperation(root:UIView,operations:[(String,String)],handler:@escaping ((_ id:String)->())){
        let count = CGFloat(operations.count)
         root.topBorder(width: 1, borderColor: UIColor.black)
        var index = CGFloat(0)
        for (title,imageName) in operations{
            let rect = CGRect(x: (SCREEN_WIDTH/count)*index, y: 0, width: SCREEN_WIDTH/count, height: 40)
            index += 1
            let operationItem = OperationItemView(frame: rect  , title: title, imageName: imageName)
            root.addSubview(operationItem)
          operationItem.handler = handler
            operationItem.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(OperationBarViewUtil.operationItem(uiTap:)))
            
            operationItem.addGestureRecognizer(tapGesture)
        }
    }
    
    //item的点击事件c处理
    @objc  private func operationItem(uiTap:UITapGestureRecognizer){
        
        guard let msg:OperationItemView = uiTap.view as? OperationItemView else{
            return
        }
        
        guard let handler = msg.handler else{
            return
        }
        
        
        handler(msg.imageName)
    }

    
    class func updateOperationItemTitle(root:UIView,index:Int , itemData:(String,String)){
        let operationItem:OperationItemView = root.subviews[index] as! OperationItemView
        operationItem.set(title: itemData.0, imageName: itemData.1)
    }
    
    class func updateOperationItemTitle(root:UIView,index:Int , image:String){
        let operationItem:OperationItemView = root.subviews[index] as! OperationItemView
        operationItem.setImageName(name: image)
    }
}
