//
//  PlayContentViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/12/21.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

class PlayContentViewController: UIViewController {

    @IBOutlet weak var operationBarViewRoot: UIView!
    @IBOutlet weak var addRciteButton: UIButton!
    @IBOutlet weak var playBarRoot: UIView!
    @IBOutlet weak var contentListRoot: UIView!
    @IBOutlet weak var nav: UIBarButtonItem!
    
    private var currentPlayIndex = -1;
    
    
    
    //当前播放的Content的最长时间
    private var currentMax:TimeInterval = 0;
    
    private var contentPlayer:ContentPlayer?
    
    private lazy var playBarView:PlayBarView = {
        let playBar = PlayBarView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 90))
        playBar.delegate = self
        return playBar
    }()
    
    
    private var datas:[Content]? = [Content]();
    
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: SCREEN_WIDTH-10, height: 30)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical

        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
      //  self.collectionView.allowsSelection = true
        collectionView.register(UINib(nibName: "SimpleTextCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         load()
         navigation()
         initEventHandler()
         beginReceivingRemoteControlEvents()
        // Do any additional setup after loading the view.
    }


    override func viewWillDisappear(_ animated: Bool) {
     endReceivingRemoteControlEvents()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(self.contentPlayer != nil){
            self.contentPlayer?.delegate = self
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    

    
    func beginReceivingRemoteControlEvents(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
       self.becomeFirstResponder()
        
    }
    
    func endReceivingRemoteControlEvents(){
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {

        
        if event?.type == UIEventType.remoteControl {
            switch event!.subtype {
            case .remoteControlTogglePlayPause:
                print("暂停/播放")
            case .remoteControlPreviousTrack: // ##  <-  ##
                print("上一首")
            case .remoteControlNextTrack: // ## -> ##
                print("下一首")
            case .remoteControlPlay: // ## > ##
                print(">")
            case .remoteControlPause: // ## || ##
                print("||")
            default:
                break
            }
        }
    }
    
    
    func setBackground() {
    
        //大标题 - 小标题  - 歌曲总时长 - 歌曲当前播放时长 - 封面
   //   PlayIng
        
       
    }
    
    private func initEventHandler(){
        addRciteButton.addTarget(self, action: #selector(PlayContentViewController.returnEventHandler), for: .touchDown)
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
//MARK: UI OPeration
extension PlayContentViewController{
    
    private func setUI(){
    
        self.playBarRoot.addSubview(self.playBarView)
        self.contentListRoot.addSubview(self.collectionView)
        collectionView.frame = CGRect(x: 5, y: 0, width:SCREEN_WIDTH-10, height: self.contentListRoot.bounds.height)
       
        
        let operations:[(String,String,Selector)] = [("返回","arrow-return-left",#selector(PlayContentViewController.returnEventHandler)),
                                                     ("文稿","content",#selector(PlayContentViewController.tapContentHandler)),
                                                     ("赞","heart",#selector(PlayContentViewController.tapHeartHandler)),
                                                     ("分享","share32",#selector(PlayContentViewController.tapShareHandler))]
        
        OperationBarViewUtil.addOperation(target:self,root: operationBarViewRoot, operations: operations)
    }
    
    @objc private func tapContentHandler(){
        if(self.currentPlayIndex < 0){
            self.showAlert(message: "还没有选择播放的数据")
            return
        }
        
        let playSegmentViewController = PlaySegmentViewController()
        
        playSegmentViewController.currentSegmentPlayIndex = self.contentPlayer?.currentPlayIndex ?? 0
        
        self.present(playSegmentViewController, animated: true){
            () in
            playSegmentViewController.contentPlayer = self.contentPlayer
            playSegmentViewController.content = self.datas![self.currentPlayIndex]
        }
    }
    
    @objc private func tapHeartHandler(){
        if(self.currentPlayIndex < 0 || self.currentPlayIndex >= self.datas?.count ?? 0){
            self.showAlert(message: "还没有选择播放数据")
            return
        }
        guard let content = self.datas?[self.currentPlayIndex] else {
            self.showAlert(message: "还没有选择播放数据")
            return
        }
        DispatchQueueUtil.run {
              HeartedUtil.contentHeated(targetId: content.id ?? "")
        }
      
        content.awesomeNum? += Int64(1)
        HeartedUtil.updateAwesome(root: self.operationBarViewRoot, content: content, heartedIndex: 2, userInteract: true)
       
    }
    
   
    
    @objc private func tapShareHandler(){
        let share = ActionSheetDialogViewController()
        share.modalPresentationStyle = .overCurrentContext
        share.delegate = ShareViewActionSheetDelegate( segment:Segment())
        
        self.present(share, animated: true, completion: nil)
    }
    
   
    
    //加载content
    private func load(){
        MyContentDataCache.instance.load(){
            (contents) in
            self.datas?.removeAll()
            if let list = contents {
                   self.datas?.append(contentsOf: list)
            }
            
            if(self.datas == nil  || (self.datas?.isEmpty)! ){
               //没有加载到数据什么都不做
            }else{
                self.setUI();
                self.contentPlayer = ContentPlayer()
                self.contentPlayer?.delegate = self
                self.collectionView.reloadData()
            }
            
        }
    }
    
    private func navigation(){
        self.nav.action = #selector(PlayContentViewController.returnEventHandler)
    }
    
    //返回触发的事件
    @objc  override func returnEventHandler(){
        self.playBarView.stop()
        self.contentPlayer?.destory()
        self.dismiss(animated: true, completion: nil)
    }
    
   
   //加载content下的段
    private func loadSegments(content:Content)  {
        let contentInfoViewModel = ContentInfoDataCache(content: content)
        contentInfoViewModel.load(){
            (segments) in
            guard let arr = segments else{
                return
            }
            self.createSegmentPlayEntity(segments: arr)
        }
        
        
    }
    
    private func createSegmentPlayEntity(segments:[Segment]){
        var segmentPlayEntities = SegmentPlayEntity.toSegmentPlayEntitys(segments: segments)
        
        if(segmentPlayEntities.count == 0){
            return
        }
        
        guard  let lastPlayEntity = segmentPlayEntities.last else{
            return
        }
        
       
        
        //设置当前播放的最大的值
        self.currentMax = lastPlayEntity.endTime ?? 0
        self.contentPlayer?.playDatas = segmentPlayEntities
        if (segmentPlayEntities[0].filePath ?? "").contains(APP_ROOT_PATH){
           self.play()
            return
        }
        Service.download(filePath: segmentPlayEntities[0].filePath ?? "") { (filePath) in
           segmentPlayEntities[0].filePath = filePath
           self.play()
        }
    }
    
    private func play(){
        self.playBarView.updateProgress(value: 0)
        self.playBarView.toPlayStatus()
        self.contentPlayer?.play()
    }
    
  
    
    private func play(index:Int){
        guard let datas = self.datas else{
            return
        }
        
        deselected(index: currentPlayIndex)
        self.currentPlayIndex = index
     
        if(currentPlayIndex < 0){
            currentPlayIndex =  datas.count - 1
        }else if(currentPlayIndex >= datas.count){
            currentPlayIndex = 0
        }
        
        
        selected(index: currentPlayIndex)
        self.loadSegments(content: datas[self.currentPlayIndex])
    }
    
    private func selected(index:Int){
        if(index < 0){
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) else{
            return
        }
        
        let simpleTextCollectionViewCell:SimpleTextCollectionViewCell = cell  as! SimpleTextCollectionViewCell
        simpleTextCollectionViewCell.selectCell()
         HeartedUtil.updateAwesome(root: self.operationBarViewRoot, content: self.datas![index], heartedIndex: 2, userInteract: false)
    }
    
    private func deselected(index:Int){
        if(index < 0){
            return
        }
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = self.collectionView.cellForItem(at: indexPath) else{
            return
        }
        
        let simpleTextCollectionViewCell:SimpleTextCollectionViewCell = cell  as! SimpleTextCollectionViewCell
        simpleTextCollectionViewCell.deselectCell()
    }
    
}

//MARK: 实现集合的代理
extension PlayContentViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SimpleTextCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY, for: indexPath) as! SimpleTextCollectionViewCell
       
         let content = self.datas![indexPath.item]

        cell.setText(content.title ?? "")
        cell.textLabel.textAlignment = .left
        cell.delegate = self
        
        if(self.currentPlayIndex == indexPath.item){
            cell.selectCell()
        }else{
            cell.deselectCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
       
        self.play(index: indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell:SimpleTextCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
//
//        cell.deselectCell()
    }
}



//MARK: 实现SimpleTextCollectionViewCell代理
extension PlayContentViewController:SimpleTextCollectionViewCellDelegate{
     func selected(cell: SimpleTextCollectionViewCell) {
        cell.textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel.textColor = UIColor(r: CGFloat(0xed), b: CGFloat(0x74), y: CGFloat(0x2e))
    }
    
    
     func deSelected(cell: SimpleTextCollectionViewCell) {
        cell.textLabel.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel.textColor = UIColor.black
    }
}


//MARK:  PlayBarViewDelegate
extension PlayContentViewController:PlayBarViewDelegate{
    
   

    func next(playBarView: PlayBarView) {
        self.play(index: self.currentPlayIndex+1)
    }
    
    func play(playBarView: PlayBarView) {
        if(self.contentPlayer?.playDatas == nil){
              self.play(index: self.currentPlayIndex)
        }else{
             self.contentPlayer?.start()
        }
       
        
      
    }
    
    func previous(playBarView: PlayBarView) {
        self.play(index: self.currentPlayIndex - 1)
    }
    
  
    func pause(playBarView:PlayBarView){
        guard let contentPlayer = self.contentPlayer else {
            return
        }
        
        contentPlayer.pause()
        
    }
    
    func progressValueChange(playBarView:PlayBarView,value:Float){
       let currentTime = Double(value) * self.currentMax
        guard let contentPlayer = self.contentPlayer else {
            return
        }
        
        
        var i = 0 ;
        
        //播放的时间点
        var atTime:Double = 0;
        //播放的索引
        var playingIndex = 0;
        
        for segmentPlayEntity in contentPlayer.playDatas! {
            if(currentTime >= segmentPlayEntity.startTime! && currentTime <= segmentPlayEntity.endTime!){
                playingIndex = i
                atTime = Double(currentTime - segmentPlayEntity.startTime!)
                break
            }
            i += 1
        }
        
    
        
        contentPlayer.play(index:playingIndex, atTime: atTime)
    }
    
    
}

//MARK:ContentPlayer
extension PlayContentViewController:ContentPlayerDelegate{
    //当前播放时间改变
    func currentTimeChange(contentPlayer:ContentPlayer,currentTime:TimeInterval){
        var hasPlayedTime = 0.0
        if(contentPlayer.currentPlayIndex != 0){
            hasPlayedTime = contentPlayer.getSegmentPlayEntity(index: contentPlayer.currentPlayIndex-1)?.endTime ?? 0
        }
        let value = Float((hasPlayedTime + currentTime)/self.currentMax)
        self.playBarView.updateProgress(value: value)
    }
    
    func finish(contentPlayer:ContentPlayer,index:Int){
        
    }
    
    func currentPlayIndexChange(contentPlayer:ContentPlayer, index:Int){
       //self.playBarView.startPlay()
    }
    //播放完成,自动播放下一个
    func finish(contentPlayer:ContentPlayer){
        self.play(index: self.currentPlayIndex+1)
    }
    
    func error(contentPlayer:ContentPlayer,message:String){
        
    }
}
