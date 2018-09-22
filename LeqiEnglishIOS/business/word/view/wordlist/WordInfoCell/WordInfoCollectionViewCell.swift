//
//  WordInfoCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/20.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation
class WordInfoCollectionViewCell: UICollectionViewCell {
    let  LOG = LOGGER("WordInfoCollectionViewCell")
    
    static let WORD_INFO_CELL_INDENTIFY = "WORD_INFO_CELL_INDENTIFY"
    
    @IBOutlet weak var means: UILabel!
    
    @IBOutlet weak var enPlayButton: UIButton!
    @IBOutlet weak var enPron: UILabel!
    
    @IBOutlet weak var amPlayButton: UIButton!
    @IBOutlet weak var amPron: UILabel!
    
    @IBOutlet weak var ttsPlayButton: UIButton!
    @IBOutlet weak var wordInfo: UILabel!
    
    @IBOutlet weak var enAmPro: UIView!
    
    private var ttsPlayer:AVAudioPlayer?
    private var enPlayer:AVAudioPlayer?
    private var amPlayer:AVAudioPlayer?
    
    var word:Word?{
        didSet{
            
            setItem(item:word)
            
            
            updateData(item:word)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initButton()
    }
    
}

extension WordInfoCollectionViewCell{
    
    private func initButton(){
        amPlayButton.addTarget(self, action: #selector(WordInfoCollectionViewCell.clickAmPlayButton), for: UIControlEvents.touchDown)
        enPlayButton.addTarget(self, action: #selector(WordInfoCollectionViewCell.clickEnPlayButton), for: UIControlEvents.touchDown)
        ttsPlayButton.addTarget(self, action: #selector(WordInfoCollectionViewCell.clickTtsAudio), for: UIControlEvents.touchDown)
        
    }
    
    private func setItem(item:Word?){
        guard let w = item else{
            return
        }
        loadTTS(word:w)
        loadAMAudio(word:w)
        loadEnAudio(word: w)
        loadWordMean(item:w)
    }
    
    //加载单词中的means
    private func loadWordMean(item:Word){
         self.means.text = WordUtil.getMeans(item: item)
    }
    
    
    private func updateData(item:Word? = nil){
        
        guard let w = word else{
            enPron.text = ""
            amPron.text = ""
            wordInfo.text = ""
            means.text = ""
            
            return
        }
        
        if let proText = StringUtil.exceptEmpty(w.phEn){
            enPron.text = "英[\(proText)]"
        }else{
            enPron.text = ""
        }
        
        if let proText = StringUtil.exceptEmpty(w.phAm){
            
            amPron.text = "美[\(proText)]"
        }else{
            amPron.text = ""
        }
        
        if let word = w.word{
            wordInfo.text = word
        }else{
            wordInfo.text = ""
        }
        
        
        
    }
    
    
    
    
    private func loadAMAudio(word:Word){
        guard let mp3 = word.amAudionPath else{
            self.amPlayButton.isHidden = true
            self.amPlayer  = nil
            return
        }
        self.amPlayButton.isHidden = false
        Service.download(filePath: mp3){
            (mp3Path) in
            do{
                self.amPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mp3Path))
                self.amPlayer?.prepareToPlay()
            }catch let err {
                print("创建失败:\(err.localizedDescription)")
            }
        }
        
        
        
    }
    
  
    
    private func loadEnAudio(word:Word){
        guard let mp3 = word.enAudioPath else{
              self.enPlayButton.isHidden = true
            self.enPlayer = nil
            return
        }
        enPlayButton.isHidden = false
        self.ttsPlayButton.isHidden = true
        Service.download(filePath: mp3){
            (mp3Path) in
            do{
                self.enPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mp3Path))
                self.enPlayer?.prepareToPlay()
            } catch let err {
                print("创建失败:\(err.localizedDescription)")
            }
        }
        
        
        
    }
    
 
    
    private func loadTTS(word:Word){
        guard let mp3 = StringUtil.exceptEmpty(word.ttsAudioPath)  else{
            ttsPlayButton.isHidden = true
            self.ttsPlayer = nil
            return
        }

        ttsPlayButton.isHidden = false
        Service.download(filePath: mp3){
            (mp3Path) in
            do{
                
                self.ttsPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: mp3Path))
                self.ttsPlayer?.prepareToPlay()
            } catch let err {
                print("创建失败:\(err.localizedDescription)")
            }
        }
        
        
        
    }
    
    @objc private func clickAmPlayButton(){
        guard let player = self.amPlayer else{
            return
        }
         self.amPlayButton.setImage(UIImage(named: "playing_word"), for: .normal)
        player.play()
        self.perform(#selector(WordInfoCollectionViewCell.buttonRecover(button: )), with: amPlayButton, afterDelay: player.duration)
    }
    @objc  private func clickEnPlayButton(){
        guard let player = self.enPlayer else{
            return
        }
        self.enPlayButton.setImage(UIImage(named: "playing_word"), for: .normal)
        player.play()
        self.perform(#selector(WordInfoCollectionViewCell.buttonRecover(button: )), with: enPlayButton, afterDelay: player.duration)
 
    }
    
    @objc func clickTtsAudio(){
        LOG.info("clickTtsAudio")
        guard let player = self.ttsPlayer else{
            return
        }
        self.ttsPlayButton.setImage(UIImage(named: "playing_word"), for: .normal)
        player.play()
        self.perform(#selector(WordInfoCollectionViewCell.buttonRecover(button:)), with: ttsPlayButton, afterDelay: player.duration)
    }
    
    @objc func buttonRecover(button:UIButton){
         button.setImage(UIImage(named: "play_word"), for: .normal)
    }
}
