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
//    static let host = "http://www.leqienglish.com"
    
    static let host = "http://192.168.43.9:8080"
    
    static let LOG = LOGGER("Service")
    
    static var isConnect = false;
    
  
    
  
    private static  var  alamoFireManager = { () -> SessionManager in
        let  manager = Alamofire.SessionManager.default
               manager.session.configuration.timeoutIntervalForRequest = 1
       
         return manager
    }()
    
    class func download(filePath:String , hasLoaded: @escaping( _ percent:CGFloat)->(),finishedCallback:@escaping (_ result:String)->()){
          let path = "file/download?path=\(filePath)"
        //拼接路径
        let httpPath = "\(host)/\(path)"
        if(!Service.isConnect){
            finishedCallback("")
            return;
        }
        //拼接项目跟目录
        
        let fileURL = FileUtil.absulateFileUrl(filePath: filePath)
        
        //如果文件存在，就不下载文件
        if(FileManager.default.fileExists(atPath: fileURL.path)){
            LOG.info("文件已存在")
            finishedCallback(fileURL.path)
            return
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(httpPath, to: destination).downloadProgress(queue: DispatchQueue.main, closure: {
            (progress) in
               hasLoaded(CGFloat(progress.fractionCompleted))
        }).response { response in
            
            if response.error == nil, let imagePath = response.destinationURL?.path {
                print(imagePath)
                finishedCallback(imagePath)
            }else{
                FileUtil.removeFile(filePath: filePath)
                finishedCallback("")
            }
        }
    }
   
    class func download(filePath:String,finishedCallback:@escaping (_ result:String)->()){
        //拼接路径
        let httpPath = "file/download?path=\(filePath)"

        download(path:httpPath,filePath:filePath,finishedCallback:finishedCallback)
    }
    
    
    class func reDownload(filePath:String,finishedCallback:@escaping (_ result:String)->()){
        //拼接路径
        let httpPath = "file/download?path=\(filePath)"
        let fileURL = FileUtil.absulateFileUrl(filePath: filePath)
        do{
        try FileManager.default.removeItem(atPath: fileURL.path)
        }catch{
           print(filePath)
        }
        download(path:httpPath,filePath:filePath,finishedCallback:finishedCallback)
    }
    
    
    //
//    class func currentNetReachability() {
//        let manager = NetworkReachabilityManager(host: host)
//        manager?.listener = { status in
//           // var statusStr: String?
//            switch status {
//            case .unknown:
//               
//                Service.isConnect = false;
//                break
//            case .notReachable:
//                
//                Service.isConnect = false;
//            case .reachable:
//                if (manager?.isReachableOnWWAN)! {
//                  
//                } else if (manager?.isReachableOnEthernetOrWiFi)! {
//                    
//                }
//                
//                Service.checkNet(resultCallback:{(b) in
//                      Service.isConnect = b;
//                })
//               
//                break
//            }
//           // self.debugLog(statusStr as Any)
//        }
//        manager?.startListening()
//    }
  
    
    class func download(path:String,filePath:String,finishedCallback:@escaping (_ result:String)->()){
        //拼接路径
        let httpPath = "\(host)/\(path)"
        //拼接项目跟目录
      
        let fileURL = FileUtil.absulateFileUrl(filePath: filePath)
       
        //如果文件存在，就不下载文件
        if(FileManager.default.fileExists(atPath: fileURL.path)){
            LOG.info("文件已存在")
            finishedCallback(fileURL.path)
            return
        }
        
        if(!Service.isConnect){
            finishedCallback("")
            return;
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        alamoFireManager.download(httpPath, to: destination).response { response in
           
            if response.error == nil, let imagePath = response.destinationURL?.path {
                print(imagePath)
                finishedCallback(imagePath)
            }else{
                FileUtil.removeFile(filePath: filePath)
                finishedCallback("")
            }
        }
    }
    
    class  func post(path:String,params:[String:String]? = nil,finishedCallback:@escaping (_ resut :[String:NSObject])->() ){
          let httpPath = getHttpPath(path)
        
        if(!Service.isConnect){
            return;
        }
        Alamofire.request(httpPath, method: .post, parameters:params , encoding: JSONEncoding.default, headers: nil).responseJSON(){  (response) in

            guard let result = response.result.value as? [String : NSObject] else {
                LOG.error(response.result.error.debugDescription)
                  //finishedCallback([String : NSObject]())
                return
            }

            LOG.info("\(result)")

            finishedCallback(result)
        }
        //request(method: .post, path: path, params: params, finishedCallback: finishedCallback)
    }
    
    class func put(path:String,params:[String:String]? = nil, finishedCallback:@escaping (_ resut :[String:NSObject])->()){
        if(!Service.isConnect){
            return;
        }
         request(method: .put, path: path, params: params, finishedCallback: finishedCallback)
    }
    
    
    private class func request(method: HTTPMethod, path:String,params:[String:String]? = nil, finishedCallback:@escaping (_ resut :[String:NSObject])->()){
          let httpPath = getHttpPath(path)
        
        if(!Service.isConnect){
            return;
        }
        
        
        alamoFireManager.request(httpPath, method: method, parameters:params , encoding: JSONEncoding.default, headers: nil).responseJSON(){  (response) in
            
            guard let result = response.result.value as? [String : NSObject] else {
                LOG.error(response.result.error.debugDescription)
                  //finishedCallback([String : NSObject]())
                return
            }
            
            LOG.info("\(result)")
            
            finishedCallback(result)
        }
    }
    
    //检查网络能不能连接到服务段
    class func checkNet(resultCallback:@escaping (_ result :Bool)->()){
        let httpPath = getHttpPath("/check/check")
      
        
        alamoFireManager.request(httpPath, method: .get, encoding: URLEncoding.httpBody, headers: nil).responseJSON{
            (response) in
            
            guard let result = response.result.value as? [String : NSObject] else {
                LOG.error(response.result.description)
                 Service.isConnect = false
                resultCallback(false)
                return
            }
            Service.isConnect = true
            resultCallback(true)
        }
    }
    
   
    
    //调用Get方法
    class func get(path:String,finishedCallback: @escaping (_ result : [String:NSObject])->()){
        
        let httpPath = getHttpPath(path)
    
        if(!Service.isConnect){
            return;
        }
        
        Alamofire.request(httpPath, method: .get, encoding: URLEncoding.httpBody, headers: nil).responseJSON{
            (response) in

            guard let result = response.result.value as? [String : NSObject] else {
                LOG.error(response.result.description)
               //  finishedCallback([String : NSObject]())
                return
            }
            finishedCallback(result)
        }
        
        //  request(method: .get, path: path, params: nil, finishedCallback: finishedCallback)
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
    
    class func getData2String(data:[String:NSObject]) -> String?{
        guard let message = data["data"] as? String else {return ""}
        
        return message
    }
    
    class func getMessage(data:[String:NSObject]) -> String?{
        guard let message = data["message"] as? String else {return ""}
        
        return message
    }
    
    class func isSuccess(data:[String:NSObject]) ->Bool{
        guard let status = data["status"]  else {

            return false
            
        }
        
        if "\(status)" == "-1" {
            LOG.info("\(status)")
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
