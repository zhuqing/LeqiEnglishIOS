//
//  MyWords.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyWords: DataCache<[Word]> {
    private var user:User
    
    init(user:User){
        self.user = user
    }
    
    override func getFromService(finished: @escaping ([Word]?) -> ()) {
        Service.get(path: "english/word/findByUserId?userId=\(self.user.id ?? "")"){
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
