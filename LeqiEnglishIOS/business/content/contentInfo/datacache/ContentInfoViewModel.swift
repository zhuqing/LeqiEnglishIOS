//
//  ContentInfoViewModel.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/17.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ContentInfoViewModel: DataCache<[Segment]> {
    
    private var content:Content?
    
    private let LOG = LOGGER("ContentInfoViewModel")
    private let TYPE = "ContentInfoViewModel"
    
    init(content:Content?) {
        self.content = content
    }
    
    override func getFromService(finished: @escaping ([Segment]?) -> ()) {
        
        guard let c = content else {return}
        
        Service.get(path: "segment/findByContentId?contentId=\(c.id ?? "none")"){
            (data) in
            
            let datas = Service.getDatas(data: data)
            
            var contents:[Segment]? = [Segment]()
            for d in datas!{
                contents?.append(Segment(data:d))
            }
            
            finished(contents)
        }
    }
    
    override func getFromCache() -> [Segment]? {
        if(self.content == nil){
            return nil
        }
        
        let datas = SQLiteManager.instance.readData(type: TYPE, parentId: self.content?.id ?? "")

        if(datas == nil || datas?.isEmpty ?? true){
            return nil
        }
        
        var segments = [Segment]()
        for d in datas!{
            segments.append(Segment(data: String.toDictionary(d)!))
        }
        
        return segments
        
    }
    
    override func checkAndLoadNewset(finished:@escaping (_ ts:[Segment]?)->())  {
       let contentCache = SingleContent(contentId: self.content?.id ?? "")
        contentCache.getFromService(finished: {(c) in
            guard let con = c else{
                return
            }
            
            if(con.updateDate ?? 0  <= self.content?.updateDate ?? 0){
                return;
            }
            
           self.getFromService(finished: finished)
        })
    }
    
    override func cacheData(data: [Segment]?) {
        guard let arr = data else{
            return
        }
        
        if(self.content == nil){
            return
        }
        for  d  in arr {
               SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: self.content?.id ?? "", type: TYPE)
        }
   
    }
    
    override func claerData() {
       super.claerData()
         SQLiteManager.instance.delete(type: TYPE, parentId: self.content?.id ?? "")
    }
}
