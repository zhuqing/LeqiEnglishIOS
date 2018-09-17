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
    static let host="http://www.leqienglish.com"
    
    class func download(path:String,filePath:String,finishedCallback:@escaping (_ result:String)->()){
        let httpPath = "\(host)/\(path)"
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(filePath)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        
        Alamofire.download(httpPath, to: destination).response { response in
            print(response)
            
            if response.error == nil, let imagePath = response.destinationURL?.path {
                print(imagePath);
                finishedCallback(imagePath)
            }
        }
    }
    
    
    //调用Get方法
    class func get(path:String,finishedCallback: @escaping (_ result : [String:NSObject])->()){
        
        let httpPath = "\(host)/\(path)"
    
        print(httpPath)
        
        Alamofire.request(httpPath, method: .get, encoding: URLEncoding.httpBody, headers: nil).responseJSON{
            (response) in
        
            guard let result = response.result.value as? [String : NSObject] else {
                print(response.result.error)
                return
            }
            print(result)
            finishedCallback(result)
        }
    }
    
    class func getData(data:[String:NSObject])->[String:NSObject]?{
        guard let result = data["data"] as? [String:NSObject] else {
            guard let str = data["data"] as? String else {return nil}
            return String.toDictionary(str)
        }
        
        return result
    }
    
    class func getDatas(data:[String:NSObject])->[[String : NSObject]]?{
        
        guard let result = data["data"] as? [[String : NSObject]] else {
            guard let str = data["data"] as? String else {return nil}
            return String.toDictionarys(str)
        }
        return result
    }
    
    class func getMessage(data:[String:NSObject]) -> String?{
        guard let message = data["message"] as? String else {return ""}
        
        return message
    }
    
    class func isSuccess(data:[String:NSObject]) ->Bool{
        guard let status:String = data["status"] as? String else {
            return false
            
        }
        
        if status == "-1" {
            return false
        }
        
        return true
        
    }
    
    
}
