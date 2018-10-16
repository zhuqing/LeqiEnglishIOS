//
//  WordListController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
import MJRefresh

class HomeViewController: UIViewController {
    
    let USER_BORDER_VIEW:CGFloat = 140
    
    let MY_RECITING_HEIGHT:CGFloat = 358
    
    let MY_RECOMMED_HEIGHT:CGFloat = 300
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    var  refresher:UIRefreshControl?
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width, height: USER_BORDER_VIEW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
        initHeader(collectionView)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib(nibName: "UserBoardView", bundle: nil), forCellWithReuseIdentifier: UserBoardView.USER_BOARDER_VIEW_REUSE_IDENTIFIRE)
        
        collectionView.register(UINib(nibName: "MyRecitedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyRecitedCollectionViewCell.MYRECITEING_COLLECTION_REUSE_IDENTIFIRE)
        
        collectionView.register(UINib(nibName: "MyRecommendCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MyRecommendCollectionViewCell.MY_RECOMMEND_VIEW_REUSE_IDENTIFIRE)
        
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 50, width: SCREEN_WIDTH, height: self.view.bounds.height-50)
        //addrefresh()
        
        //collectionView.addGestureRecognizer()
    }
    
    
}


extension HomeViewController{
    
    // @objc private func
    
    private func initHeader(_ collectionView:UICollectionView){
        header.setRefreshingTarget(self, refreshingAction: #selector(HomeViewController.refresh))
        header.backgroundColor = UIColor.white
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.isAutomaticallyChangeAlpha = true;
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("释放刷新", for: .pulling)
        header.setTitle("正在刷新", for: .refreshing)
        
        //修改字体
        header.stateLabel.font = UIFont.systemFont(ofSize: 15)
        header.lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 13)
        
        //修改文字颜色
        header.stateLabel.textColor = UIColor.red
      //  header.lastUpdatedTimeLabel.textColor = UIColor.blue
        
        collectionView.mj_header  = header
        
    }
    
    @objc private func drag(){
        
    }
    
    @objc private func refresh(){
        
        print("refresh")
        AppRefreshManager.instance.refresh()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            // self.refresher!.endRefreshing()
            self.collectionView.mj_header.endRefreshing()
        }
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
            ContentInfoViewController.isMyRecite = false
            vc.content = clickItem
            
        }
    }
    
    func moreLabelTap(){
        let vc = ContentSearchViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
//实现MyRecitedCollectionViewCellDelegate
extension HomeViewController:MyRecitedCollectionViewCellDelegate{
    
    func addMoreReciteContents() {
        let vc = ContentSearchViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func myRecitedCollectionViewCell( clickItem: ReciteContentVO) {
        let vc = ContentInfoViewController()
        ContentInfoViewController.isMyRecite = true
        self.present(vc, animated: true){
            
            vc.content = clickItem as Content
            
        }
    }
    
    func showMoreMyContents() {
        let vc = MyContentsViewController()
        self.present(vc, animated: true, completion: nil)
    }
}


//MARK 实现UserBoardViewDelegate
extension HomeViewController : UserBoardViewDelegate{
    func reciteWordButtonClick() {
        let vc = MyReciteWordInfoViewController()
        self.present(vc, animated: true){
            
        }
        
    }
}

