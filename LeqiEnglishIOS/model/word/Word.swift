//
//  Word.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

import Foundation

class Word : Entity{
    
    
    var word:String?
    
    var wordPast:String?
    
    var wordDone:String?
    
    var worder:String?
    
    var wordest:String?
    
    var means:String?
    
    var detail:String?
    
    var enAudioPath:String?
    
    var amAudionPath:String?
    
    var ttsAudioPath:String?
    
    var phAm:String?
    
    var phEn:String?
    
    override init() {
        
    }
    convenience init(data:[String:AnyObject]) {
        self.init()
        setValuesForKeys(data)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "word":
            self.word = value as? String
        case "wordPast":
            self.wordPast = value as? String
        case "wordDone":
            self.wordDone = value as? String
        case "worder":
            self.worder = value as? String
        case "wordest":
            self.wordest = value as? String
        case "means":
            self.means = value as? String
        case "detail":
            self.detail = value as? String
        case "enAudioPath":
            self.enAudioPath = value as? String
        case "amAudionPath":
            self.amAudionPath = value as? String
        case "ttsAudioPath":
            self.ttsAudioPath = value as? String
        case "phAm":
            self.phAm = value as? String
        case "phEn":
            self.phEn = value as? String
            
        default:
            super.setValue(value, forKey: key)
            break
        }
    }
    
    override func toDictionary()->[String:NSObject]{
        var dic = super.toDictionary()
        
        if  let v = self.word{
            dic["word"] = v as NSObject
        }
        if  let v = self.wordPast{
            dic["wordPast"] = v as NSObject
        }
        if  let v = self.wordDone{
            dic["wordDone"] = v as NSObject
        }
        if  let v = self.worder{
            dic["worder"] = v as NSObject
        }
        if  let v = self.wordest{
            dic["wordest"] = v as NSObject
        }
        if  let v = self.means{
            dic["means"] = v as NSObject
        }
        if  let v = self.detail{
            dic["detail"] = v as NSObject
        }
        if  let v = self.enAudioPath{
            dic["enAudioPath"] = v as NSObject
        }
        if  let v = self.amAudionPath{
            dic["amAudionPath"] = v as NSObject
        }
        if  let v = self.ttsAudioPath{
            dic["ttsAudioPath"] = v as NSObject
        }
        if  let v = self.phAm{
            dic["phAm"] = v as NSObject
        }
        if  let v = self.phEn{
            dic["phEn"] = v as NSObject
        }
        
        return dic
    }
}
