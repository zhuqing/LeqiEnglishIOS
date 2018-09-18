//
//  MyRecitedViewModel.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class MyRecitedViewModel:DataCache<ReciteContentVO>{
    override func getFromService(finished: @escaping ([ReciteContentVO]?) -> ())  {
        Service.get(path: "recommend/recommendArticle?userId=userId"){
            (data) in
            
            let datas = Service.getDatas(data: data)
            
            var contents:[ReciteContentVO]? = [ReciteContentVO]()
            for d in datas!{
                contents?.append(ReciteContentVO(data:d))
            }
            
            finished(contents)
        }
    }
}
