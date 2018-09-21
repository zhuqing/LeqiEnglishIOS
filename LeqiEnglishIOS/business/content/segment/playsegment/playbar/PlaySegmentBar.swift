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
    //播放监听
    private var timer:Timer?
    
    //录音，播放录音工具
    private var recordManager:RecordManager = RecordManager()
    
    private var avAudioPlayer:AVAudioPlayer?
    
    static let HEIGHT:CGFloat = 60
    let spacing:CGFloat = 30
    
    var segmentPlayItem:SegmentPlayItem?{
        didSet{
            reset()
            playEventHandler()
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
//MARK 界面布局，及事件
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
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    private func  addPlayButton(){
        
        let height = PlaySegmentBar.HEIGHT/CGFloat(2)
        let y = height - height/CGFloat(2)
        playButton.frame = CGRect(x: spacing, y: y, width: height, height: height)
        self.addSubview(playButton)
        
        
        playButton.addTarget(self, action: #selector(PlaySegmentBar.playEventHandler), for: .touchDown)
    }
    
    private func addRecordButton(){
        
        let height = PlaySegmentBar.HEIGHT/CGFloat(2)
        let x = SCREEN_WIDTH/CGFloat(2)-height
        
        recordButton.frame = CGRect(x: x, y: 0, width: PlaySegmentBar.HEIGHT, height: PlaySegmentBar.HEIGHT)
        self.addSubview(recordButton)
        
        recordButton.addTarget(self, action: #selector(PlaySegmentBar.recordEventHandler), for: .touchDown)
    }
    
    private func addPlayRecord(){
        
        let height = PlaySegmentBar.HEIGHT/CGFloat(2)
        let y = height - height/CGFloat(2)
        let x = SCREEN_WIDTH - spacing - height
        playRecordButton.frame = CGRect(x: x, y: y, width: height, height: height)
        self.addSubview(playRecordButton)
        
        
        playRecordButton.addTarget(self, action: #selector(PlaySegmentBar.playRecordEventHandler), for: .touchDown)
    }
    
    @objc private func playEventHandler(){
        
        self.LOG.info("playEventHandler\(status)")
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        switch status {
        case .STOP:
            status = .PLAY
            self.startPlay()
        case .PLAY:
            status = .STOP
            self.stopPlay()
        case .RECORD:
            status = .PLAY
            self.stopRecord()
            self.startPlay()
        case .PLAY_RECORD:
            status = .PLAY
            self.stopPlayRecord()
            self.startPlay()
        }
        changeButtonImage()
    }
    
    
    
    @objc private func recordEventHandler(){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.LOG.info("recordEventHandler\(status)")
        switch status {
        case .STOP:
            status = .RECORD
            startRecord()
        case .PLAY:
            status = .RECORD
            self.stopPlay()
            startRecord()
            
        case .RECORD:
            status = .PLAY_RECORD
            self.stopRecord()
            self.startPlayRecord()
            
            
        case .PLAY_RECORD:
            status = .RECORD
            self.stopPlayRecord()
            self.startRecord()
        }
        
        changeButtonImage()
    }
    
    @objc private func playRecordEventHandler(){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.LOG.info("playRecordEventHandler\(status)")
        switch status {
        case .STOP:
            status = .PLAY_RECORD
            //self.stopRecord()
            self.startPlayRecord()
            
        case .PLAY:
            status = .PLAY_RECORD
             //self.stopRecord()
            stopPlay()
            self.startPlayRecord()
            
        case .RECORD:
            status = .PLAY_RECORD
            self.stopRecord()
            self.startPlayRecord()
            
        case .PLAY_RECORD:
            status = .STOP
            self.stopPlayRecord()
            
        }
        
        changeButtonImage()
    }
    
    private func changeButtonImage(){
        switch status {
        case .STOP:
            
            playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
            recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
        case .PLAY:
            playButton.setImage(UIImage(named: "leqi_playing"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
            recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
            
        case .RECORD:
            playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_record"), for: .normal)
            recordButton.setImage(UIImage(named: "leqi_recording"), for: .normal)
            
            
        case .PLAY_RECORD:
            playButton.setImage(UIImage(named: "leqi_play"), for: .normal)
            playRecordButton.setImage(UIImage(named: "leqi_play_recording"), for: .normal)
            recordButton.setImage(UIImage(named: "leqi_record"), for: .normal)
        }
    }
    
    
}

//MARK 播放mp3，录音，播放录音
extension PlaySegmentBar : AVAudioPlayerDelegate , RecordManagerDelegate{
    
    
    private func createAudioPlayer(){
        do {
            avAudioPlayer = try AVAudioPlayer(contentsOf: FileUtil.absulateFileUrl(filePath: mp3Path!))
            avAudioPlayer?.prepareToPlay()
            
            recordManager.delegate = self
        } catch let err {
            print("创建失败:\(err.localizedDescription)")
        }
    }
    
    func playFinshed() {
        LOG.info("playFinshed")
        self.playRecordEventHandler()
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
        
        self.perform(#selector(PlaySegmentBar.stopPlayAndDelayRecord), with: nil, afterDelay: Double(playItem.endTime!-playItem.startTime!)/1000.0)
        
    }
    
    
    //停止播放两秒后开始录音
    private func stopPlay(){
        self.LOG.info("stopPlay")
        guard let audioPlayer = self.avAudioPlayer else{
            return
        }
        if(audioPlayer.isPlaying){
            audioPlayer.pause()
        }
        
        
    }
    
    @objc private func stopPlayAndDelayRecord(){
        stopPlay()
        self.perform(#selector(PlaySegmentBar.startRecordAndDelayPlay), with: nil, afterDelay: 2.0)
    }
    
    
    @objc  private func startRecord(){
        self.LOG.info("startRecord")
        self.recordManager.beginRecord()
        
        
    }
    
    @objc  private func startRecordAndDelayPlay(){
        guard let playItem = self.segmentPlayItem else{
            return
        }
        self.recordManager.beginRecord()
        
        status = .RECORD
        self.changeButtonImage()
        
        self.perform(#selector(PlaySegmentBar.startPlayRecord), with: nil, afterDelay: Double(playItem.endTime!-playItem.startTime!)/1000.0+1.0)
    }
    
   
    @objc private func stopRecord(){
        self.LOG.info("stopRecordAndPlay")
        self.recordManager.stopRecord()
        
    }
    //播放录音
    @objc private func startPlayRecord(){
        status = .PLAY_RECORD
        self.changeButtonImage()
        stopRecord()
        self.LOG.info("startPlayRecord")
        self.recordManager.play()
    }
    
    private func stopPlayRecord(){
        self.recordManager.stopPlay()
    }
    
}
