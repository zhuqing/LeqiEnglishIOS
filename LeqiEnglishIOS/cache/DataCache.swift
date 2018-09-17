//
//  LoadData.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class DataCache<T:Entity> {
    func getFromService(finished:@escaping (_ ts:[T]?)->()){}
    func getFromCache(finished:@escaping (_ ts:[T]?)->())->[T]?{return nil}
    func load(finished:@escaping (_ ts:[T]?)->()){
        getFromService(finished: finished)
    }
}


