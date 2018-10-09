//
//  LongDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class LongDataCache: DataCache<Int64> {
    private var path:String
    
    init(path:String){
        self.path = path
    }
    
    override func getFromService(finished: @escaping (Int64?) -> ()) {
        Service.get(path: self.path){
            (results) in
            
            guard let value = Service.getData2String(data: results) else{
               finished(0)
                return
            }
            
            finished(Int64(value))
        }
    }
}
