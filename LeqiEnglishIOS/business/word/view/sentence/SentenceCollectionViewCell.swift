//
//  SentenceCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class SentenceCollectionViewCell: UICollectionViewCell {
    static let INDENTIFER = "SentenceCollectionViewCell"
    
    private lazy var chineseLabel: UITextView? = {
        let uiTextView = UITextView(frame: CGRect.zero)
        uiTextView.isScrollEnabled = false
         uiTextView.font = UIFont.systemFont(ofSize: 13, weight:UIFont.Weight.light)
       
        return uiTextView
    }()
    
    private var englishLabel: UITextView? = {
        let uiTextView = UITextView(frame: CGRect.zero)
        uiTextView.isScrollEnabled = false
         uiTextView.font = UIFont.systemFont(ofSize: 17)
        return uiTextView
    }()
    
    
    var sentence:Sentence?{
        didSet{
            sentenceChange()
        }
    }
    
    private var sentences:[Sentence]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        englishLabel?.isScrollEnabled = false
        self.addSubview(englishLabel!)
        self.addSubview(chineseLabel!)
        // Initialization code
    }
    
    private func sentenceChange(){
        guard let sentence = self.sentence else{
            chineseLabel?.text = ""
            englishLabel?.text = ""
            return;
        }
        
        if let english = sentence.english {
            englishLabel?.text = english
        }else{
            englishLabel?.text = ""
        }
        
        if let chinese = sentence.chinese{
            chineseLabel?.text = chinese
        }else{
            chineseLabel?.text = ""
        }
        
        setUI()
    }
    
    private func setUI(){
        guard let sentence = self.sentence else{
         
            return
        }
        
        let englishHeight =  StringUtil.computerHeight(text: sentence.english ?? "", font: UIFont.systemFont(ofSize: 17), fixedWidth: SCREEN_WIDTH - 20)
        
        self.englishLabel?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 20, height: englishHeight)
        
        let chineseHeight =  StringUtil.computerHeight(text: sentence.chinese ?? "", font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light), fixedWidth: SCREEN_WIDTH - 20)
        
        
          self.chineseLabel?.frame = CGRect(x: 0, y: englishHeight, width: SCREEN_WIDTH - 20, height: chineseHeight)
        
    }
    
}
