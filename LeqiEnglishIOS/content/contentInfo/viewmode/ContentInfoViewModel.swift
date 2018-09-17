//
//  ContentInfoViewModel.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/17.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ContentInfoViewModel: DataCache<Segment> {
    
    private var content:Content?
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
}
