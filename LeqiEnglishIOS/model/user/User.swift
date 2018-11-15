import Foundation
class User : Entity{
    
    
    var name:String?
    
    var sex:Int?
    
    var password:String?
    
    var email:String?
    
    var vipLastData:String?
    
    var phoneNumber:String?
    
    var otherSysId:String?
    
    var lastLogin:Int64?
    
    var type:Int?
    
    var imagePath:String?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "name":
            self.name = value as? String
        case "sex":
            self.sex = value as? Int
        case "password":
            self.password = value as? String
        case "email":
            self.email = value as? String
        case "vipLastData":
            self.vipLastData = value as? String
        case "phoneNumber":
            self.phoneNumber = value as? String
        case "otherSysId":
            self.otherSysId = value as? String
        case "lastLogin":
            self.lastLogin = value as? Int64
        case "type":
            self.type = value as? Int
        case "imagePath":
            self.imagePath = value as? String
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.name{
            dic["name"] = v as NSObject
        }
        if  let v = self.sex{
            dic["sex"] = v as NSObject
        }
        if  let v = self.password{
            dic["password"] = v as NSObject
        }
        if  let v = self.email{
            dic["email"] = v as NSObject
        }
        if  let v = self.vipLastData{
            dic["vipLastData"] = v as NSObject
        }
        if  let v = self.phoneNumber{
            dic["phoneNumber"] = v as NSObject
        }
        if  let v = self.otherSysId{
            dic["otherSysId"] = v as NSObject
        }
        if  let v = self.lastLogin{
            dic["lastLogin"] = v as NSObject
        }
        if  let v = self.type{
            dic["type"] = v as NSObject
        }
        if  let v = self.imagePath{
            dic["imagePath"] = v as NSObject
        }
        
        return dic
    }
}
