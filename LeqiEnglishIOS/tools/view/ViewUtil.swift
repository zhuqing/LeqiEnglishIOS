//
//  ViewUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/5.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class ViewUtil {
    
    //添加操作栏的元素
    class func addOperation(target: Any?,root:UIView,operations:[(String,String,Selector)]){
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
    
    class func updateOperationItemTitle(target: Any?,root:UIView,index:Int , itemData:(String,String)){
        let operationItem:OperationItemView = root.subviews[index] as! OperationItemView
        operationItem.set(title: itemData.0, imageName: itemData.1)
    }
    
    class func updateOperationItemTitle(target: Any?,root:UIView,index:Int , image:String){
        let operationItem:OperationItemView = root.subviews[index] as! OperationItemView
        operationItem.setImageName(name: image)
    }
}
