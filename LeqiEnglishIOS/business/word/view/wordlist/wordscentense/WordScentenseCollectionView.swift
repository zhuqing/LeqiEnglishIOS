//
//  WordScentenseCollectionView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol WordScentenseCollectionViewDelegate {
    func toContentInfo(_ content:Content)
}

class WordScentenseCollectionView: UICollectionViewCell {
    
    static let WORD_SCENTENSE_COLLECTION_VIEW = "WORD_SCENTENSE_COLLECTION_VIEW"
    
    var word:Word?{
        didSet{
            if let w = self.word {
                loadData(word: w)
            }else{
                clear()
            }
        }
    }
    
    var delegate:WordScentenseCollectionViewDelegate?
    
    
    @IBOutlet weak var rootView: UIView!
    
    var wordAndSegemnts = [WordAndSegment]()
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-20, height: 160)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "WordScentenseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordScentenseCollectionViewCell.WORD_SCENTENSE_COLLECTION_VIEWCELL)
        
        
        
        return collectionView
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 5, y: 0, width: SCREEN_WIDTH-10, height: SCREEN_HEIGHT)
    }
    
}

extension WordScentenseCollectionView{
    private  func loadData(word:Word){
        let wordS = WordScentenseDataCache(word: word)
        wordS.getFromService(){
            (datas) in
            self.wordAndSegemnts = datas!
            self.collectionView.reloadData()
        }
    }
    
   
    private func clear(){
        
    }
}


// MARK 实现 UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension WordScentenseCollectionView: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wordAndSegment = self.wordAndSegemnts[indexPath.item]
        
        var height:CGFloat = 40
        
        guard let s = wordAndSegment.scentence else{
            return  CGSize(width: SCREEN_WIDTH, height: height)
        }
        
        let ch_am = StringUtil.toChAndEN(str: s)
        
        height +=   StringUtil.computerHeight(text:ch_am.0, font: UIFont.systemFont(ofSize: CGFloat(17)), fixedWidth: SCREEN_WIDTH-20)
        
        
        height +=   StringUtil.computerHeight(text:ch_am.1, font: UIFont.systemFont(ofSize: CGFloat(13)), fixedWidth: SCREEN_WIDTH-20)
        
        
        return  CGSize(width: SCREEN_WIDTH-20, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return wordAndSegemnts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordScentenseCollectionViewCell.WORD_SCENTENSE_COLLECTION_VIEWCELL, for: indexPath) as? WordScentenseCollectionViewCell
        cell?.wordAndSegment = wordAndSegemnts[indexPath.item]
        cell?.delegate = self
        return cell!
    }
}


//点击单词相关句子的Content 标题
extension WordScentenseCollectionView : WordScentenseCollectionViewCellDelegate{
    
    func clickContentTitle(_ contentId: String) {
        
        guard let delegate = self.delegate else{
            return
        }
       
        let singleContent = SingleContent(contentId: contentId)
        
        singleContent.load(){
            (content) in
            guard let c = content else{
                return
            }
            delegate.toContentInfo(c)
        }
    }
}
