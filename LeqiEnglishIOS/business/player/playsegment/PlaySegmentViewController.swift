//
//  PlaySegmentViewController.swift
//  LeqiEnglishIOS
//播放每段的内容
//  Created by zhuleqi on 2019/1/2.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class PlaySegmentViewController: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var playBarRootView: UIView!
    @IBOutlet weak var segmentListRootView: UIView!
    @IBOutlet weak var operationBarRootView: UIView!
    
    private var LOG = LOGGER("PlaySegmentViewController")
    
    var contentPlayer:ContentPlayer?{
        didSet{
             contentPlayer?.delegate = self
        }
    }
    
    
    private lazy var playBarView:PlayBarView = {
        let playBarView = PlayBarView(frame: CGRect.zero)
        playBarView.delegate = self
        return playBarView
    }()
    
    //当前正在播放的句子所在s的Cell
    private var selectedCell:PlaySementItemCollectionViewCell?
    
    var content:Content?{
        didSet{
            loadData()
        }
    }
    //当前播放的是第几个段
    var currentSegmentPlayIndex:Int = 0
    
    //当前播放的是段中的第几句
    private var currentPlaySentenceIndex:Int = 0;
    
    private var isPlaying  = false
    
    private var currentMax = 0.0
    
    //用户交互触发
    private var userInteract = false
    
    
    //当前播放的数据
    private var segments:[Segment] = [Segment]()
    
    
    private var segmentPlayItems:[SegmentPlayItem] = [SegmentPlayItem]()
    
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        //layout.itemSize = CGSize(width: SCREEN_WIDTH, height: 200)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PlaySementItemCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: PlaySementItemCollectionViewCell.PALY_SEGMENT_ITEM_CELL)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        navigation()
        // Do any additional setup after loading the view.
    }
    private func navigation(){
        self.back.action = #selector(PlaySegmentViewController.returnEventHandler)
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: UI
extension PlaySegmentViewController{
    private func setUI(){
        self.segmentListRootView.addSubview(self.collectionView)
       
        
        self.playBarRootView.addSubview(self.playBarView)
        self.playBarView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.playBarRootView.bounds.height)
        
        let operations:[(String,String,Selector)] = [("返回","arrow-return-left",#selector(PlaySegmentViewController.returnEventHandler)),
                                                     ("背诵","recite_content",#selector(PlaySegmentViewController.reciteSegmentHandler)),
                                                     ("赞","heart",#selector(PlaySegmentViewController.tapHeartHandler)),
                                                     ("分享","share32",#selector(PlaySegmentViewController.tapShareHandler))]
        
        ViewUtil.addOperation(target:self,root: operationBarRootView, operations: operations)
        
    }
    
    //更新segment的点赞数
    private func updateAwesome(segment:Segment?,userInteract:Bool){
        
        guard let s = segment else{
            ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, itemData:("赞","heart"))
            return
        }
        
        if((s.awesomeNum ?? 0) == 0){
             ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, itemData:("赞","heart"))
            return
        }
        
        if(userInteract){
            ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, itemData:("\(s.awesomeNum ?? 0)","heart_red"))
            return
        }
        
        ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, itemData:("\(s.awesomeNum ?? 0)","heart"))
        
        let cache = UserHeartedDataCache(segmentId: s.id ?? "")
        
        cache.load(){
            
            (userHearted) in
            guard userHearted != nil else{
                 ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, itemData:("\(s.awesomeNum ?? 0)","heart"))
                return
            }
            
             ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, itemData:("\(s.awesomeNum ?? 0)","heart_red"))
            
        }
        
        
    }
    
    
    //背诵当前正在播放的段
    @objc private func reciteSegmentHandler(){
        
    }
    //点赞
    @objc private func tapHeartHandler(){
        
        if(self.currentPlaySentenceIndex < 0 || self.currentPlaySentenceIndex > self.segments.count){
            return
        }
        
        let segment = self.segments[self.currentSegmentPlayIndex]
        
        HeartedDataCache.segmentHeated(targetId: segment.id ?? "", contentId: segment.contentId ?? "")
        segment.awesomeNum = (segment.awesomeNum ?? 0) + 1
        self.updateAwesome(segment: segment,userInteract: true)
      //  ViewUtil.updateOperationItemTitle(target: self, root: self.operationBarRootView, index: 2, image: "heart_red")
    }
    //分享
    @objc private func tapShareHandler(){
        let share = ActionSheetDialogViewController()
        share.modalPresentationStyle = .overCurrentContext
        share.delegate = ShareViewActionSheetDelegate( segment:Segment())
        
        self.present(share, animated: true, completion: nil)
    }
}
//MARK: data
extension PlaySegmentViewController{
    //加载数据
    private func loadData(){
        guard let content = self.content else{
            self.segments.removeAll()
            self.collectionView.reloadData()
            return;
        }
        
        //加载Content中的segment数据
       let contentInfoDataCache =  ContentInfoDataCache(content: content)
        contentInfoDataCache.load(){
            (segments) in
             self.segments.removeAll()
             self.segmentPlayItems.removeAll()
            guard let segmentList = segments else{
               
                return;
            }
             self.collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.segmentListRootView.frame.height)
            self.segments.append(contentsOf: segmentList)
         
            self.play(index: self.currentSegmentPlayIndex ?? 0)
            if(self.contentPlayer?.isPlaying ?? false){
                self.playBarView.toPlayStatus()
            }
        }
        
        AppRefreshManager.instance.regist(id: ContentInfoDataCache.CACHE_MANAGER_ID, contentInfoDataCache)
    }
    
   private func play(index:Int){
    
        self.currentSegmentPlayIndex = index
        self.segmentPlayItems.removeAll()
        
        if(self.segments.count <= index){
             self.collectionView.reloadData()
            return
        }
        
        let segment = self.segments[index]
    //更新点赞
       updateAwesome(segment: segment,userInteract: false)
    
        guard let content =  segment.content else {
             self.collectionView.reloadData()
            return
        }
        
        guard let segmentPlayItems = SegmentPlayItem.toItems(str: content) else{
             self.collectionView.reloadData()
            return
        }
    
        self.currentMax = Double((segmentPlayItems.last?.endTime ?? 0))/1000
        
        self.segmentPlayItems = segmentPlayItems
        
        self.collectionView.reloadData()
        
        
    }
}



//MARK:PlayBarViewDelegate
extension PlaySegmentViewController:PlayBarViewDelegate{
    func next(playBarView:PlayBarView){
        guard let contentPlayer = self.contentPlayer else{
            return
        }
        
        guard let datas = contentPlayer.playDatas else{
            return
        }
        
        if((self.currentSegmentPlayIndex + 1) >= datas.count){
            self.showAlert(message: "已经是最后一个了")
            return;
        }
    LOG.info("next \(currentSegmentPlayIndex)")
        contentPlayer.play(index: self.currentSegmentPlayIndex+1)
        
        
    }
    
    func previous(playBarView:PlayBarView){
        guard let contentPlayer = self.contentPlayer else{
            return
        }
        
        if(self.currentSegmentPlayIndex == 0){
             self.showAlert(message: "已经是第一个了")
            return
        }
       LOG.info("previous \(currentSegmentPlayIndex)")
        contentPlayer.play(index: self.currentSegmentPlayIndex-1)
     
    }
    
    func play(playBarView:PlayBarView){
        guard let contentPlayer = self.contentPlayer else{
            return
        }
        
        contentPlayer.start()
        
    }
    
    func pause(playBarView:PlayBarView){
        guard let contentPlayer = self.contentPlayer else{
            return
        }
        contentPlayer.pause()
    }
    //进度条值改变
    func progressValueChange(playBarView:PlayBarView,value:Float){
        guard let contentPlayer = self.contentPlayer else{
            return
        }
        
        let currentTime = (Double(value) * currentMax)
        contentPlayer.play(atTime: currentTime)
    }
    
}

//MARK:ContentPlayer
extension PlaySegmentViewController:ContentPlayerDelegate{
    //当前播放时间改变
    func currentTimeChange(contentPlayer:ContentPlayer,currentTime:TimeInterval){
        let value = Float(currentTime/self.currentMax)
        self.playBarView.updateProgress(value: value)
        
        var index = 0
        for segmentPlayItem in self.segmentPlayItems{
            
            if(currentTime >= Double(segmentPlayItem.startTime ?? 0)/1000 && currentTime <= Double(segmentPlayItem.endTime ?? 0)/1000 ){
                break
            }
            
            index += 1
        }
        
        self.select(index: index)
        if(self.currentPlaySentenceIndex == index){
           
            return
        }
        disSelect(index:currentPlaySentenceIndex)
        currentPlaySentenceIndex = index
       
    }
    
    private func disSelect(index:Int){
        
        if(index < 0){
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) else{
            return
        }
        
        let selectedCell =  cell as! PlaySementItemCollectionViewCell
        selectedCell.englishTextView?.textColor = UIColor.black
    }
    
    
    private func select(index:Int){
        
        if(index < 0){
            return
        }
        
        if(index>=self.segmentPlayItems.count){
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
   
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
       
        guard let cell = self.collectionView.cellForItem(at: indexPath) else{
            return
        }
        
        let selectedCell =  cell as! PlaySementItemCollectionViewCell
        selectedCell.englishTextView?.textColor =  UIColor(r: CGFloat(0xed), b: CGFloat(0x74), y: CGFloat(0x2e))
    }
    
    
    func currentPlayIndexChange(contentPlayer:ContentPlayer, index:Int){
      
           self.play(index: index)
         LOG.info("currentPlayIndexChange \(currentSegmentPlayIndex)")
       // contentPlayer.play()
        
    }
    //播放完成,自动播放下一个
    func finish(contentPlayer:ContentPlayer){
       // self.play(index: self.currentPlayIndex+1)
    }
    
    func error(contentPlayer:ContentPlayer,message:String){
        
    }
}

//MARK: UICollectionViewDelegateFlowLayout UICollectionViewDataSource
extension PlaySegmentViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    //根据内容重新设置单元格的大小
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = self.segmentPlayItems[indexPath.item]

        guard let engStr = item.englishSenc else{
            return CGSize(width: SCREEN_WIDTH, height: 60)
        }
        
        //英文的高度
        var height = StringUtil.computerHeight(text: engStr, font: UIFont.boldSystemFont(ofSize: 18), fixedWidth: SCREEN_WIDTH-10)+5
        
        
        //中文的高度
        if let chstr = item.chineseSenc {
            let chStrHeight = StringUtil.computerHeight(text: chstr, font: UIFont.systemFont(ofSize: 13), fixedWidth: SCREEN_WIDTH-10)+10
            
            height += chStrHeight
        }
        
        return CGSize(width: SCREEN_WIDTH, height:CGFloat(Int(height+30)))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.segmentPlayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:PlaySementItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaySementItemCollectionViewCell.PALY_SEGMENT_ITEM_CELL, for: indexPath) as! PlaySementItemCollectionViewCell
        
        cell.setItem(item: self.segmentPlayItems[indexPath.item])
        cell.englishTextView?.textColor = UIColor.black
       
        return cell
    }
    
    
    
}



extension PlaySegmentViewController : PlaySementItemCollectionViewCellDelegate{
    func textViewClick(cell:PlaySementItemCollectionViewCell){
       
    }
    func showWord(word: String) {
       
    }
    
    func loadWordInfo(word:String,alert:ActionSheetDialogViewController){
       
    }
}
