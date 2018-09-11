//
//  RecitingContentView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/11.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
let  HEADER_H = 5

class RecitingContentView: UIView {
    
    private lazy var recitingData:[RecitedContentVO] = {
        var recitingData = [RecitedContentVO]()
        for index in 0 ..< 7{
            var recited = RecitedContentVO()
            recited.title = "\(index).XXXXXXXXX"
            recited.finishedPercent = 30
             recitingData.append(recited)
        }
       
        return recitingData
    }()
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
       
        layout.itemSize = CGSize(width: 174, height: 220)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
       // layout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: 50)
        
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ContentItemPrecentCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: CONTENT_ITEM_ORECENT_CELL)
        
       // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CONTENT_ITEM_ORECENT_CELL)
        
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER)
       // uiCollectionView.delegate = self
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

extension RecitingContentView{
    private func setupUI(){
        addSubview(collectionView)
        collectionView.frame = bounds
        backgroundColor = UIColor.white
    }
}

extension RecitingContentView:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recitingData.count
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemPrecentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CONTENT_ITEM_ORECENT_CELL, for: indexPath) as! ContentItemPrecentCollectionViewCell
     //   cell.backgroundColor = UIColor.blue
       cell.setItem(item: recitingData[indexPath.item])
        return cell
    }
}
