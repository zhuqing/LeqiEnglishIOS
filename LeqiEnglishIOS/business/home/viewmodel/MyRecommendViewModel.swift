//
//  MyRecommendViewModel.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyRecommendViewModel: DataCache<[Content]> {
    private let DATA_TYPE = "MyRecommendViewModel"
    static let UPDATE_TYPE = "MyRecommendViewModel_UPDATE_TYPE"
    
    static let instance = MyRecommendViewModel()
    
    
    override func getUpdateTimeType() -> String? {
        return MyRecommendViewModel.UPDATE_TYPE
    }

    override func getFromService(finished: @escaping ([Content]?) -> ())  {
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        Service.get(path: "recommend/recommendArticle?userId=\(user.id ?? "")"){
            (data) in
           
            guard let datas = Service.getDatas(data: data) else{
                return
            }
            
            var contents:[Content]? = [Content]()
            for d in datas{
                contents?.append(Content(data:d))
            }
            
            finished(contents)
        }
    }
    
    
    override func getFromCache() -> [Content]? {
        
        let datas =  SQLiteManager.instance.readData(type: DATA_TYPE, parentId: UserDataCache.instance.getUserId())
        
        
        if(datas == nil || datas?.isEmpty ?? true){
            return  nil
        }
        var contents = [Content]()
        for data in datas!{
            contents.append(Content(data: String.toDictionary(data)!))
        }
        
        return contents
        
    }
    
    override func cacheData(data: [Content]?) {
        guard let ds = data else {
            return
        }

        for d in ds{
            SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), parentId: UserDataCache.instance.getUserId(), type: DATA_TYPE)
        }
    }
    
    
    //清理掉以前的数据
    override func claerData() {
        super.claerData()
        SQLiteManager.instance.delete(type: DATA_TYPE, parentId: UserDataCache.instance.getUserId())
        
        
        
    }
}
    

