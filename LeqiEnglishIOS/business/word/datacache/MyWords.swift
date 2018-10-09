//
//  MyWords.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyWords: DataCache<[Word]> {
  
    static let instance = MyWords()
    
    private override init(){
        
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        guard  let user = UserDataCache.userDataCache.getFromCache() else{
            return
        }
        Service.get(path: "english/word/findByUserId?userId=\(user.id ?? "")"){
            (results) in
            let datas = Service.getDatas(data: results)
           
            guard let array = datas else{
                return
            }
            
            var words = [Word]()
            for data in array{
                let word = Word(data: data)
                words.append(word)
            }
            finished(words)
        }
    }
}
