//
//  PlayBarView.swift
//  LeqiEnglishIOS
// 播放器
//  Created by zhuleqi on 2018/12/21.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayBarViewDelegate {
    func next(playBarView:PlayBarView)
    func previous(playBarView:PlayBarView)
    func play(playBarView:PlayBarView)
    func pause(playBarView:PlayBarView)
    //进度条值改变
    func progressValueChange(playBarView:PlayBarView,value:Float)
}

class PlayBarView: UIView {
    
    private let LOG = LOGGER("PlayBarView")
    
    var playDatas:[SegmentPlayEntity]?
    
    private var playingIndex = 0
    //播放时间的总长度
    private var max = 0.0
    
    private var userInterface = false

    
   // private var playDatas:[SegmentPlayEntity] = [SegmentPlayEntity]()
    
    var contentPlayer:ContentPlayer?
    
     var delegate:PlayBarViewDelegate?
    
    private var playStatus = PLAY_STATUS.STOP

    private lazy var progressView:UISlider = {
        let progressView = UISlider()
        progressView.tintColor = UIColor.red
        progressView.accessibilityActivate()
     
        progressView.addTarget(self, action: #selector(PlayBarView.progressValueChange), for:UIControlEvents.valueChanged)
        return progressView
    }();
    
    private lazy var playButton:UIButton = {
        let play = UIButton()
        play.setBackgroundImage(UIImage(named: "play_new") , for: UIControlState.normal)
        return play
    }();
    
    private lazy var priviousButton:UIButton = {
        let play = UIButton()
        play.setBackgroundImage(UIImage(named: "previous_new") , for: UIControlState.normal)
        return play
    }();
    
    private lazy var nextButton:UIButton = {
        let play = UIButton()
        play.setBackgroundImage(UIImage(named: "next_new") , for: UIControlState.normal)
        return play
    }();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
     
        //beginReceivingRemoteControlEvents();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
}


//MARK: 设置UI
extension PlayBarView{
    
    private func setUI(){
        self.addSubview(self.progressView)
        self.progressView.frame = CGRect(x: 10, y: 5, width: SCREEN_WIDTH-20, height: 10)
        
        self.addSubview(self.playButton)
        self.playButton.frame = CGRect(x:  SCREEN_WIDTH/2-32, y: 25, width: 64, height: 64)
        playButton.addTarget(self, action: #selector(PlayBarView.playEventHandler), for: .touchDown)
        
        self.addSubview(self.priviousButton)
        self.priviousButton.frame = CGRect(x:  SCREEN_WIDTH/2-70-32-16, y: 25+16, width: 32, height: 32)
        priviousButton.addTarget(self, action: #selector(PlayBarView.previousEventHandler), for: .touchDown)
        
        self.addSubview(self.nextButton)
        self.nextButton.frame = CGRect(x:  SCREEN_WIDTH/2+70+16, y: 25+16, width: 32, height: 32)
        nextButton.addTarget(self, action: #selector(PlayBarView.nextEventHandler), for: .touchDown)
        
    }
    
    //点击播放按钮事件
    @objc private func playEventHandler(){
        
        play()
    }
    
    //点击上一个按钮的时间
    @objc private func previousEventHandler(){
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.previous(playBarView: self)
    }
    //点击下一个按钮事件
    @objc private func nextEventHandler(){
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.next(playBarView: self)
    }
    
    //进度条值改变
    @objc private func progressValueChange(){
        if(!userInterface){
            return
        }
        
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.progressValueChange(playBarView: self, value: self.progressView.value)
    }
    
    
    //更新进度条
    func updateProgress(value:Float){
        userInterface = false
        self.setProgerssValue(value:value)
        userInterface = true
       
    }
    
    //修改当前时间，和最大时间
    func currentTimeAndMaxTime(currentTime:TimeInterval,maxTime:TimeInterval)  {
        
    }
    
  
    func play(){
        switch self.playStatus {
        case .STOP:
            playStatus = .PLAY
            self.startPlay()
        case .PLAY:
            playStatus = .STOP
           stop()
        case .RECORD:
           LOG.info("RECORD")
        case .PLAY_RECORD:
              LOG.info("PLAY_RECORD")
        }
        
    }
    
    private func play(segmentPlayEnties:[SegmentPlayEntity]){
        if let player = self.contentPlayer {
            if(player.isPlaying){
                play()
            }
        }
        playStatus = .STOP
        self.playDatas = segmentPlayEnties
        self.playingIndex = 0
        self.max = segmentPlayEnties[segmentPlayEnties.count-1].endTime ?? 0
        setProgerssValue(value:0)
       self.play()
        
    }
    
    private func setProgerssValue(value:Float){
        self.userInterface = true
        self.progressView.setValue(value, animated: true)
        self.userInterface = false
    }
    

    
     func startPlay(){
        //没有数据时，加载数据
       toPlayStatus()
        if( self.delegate != nil){
            self.delegate?.play(playBarView: self)
            return
        }
       
    }
    
    func toPlayStatus(){
        playStatus = .PLAY
        self.playButton.setBackgroundImage(UIImage(named: "pause_new"), for: .normal)
    }
    
   
    
    func stop(){
        playStatus = .STOP
        self.playButton.setBackgroundImage(UIImage(named: "play_new"), for: .normal)
        if( self.delegate != nil){
            self.delegate?.pause(playBarView: self)
            return
        }
    }
}

