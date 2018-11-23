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
    
    @IBOutlet weak var wordNumberLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var wordInfoRootView: UIView!
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    private var avPlayer:AVAudioPlayer?
    
    private var reciteWords = [Word]()
    
    
    var isPlaying:Bool = false
    
    //每个单词的背诵次数
    private var reciteCount = 0
    
    //背诵单词的索引
    private var reciteWordIndex:Int = 0
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: wordInfoRootView.bounds.height)
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
            
            self.refreshData();
        }
    }
    
    private func refreshData(){
        
        self.collectionView.reloadData()
        
    }
    
    private func setupUI(){
        
        resetWordInfoRootView()
        
        navigation()
        loadwords()
        registButtonEvent()
    }
    
    
    private func resetWordInfoRootView(){
       
            for view in self.wordInfoRootView.subviews{
                view.removeFromSuperview()
            }
            self.wordInfoRootView.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: wordInfoRootView.frame.height)
      
    }
    
    
    //所有加载单词的发音文件
    private func loadAudioFile(){
        for word in self.reciteWords{
            let path = getWordAudioPath(word: word)
            
            Service.download(filePath: path){_ in}
        }
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
    }
    
    @objc private func backEventHandler(){
        pauseRecite()
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: 背诵或有关的事件
extension ReciteWordViewController{
    //MARK: 点击事件注册
    private func registButtonEvent(){
        self.startButton.addTarget(self, action: #selector(ReciteWordViewController.startRecite), for: .touchDown)
    }
    //MARK: 点击事件注册
    @objc private func startRecite(){
        if(isPlaying){
            startButton.backgroundColor = UIColor.yellow
            startButton.setTitle("继续", for: .normal)
            self.isPlaying = false
            pauseRecite()
        }else{
            startButton.backgroundColor = UIColor.red
            startButton.setTitle("暂停", for: .normal)
            self.isPlaying = true
            self.reciteCount = 0
            self.avPlayer = nil
            loadAVPlayer()
        }
        
        
    }
    //MARK: 暂停背诵
    private func pauseRecite(){
        if let avplay = self.avPlayer{
            avplay.stop()
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @objc private func reciteEventHandler(){
        
        if(reciteWordIndex >= self.reciteWords.count){
            reciteFinishedAlert()
            return
        }
        
        if(reciteCount == 3){
            nextWord()
            
        } else{
            playAgain()
        }
    }
    
    //背诵或默写完成后显示的消息提示框
    private func reciteFinishedAlert(){
        let message = "背诵完成！"
       
        var reciteNumber = 10
        
        if let reciteConfig = MyReciteWordConfig.instance.getFromCache(){
            reciteNumber = reciteConfig.reciteNumberPerDay ?? 10
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "开始默写", style: .default, handler: {
            (action) in
            let vc = WriteWordViewController()
          
            self.present(vc, animated: true){
                vc.setWords(self.reciteWords)
            }
        }))
        
       // alert.addAction(UIAlertAction(title: "分享给朋友", style: .default, handler: ))
        alert.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: {
            (action) in
          self.returnHome()
        }))
        
        
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
        
    }
    
    
    //播放单词音频，播放完成后，进行下一次播放
    @objc private func playAgain(){
        
        reciteCount += 1
        
        avPlayer?.play()
        
        self.perform(#selector(ReciteWordViewController.reciteEventHandler), with: nil, afterDelay: 2+(self.avPlayer?.duration)!)
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
