//
//  SegmentDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/7.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class SegmentDataCache: DataCache<Segment> {

    private var id:String
     init(id:String) {
        self.id = id
    }
    
    override func getFromService(finished: @escaping (Segment?) -> ()) {
        Service.get(path: "/segment/findById?id=\(self.id)" ){
            (datas) in
           
            
            guard  let data = Service.getData(data: datas) else{
                 finished(nil);
                return
            }
            
            let segment = Segment(data: data)
            
            finished(segment);
        }
    }
    
    func updateData(contentId:String){
        self.getFromService(){
            (segment) in
            guard let s = segment else{
                return
            }
            
            SQLiteManager.instance.update(entity: s)
            
            let contentInfoDataCache:ContentInfoDataCache? = AppRefreshManager.instance.get(id: ContentInfoDataCache.CACHE_MANAGER_ID) as? ContentInfoDataCache
            
            if let con = contentInfoDataCache {
                con.update(segment: s)
            }
            
           
        }
    }
}
