//
//  RecomenContentView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class RecomenContentView: UIView {

    private lazy var headview :ContentHeaderView={
        let rect = CGRect(x: 0, y: SPACING, width: SCREEN_WIDTH, height: CONTENT_HEADER_HEIGHT)
        let headView = ContentHeaderView(frame: rect, name: "推荐")
        // headView.backgroundColor = UIColor.blue
        return headView
    }()
    
    private lazy var recitingData:[Content] = {
        var recitingData = [Content]()
        for index in 0 ..< 7{
            var recited = ReciteContentVO()
            recited.title = "乔布斯英语演讲：斯坦福大学2005年毕业典礼上的演讲"
           
            recitingData.append(recited)
        }
        
        return recitingData
    }()
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: CONTENT_CELL_WIDTH, height: CONTENT_CELL_HEIGHT)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ContentItemCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: CONTENT_ITEM_CELL)

        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RecomenContentView{
    private func setupUI(){
        addSubview(headview)
        addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: CONTENT_HEADER_HEIGHT+SPACING, width: SCREEN_WIDTH, height: CONTENT_CELL_HEIGHT+SPACING)
        
        backgroundColor = UIColor.white
    }
}

extension RecomenContentView:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recitingData.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CONTENT_ITEM_CELL, for: indexPath) as! ContentItemCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        cell.setItem(item: recitingData[indexPath.item])
        return cell
    }
}
