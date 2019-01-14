//
//  ContentPlayer.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/3.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

protocol ContentPlayerDelegate {
    //当前播放时间改变
    func currentTimeChange(contentPlayer:ContentPlayer,currentTime:TimeInterval)
    // 播放索引
    func currentPlayIndexChange(contentPlayer:ContentPlayer,index:Int)
    //播放完成
    func finish(contentPlayer:ContentPlayer)
    
    //第I个播放完成播放完成
    func finish(contentPlayer:ContentPlayer,index:Int)
    
    func error(contentPlayer:ContentPlayer,message:String)
}

//content播放器
class ContentPlayer: NSObject {
    
    private let LOG = LOGGER("contentPlayer")
    //播放器
    private var player:AVAudioPlayer?
    
    //是否自动播放下一个
    var autoNext = true
    
    let session = AVAudioSession.sharedInstance()
    //播放的数据
    var playDatas:[SegmentPlayEntity]?
    
    var delegate:ContentPlayerDelegate?
    
    //是否正在播放
    var   isPlaying:Bool{
        get{
            guard let player = self.player else{
                return false
            }
            
            return player.isPlaying
        }
    }
    
    //当前播放的时间
    var currentTime:TimeInterval{
        get{
            guard let player = self.player else{
                return 0
            }
            
            return player.currentTime
        }
    }
    
    //当前播放的索引
    var currentPlayIndex = 0
    
  
    //是否运行计时器
    private var runTimer = true
    
    private var timer:Timer?
    
    override init() {
        super.init()
        self.initAV()
        self.startRunTimer()
       
    }
    
    @objc private func timerHandler(){
        if(!runTimer){
            self.timer?.invalidate()
        //return
        }
        guard let delegate = self.delegate else {
            return
        }
        
        guard let player = self.player else{
            return
        }
        
        if(player.isPlaying){
            delegate.currentTimeChange(contentPlayer: self, currentTime: player.currentTime)
        }
           
        
       
       // startRunTimer()
    }
    
    //根据索引获取SegmentPlayEntity
    func getSegmentPlayEntity(index:Int) -> SegmentPlayEntity?{
        guard let datas = self.playDatas else{
            return nil
        }
        if(index < 0 || index >= datas.count){
            return nil
        }
        
        return datas[index]
    }
    
    //开始运行计时器
    private func startRunTimer(){
         self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ContentPlayer.timerHandler), userInfo: nil, repeats: true)
    }
    
    //播放 ， index指定时间，播放的位置
    func play(index:Int = 0 , atTime:TimeInterval){
        if(currentPlayIndex == index){
            self.player?.play(atTime: atTime)
            return;
        }
        
        self.play(index: index)
        
        self.player?.play(atTime: atTime)
    }
    
  
 
    //播放， 默认从第一个播放
    func play(index:Int = 0)  {
        self.currentPlayIndex = index
        
        if let delegate = self.delegate {
            delegate.currentPlayIndexChange(contentPlayer: self, index: self.currentPlayIndex)
        }
        
        guard let datas = self.playDatas else{
            return
        }
        
        //索引越界
        if(index < 0 || index >= datas.count){
            return
        }
        
        let segmentPlayEntity = datas[index]
        guard let filePath = segmentPlayEntity.filePath else{
            return
        }
        if(!filePath.contains(APP_ROOT_PATH)){
            LOG.info("download \(filePath)")
            Service.reDownload(filePath: filePath){
                (path) in
                segmentPlayEntity.filePath = path
                self.play(index: index)
            }
            return
        }
        
        tryLoad(segmentPlayEntity: segmentPlayEntity, index: index)
       
    }
    
    private func tryLoad(segmentPlayEntity:SegmentPlayEntity,index:Int){
      
        
        guard let filePath = segmentPlayEntity.filePath else{
            return
        }
      
        LOG.info("load \(filePath)")
       
        do {
            self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            self.player?.prepareToPlay()
            self.player?.delegate = self
            self.player?.play()
          
        } catch let err {
            self.LOG.info("创建失败:\(err.localizedDescription)")
            segmentPlayEntity.filePath  = segmentPlayEntity.path ?? ""
            play(index:index)
        }
           
            
       
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
    
    //开始播放
    func start(){
        guard let player = self.player else{
            return
        }
        
        player.play()
    }
    
    //停止播放
    func pause(){
       
        guard let player = self.player else{
            return
        }
        
        player.pause()
    }
    
    //销毁
    func destory(){
         self.runTimer = false
          self.timer?.invalidate()
        guard let player = self.player else{
            return
        }
      
        player.stop()
    }
    
   
    //播放下一个
    private func playNext(){
        
        //如果播放的是最后一个，调用播放完成借口
        if(currentPlayIndex + 1 == self.playDatas?.count){
            guard let delegate = self.delegate else{
                return
            }
            
            delegate.finish(contentPlayer: self)
            return
        }
        
        if let d = self.delegate {
            d.finish(contentPlayer: self, index: self.currentPlayIndex)
        }
        //判断是否自动播放下一个
        if(!autoNext){
            return
        }
        self.play(index: currentPlayIndex+1)
    }
}


extension ContentPlayer:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if(flag){//播放完成
            self.playNext()
        }
    }
    

   
}
