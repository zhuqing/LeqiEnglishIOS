//
//  SegmentPlayEntity.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/12/21.
//  Copyright © 2018 zhuleqi. All rights reserved.
//
class SegmentPlayEntity : Entity{
    
    var startTime:Double?
    
    var endTime:Double?
    
    var filePath:String?
    
    var path:String?
    
    var segmentId:String?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "startTime":
            self.startTime = value as? Double
        case "endTime":
            self.endTime = value as? Double
        case "filePaht":
            self.filePath = value as? String
        case "segmentId":
            self.segmentId = value as? String
        case "path":
            self.path = value as? String
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.startTime{
            dic["startTime"] = v as NSObject
        }
        if  let v = self.endTime{
            dic["endTime"] = v as NSObject
        }
        if  let v = self.filePath{
            dic["filePaht"] = v as NSObject
        }
        if  let v = self.segmentId{
            dic["segmentId"] = v as NSObject
        }
        
        return dic
    }
    
    public class func createSegmentPlayEntity(segment:Segment) -> SegmentPlayEntity?{
        let segmentPlayEntity =  SegmentPlayEntity()
        
        segmentPlayEntity.segmentId = segment.id ?? ""
        segmentPlayEntity.filePath = segment.audioPath ?? ""
        segmentPlayEntity.path = segment.audioPath ?? ""
        guard let contentStr =  segment.content else{
            return nil
        }
        
        let contentStrTrimed = contentStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
  
        let nsStr:NSString = NSString(string: contentStrTrimed)
       
        let strArr = nsStr.components(separatedBy: SLIP_SENTENCE)
        
        let first = strArr[0]
        let last = strArr[strArr.count - 1]
      
        let firstStr:NSString = NSString(string: first)
        let startAndEndArr = firstStr.components(separatedBy: SLIP_START_AND_END)
        segmentPlayEntity.startTime = Double(startAndEndArr[0])!/1000
        
        let lastStr:NSString = NSString(string: last)
        let lastStartAndEndArr = lastStr.components(separatedBy: SLIP_START_AND_END)
        
        if(lastStartAndEndArr.count != 2){
            return nil
        }
        let lastTimeStr = NSString(string: lastStartAndEndArr[1])
        let lastTimeStrArr = lastTimeStr.components(separatedBy: SLIP_TIME_AND_TEXT)
        
        segmentPlayEntity.endTime = Double(lastTimeStrArr[0])!/1000
        
        return segmentPlayEntity
    }
}
