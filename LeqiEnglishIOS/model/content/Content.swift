
import Foundation

class Content : Entity{
    
    var content:String?
    
    var userId:String?
    
    var imagePath:String?
    
    var widthImagePath:String?
    
    var audioPath:String?
    
    var title:String?
    
    var parentId:String?
    
    var catalogId:String?
    
    var readNum:Int64?
    
    var awesomeNum:Int64?
    
    override init() {
        
    }
    
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "content":
            self.content = value as? String
        case "userId":
            self.userId = value as? String
        case "imagePath":
            self.imagePath = value as? String
        case "widthImagePath":
            self.widthImagePath = value as? String
        case "audioPath":
            self.audioPath = value as? String
        case "title":
            self.title = value as? String
        case "parentId":
            self.parentId = value as? String
        case "catalogId":
            self.catalogId = value as? String
        case "readNum":
            self.readNum = value as? Int64
        case "awesomeNum":
            self.awesomeNum = value as? Int64
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.content{
            dic["content"] = v as NSObject
        }
        if  let v = self.userId{
            dic["userId"] = v as NSObject
        }
        if  let v = self.imagePath{
            dic["imagePath"] = v as NSObject
        }
        if  let v = self.widthImagePath{
            dic["widthImagePath"] = v as NSObject
        }
        if  let v = self.audioPath{
            dic["audioPath"] = v as NSObject
        }
        if  let v = self.title{
            dic["title"] = v as NSObject
        }
        if  let v = self.parentId{
            dic["parentId"] = v as NSObject
        }
        if  let v = self.catalogId{
            dic["catalogId"] = v as NSObject
        }
        if  let v = self.readNum{
            dic["readNum"] = v as NSObject
        }
        if  let v = self.awesomeNum{
            dic["awesomeNum"] = v as NSObject
        }
        
        return dic
    }
}
