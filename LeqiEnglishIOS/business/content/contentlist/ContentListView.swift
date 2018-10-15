//
//  CotentListView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import MJRefresh

protocol ContentListViewDelegate {
    func addMoreDatas(finished:(_ contents:[Content])->Void)
    func didSelected(content:Content)
}

class ContentListView: UIView {
    
    let LOG = LOGGER("ContentListView")
    
    var delegate:ContentListViewDelegate?
    
    private let footer = MJRefreshAutoNormalFooter()
    
     var datas:[Content]? = [Content](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView:UICollectionView  = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH/2-20, height: (SCREEN_WIDTH/2-20)*1.4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
      
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib(nibName: "ContentItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ContentItemCollectionViewCell.CONTENT_ITEM_CELL)
        
       
        footer.setRefreshingTarget(self, refreshingAction: #selector(ContentListView.addMoreDatas))
        collectionView.mj_footer = footer
        
        return collectionView
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
       super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentListView{
    
    private func setUI(){
        self.addSubview(self.collectionView)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
    }
    
    private func addFooter(){
        LOG.info("delegate")
        
    }
    
    @objc private func addMoreDatas(){
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.addMoreDatas(){
            (contents) in
            self.datas?.append(contentsOf: contents)
            collectionView.mj_footer.endRefreshing()
        }
       
    }
}

//MARK:DataSource,Delegate
extension ContentListView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        guard let delegate = self.delegate else{
            return
        }
        
        let content = self.datas![indexPath.item]
        delegate.didSelected(content: content)
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.datas?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentItemCollectionViewCell.CONTENT_ITEM_CELL, for: indexPath) as! ContentItemCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        cell.setItem(item: self.datas![indexPath.item])
        return cell
    }
}
