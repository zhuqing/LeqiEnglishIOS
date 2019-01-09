//
//  CollectionUtils.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/7.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class CollectionUtils {

    //在datas中与d相同的数据的索引
    class func indexof<T:Entity>(datas:[T] , d:T)->Int {
        for index in 0 ..< datas.count{
            let c = datas[index]
            
            if((c.id ?? "") == (d.id ?? "")){
                return index
               
            }
            
        }
        
        return -1
    }
}
