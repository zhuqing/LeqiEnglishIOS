//
//  WordListSimpleViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/12.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordListSimpleViewController: UIViewController {
    
    private let LOG = LOGGER("WordListSimpleViewController")
    
    @IBOutlet weak var rootView: UIView!
    
    var wordDic = [Int:[Word]]()
    
    var wordList:[Word]? = [Word](){
        didSet{
            self.resetWords()
            collectionView.reloadData()
        }
    }
    
    
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-40, height: 160)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: SCREEN_WIDTH-10, height: 40)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        collectionView.register(UINib(nibName: "WordInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY)
        
        collectionView.register(UINib(nibName: "WordHeaderCollectionViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: WordHeaderCollectionViewCell.WORD_HEADER_INDENTIFY)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: rootView.bounds.height)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension WordListSimpleViewController{
    func loadData(content:Content){
        
        let dataCache = WordContentDataCache(content: content)
        dataCache.getFromService(){(words) in
            self.wordList = words
            
        }
    }
    
   
    
    
}

//MARK 实现 UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension WordListSimpleViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wordInfoView = WordInfoViewController()
        
        self.present(wordInfoView, animated: true){
            wordInfoView.word = self.wordDic[indexPath.section]?[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header:WordHeaderCollectionViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WordHeaderCollectionViewCell.WORD_HEADER_INDENTIFY, for: indexPath) as! WordHeaderCollectionViewCell
        
        let word = self.wordDic[indexPath.section]![indexPath.item]
        
        header.setHeader((word.word?.first?.description.uppercased())!)
        header.backgroundColor = UIColor.lightGray
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.wordDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LOG.error("section = \(section) ")
        return  (self.wordDic[section]?.count)!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY, for: indexPath) as? WordInfoCollectionViewCell
        
        LOG.error("\(indexPath.section) , \(indexPath.item)")
        
        cell?.word = self.wordDic[indexPath.section]?[indexPath.item]
        
        if(self.wordDic[indexPath.section]?.count == indexPath.item+1){
            cell?.hiddenBottomView()
        }else{
            cell?.showBottomView()
        }
        
        return cell!
    }
    
    
}

extension WordListSimpleViewController{
    private  func toDic(words:[Word]) ->[Int:[Word]]{
        var wordDic = [Int:[Word]]()
        
        let wordList = words.sorted(by: {
            (w1,w2) in
            
            return (w1.word?.compare(w2.word!))! != ComparisonResult.orderedDescending
        })
        
        var section  = 0
        var lastChar = wordList[0].word?.lowercased().first!
        
        for word in wordList {
            guard let firstLetter = word.word?.lowercased().first else {
                continue
            }
            
            if (firstLetter != lastChar){
                section += 1
                lastChar = firstLetter
            }
            
            if(wordDic[section] == nil){
                wordDic[section]  = [Word]()
            }
            
            wordDic[section]!.append(word)
        }
        
        return wordDic
        
    }
    
    private func resetWords(){
        self.wordDic.removeAll()
        if(self.wordList?.count == 0){
            
            return
        }
        
        self.wordDic = toDic(words: self.wordList!)
        
        
    }
    
    
}

