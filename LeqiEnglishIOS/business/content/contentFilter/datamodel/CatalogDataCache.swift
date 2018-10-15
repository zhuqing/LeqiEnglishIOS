//
//  CatalogDataCache.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class CatalogDataCache: DataCache<[Catalog]> {
    
    static let instance = CatalogDataCache()
    
    static let TYPE = "CATA_DATACACHE"
    
    private override init(){
        super.init()
    }
    
    override func getFromCache() -> [Catalog]? {
        guard  let datas = SQLiteManager.instance.readData(type: CatalogDataCache.TYPE) else {
            return nil
        }
        var catalogs = [Catalog]()
        for data in datas {
            catalogs.append(Catalog(data: String.toDictionary(data)!))
        }
        
        return catalogs
    }
    
    override func getFromService(finished: @escaping ([Catalog]?) -> ()) {CATALOG_TYPE
        Service.get(path: "english/catalog?type=\(CATALOG_TYPE)"){
            (results) in
            guard let datas = Service.getDatas(data: results) else {
                return
            }
            
            var catalogs = [Catalog]()
            for data in datas {
                catalogs.append(Catalog(data: data))
            }
            
            finished(catalogs)
        }
    }
    
    override func cacheData(data: [Catalog]?) {
        if( data == nil){
            return
        }
        
        SQLiteManager.instance.delete(type: CatalogDataCache.TYPE)
       
        for d in data! {
            let josn =
            SQLiteManager.instance.insertData(id: d.id ?? "", json: d.toJSONString(), type: CatalogDataCache.TYPE)
        }
        
    }
}
