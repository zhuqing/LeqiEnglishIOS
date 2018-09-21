//
//  WordListCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rootView: UIView!
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
       // layout.itemSize = CGSize(width: self.view.bounds.width, height: USER_BORDER_VIEW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "WordInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY)
        
       
        
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension WordListCollectionViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 1:
            return  CGSize(width: self.view.bounds.width, height: MY_RECITING_HEIGHT)
        case 2:
            return  CGSize(width: self.view.bounds.width, height: MY_RECOMMED_HEIGHT)
        default:
            return CGSize(width: self.view.bounds.width, height: USER_BORDER_VIEW)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: UserBoardView.USER_BOARDER_VIEW_REUSE_IDENTIFIRE, for: indexPath)
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: MyRecitedCollectionViewCell.MYRECITEING_COLLECTION_REUSE_IDENTIFIRE, for: indexPath)
            
        case 2:
            let cell:MyRecommendCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecommendCollectionViewCell.MY_RECOMMEND_VIEW_REUSE_IDENTIFIRE, for: indexPath) as? MyRecommendCollectionViewCell
            
          //  cell?.delegate = self
            
            return cell!
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: UserBoardView.USER_BOARDER_VIEW_REUSE_IDENTIFIRE, for: indexPath)
        }
        
        
        
    }
}
