//
//  Catalog.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/6.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class Catalog : Entity{
    /**
     * 分类的标题
     */
    var  title:String?
    /**
     * 图片路径
     */
    var  imagePath:String?
    /**
     * 书和章节
     */
    var  type:Int?
    
    /**
     * 如果是章节的话 有父节点Id
     */
    var  parentId:String?
    
    /**
     * 详情描述
     */
    var  description:String?
    
    /**
     * 创建者
     */
    var  userId:String?
    
    /**
     * 订阅数
     */
    var  subscribeNum:Int?
    

}
