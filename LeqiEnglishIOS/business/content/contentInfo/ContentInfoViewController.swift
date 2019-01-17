//
//  ContentInfoViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/16.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ContentInfoViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var add2MyReciteButton: UIButton!
    @IBOutlet weak var collectionRootView: UIView!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var operationBarRootView: UIView!
    
    @IBOutlet weak var back: UIBarButtonItem!
    let LOG = LOGGER("ContentInfoViewController")
    
    
    var content:Content?{
        didSet{
            guard let c = content else {return}
            
            setContent(c)
            resetUI()
        }
    }
    
    private var contentPlayer:ContentPlayer?
    
    //可以播放的segment数据
    private var segmentPlayEntities:[SegmentPlayEntity]?
    
    static var isMyRecite:Bool? = false{
        didSet{
          //ContentInfoViewController.self.resetUI()
        }
    }
    
    var segments:[Segment] = [Segment]()
    
    private lazy var collectionView:UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: SEGMENT_CELL_WIDTH, height: SEGMENT_CELL_HEIGHT)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "SegmentViewItem", bundle:nil), forCellWithReuseIdentifier: SegmentViewItem.SEGMENT_VIEW_ITEM_CELL)
        
        collectionView.backgroundColor = UIColor.clear
        return collectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the vie.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refresh()
        guard let player = self.contentPlayer else{
            return
        }
        
        player.pause()
    }
    
   
}
//MARK: UI EVENT
extension ContentInfoViewController{
    private func setupUI(){
        // self.navigationController.navigationBar.trans
        // self.navigationItem.leftBarButtonItem
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: collectionRootView.frame.height)
        addListener()
        resetUI()
        initOperationBar()
     
    }
    
    private func initOperationBar(){
        let operations:[(String,String)] = [("返回","arrow-return-left"),
                                            ("听音频","listen_icon"), ("赞","heart"),
                                            ("分享","share32")]
        OperationBarViewUtil.instance.addOperation(root: self.operationBarRootView, operations: operations, handler: operationTab(id: ))
    }
    
    
    private func  operationTab(id:String){
        switch id {
        case "arrow-return-left":
            self.backEventHandler()

        case "listen_icon":
            self.audioPlayHandler()
        case "heart":
            self.updateHearted(userInteract: true)
            
        case "share32":
            self.shareEventHandler()
        default:
            self.backEventHandler()
        }
    }
    
    //分享按钮事件
    private func shareEventHandler(){
        let share = ActionSheetDialogViewController()
        if(self.segments.count == 0){
            return
        }
        share.modalPresentationStyle = .overCurrentContext
        
        share.delegate = ShareViewActionSheetDelegate( segment:self.segments.first!,title:"听")
        
        self.present(share, animated: true, completion: nil)
    }
    //播放音频事件
    private func audioPlayHandler(){
        guard let content = self.content else{
            return
        }
        
        guard let player = self.contentPlayer else{
            return
        }
        
        let playSegment = PlaySegmentViewController()
        playSegment.contentPlayer = self.contentPlayer
        
        playSegment.currentSegmentPlayIndex = 0
        self.present(playSegment, animated: true, completion: {
            player.play(index: 0)
            playSegment.content = content
        })
    }
    
    //更新点赞
    private func updateHearted(userInteract:Bool = false){
        guard let content = self.content else{
            return
        }
        content.awesomeNum = (content.awesomeNum ?? 0) + 1
        HeartedUtil.updateAwesome(root: self.operationBarRootView, content: content, heartedIndex: 2, userInteract: userInteract)
    }
    
    private func navigation(){
        self.back.action = #selector(ContentInfoViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
        guard  let player = self.contentPlayer else {
            return
        }
        
        player.destory()
        
    }
    //按钮时间监听
    private func addListener(){
        self.add2MyReciteButton.addTarget(self, action: #selector(ContentInfoViewController.btnClickEventHandler), for: UIControlEvents.touchDown)
         navigation()
    }
    //重新设置UI
    private func resetUI(){
        if(ContentInfoViewController.isMyRecite ?? false){
             self.add2MyReciteButton.isHidden = true
        }else{
             self.add2MyReciteButton.isHidden = false
        }
          updateHearted()
    }
    
    @objc private func btnClickEventHandler(){
        guard let content = self.content else{
            LOG.error("Content = nil")
            return
        }
        
        guard let contentId = content.id else{
            LOG.error("content 没有Id")
            return
        }
        
        let userData = UserDataCache.instance
        
        guard let user = userData.getFromCache() else {
            LOG.error("没找到User")
            return
        }
        
        guard let userId = user.id else {
            LOG.error("没找到User.id")
            return
        }
        
        Service.post(path: "userAndContent/create",params: ["userId":userId,"contentId":contentId,"finishedPercent":"0"]){
            (result) in
            self.LOG.info(result.description)
            self.hasAdd2Recited()
            MyRecitingContentDataCache.instance.claerData()
            MyRecommendViewModel.instance.claerData()
            MyContentDataCache.instance.claerData()
            
        }
    }
    
  
    
    //已经添加到了我的背诵
    func hasAdd2Recited(){
        self.add2MyReciteButton.setTitle("已经添加到了我的背诵", for: .normal)
        self.add2MyReciteButton.backgroundColor = UIColor.red
       // self.add2MyReciteButton.isHidden = true
    }
    
    
    private func setContent(_ content:Content){
        // self.content = content
        self.titleLabel.text = content.title!
        loadData()
        //loadFile(content)
    }
    
   
    
    private func createContentWords()->Segment{
        let segment = Segment()
        segment.title = "单词列表"
        segment.id = ""
        
        return segment
    }
}


extension ContentInfoViewController{
    //加载数据
    private func loadData(){
        let segmentDatas = ContentInfoDataCache(content: self.content)
        segmentDatas.load(){
            (segments) in
            if let ss = segments {
                self.segments = ss
                //self.segments.insert(self.createContentWords(), at: 0)
            }else{
                self.segments = [Segment]()
            }
            
            self.collectionView.reloadData()
            self.loadHasRecitedSegmentData(self.content!)
            self.loadSegmentPlayEntitys(segments: self.segments)
        }
    }
    
    private func loadSegmentPlayEntitys(segments:[Segment]){
        
        self.segmentPlayEntities = SegmentPlayEntity.toSegmentPlayEntitys(segments: segments)
        if(self.contentPlayer == nil){
            self.contentPlayer = ContentPlayer()
        }
        
        self.contentPlayer?.playDatas = self.segmentPlayEntities
        
        
    }
    
    //加载已经背诵的段的数据
    private func loadHasRecitedSegmentData(_ content:Content){

        UserSegmentDataCache(contentId: content.id ?? "").load(finished: {
            (userAndSegments) in
            guard let us = userAndSegments else{
                 self.finishedLabel.text = "已完成0/\( self.segments.count)"
                return
            }
            self.finishedLabel.text = "已完成\(us.count)/\( self.segments.count)"
        })
    }
}

extension ContentInfoViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toSegment(segment: segments[indexPath.item],index:indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segments.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SegmentViewItem = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentViewItem.SEGMENT_VIEW_ITEM_CELL, for: indexPath) as! SegmentViewItem
       
        cell.segment = segments[indexPath.item]
        return cell
    }
}

extension ContentInfoViewController : RefreshDataCacheDelegate{
    func clearnCacheThenRefresh() {
        UserSegmentDataCache(contentId: self.content?.id ?? "").claerData()
        refresh()
    }
    
    func refresh() {
       self.loadData()
    }
}

extension ContentInfoViewController{
    
    private func toSegment(segment:Segment,index:Int){
        var path:String = ""
        if(segment.audioPath != nil){
            path = segment.audioPath!
        }else if(content?.audioPath != nil){
            path = (content?.audioPath!)!
        }
        
        if(path.count == 0){
            toSegmentInfo(segment: segment,index: index)
            return
        }
        
        if(FileUtil.hasFile(path: path)){
            toSegmentInfo(segment: segment,index: index)
        }else{
            toLoadView(segment: segment,index: index, path: path)
        }
      
    }
    
    private func toLoadView(segment:Segment,index:Int,path:String){
        let loadView = LoadingViewController()
        self.present(loadView, animated: true, completion: {
            () in
            loadView.load(path: path, callback: {() in
                loadView.dismiss(animated: false, completion: nil)
                self.toSegmentInfo(segment: segment,index:index)
            })
        })
    }
    
    private func toSegmentInfo(segment:Segment,index:Int){
        let uiView = UISegmentPlayViewController()
   
      //  uiView.segmentPlayEntities = self.segmentPlayEntities
       // uiView.contentPlayer = self.contentPlayer
        self.present(uiView, animated: true){
     
            uiView.setSegment(item: segment,mp3Path: segment.audioPath ?? "")
            uiView.content = self.content
        }
    }
    
    //把当前content下关联的单词，关联给用户
   
}
