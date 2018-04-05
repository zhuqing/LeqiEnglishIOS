//
//  Service.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/4/2.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import Alamofire
class Service{
    func get(url:String,paramter:Dictionary<String,String>) -> Void{
        Alamofire.request("https://httpbin.org/get").response { response in
        print("Request: \(response.request)")
        print("Response: \(response.response)")
        print("Error: \(response.error)")
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)")
        }
        }
    }
}
