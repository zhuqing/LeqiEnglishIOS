//
//  WordListViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordListViewController: UIViewController {
    @IBOutlet weak var rootView: UIView!
    
    var wordList:[Word]? = [Word](){
        didSet{
            collectionView.reloadData()
        }
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
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.lightGray
        
        collectionView.register(UINib(nibName: "WordInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY)
        
        
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: SCREEN_HEIGHT)
        // Do any additional setup after loading the view.
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

extension WordListViewController{
    func loadData(content:Content){
       let dataCache = WordContentDataCache(content: content)
        dataCache.getFromService(){(words) in
            self.wordList = words
            
        }
    }
}

//MARK 实现 UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension WordListViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let wordList = self.wordList{
             return wordList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY, for: indexPath) as? WordInfoCollectionViewCell
      cell?.word = wordList![indexPath.item]
       return cell!
    }
}
