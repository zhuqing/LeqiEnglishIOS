//
//  MyRecommendCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol MyRecommendCollectionViewCellDelegate {
    func myRecommendCollectionViewCell(_ collectionView:UICollectionView ,clickItem:Content)
    func moreLabelTap()
}
class MyRecommendCollectionViewCell: UICollectionViewCell {
    
    static let MY_RECOMMEND_VIEW_REUSE_IDENTIFIRE = "MY_RECOMMEND_VIEW_REUSE_IDENTIFIRE"
    
    private var recommendViewModel = MyRecommendViewModel()
    
    @IBOutlet weak var moreLabel: UILabel!
    
    var delegate:MyRecommendCollectionViewCellDelegate?
    
    @IBOutlet weak var collectionRootView: UIView!
    
    private  var recommendDatas:[Content] = [Content]()
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: CONTENT_CELL_WIDTH, height: CONTENT_CELL_HEIGHT)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ContentItemCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: ContentItemCollectionViewCell.CONTENT_ITEM_CELL)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        AppRefreshManager.instance.regist(id: "MyRecommendCollectionViewCell", self)
    }
}


extension MyRecommendCollectionViewCell{
    private func setupUI(){
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: collectionRootView.frame.height)
        loadData()
        initListener()
    }
    
    private func initListener(){
        self.moreLabel.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MyRecommendCollectionViewCell.showMore))
        
        self.moreLabel.addGestureRecognizer(gesture)
    }
    
    @objc private func showMore(){
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.moreLabelTap()
    }
    
    private func loadData(){
        recommendViewModel.load(){
            (contents) in
            if contents == nil{
                self.recommendDatas = [Content]()
            }else{
                self.recommendDatas = contents!
            }
            
            self.collectionView.reloadData()
        }
    }
}

extension MyRecommendCollectionViewCell:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendDatas.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentItemCollectionViewCell.CONTENT_ITEM_CELL, for: indexPath) as! ContentItemCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        cell.setItem(item: recommendDatas[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = recommendDatas[indexPath.item]

        guard let delegate = self.delegate else{
            return
        }

        delegate.myRecommendCollectionViewCell( collectionView, clickItem: content)
        
    }
    
  
}

extension MyRecommendCollectionViewCell : RefreshDataCacheDelegate{
    func refresh() {
        
       loadData()
    }
    
  
}
