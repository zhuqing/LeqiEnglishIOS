//
//  ContentListViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit
protocol ContentListViewControllerDelegate {
    func addMoreDatas(contentListViewController:ContentListViewController,finished:(_ contents:[Content])->Void)
  
    func selected(contentListViewController:ContentListViewController,_ content:Content)
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
        
        
       
        addFooter(collectionView)
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
    
    private func addFooter(_ collectionView:UICollectionView){
        footer.setRefreshingTarget(self, refreshingAction: #selector(ContentListViewController.addMoreDatas))
        footer.setTitle("", for: .idle)
        footer.setTitle("", for: .pulling)
        footer.setTitle("没有更多的数据了", for: .noMoreData)
        footer.setTitle("数据加载中", for: .refreshing)
        footer.setTitle("释放加载更多", for: .willRefresh)
        collectionView.mj_footer = footer
    }
    
    @objc private func addMoreDatas(){
        guard let delegate = self.delegate else{
             footer.setTitle("没有更多的数据了", for: .noMoreData)
            
             collectionView.mj_footer.endRefreshing()
            return
        }
        
        delegate.addMoreDatas(contentListViewController: self){
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
        if let d = self.delegate {
            d.selected(contentListViewController:self,content)
            return
        }
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
