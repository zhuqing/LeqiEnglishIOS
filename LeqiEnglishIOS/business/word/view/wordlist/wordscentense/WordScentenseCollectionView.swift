//
//  WordScentenseCollectionView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordScentenseCollectionView: UICollectionViewCell {
    
    static let WORD_SCENTENSE_COLLECTION_VIEW = "WORD_SCENTENSE_COLLECTION_VIEW"

    @IBOutlet weak var rootView: UIView!
    
    var wordAndSegemnts = [WordAndSegment]()
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: 160)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightGray
        
        collectionView.register(UINib(nibName: "WordScentenseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordScentenseCollectionViewCell.WORD_SCENTENSE_COLLECTION_VIEWCELL)
        
        
        
        return collectionView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension WordScentenseCollectionView{
    func loadData(word:Word){
        let wordS = WordScentenseDataCache(word: word)
        wordS.getFromService(){
            (datas) in
            self.wordAndSegemnts = datas!
        }
    }
}


// MARK 实现 UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension WordScentenseCollectionView: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return wordAndSegemnts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordScentenseCollectionViewCell.WORD_SCENTENSE_COLLECTION_VIEWCELL, for: indexPath) as? WordScentenseCollectionViewCell
        cell?.setItem(item: wordAndSegemnts[indexPath.item])
        return cell!
    }
}
