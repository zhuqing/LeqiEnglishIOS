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
    func textViewClick(cell:PlaySementItemCollectionViewCell)
}

class PlaySementItemCollectionViewCell: UICollectionViewCell {
    let LOG = LOGGER("PlaySementItemCollectionViewCell")
    static let PALY_SEGMENT_ITEM_CELL = "PALY_SEGMENT_ITEM_CELL"
    
    var segmentPlayItem:SegmentPlayItem?
    
    var delegate:PlaySementItemCollectionViewCellDelegate?

    private lazy var chineseTextLabel: UILabel? = {
        let uiLabel = UILabel(frame: CGRect.zero)
        uiLabel.font = UIFont.systemFont(ofSize: 13)
        uiLabel.numberOfLines = 0
        return uiLabel
    }()
    
    private lazy var blackLine:UIView? = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.black
        
        return line
    }()
  
    lazy  var englishTextView: UITextView? = {
       let uiTextView = UITextView(frame: CGRect.zero)
        uiTextView.font = UIFont.boldSystemFont(ofSize: 18)
        uiTextView.isEditable = false
        uiTextView.isScrollEnabled = false
        uiTextView.autoresizingMask = .flexibleHeight
        return uiTextView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
   
        addMenu()
        addTap()
    }
    
    func setItem(item:SegmentPlayItem){
        self.segmentPlayItem = item
        if let text = item.englishSenc{
            englishTextView?.text = text
        }else{
             return
        }
        
        var y = CGFloat(5)
        
         let enHeight =  CGFloat(Int(StringUtil.computerHeight(text: item.englishSenc!, font: UIFont.boldSystemFont(ofSize: 18), fixedWidth: SCREEN_WIDTH-10)+5))
        self.addSubview(self.englishTextView!)
        
        englishTextView?.frame = CGRect(x:  CGFloat(5), y:y, width: SCREEN_WIDTH-10, height: CGFloat(enHeight+5))
        y += enHeight + CGFloat(5)
        if let text = item.chineseSenc{
            chineseTextLabel?.text = text
            self.addSubview(self.chineseTextLabel!)
            
            let height =  CGFloat(Int(StringUtil.computerHeight(text: text, font: UIFont.systemFont(ofSize: 13), fixedWidth: SCREEN_WIDTH-10)+5))
            
            chineseTextLabel?.frame = CGRect(x:  CGFloat(5), y:y, width: SCREEN_WIDTH-10, height: CGFloat(height))
            y += height + CGFloat(5)
        }
        
         self.addSubview(self.blackLine!)
        self.blackLine?.frame = CGRect(x: 0, y: self.frame.height - 1, width: SCREEN_WIDTH, height: 1)
        
    }
    
    private func  addTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlaySementItemCollectionViewCell.tapHandler))
    
        self.englishTextView?.addGestureRecognizer(tap)
    }
    
    @objc private func tapHandler(){
        LOG.info("tapHandler")
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.textViewClick(cell: self)
    }
    
    //进入播放状态
    func play(bar:UIView){
        bar.removeFromSuperview()
        bar.frame = CGRect(x: 0, y: self.frame.height - PlaySegmentBar.HEIGHT - 3, width: SCREEN_WIDTH, height: 0)
        
        self.addSubview(bar)
        UIView.animate(withDuration: 1) {
             bar.frame = CGRect(x: 0, y: self.frame.height - PlaySegmentBar.HEIGHT - 3, width: SCREEN_WIDTH, height: PlaySegmentBar.HEIGHT)
        }
      
        
          self.blackLine?.frame = CGRect(x: 0, y: self.frame.height - 1, width: SCREEN_WIDTH, height: 1)
       
    }
    
    //如果有播放进度条，移除
    func removeIfHave(bar :UIView){
        if(self.subviews.contains(bar)){
            bar.removeFromSuperview()
            self.blackLine?.frame = CGRect(x: 0, y: self.frame.height - 1, width: SCREEN_WIDTH, height: 1)
        }
    }
    
    func stop(bar:UIView){
      
        bar.removeFromSuperview()
        self.blackLine?.frame = CGRect(x: 0, y: self.frame.height - 1, width: SCREEN_WIDTH, height: 1)
    }
    
 
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if(action == #selector(PlaySementItemCollectionViewCell.showWords)){
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true;
    }
    
    
    private func addMenu(){
        let showWordMenu = UIMenuItem(title: "查看", action: #selector(PlaySementItemCollectionViewCell.showWords))
        
        let menuController:UIMenuController = UIMenuController.shared
        
        menuController.menuItems = [showWordMenu]
        
    }
    
    @objc  private func canPerform() ->Bool{
        return true
    }
    
    @objc  private func showWords(){
        guard let delegate = self.delegate else{
            return
        }
      
        delegate.showWord(word:  (self.englishTextView?.text(in: (self.englishTextView?.selectedTextRange!)!)!)!)
    }

}


