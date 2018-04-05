//
//  Word.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/4/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class Word : Entity{
    var word:String
    var information:String
    var contentIds:Array<String> = []
    
     init(id: String, createTime: String, updateTime: String, status: String,word:String,information:String,contentIds:Array<String>) {
        super.init(id: id, createTime: createTime, updateTime: updateTime, status: status)
        self.word = word
        self.information = information;
        self.contentIds = contentIds;
    }
    
    convenience  init(){
        super.init()
        self.word = ""
        self.information = ""
        self.contentIds = []
    }
}
