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
    
    static let ROOT="leqienglish"
    
    static let LOG = LOGGER("Service")
    
    class func download(path:String,filePath:String,finishedCallback:@escaping (_ result:String)->()){
        //拼接路径
        let httpPath = "\(host)/\(path)"
        //拼接项目跟目录
        let appFilePath = "\(ROOT)\\\(filePath)"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(appFilePath)
       
        //如果文件存在，就不下载文件
        if(FileManager.default.fileExists(atPath: fileURL.path)){
            LOG.info("文件已存在")
            finishedCallback(fileURL.path)
            return
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(httpPath, to: destination).response { response in
           
            if response.error == nil, let imagePath = response.destinationURL?.path {
                print(imagePath)
                finishedCallback(imagePath)
            }
        }
    }
    
    class  func post(path:String,params:[String:String]? = nil,finishedCallback:@escaping (_ resut :[String:NSObject])->() ){
          let httpPath = getHttpPath(path)
        
        
        Alamofire.request(httpPath, method: .post, parameters:params , encoding: URLEncoding.httpBody, headers: nil).responseJSON(){  (response) in
            
            guard let result = response.result.value as? [String : NSObject] else {
                LOG.error(response.result.description)
                return
            }
            finishedCallback(result)
        }
    }
    
   
    
    //调用Get方法
    class func get(path:String,finishedCallback: @escaping (_ result : [String:NSObject])->()){
        
        let httpPath = "\(host)/\(path)"
        
        print(httpPath)
        
        Alamofire.request(httpPath, method: .get, encoding: URLEncoding.httpBody, headers: nil).responseJSON{
            (response) in
            
            guard let result = response.result.value as? [String : NSObject] else {
                LOG.error(response.result.description)
                return
            }
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
    
    //拼接成完整路径
    private class func getHttpPath(_ path:String)->String{
        let httpPath = "\(host)/\(path)"
        
        LOG.info(httpPath)
        
        return httpPath
    }
    
    
}
