//
//  WordListController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let USER_BORDER_VIEW:CGFloat = 140
    
    let MY_RECITING_HEIGHT:CGFloat = 358
    
    let MY_RECOMMED_HEIGHT:CGFloat = 300
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width, height: USER_BORDER_VIEW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
     
        collectionView.register(UINib(nibName: "UserBoardView", bundle: nil), forCellWithReuseIdentifier: UserBoardView.USER_BOARDER_VIEW_REUSE_IDENTIFIRE)
        
        collectionView.register(UINib(nibName: "MyRecitedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyRecitedCollectionViewCell.MYRECITEING_COLLECTION_REUSE_IDENTIFIRE)
        
        collectionView.register(UINib(nibName: "MyRecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyRecommendCollectionViewCell.MY_RECOMMEND_VIEW_REUSE_IDENTIFIRE)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }


}

extension HomeViewController:UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
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
           let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: UserBoardView.USER_BOARDER_VIEW_REUSE_IDENTIFIRE, for: indexPath) as? UserBoardView
            cell?.delegate = self
           return cell!
        case 1:
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecitedCollectionViewCell.MYRECITEING_COLLECTION_REUSE_IDENTIFIRE, for: indexPath) as?
             MyRecitedCollectionViewCell
             
             cell?.delegate = self
            
             return cell!
            
            
        case 2:
            let cell:MyRecommendCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecommendCollectionViewCell.MY_RECOMMEND_VIEW_REUSE_IDENTIFIRE, for: indexPath) as? MyRecommendCollectionViewCell
            
            cell?.delegate = self
            
            return cell!
        default:
          return collectionView.dequeueReusableCell(withReuseIdentifier: UserBoardView.USER_BOARDER_VIEW_REUSE_IDENTIFIRE, for: indexPath)
        }
      
        
      
    }
}

//MARK 实现MyRecommendCollectionViewCellDelegate
extension HomeViewController:MyRecommendCollectionViewCellDelegate{
    func myRecommendCollectionViewCell(_ collectionView: UICollectionView, clickItem: Content) {
        ////self.prepare(for: UIStoryboardSegue, sender: <#T##Any?#>)
        print(clickItem.toDictionary())
    
        
        let vc = ContentInfoViewController()
      
        self.present(vc, animated: true){
              vc.content = clickItem
            ContentInfoViewController.isMyRecite = true
        }
    }
    
   
}
//实现MyRecitedCollectionViewCellDelegate
extension HomeViewController:MyRecitedCollectionViewCellDelegate{
   
    
    func myRecitedCollectionViewCell( clickItem: ReciteContentVO) {
        let vc = ContentInfoViewController()
        
        self.present(vc, animated: true){
            vc.content = clickItem as Content
            ContentInfoViewController.isMyRecite = false
        }
    }
}


//MARK 实现UserBoardViewDelegate
extension HomeViewController : UserBoardViewDelegate{
    func reciteWordButtonClick() {
        let vc = ReciteWordViewController()
        self.present(vc, animated: true){
           
        }
        
    }
}

