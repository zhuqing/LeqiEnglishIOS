//
//  Logger.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class LOGGER{
    var tag:String
    init(_ tag:String){
        self.tag = tag
    }
    
    func info(_ message:String){
        print("INFO:\(tag)\t\(message)")
    }
    
    func warn(_ message:String){
        print("WARN:\(tag)\t\(message)")
    }
    func error(_ message:String){
        print("ERROR:\(tag)\t\(message)")
    }
    
}

