//
//  PlaySementItemCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
protocol PlaySementItemCollectionViewCellDelegate {
    func showWord(word:String)
}

class PlaySementItemCollectionViewCell: UICollectionViewCell {
    
    static let PALY_SEGMENT_ITEM_CELL = "PALY_SEGMENT_ITEM_CELL"
    
    var segmentPlayItem:SegmentPlayItem?
    
    var delegate:PlaySementItemCollectionViewCellDelegate?

    @IBOutlet weak var chineseTextLabel: UILabel!
  
    @IBOutlet weak var englishTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.buttomBorder(width: CGFloat(2), borderColor: UIColor.black)
        englishTextView.autoresizingMask = .flexibleHeight
        addMenu()
    }
    
    func setItem(item:SegmentPlayItem){
        self.segmentPlayItem = item
        
        if let text = item.englishSenc{
            englishTextView.text = text
            
           
 
        }
        
        if let text = item.chineseSenc{
            chineseTextLabel.text = text
             let enHeight =  StringUtil.computerHeight(text: item.englishSenc!, font: UIFont.systemFont(ofSize: 16), fixedWidth: SCREEN_WIDTH-20)+10
            
            let height =  StringUtil.computerHeight(text: text, font: UIFont.systemFont(ofSize: 13), fixedWidth: SCREEN_WIDTH-20)+10
            
              chineseTextLabel.frame = CGRect(x:  CGFloat(5), y:CGFloat(enHeight+10), width: englishTextView.frame.width, height: CGFloat(height))
        }
        
    }
    
    func play(bar:UIView){
        bar.frame = CGRect(x: 0, y: self.frame.height - PlaySegmentBar.HEIGHT, width: SCREEN_WIDTH, height: PlaySegmentBar.HEIGHT)
        self.contentView.addSubview(bar)
    }
    
    func stop(bar:UIView){
        bar.removeFromSuperview()

    }
    
 
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        return true;
    }
    
    
    private func addMenu(){
        let showWordMenu = UIMenuItem(title: "查看", action: #selector(PlaySementItemCollectionViewCell.showWords))
        
        let menuController:UIMenuController = UIMenuController.shared
        
        menuController.menuItems = [showWordMenu]
        
       // self.englishTextView.ca
       
        
    }
    
    @objc  private func canPerform() ->Bool{
        return true
    }
    
    @objc  private func showWords(){
        
    }

}


