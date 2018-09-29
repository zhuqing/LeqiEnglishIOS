//
//  MyReciteWords.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/27.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyReciteWords: DataCache<[Word]> {
    var LOG = LOGGER("MyReciteWords");
    
    static let  instance = MyReciteWords();
    
    private override init() {
        
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        guard  let user = UserDataCache.userDataCache.getFromCache() else{
            self.LOG.error("没有找到user")
            return
        }
        
        guard  let reciteConfig = MyReciteWordConfig.instance.getFromCache() else{
            self.LOG.error("没有找到reciteConfig")
            return
        }
        
        Service.get(path: "english/word/findMyReciteByUserIdAndNumber?userId=\(user.id ?? "")&number=\(reciteConfig.reciteNumberPerDay ?? 10)"){
            (results) in
            let datas = Service.getDatas(data: results)
            
            guard let array = datas else{
                return
            }
            
            var words = [Word]()
          
            for data in array{
                words.append(Word(data: data))
            }
            finished(words)
        }
    }
}
