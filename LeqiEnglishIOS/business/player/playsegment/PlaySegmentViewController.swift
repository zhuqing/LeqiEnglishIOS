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
    
    //是否自动播放下一个
    var autoNext = true
    
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
    
    //
    private func setUI(){
        self.segmentListRootView.addSubview(self.collectionView)
       
        
        self.playBarRootView.addSubview(self.playBarView)
        self.playBarView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.playBarRootView.bounds.height)
        
       self.initOperationBar()
    }
    
    private func initOperationBar(){
        let operations:[(String,String)] = [("返回","arrow-return-left"),
                                            ("背诵","recite_content"),
                                            ("赞","heart"),
                                            ("分享","share32")]
        OperationBarViewUtil.instance.addOperation(root: self.operationBarRootView, operations: operations, handler: operationTab(id: ))
    }
    
    
    private func  operationTab(id:String){
        switch id {
        case "arrow-return-left":
            self.returnEventHandler()
            
        case "recite_content":
            self.returnEventHandler()
        case "heart":
            self.updateHearted(userInteract: true)
            
        case "share32":
            self.tapShareHandler()
        default:
            self.returnEventHandler()
        }
    }
    
    //更新点赞
    private func updateHearted(userInteract:Bool = false){
        if(segments.count == 0){
            return
        }
        if(self.currentPlaySentenceIndex < 0 || self.currentPlaySentenceIndex > self.segments.count){
            return
        }
        let segment = self.segments[self.currentSegmentPlayIndex]
        
        if(userInteract){
             segment.awesomeNum = (segment.awesomeNum ?? 0) + 1
        }
       
        HeartedUtil.updateAwesome(root: self.operationBarRootView, segment: segment, heartedIndex: 2, userInteract: userInteract)
    }
    
    //背诵当前正在播放的段
    @objc private func reciteSegmentHandler(){
        
    }
    
    //分享
    @objc private func tapShareHandler(){
        
        if(segments.count == 0){
            return
        }
        if(self.currentPlaySentenceIndex < 0 || self.currentPlaySentenceIndex > self.segments.count){
            return
        }
        let segment = self.segments[self.currentSegmentPlayIndex]
        
        let share = ActionSheetDialogViewController()
        share.modalPresentationStyle = .overCurrentContext
        share.delegate = ShareViewActionSheetDelegate( segment:segment,title:"听")
        
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
         
            self.play(index: self.currentSegmentPlayIndex )
            if(self.contentPlayer?.isPlaying ?? false){
                self.playBarView.toPlayStatus()
            }
        }
        
        AppRefreshManager.instance.regist(id: ContentInfoDataCache.CACHE_MANAGER_ID, contentInfoDataCache)
    }
    
    private func createContentPlayer(){
        if(self.contentPlayer != nil){
            return
        }
        
       
       // self.contentPlayer?.playDatas = self.
        
    }
    
    private func play(index:Int){
        
        //如果播放的内容没变，继续播放
       
        self.currentSegmentPlayIndex = index
        self.segmentPlayItems.removeAll()
        
        if(self.segments.count <= index){
            self.collectionView.reloadData()
            return
        }
        
        let segment = self.segments[index]
        //更新点赞
        self.updateHearted()
        
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
    
    func finish(contentPlayer:ContentPlayer,index:Int){
        if(autoNext){
              contentPlayer.play(index: index)
        }
     
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
