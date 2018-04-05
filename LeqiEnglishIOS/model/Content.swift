//
//  File.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/4/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class Content : Entity{
    var title:String
    var content:String
    var timing:String
    var audioPath:String
    var imagePath:String
    var auther:String
    
    var words:Array<String> = []
    
 init(id:String,createTime:String,updateTime:String,status:String,title:String,content:String,timing:String,audioPath:String,imagePath:String,auther:String){
        super.init(id: id, createTime: createTime, updateTime: updateTime, status: status)
        self.title = title
        self.content = content
        self.timing = timing
        self.audioPath = audioPath
        self.imagePath = imagePath
        self.auther = auther
    }
    
    convenience  init() {
     super.init()
        self.title = ""
        self.content = ""
        self.timing = ""
        self.audioPath = ""
        self.imagePath = ""
        self.auther = ""
    }
}
