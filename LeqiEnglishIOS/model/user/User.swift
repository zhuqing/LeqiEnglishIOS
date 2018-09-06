//
//  User.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/6.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation

class User : Entity{
    /**
     * 匿名
     */
    var  name:String?
    /**
     * 性别
     */
    var  sex:Int?
    /**
     * 密码
     */
    var  password:String?
    /**
     * 邮箱
     */
    var  email:String?
    
    /**
     * VIP截止日期
     */
    var  vipLastData:String?
    /**
     * 手机号码
     */
    var  phoneNumber:String?
    
    
    /**
     * 其他系统的Id
     
     */
    var  otherSysId:String?
    
    /**
     * 最后一次登录时间
     */
    var  lastLogin:Int64?
    
    /**
     * 用户图像
     */
    var  imagePath:String?
    

}
