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
    
    @IBOutlet weak var back: UIBarButtonItem!
    let LOG = LOGGER("ContentInfoViewController")
    
    
    var content:Content?{
        didSet{
            guard let c = content else {return}
            
            setContent(c)
            resetUI()
        }
    }
    
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
    
    
    
    
}

extension ContentInfoViewController{
    private func setupUI(){
        // self.navigationController.navigationBar.trans
        // self.navigationItem.leftBarButtonItem
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: collectionRootView.frame.height)
        addListener()
        resetUI()
        navigation()
    }
    
    private func navigation(){
        self.back.action = #selector(ContentInfoViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated: true, completion: nil)
        
        
    }
    
    private func addListener(){
        self.add2MyReciteButton.addTarget(self, action: #selector(ContentInfoViewController.btnClickEventHandler), for: UIControlEvents.touchDown)
    }
    //重新设置UI
    private func resetUI(){
        if(ContentInfoViewController.isMyRecite ?? false){
             self.add2MyReciteButton.isHidden = true
        }else{
             self.add2MyReciteButton.isHidden = false
        }
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
        }
    }
    
    private func loadFile(_ content:Content){
        Service.download(filePath: content.audioPath!){(path) in
        self.LOG.info(path)
        }
    }
    
    
    private func setContent(_ content:Content){
        // self.content = content
        self.titleLabel.text = content.title!
        loadData()
        loadFile(content)
    }
    
    private func loadData(){
        let segmentDatas = ContentInfoViewModel(content: self.content)
        segmentDatas.load(){
            (segments) in
            if let ss = segments {
                self.segments = ss
                self.segments.insert(self.createContentWords(), at: 0)
            }else{
                self.segments = [Segment]()
            }
            
            self.collectionView.reloadData()
            
        }
    }
    
    private func createContentWords()->Segment{
        let segment = Segment()
        segment.title = "单词列表"
        segment.id = ""
        
        return segment
    }
}

extension ContentInfoViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let segment =  segments[indexPath.item]
        
      
        if(indexPath.item == 0){
            let word = WordListViewController()
            self.present(word, animated: true){
                word.loadData(content:self.content!)
                self.insertWordsToUser(self.content?.id ?? "")
            }
        }else{
            let uiView = UISegmentPlayViewController()
            self.present(uiView, animated: true){
                uiView.setSegment(item: segment,mp3Path: (self.content?.audioPath)!)
            }
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segments.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SegmentViewItem = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentViewItem.SEGMENT_VIEW_ITEM_CELL, for: indexPath) as! SegmentViewItem
        //   cell.backgroundColor = UIColor.blue
        cell.segment = segments[indexPath.item]
        return cell
    }
}

extension ContentInfoViewController{
    
    //把当前content下关联的单词，关联给用户
    private func insertWordsToUser(_ contentId:String){
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        Service.post(path: "userAndWord/insertAllByContentId?contentId=\(contentId)&userId=\(user.id ?? "")"){
            (_) in
        }
    }
}
