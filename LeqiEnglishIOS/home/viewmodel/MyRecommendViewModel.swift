//
//  MyRecommendViewModel.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyRecommendViewModel: DataCache<Content> {
    

    override func getFromService(finished: @escaping ([Content]?) -> ())  {
        Service.get(path: "recommend/recommendArticle?userId=userId"){
            (data) in
           
            let datas = Service.getDatas(data: data)
            
            var contents:[Content]? = [Content]()
            for d in datas!{
                contents?.append(Content(data:d))
            }
            
            finished(contents)
        }
    }
}
    

