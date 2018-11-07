//
//  SimpleWordInfoViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/2.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class SimpleWordInfoViewController: UIViewController {
    var LOG = LOGGER("SimpleWordInfoViewController")
    var word:Word?{
        didSet{
             collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: self.view.frame.height)
            collectionView.reloadData()
        }
    }
    
    //加载单词
     func loadWord(word:String){
        WordDataCache(word: word).load(finished: {
            (word) in
            self.LOG.info((word?.toJSONString())!)
            self.word = word
        })
    }
    
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
        
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "WordInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY)
        
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(collectionView)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK 实现 UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension SimpleWordInfoViewController: UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let w = self.word else{
            return  CGSize(width: SCREEN_WIDTH, height: 70)
        }
        
        let means = WordUtil.getMeans(item: w)
        var height:CGFloat =   StringUtil.computerHeight(text:means, font: UIFont.systemFont(ofSize: CGFloat(17)), fixedWidth: SCREEN_WIDTH-20)
        
        
        
        switch indexPath.item {
        case 0:
            height += 90
            
            return  CGSize(width: SCREEN_WIDTH, height: height)
            
        default:
            return CGSize(width: self.view.bounds.width, height: height)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY, for: indexPath) as? WordInfoCollectionViewCell
        cell?.word = self.word
        return cell!
        
        
        
    }
}
