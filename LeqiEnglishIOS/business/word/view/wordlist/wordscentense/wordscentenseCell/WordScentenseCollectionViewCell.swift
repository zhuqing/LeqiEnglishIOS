//
//  WordScentenseCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

protocol WordScentenseCollectionViewCellDelegate {
    func clickContentTitle(_ contentId:String)
}

class WordScentenseCollectionViewCell: UICollectionViewCell {
    static let WORD_SCENTENSE_COLLECTION_VIEWCELL = "WORD_SCENTENSE_COLLECTION_VIEWCELL"
    
    let LOG = LOGGER("WordScentenseCollectionViewCell")
    
    var wordAndSegment:WordAndSegment?{
        didSet{
            clear()
            if let ws = self.wordAndSegment{
                setItem(item: ws)
            } 
        }
    }
    
    var delegate:WordScentenseCollectionViewCellDelegate?
    private var avAudioPlayer:AVAudioPlayer?
    

    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var enLabel: UILabel!
    @IBOutlet weak var chLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initEvent()
    }
    
    
    
    
    
    private func setItem(item:WordAndSegment){
        let ch_em = StringUtil.toChAndEN(str: item.scentence!)
        enLabel.text = ch_em.0
        chLabel.text = ch_em.1
        setButton("来自：\(item.contentTitle ?? "")")
        load(item)
    }
    
    private func clear(){
        enLabel.text = ""
        chLabel.text = ""
        titleButton.setTitle("", for: .normal)
         self.avAudioPlayer = nil
    }
    
    private func setButton(_ title:String){
       let attribultStr = NSMutableAttributedString(string: title)

        attribultStr.addAttributes([.underlineColor:UIColor.blue , .underlineStyle:NSUnderlineStyle.styleSingle.rawValue], range: NSRange(location: 0, length: title.count))
        
        self.titleButton.setAttributedTitle(attribultStr, for: .normal)
    }
    
}
//MARK 播放音频
extension WordScentenseCollectionViewCell{
    
    private func load(_ item:WordAndSegment){
        guard let path = item.audioPath else{
            return
        }
        self.avAudioPlayer = nil
        Service.download(filePath: path){
            (filePath) in
            do{
                self.avAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            }catch{
                
            }
        }
    }
    
    
    //点击英文文本的事件
    private func initEvent(){
        enLabel.isUserInteractionEnabled = true
        let labelGet = UITapGestureRecognizer(target: self, action:#selector(WordScentenseCollectionViewCell.startPlay(uiGet:)))
        
        enLabel.addGestureRecognizer(labelGet)
        
        
                self.titleButton.addTarget(self, action: #selector(WordScentenseCollectionViewCell.clickTitleButton), for: UIControlEvents.touchDown)
     
    }
    
    //点击Content 标题的按钮时 触发的事件
    @objc private func clickTitleButton(){
         LOG.info("clickTitleButton")
        guard let ws = self.wordAndSegment else{
            return
        }

        guard  let contentId = ws.contentId else {
            return
        }

        if let d = self.delegate {
            
            d.clickContentTitle(contentId)
        }
    }
    
    @objc private func startPlay(uiGet:UIGestureRecognizer){
        
        guard let wordSegment = self.wordAndSegment else{
            return
        }
        
        guard let av = self.avAudioPlayer else{
            return
        }
        
        
        if(av.isPlaying){
            return
        }
        
        let startTime = wordSegment.startTime ?? Int64(0)
        let endTime = wordSegment.endTime ?? Int64(0)
        
        av.currentTime = Double(startTime)/Double(1000)
        av.play()
        
        
        
        self.perform(#selector(self.stopPlay), with: nil, afterDelay: Double(endTime-startTime)/Double(1000))
    }
    
    @objc private func stopPlay(){
        guard let av = self.avAudioPlayer else{
            return
        }
        if(av.isPlaying){
            av.stop()
        }
    }
}
