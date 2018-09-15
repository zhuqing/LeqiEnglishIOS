//
//  LoadData.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol DataCache {
   func getFromService<T:Entity> ()->[T]?
   func getFromCache<T:Entity> ()->[T]?
   func load<T:Entity> (finished:(_ ts:[T]?)->())
}

extension DataCache{
    func load<T:Entity>(finished:(_ ts:[T]?)->()){
        var ts:[T]? = getFromCache()
        
        if ts == nil{
            ts = getFromService()
        }
        
        finished(ts);
    }
}
