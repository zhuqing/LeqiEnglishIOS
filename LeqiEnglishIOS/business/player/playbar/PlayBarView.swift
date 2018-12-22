//
//  PlayBarView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/12/21.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayBarViewDelegate {
    func next(playBarView:PlayBarView)
    func previous(playBarView:PlayBarView)
    func finished(playBarView:PlayBarView)
    func play(playBarView:PlayBarView)
}

class PlayBarView: UIView {
    
    private let LOG = LOGGER("PlayBarView")
    
    var playDatas:[SegmentPlayEntity]?
    
    private var playingIndex = 0
    private var max = 0
    
    private var userInterface = false
    
    let session = AVAudioSession.sharedInstance()
    
   // private var playDatas:[SegmentPlayEntity] = [SegmentPlayEntity]()
    
    
     var delegate:PlayBarViewDelegate?
    
    private var playStatus = PLAY_STATUS.STOP
    private var avAudioPlayer:AVAudioPlayer?
    private lazy var progressView:UISlider = {
        let progressView = UISlider()
        progressView.tintColor = UIColor.red
      //  progressView.progressTintColor = UIColor.blue
        progressView.accessibilityActivate()
        progressView.addTarget(self, action: #selector(PlayBarView.progressValueChange), for:UIControlEvents.valueChanged)
      //  progressView.trackTintColor = UIColor.blue
        return progressView
    }();
    
    private lazy var playButton:UIButton = {
        let play = UIButton()
        play.setBackgroundImage(UIImage(named: "play_red") , for: UIControlState.normal)
        return play
    }();
    
    private lazy var priviousButton:UIButton = {
        let play = UIButton()
        play.setBackgroundImage(UIImage(named: "previous_play") , for: UIControlState.normal)
        return play
    }();
    
    private lazy var nextButton:UIButton = {
        let play = UIButton()
        play.setBackgroundImage(UIImage(named: "next_play") , for: UIControlState.normal)
        return play
    }();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        initAV()
        //beginReceivingRemoteControlEvents();
    }
    
    private func initAV(){
        do{
            //  设置会话类别
            try session.setCategory(AVAudioSessionCategoryPlayback)
            //  激活会话
            try session.setActive(true)
        }catch {
            print(error)
            return
        }
        

    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
  
    
}

extension PlayBarView{
//    func setBackground() {
//
//        //大标题 - 小标题  - 歌曲总时长 - 歌曲当前播放时长 - 封面
//        let settings = [MPMediaItemPropertyTitle: "大标题",MPMediaItemPropertyArtist: "小标题", MPMediaItemPropertyPlaybackDuration: "\(max)",MPNowPlayingInfoPropertyElapsedPlaybackTime: "\(getCurrentTime())",MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: UIImage(named: "play_red")!)]
//
//        MPNowPlayingInfoCenter.defaultCenter().setValue(settings, forKey: "nowPlayingInfo")
//    }
    
    
    

}

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
    
    @objc private func playEventHandler(){
        
        play()
    }
    
    @objc private func previousEventHandler(){
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.previous(playBarView: self)
    }
    
    @objc private func nextEventHandler(){
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.next(playBarView: self)
    }
    
    @objc private func progressValueChange(){
        if(userInterface){
            return
        }
        let currentTime = Int(Float(max) * self.progressView.value)
        
        var i = 0 ;
        
        var atTime:Double = 0;
        for segmentPlayEntity in self.playDatas!{
            if(currentTime >= segmentPlayEntity.startTime! && currentTime <= segmentPlayEntity.endTime!){
                playingIndex = i
                atTime = Double(currentTime - segmentPlayEntity.startTime!)
                break
            }
            i += 1
        }
        
        self.playNext()
        self.avAudioPlayer?.play(atTime: atTime)
        
    }
    
    
    private func initAudioPlay(filePath:String){
        do {
            self.avAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
      
                //AVAudioSessionCategoryPlayback扬声器模式
            try session.setCategory(AVAudioSessionCategoryPlayback)
           

         
                self.avAudioPlayer?.prepareToPlay()
                self.avAudioPlayer?.delegate = self
                self.avAudioPlayer?.play()
          
            // NSObject.cancelPreviousPerformRequests(withTarget: self)
            //let length  = self.avAudioPlayer?.duration
            
           // self.perform(#selector(PlayBarView.playFinished), with: nil, afterDelay:length!)
           
        } catch let err {
            print("创建失败:\(err.localizedDescription)")
        }
        // self.avAudioPlayer.sett
    }
    
    
    @objc private func updateProgress(){
        guard let player = self.avAudioPlayer else{
            return
        }
        
        if(!player.isPlaying){
            return
        }
        
        let progress = CGFloat(getCurrentTime())/CGFloat(self.max)
        self.setProgerssValue(value: Float(progress))
        self.perform(#selector(PlayBarView.updateProgress), with: nil, afterDelay:0.1)
    }
    
    private func getCurrentTime()->Int{
        guard let player = self.avAudioPlayer else{
            return 0
        }
        let currentTime = player.currentTime
        let lastEndTime = self.playDatas?[self.playingIndex-1].endTime!;
        
        return Int(currentTime) + lastEndTime!
    }
    
    func play(){
        
       
        switch self.playStatus {
        case .STOP:
            playStatus = .PLAY
            self.playButton.setBackgroundImage(UIImage(named: "pause_red"), for: .normal)
            self.playNext()
            self.perform(#selector(PlayBarView.updateProgress), with: nil, afterDelay:0.2)
           // self.forma
        case .PLAY:
           stop()
        case .RECORD:
           LOG.info("RECORD")
        case .PLAY_RECORD:
              LOG.info("PLAY_RECORD")
        }
        
    }
    
    func play(segmentPlayEnties:[SegmentPlayEntity]){
        if let player = self.avAudioPlayer {
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
    
    @objc private func playFinished(){
        if( self.playingIndex == self.playDatas?.count){
            callPlayFinished()
            return
        }
        
        playNext()
    }
    
    private func playNext(){
        //没有数据时，加载数据
        if(self.playDatas == nil && self.delegate != nil){
            self.delegate?.play(playBarView: self)
            return
        }
        let segmentPlayEntity = self.playDatas?[self.playingIndex]
        
        if(segmentPlayEntity  == nil){
            self.callPlayFinished()
            return
        }
        
        guard let filePath =  segmentPlayEntity?.filePath else{
            return
        }
        
        let filePathNS = NSString(string: filePath)
       
        
        if(filePathNS.contains(APP_ROOT_PATH)){
           self.initAudioPlay(filePath: filePath)
           self.playingIndex += 1
        }else{
            Service.download(filePath: filePath, finishedCallback: {
                (path) in
                self.playingIndex += 1
                segmentPlayEntity?.filePath = path
                self.initAudioPlay(filePath: path)
              
                
            })
        }
       
    }
    
    private func callPlayFinished(){
        guard let delegate = self.delegate else{
            return
        }
        delegate.finished(playBarView: self)
    }
    
    func stop(){
        playStatus = .STOP
        self.playButton.setBackgroundImage(UIImage(named: "play_red"), for: .normal)
        guard let player = self.avAudioPlayer else {
            return
        }
        player.pause()
    }
}


extension PlayBarView:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if(flag){
            self.playFinished()
        }
    }
}
