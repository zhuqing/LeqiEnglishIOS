//
//  ShortWordCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class ShortWordCollectionViewCell: UICollectionViewCell {
    
    static let INDENTIFIER = "ShortWordCollectionViewCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var rootView: UIView!
    
    
    var shortWord:ShortWord?{
        didSet{
            shortWordChange()
        }
    }
    
    private var sentences = [Sentence]()
    
    
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
       
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        collectionView.register(UINib(nibName: "SentenceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SentenceCollectionViewCell.INDENTIFER)
        
       
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
        // Initialization code
    }
    
    private func setUI(){
      self.rootView.addSubview(self.collectionView)
      
    }
    
    private func shortWordChange(){
        guard let shortWord = self.shortWord else{
            wordLabel.text = ""
            infoLabel.text = ""
            self.sentences.removeAll()
            self.collectionView.reloadData()
            return
        }
        
        if let word = shortWord.word{
            wordLabel.text = word
        }else{
            wordLabel.text = ""
        }
        
        if let info = shortWord.info{
            infoLabel.text = info
        }else{
            infoLabel.text = ""
        }
        loadSentences()
    }
    
    private func loadSentences(){
        if self.shortWord == nil{
            return
        }
        
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.rootView.frame.width, height: rootView.frame.height)
        
        let sentenceData = SentenceInShortWordDataCache(shortWord: self.shortWord!)
        
        sentenceData.load(){(sentences) in
            if(sentences == nil){
                self.sentences = [Sentence]()
            }else{
                self.sentences = sentences!
            }
            
            self.collectionView.reloadData()
        }
        
    }

}

extension ShortWordCollectionViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let sentence = self.sentences[indexPath.item]
        
        let englishHeight =  StringUtil.computerHeight(text: sentence.english ?? "", font: UIFont.systemFont(ofSize: 17), fixedWidth: SCREEN_WIDTH - 20)
        
        let chineseHeight =  StringUtil.computerHeight(text: sentence.chinese ?? "", font: UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light), fixedWidth: SCREEN_WIDTH - 20)
        
       return CGSize(width: SCREEN_WIDTH - 20, height: englishHeight + chineseHeight+5)
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return  self.sentences.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: SentenceCollectionViewCell.INDENTIFER, for: indexPath) as? SentenceCollectionViewCell

        
        cell?.updateItem(sentence: self.sentences[indexPath.item], index: indexPath.item+1) 

        return cell!
    }
    
    
}


