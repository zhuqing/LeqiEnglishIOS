//
//  SingleContent.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class SingleContent: DataCache<Content> {
    let LOG = LOGGER("SingleContent")
    var contentId:String
    init(contentId:String) {
        self.contentId = contentId
    }
    
    override func getFromService(finished: @escaping (Content?) -> ()) {
        Service.get(path: "english/content/findById?id=\(self.contentId)"){
            (results) in
            self.LOG.info("\(results)")
            
            let data = Service.getData(data: results)
            
            guard let d = data else{
                return 
            }
            
            let content = Content(data:d)
            
            finished(content)
        }
    }
    
    func updateDatabase(){
        self.getFromService(){
            (content) in
            guard let c = content else{
                return
            }
            MyContentDataCache.instance.update(content: c)
            SQLiteManager.instance.update(entity: c)
        }
    }
    
   
}
