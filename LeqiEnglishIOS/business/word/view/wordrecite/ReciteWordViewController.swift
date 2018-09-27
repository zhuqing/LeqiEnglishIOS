//
//  ReciteWordViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

import AVFoundation

class ReciteWordViewController: UIViewController {
    
    private var LOG = LOGGER("ReciteWordViewController")

    @IBOutlet weak var wordNumber: UILabel!
    @IBOutlet weak var wordInfoRootView: UIView!
    @IBOutlet weak var startWriteButton: UIButton!
    @IBOutlet weak var startReciteButton: UIButton!
    @IBOutlet weak var back: UIBarButtonItem!
    
    private var avPlayer:AVAudioPlayer?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        loadword()
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
//MARK 加载数据
extension ReciteWordViewController{
    private func loadword(){
        guard let user =   UserDataCache.userDataCache.getFromCache() else{
            self.LOG.error("没有找到用户")
            return
        }
        
       let myWords =  MyWords(user: user)
        
        myWords.load(){
            (words) in
            
            self.wordNumber.text = "共有\(words?.count)个单词"
        }
    }
}

extension ReciteWordViewController{
    private func navigation(){
        self.back.action = #selector(ReciteWordViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
}
