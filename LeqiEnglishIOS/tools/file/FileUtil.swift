//
//  FileUtil.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/19.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
class FileUtil{
     static let LOG = LOGGER("FileUtil")
     static let ROOT="leqienglish"
    class func absulateFileUrl(filePath:String)->URL{
        //拼接项目跟目录URL
        
        let appFilePath = "\(ROOT)/\(filePath)"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        FileUtil.LOG.warn(documentsURL.appendingPathComponent(appFilePath).path)
        return documentsURL.appendingPathComponent(appFilePath)
    }
    
    class func removeFile(filePath:String){
        do {
            try FileManager.default.removeItem(atPath: filePath)
        }
        catch{
            print(error)
        }
       
    }
    
    //判断文件是否存在
    class func hasFile(path:String) ->Bool{
        let absulatePath = FileUtil.absulateFileUrl(filePath: path)
   //     removeFile(filePath: absulatePath.path)
        if(FileManager.default.fileExists(atPath: absulatePath.path)){
            return true
        }
        
        return false
    }
}
