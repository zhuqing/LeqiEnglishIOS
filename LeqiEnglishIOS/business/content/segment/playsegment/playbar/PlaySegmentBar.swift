//
//  PlaySegmentBar.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

//MARK 播放状态枚举
enum PALY_STATUS{
    case STOP
    case PLAY
    case RECORD
    case PLAY_RECORD
}

class PlaySegmentBar: UIView {
    
    var LOG = LOGGER("PlaySegmentBar")
    
      private var timer:Timer?
    
    private var avAudioPlayer:AVAudioPlayer?
    
    static let HEIGHT:CGFloat = 60
     let spacing:CGFloat = 30
    
    var segmentPlayItem:SegmentPlayItem?{
        didSet{
            reset()
            play()
        }
    }
  
    
   
    
    var mp3Path:String?{
        didSet{
            createAudioPlayer()
        }
    }
    
    private var status = PALY_STATUS.STOP
    private var playButton:UIButton = UIButton(frame: CGRect.zero)
    private var recordButton:UIButton = UIButton(frame: CGRect.zero)
    private var playRecordButton:UIButton = UIButton(frame: CGRect.zero)
    
    init(frame: CGRect,mp3Path:String) {
        self.mp3Path = mp3Path
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

extension PlaySegmentBar{
    private func setupUI(){
        addPlayButton()
        addRecordButton()
        addPlayRecord()
        stopPlay()
        reset()
    }
    
    func reset(){
        status = PALY_STATUS.STOP
        playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
        recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
        playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
        
        if let player = self.avAudioPlayer{
            if (player.isPlaying){
                player.pause()
            }
        }
    }
    
    private func  addPlayButton(){
       
        let height = PlaySegmentBar.HEIGHT/CGFloat(2)
        let y = height - height/CGFloat(2)
        playButton.frame = CGRect(x: spacing, y: y, width: height, height: height)
        self.addSubview(playButton)
        
        
        playButton.addTarget(self, action: #selector(PlaySegmentBar.play), for: .touchDown)
    }
    
    private func addRecordButton(){
      
        let height = PlaySegmentBar.HEIGHT/CGFloat(2)
        let x = SCREEN_WIDTH/CGFloat(2)-height
        
        recordButton.frame = CGRect(x: x, y: 0, width: PlaySegmentBar.HEIGHT, height: PlaySegmentBar.HEIGHT)
        self.addSubview(recordButton)
        
        recordButton.addTarget(self, action: #selector(PlaySegmentBar.record), for: .touchDown)
    }
    
    private func addPlayRecord(){
      
        let height = PlaySegmentBar.HEIGHT/CGFloat(2)
        let y = height - height/CGFloat(2)
        let x = SCREEN_WIDTH - spacing - height
        playRecordButton.frame = CGRect(x: x, y: y, width: height, height: height)
        self.addSubview(playRecordButton)
        
        
        playRecordButton.addTarget(self, action: #selector(PlaySegmentBar.playRecord), for: .touchDown)
    }
    
    @objc private func play(){
        switch status {
        case .STOP:
            status = .PLAY
            playButton.setImage(UIImage(named: "leqi_playing"), for: .normal)
            startPlay()
        case .PLAY:
            status = .STOP
            playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
           stopPlay()
        case .RECORD:
            status = .PLAY
            recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
            playButton.setImage(UIImage(named: "leqi_playing"), for: .normal)
           startPlay()
        case .PLAY_RECORD:
            status = .PLAY
            playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
            playButton.setImage(UIImage(named: "leqi_playing"), for: .normal)
            startPlay()
        }
    }
    
  
    
    @objc private func record(){
        switch status {
        case .STOP:
            status = .RECORD
            recordButton.setImage(UIImage(named: "leqi_recording"), for: .normal)
            
        case .PLAY:
            status = .RECORD
            playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
            recordButton.setImage(UIImage(named: "leqi_recording"), for: .normal)
             stopPlay()
        case .RECORD:
            status = .PLAY_RECORD
            recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_recording"), for: .normal)
        case .PLAY_RECORD:
            status = .PLAY_RECORD
            playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
           recordButton.setImage(UIImage(named: "leqi_recording"), for: .normal)
        }
    }
    
    @objc private func playRecord(){
        switch status {
        case .STOP:
            status = .PLAY_RECORD
            playRecordButton.setImage(UIImage(named: "leqi_play_recording"), for: .normal)
            
        case .PLAY:
            status = .PLAY_RECORD
            playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_recording"), for: .normal)
            stopPlay()
        case .RECORD:
            status = .PLAY_RECORD
            recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_recording"), for: .normal)
        case .PLAY_RECORD:
            status = .STOP
             playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
       
        }
    }
}

//MARK 播放mp3
extension PlaySegmentBar : AVAudioPlayerDelegate{
  
    
    private func createAudioPlayer(){
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: FileUtil.absulateFileUrl(filePath: mp3Path!))
            avAudioPlayer?.prepareToPlay()
            
        } catch let err {
            print("创建失败:\(err.localizedDescription)")
        }
    }
    
    
    private func startPlay(){
        guard let audioPlayer = self.avAudioPlayer else{
            return
        }
        guard let playItem = segmentPlayItem else{
            return
        }
        
        guard let startTime = playItem.startTime else{
            return
        }
        
        LOG.info("starttime\(startTime)")
        audioPlayer.currentTime =  Double(startTime)/Double(1000)
        audioPlayer.play()
        timer = Timer.scheduledTimer(timeInterval: Double(0.1), target: self, selector: #selector(PlaySegmentBar.checkCurrentTime), userInfo: nil, repeats:true )
        
        
       // Timer.init(timeInterval: TimeInterval(bitPattern: <#T##UInt64#>), target: <#T##Any#>, selector: <#T##Selector#>, userInfo: <#T##Any?#>, repeats: <#T##Bool#>)
    }
    
    @objc private func checkCurrentTime(){
        
        LOG.info("checkCurrentTime")
        
        guard let item = self.segmentPlayItem else{
            if let timer = self.timer{
                timer.invalidate()
            }
            return
        }
       
        if( (avAudioPlayer?.currentTime)! * Double(1000) > Double(item.endTime!)){
            timer?.invalidate()
            play()
        }
    }
    
    private func stopPlay(){
        guard let audioPlayer = self.avAudioPlayer else{
            return
        }
        if(audioPlayer.isPlaying){
        audioPlayer.pause()
        }
        
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    
}
