//
//  UISegmentPlayViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UISegmentPlayViewController: UIViewController {
    let  LOG = LOGGER("UISegmentPlayViewController")

    @IBOutlet weak var collectionRootView: UIView!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var operationBarRootView: UIView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!


    private var circlePlayBar = CirclePlayerView()
    
    var content:Content?
    
    var segment:Segment?

    
    private var contentPlayer:ContentPlayer?
    
    private lazy var playBar:PlaySegmentBar? = {
        
        let playBar = PlaySegmentBar(frame: CGRect.zero, mp3Path: "")
        return playBar
    }()
    
    private var lastCell:PlaySementItemCollectionViewCell?
    
    private var selectIndex:Int = -1;
    

    
    var segmentPlayItems = [SegmentPlayItem]()
    
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
        self.setupUI()
        loading.startAnimating()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSegment(item:Segment,mp3Path:String){
        playBar?.mp3Path = mp3Path
        self.segment = item
        segmentPlayItems = SegmentPlayItem.toItems(str: item.content!)!
        
        addCollectionView()
        collectionView.reloadData()
        insertUserAndWord(item)
        HeartedUtil.updateAwesome(root: self.operationBarRootView, segment: item, heartedIndex: 3, userInteract: false)
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        guard let player = self.contentPlayer else{
            return
        }
        
        player.pause()
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

extension UISegmentPlayViewController{
    
    private func setupUI(){
       
        navigation()
        initOperationBar()
        self.addPlayView()
       // showWords.addTarget(self, action: #selector(UISegmentPlayViewController.showWordsEventHandler), for: .touchDown)
       // self.startRecite.addTarget(self, action: #selector(UISegmentPlayViewController.startReciteHandler), for: .touchDown)
    }
    
    private func addPlayView(){
        self.view.addSubview(circlePlayBar)
        circlePlayBar.delegate = self
        circlePlayBar.frame = CGRect(x: SCREEN_WIDTH - 100, y: SCREEN_HEIGHT-200, width: 70, height: 70)
    }
    
    private func initOperationBar(){
       
        let operations:[(String,String)] = [("返回","arrow-return-left"),
                                                     ("单词/短语","word_icon"),
                                                       ("赞","heart"),
                                                     ("分享","share32")]
        OperationBarViewUtil.instance.addOperation(root: self.operationBarRootView, operations: operations, handler: operationTab(id: ))
    }
    
    private func  operationTab(id:String){
        switch id {
        case "arrow-return-left":
            self.backEventHandler()
        case "word_icon":
            self.showWordsEventHandler()
            stopAllPlay()
       
        case "heart":
            updateHearted(userInteract: true)
            
        case "share32":
            self.shareEventHandler()
            stopAllPlay()
        default:
            self.backEventHandler()
        }
    }
    
  
    
    private func updateHearted(userInteract:Bool){
        guard let segment = self.segment else{
            return
        }
        segment.awesomeNum = (segment.awesomeNum ?? 0) + 1
        HeartedUtil.updateAwesome(root: self.operationBarRootView, segment: segment, heartedIndex: 3, userInteract: userInteract)
    }
   
    
    private func addCollectionView(){
        collectionRootView.subviews.forEach({(view) in view.removeFromSuperview()})
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: collectionRootView.bounds.height)
    }
    private func navigation(){
        self.back.action = #selector(UISegmentPlayViewController.backEventHandler)
       
    }
    
    private func showWordsEventHandler(){
        let words = SegmentWordViewController()
        
        self.present(words, animated: true, completion: {() in
            words.currentSegment = self.segment
        })
    }
    
    private func shareEventHandler(){
        let share = ActionSheetDialogViewController()
        share.modalPresentationStyle = .overCurrentContext
        share.delegate = ShareViewActionSheetDelegate( segment:self.segment!)
        
        self.present(share, animated: true, completion: nil)
    }
    
    @objc private func backEventHandler(){
       self.stopAllPlay()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func stopAllPlay(){
        self.playBar?.reset()
        self.contentPlayer?.pause()
        self.circlePlayBar.stop()
    }
    
    //跳转到背诵界面
    @objc private func startReciteHandler(){
        let vc = ReciteSegmentViewController()
        let during = (self.segmentPlayItems.last?.endTime)! - self.segmentPlayItems[0].startTime!
        self.present(vc, animated: true){
            
            vc.during = Double(during)/1000.0
            vc.segment = self.segment
            guard let userRecord = UserReciteRecordDataCache.instance.getFromCache() else{
                return
            }
            Service.put(path: "userReciteRecord/updateReciteMinutes?id=\(userRecord.id ?? "")&minutes=\( Int(vc.during) )"){(_) in}
            
            if let content = self.content {
                
                let userSegmentDataCache =  UserSegmentDataCache(contentId: content.id ?? "")
                
                let userAndSegment = UserAndSegment()
                userAndSegment.contentId = content.id
                userAndSegment.segmentId = self.segment?.id
                userAndSegment.userId = userSegmentDataCache.getCurrentUserId()
                
                userSegmentDataCache.commit(userAndSegment)
            }
            
            
        }
    }
    
    
}


extension UISegmentPlayViewController{
    //插入本段单词和用户的关系
    private func insertUserAndWord(_ item:Segment){
        guard  let user =  UserDataCache.instance.getFromCache() else{
            return
        }
        
        Service.post(path: "userAndWord/insertAllBySegmentId?userId=\(user.id ?? "")&segmentId=\(item.id ?? "")",params: ["userId":user.id ?? "","segmentId":item.id ?? ""]){_ in }
        
    }
}

extension UISegmentPlayViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = segmentPlayItems[indexPath.item]
        // var height = 0
        guard let engStr = item.englishSenc else{
            return CGSize(width: SCREEN_WIDTH, height: 60)
        }
        
        
        var height = StringUtil.computerHeight(text: engStr, font: UIFont.boldSystemFont(ofSize: 18), fixedWidth: SCREEN_WIDTH-10)+5
        
        
        if let chstr = item.chineseSenc {
            let chStrHeight = StringUtil.computerHeight(text: chstr, font: UIFont.systemFont(ofSize: 13), fixedWidth: SCREEN_WIDTH-10)+10
            
            height += chStrHeight
        }
        
        if(indexPath.item == selectIndex){
            height += PlaySegmentBar.HEIGHT+10
        }
        
        
        return CGSize(width: SCREEN_WIDTH, height:CGFloat(Int(height+30)))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if( self.selectIndex == indexPath.item){
            return
        }
        
        self.stopAllPlay()
        
        if let lastCell = self.lastCell{
            lastCell.stop(bar: playBar!)
        }
        let cell:PlaySementItemCollectionViewCell = collectionView.cellForItem(at: indexPath) as! PlaySementItemCollectionViewCell
        
        self.selectIndex = indexPath.item
        collectionView.reloadData()
        lastCell = cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentPlayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PlaySementItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaySementItemCollectionViewCell.PALY_SEGMENT_ITEM_CELL, for: indexPath) as! PlaySementItemCollectionViewCell
        
        cell.setItem(item: segmentPlayItems[indexPath.item])
        cell.delegate = self
        
        if(indexPath.item == self.selectIndex){
            cell.play(bar: playBar!)
            cell.selectCell()
            playBar?.segmentPlayItem = segmentPlayItems[indexPath.item]
        }else{
            cell.disSelectCell()
            cell.removeIfHave(bar: playBar!)
        }
        return cell
    }
}
//MARK:点击中文或英文文本
extension UISegmentPlayViewController : PlaySementItemCollectionViewCellDelegate{
    func textViewClick(cell:PlaySementItemCollectionViewCell){
        guard let index = collectionView.indexPath(for: cell) else{
            return
        }
        
        if( self.selectIndex == index.item){
            return
        }
          self.stopAllPlay()
        
        self.selectIndex = index.item
        self.lastCell = cell
        self.collectionView.reloadData()
    }
    func showWord(word: String) {
        if(self.playBar != nil){
            playBar?.reset()
        }
        let alert = ActionSheetDialogViewController()
        // alert.alert
        alert.modalPresentationStyle = .overCurrentContext
        alert.delegate = self
        alert.data = word as NSObject
        self.present(alert, animated: true, completion:{
            self.loadWordInfo(word: word,alert: alert)
        })
    }
    
    func loadWordInfo(word:String,alert:ActionSheetDialogViewController){
        let view:SimpleWordInfo? = alert.contentView?.subviews[0] as? SimpleWordInfo
        
        guard let swifo = view else{
            return
        }
        
        swifo.loadWord(word: word)
        
        
    }
}

extension UISegmentPlayViewController :ActionSheetDialogViewControllerDelegate{
    func getContentViewHeight(viewController: ActionSheetDialogViewController) -> CGFloat? {
        return CGFloat(200)
    }
    
    func getContentView(viewController: ActionSheetDialogViewController) -> UIView? {
        
        return SimpleWordInfo(frame: CGRect.zero)
    }
    
    func getOperation(viewController: ActionSheetDialogViewController) -> [String : () -> ()]? {
        var title = [String:()->()]()
        title["查看详情"] = {() in
            let view:SimpleWordInfo? = viewController.contentView?.subviews[0] as? SimpleWordInfo
            
            guard let swifo = view else{
                return
            }
            
            let word = swifo.word
            
            let wordInfo = WordInfoViewController()
            self.present(wordInfo, animated: true, completion:{
                wordInfo.word = word
            })
        }
        return title;
    }
    
    func closeEventHandler(viewController: ActionSheetDialogViewController) {
        
    }
    
    
  
    
}

extension UISegmentPlayViewController : ContentPlayerDelegate{
    func currentPlayIndexChange(contentPlayer: ContentPlayer, index: Int) {
        
    }
    
    func finish(contentPlayer: ContentPlayer, index: Int) {
        
    }
    
    func error(contentPlayer: ContentPlayer, message: String) {
        
    }
    
    func finish(contentPlayer: ContentPlayer) {
       self.circlePlayBar.stop()
    }
    
    func currentTimeChange(contentPlayer: ContentPlayer, currentTime: TimeInterval) {
        if(!contentPlayer.isPlaying){
            return
        }
        self.circlePlayBar.perscent = CGFloat(currentTime/contentPlayer.getMaxDuration())
    
        for index in (0 ..< self.segmentPlayItems.count) {
            let segemtItem = self.segmentPlayItems[index]
            if(currentTime >= TimeInterval(segemtItem.startTime ?? 0)/1000 && currentTime <= TimeInterval(segemtItem.endTime ?? 0)/1000){
                select(index: index)
            }
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
        selectedCell.disSelectCell()
    }
    
    
    private func select(index:Int){
        
        if(index < 0){
            return
        }
        
        if(index>=self.segmentPlayItems.count){
            return
        }
        disSelect(index: self.selectIndex)
        self.selectIndex = index
        let indexPath = IndexPath(row: index, section: 0)
        
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) else{
            return
        }
        
        let selectedCell =  cell as! PlaySementItemCollectionViewCell
        selectedCell.selectCell()
    }
}

extension UISegmentPlayViewController : CirclePlayerViewDelegate{
    func play(playBarView: CirclePlayerView) {
      
         self.playBar?.reset()
        
         audioPlayHandler()
        
    }
    
    func pause(playBarView: CirclePlayerView) {
        guard let player = self.contentPlayer else {
            return
        }
        
        player.pause()
    }
    //播放音频
    private func audioPlayHandler(){
        if(self.segment == nil ){
            return
        }
        
        // let controller = PlaySegmentViewController()
        if(self.contentPlayer == nil){
            self.contentPlayer = ContentPlayer()
            self.contentPlayer?.delegate = self
            
            self.contentPlayer?.playDatas = [SegmentPlayEntity.createSegmentPlayEntity(segment: self.segment!)!]
            self.contentPlayer?.play()
        }else{
              self.contentPlayer?.start()
        }
        
      
        self.circlePlayBar.play()
    }
    
}


