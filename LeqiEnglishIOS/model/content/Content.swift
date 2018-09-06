//
//  File.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/4/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class Content : Entity{
    
    var  content:String?;
    
    var  userId:String?;
    /**
     * 图片路
     */
    var  imagePath:String?;
    /**
     * 音频路径
     */
    var  audioPath:String?;
    
    /**
     * 标题
     */
    var  title:String?;
    /**
     * fu类ID
     */
    var  parentId:String?;
    
    /**
     * 内容所属的分类
     */
    var  catalogId:String?;
    
    /**
     * 阅读数
     */
    var  readNum:Int?;
    
   
}
