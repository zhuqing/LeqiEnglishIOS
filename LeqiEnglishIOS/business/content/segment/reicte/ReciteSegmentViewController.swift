//
//  ReciteSegmentViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit



class ReciteSegmentViewController: UIViewController {

    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var duringLabel: UILabel!
    
    var segment:Segment?
    
    var cutDownTimer:Timer?
    
    var during:Double = 0{
        didSet{
           
            countDownDuring = Int(during)
            resetDuringLabel(during)
        }
    }
    
    var countDownDuring:Int = 0
    
 
    
    private let recordManager = RecordManager()
    
    private var currentPlayStatus:PLAY_STATUS = PLAY_STATUS.STOP
    override func viewDidLoad() {
        super.viewDidLoad()
        initListener()
        recordManager.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ReciteSegmentViewController : RecordManagerDelegate{
     func playFinshed() {
        currentPlayStatus = .STOP
        changeButton()
        showSheet()
       
    }
    
    private func showSheet(){
        guard let player = self.recordManager.player else{
            return
        }
        //如果背诵时间不到播放时间的2/3，继续背书
        if( player.duration < self.during*0.6){
            //return
        }
        
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "返回主页", style: .default, handler: {
            (action) in
            self.returnHome()
        }))
        alert.addAction(UIAlertAction(title: "复习一下", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "分享给朋友", style: .default, handler: {
            (act) in
            let share = ActionSheetDialogViewController()
            share.modalPresentationStyle = .overCurrentContext
            share.delegate = ShareViewActionSheetDelegate(segment:self.segment!)
            
            self.present(share, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}




//MARK: 事件相关
extension ReciteSegmentViewController{
    private func initListener(){
        self.startButton.addTarget(self, action: #selector(ReciteSegmentViewController.startButtenHandler), for: .touchDown)
        navigation()
    }
    
    @objc private func startButtenHandler(){
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        switch self.currentPlayStatus {
        case .STOP:
           currentPlayStatus = .RECORD
           startCuntDown()
           recordManager.beginRecord()
           self.perform(#selector(ReciteSegmentViewController.recordTimeout), with: nil, afterDelay: during)
        case .PLAY:
             currentPlayStatus = .STOP
           
        case .RECORD:
            self.playRecord()
            
        case .PLAY_RECORD:
             currentPlayStatus = .STOP
             recordManager.stopPlay()
        }
        changeButton()
    }
    
    private func changeButton(){
        switch self.currentPlayStatus {
        case .STOP:
           resetDuringLabel(during)
           self.startButton.backgroundColor = UIColor.green
           self.startButton.setTitle("开始", for: .normal)
            
        case .PLAY:
            
            self.startButton.backgroundColor = UIColor.yellow
            self.startButton.setTitle("播放", for: .normal)
            
        case .RECORD:
           
            self.startButton.backgroundColor = UIColor.yellow
            self.startButton.setTitle("录音", for: .normal)
        case .PLAY_RECORD:
            
            self.startButton.backgroundColor = UIColor.red
            self.startButton.setTitle("停止", for: .normal)
            
        }
    }
    
    //开始倒计时
    private func startCuntDown(){
          countDownDuring = Int(during)
        
        self.cutDownTimer =
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ReciteSegmentViewController.cutDown), userInfo: nil, repeats: true)
       
    }
    
    @objc private func cutDown(){
        self.countDownDuring -= 1
        self.resetDuringLabel(Double(countDownDuring))
        
        if(self.countDownDuring == 0){
            self.cutDownTimer?.invalidate()
            self.playRecord()
            self.changeButton()
        }
    }
    //播放录音
    private func playRecord(){
        
        currentPlayStatus = .PLAY_RECORD
        recordManager.stopRecord()
        recordManager.play()
        
        if let timer = self.cutDownTimer{
            timer.invalidate()
        }
    }
    
    @objc private func recordTimeout(){
        currentPlayStatus = .PLAY_RECORD
        recordManager.stopRecord()
        recordManager.play()
        changeButton()
    }
    
    private func navigation(){
        self.back.action = #selector(ReciteSegmentViewController.backEventHandler)
        self.shareBarButtonItem.action = #selector(ReciteSegmentViewController.shareEventHandler)
    }
    
    @objc private func shareEventHandler(){
        let share = ActionSheetDialogViewController()
        share.modalPresentationStyle = .overCurrentContext
        share.delegate = ShareViewActionSheetDelegate(segment: self.segment!)
        
        self.present(share, animated: true, completion: nil)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func resetDuringLabel(_ during:Double){
       let minute = Int(during / 60.0)
       let second = Int(during) % 60
        
       let minuteStr = String(format: "%.2d", arguments: [minute])
           let secondStr = String(format: "%.2d", arguments: [second])
        
       self.duringLabel.text = "\(minuteStr):\(secondStr)"
    }
}


