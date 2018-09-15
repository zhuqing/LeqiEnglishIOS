//
//  RecommendDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class RecommendDataCache: DataCache {
    func load<T>(finished: ([T]?) -> ()) where T : Entity {
       
    }
    
     func getFromCache<T>() -> [T]? where T : Entity {
        return nil
    }
    
     func getFromService<T>() -> [T]? where T : Entity {
        return nil
    }
    
   
}
