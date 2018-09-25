//
//  WordInfoViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/21.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WordInfoViewController: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var rootView: UIView!
    
     var word:Word?{
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
         collectionView.register(UINib(nibName: "WordScentenseCollectionView", bundle: nil), forCellWithReuseIdentifier: WordScentenseCollectionView.WORD_SCENTENSE_COLLECTION_VIEW)
        
        
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        rootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
navigation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func navigation(){
        self.back.action = #selector(WordInfoViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK 实现 UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension WordInfoViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
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
        case 1:
            return  CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT - height - 100)
        default:
            return CGSize(width: self.view.bounds.width, height: height)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.item == 0){
         let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY, for: indexPath) as? WordInfoCollectionViewCell
            cell?.word = self.word
         return cell!
        }
        if(indexPath.item == 1){
            let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordScentenseCollectionView.WORD_SCENTENSE_COLLECTION_VIEW, for: indexPath) as? WordScentenseCollectionView
            cell?.word = self.word
            cell?.delegate = self
            return cell!
        }
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: WordInfoCollectionViewCell.WORD_INFO_CELL_INDENTIFY, for: indexPath) as? WordInfoCollectionViewCell
        return cell!
   
    }
}

extension WordInfoViewController : WordScentenseCollectionViewDelegate{
    func toContentInfo(_ content: Content) {
       let viewController = ContentInfoViewController()
        self.present(viewController, animated: true){
            viewController.content = content
        }
    }
}
