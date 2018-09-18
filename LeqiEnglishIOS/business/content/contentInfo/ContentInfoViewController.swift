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
    
    let LOG = LOGGER("ContentInfoViewController")
    
    
    var content:Content?{
        didSet{
            guard let c = content else {return}
            
            setContent(c)
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
    }
    
    private func addListener(){
        self.add2MyReciteButton.addTarget(self, action: "btnClickEventHandler", for: UIControlEvents.touchDown)
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
        
        let userData = UserDataCache()
        
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
    
    
    func setContent(_ content:Content){
        // self.content = content
        self.titleLabel.text = content.title!
        loadData()
    }
    
    private func loadData(){
        let segmentDatas = ContentInfoViewModel(content: self.content)
        segmentDatas.load(){
            (segments) in
            if let ss = segments {
                self.segments = ss
            }else{
                self.segments = [Segment]()
            }
            
            self.collectionView.reloadData()
            
        }
    }
}

extension ContentInfoViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let segment =  segments[indexPath.item]
        
        let uiView = UISegmentPlayViewController()
        
        self.present(uiView, animated: true){
            uiView.setSegment(item: segment)
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
