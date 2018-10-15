//
//  ContentsFilterDataCatche.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ContentsDataCatche: DataCache<[Content]> {
    private var path:String
    
    init(path:String){
        self.path  = path
    }
    override func getFromService(finished: @escaping ([Content]?) -> ()) {
        Service.get(path: self.path){
            (results) in
            
            guard let datas = Service.getDatas(data: results) else{
                return
            }
            
            var contents = [Content]()
            
            for data in datas {
                contents.append(Content(data: data))
            }
            
            finished(contents)
        }
    }
}
