//
//  DispatchQueueUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/23.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import Foundation
class DispatchQueueUtil{
    
    //异步执行完成后调用回调
    class func run(excutor:@escaping ()->(),callback:(()->())?){
        let queue = DispatchQueue(label: "DispatchQueueUtil")
        queue.async {
            //异步执行
            excutor()
            if(callback == nil){
                return
            }
            
            //在主线程执行
            DispatchQueue.main.async {
                guard let call = callback else{
                    return
                }
                call()
            }
         }

    }
}
