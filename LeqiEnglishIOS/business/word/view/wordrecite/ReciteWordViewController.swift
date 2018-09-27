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
   
    @IBOutlet weak var back: UIBarButtonItem!
    
    private var avPlayer:AVAudioPlayer?
    
    private var reciteWords = [Word]()
    
    //每个单词的背诵次数
    private var reciteCount = 0
    
    //背诵单词的索引
    private var reciteWordIndex:Int = 0
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.wordInfoRootView.bounds.width, height: wordInfoRootView.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        // collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "WordInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
       
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

//MARK: - 加载数据
extension ReciteWordViewController{
    
    private func loadReciteWordConfig(){
        
    }
    //加载背诵单词
    private func loadwords(){
        let myWords =  MyReciteWords.instance
        
        myWords.load(){
            (words) in
            guard let wordArr = words else{
                self.LOG.error("没有加载到单词")
                self.reciteWords = [Word]()
                self.collectionView.reloadData()
                return;
            }
            self.wordNumber.text = "今日已背诵\(wordArr.count)个单词"
            self.reciteWords = wordArr.filter(){
                (word) in
                if(StringUtil.exceptEmpty(word.ttsAudioPath) == nil){
                    if(StringUtil.exceptEmpty(word.amAudionPath) == nil){
                        if(StringUtil.exceptEmpty(word.enAudioPath) == nil){
                            return false
                        }
                    }
                }
                
                return true
            }
            self.loadAudioFile()
            self.collectionView.reloadData()
        }
    }
    
    private func setupUI(){
       // self.initEventListner()
        navigation()
        loadwords()
    }
    
    
    //所有加载单词的发音文件
    private func loadAudioFile(){
        for word in self.reciteWords{
            let path = getWordAudioPath(word: word)
            
            Service.download(filePath: path){_ in}
        }
    }
    
    
   
    //开始背诵
    @objc private func startReciteEventHandler(){
        for view in self.wordInfoRootView.subviews {
            view.removeFromSuperview()
        }
        
        self.wordInfoRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: wordInfoRootView.frame.height)
        
        collectionView.reloadData()
        startRecite()
    }
    //开始默写
    @objc private func startWriteEventHandler(){
       startRecite()
    }
    
  
}

//MARK: 实现UICollectionViewDataSource
extension ReciteWordViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY, for: indexPath) as? WordInfoCollectionViewCell
        cell?.word = self.reciteWords[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reciteWords.count
    }
}

//MARK: 导航
extension ReciteWordViewController{
    private func navigation(){
        self.back.action = #selector(ReciteWordViewController.backEventHandler)
        // self.config.action = #selector(ReciteWordViewController.configEventHandler)
    }
    
    @objc private func backEventHandler(){
        if let avplay = self.avPlayer{
            avplay.stop()
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func configEventHandler(){
        // self.dismiss(animated: true, completion: nil)
    }
}
//MARK: 背诵或有关的事件
extension ReciteWordViewController{
    private func startRecite(){
        
        self.reciteCount = 0
        self.avPlayer = nil
        self.reciteWordIndex = 0
        loadAVPlayer()
       // self.perform(#selector(ReciteWordViewController.reciteEventHandler), with: nil, afterDelay: 3)
    }
    
    @objc private func reciteEventHandler(){
        if(reciteWordIndex >= self.reciteWords.count){
           reciteFinishedAlert()
            return
        }
       
        if(reciteCount == 3){
           nextWord()
            return
        } else{
            playAgain()
        }
    }
    
    
    private func reciteFinishedAlert(){
        let alert = UIAlertController(title: nil, message: "背诵完成！", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //加载文件播放
    private func loadAVPlayer(){
        if(reciteWordIndex >= self.reciteWords.count){
            
            return
        }
        let word = self.reciteWords[reciteWordIndex]
        let path = self.getWordAudioPath(word: word)
          Service.download(filePath: path){(path) in
            do{
                self.avPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                self.avPlayer?.prepareToPlay()
                self.perform(#selector(ReciteWordViewController.playAgain), with: nil, afterDelay: 3)
                
            } catch{
                let alert = UIAlertController(title: "error", message: error.localizedDescription, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //播放下一个单词
    private func nextWord(){
        self.avPlayer = nil
        reciteWordIndex += 1
         reciteCount = 0
        if(reciteWordIndex >= self.reciteWords.count){
            reciteFinishedAlert()
            return
        }
        self.setPageIndex(index:reciteWordIndex)
       
        loadAVPlayer()
       
      //  self.perform(#selector(ReciteWordViewController.reciteEventHandler), with: nil, afterDelay: 3)
    }
    
    
    
    @objc private func playAgain(){
        
        reciteCount += 1

        avPlayer?.play()
        
        self.perform(#selector(ReciteWordViewController.reciteEventHandler), with: nil, afterDelay: 3+(self.avPlayer?.duration)!)
    }
    
    
    private func getWordAudioPath(word:Word)->String{
        if let path = StringUtil.exceptEmpty(word.amAudionPath){
            return path;
        }
        if let path = StringUtil.exceptEmpty(word.enAudioPath){
            return path;
        }
        if let path = StringUtil.exceptEmpty(word.ttsAudioPath){
            return path;
        }
        
        return ""
    }
    
    
    
    //设置集合的页码
    private func setPageIndex(index:Int)  {
        let offX = CGFloat(index) * collectionView.frame.width
        
        collectionView.setContentOffset(CGPoint(x:offX,y:0), animated: true)
    }
}
