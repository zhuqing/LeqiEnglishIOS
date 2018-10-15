//
//  ContentListViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
protocol ContentListViewControllerDelegate {
    func addMoreDatas(finished:(_ contents:[Content])->Void)
  
}
class ContentListViewController: UIViewController {

 
    

    let LOG = LOGGER("ContentListView")
    
    var delegate:ContentListViewControllerDelegate?
    
    private let footer = MJRefreshAutoNormalFooter()
    
    var datas:[Content]? = [Content](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView:UICollectionView  = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH/2-20, height: (SCREEN_WIDTH/2-20)*1.4)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isPagingEnabled = false
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib(nibName: "ContentItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ContentItemCollectionViewCell.CONTENT_ITEM_CELL)
        
        
        footer.setRefreshingTarget(self, refreshingAction: #selector(ContentListViewController.addMoreDatas))
        collectionView.mj_footer = footer
        
        return collectionView
    }()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
   
}

extension ContentListViewController{
    
    private func setUI(){
        self.view.addSubview(self.collectionView)
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
    }
    
    private func addFooter(){
        LOG.info("delegate")
        
    }
    
    @objc private func addMoreDatas(){
        guard let delegate = self.delegate else{
             collectionView.mj_footer.endRefreshing()
            return
        }
        
        delegate.addMoreDatas(){
            (contents) in
            self.datas?.append(contentsOf: contents)
            collectionView.mj_footer.endRefreshing()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelected(content: Content) {
        let vc = ContentInfoViewController()
        ContentInfoViewController.isMyRecite = false
        self.present(vc, animated: true, completion: {
            vc.content = content
        })
    }
    
}

//MARK:DataSource,Delegate
extension ContentListViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate else{
            return
        }
        
        let content = self.datas![indexPath.item]
        didSelected(content: content)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.datas?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentItemCollectionViewCell.CONTENT_ITEM_CELL, for: indexPath) as! ContentItemCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        cell.setItem(item: self.datas![indexPath.item])
        return cell
    }
}
