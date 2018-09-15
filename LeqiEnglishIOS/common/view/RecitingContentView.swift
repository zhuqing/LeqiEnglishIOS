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
   
    
    private  var reciteContentDatas:[ReciteContentVO] = [ReciteContentVO]();
    
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
        
        collectionView.register(UINib(nibName: "ContentItemPrecentCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: CONTENT_ITEM_ORECENT_CELL)

        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        loadData()
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

extension RecitingContentView{
    private func loadData(){
         print("start load")
        Service.get(path: "/english/content/findAll"){
            (result) in
          
          let sqliteManager = SQLiteManager.init()
          let datas:[[String:NSObject]] = Service.getDatas(data:result)!
            
            for  data in datas {

               let content = ReciteContentVO(data: data)
               self.reciteContentDatas.append(content)
                guard let json = String.toString(content.toDictionary()) else {continue}
               sqliteManager.insertData(id: content.id!, json: json, type: SQLiteManager.CONTENT_TYPE)
               
            }
            
           
            self.collectionView.reloadData()
        }
    }
}

extension RecitingContentView:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reciteContentDatas.count
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemPrecentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CONTENT_ITEM_ORECENT_CELL, for: indexPath) as! ContentItemPrecentCollectionViewCell
     //   cell.backgroundColor = UIColor.blue
       cell.setItem(item: reciteContentDatas[indexPath.item])
        return cell
    }
}
