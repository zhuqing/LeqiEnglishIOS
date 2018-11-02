//
//  MyRecitedCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol MyRecitedCollectionViewCellDelegate {
    func myRecitedCollectionViewCell(clickItem:ReciteContentVO)
    func addMoreReciteContents()
    
    func showMoreMyContents()
}

class MyRecitedCollectionViewCell: UICollectionViewCell {
    static let  MYRECITEING_COLLECTION_REUSE_IDENTIFIRE = "MYRECITEING_COLLECTION_REUSE_IDENTIFIRE"
    
    @IBOutlet weak var myRecitNumberLabel: UILabel!
    @IBOutlet weak var add2MyReciteButton: UIButton!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var myRecitingNumber: NSLayoutConstraint!
    @IBOutlet weak var collectionRootView: UIView!
    
    var delegate:MyRecitedCollectionViewCellDelegate?
    
    var reciteContentDatas:[ReciteContentVO]? = [ReciteContentVO]();
   
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: CONTENT_CELL_WIDTH, height: CONTENT_CELL_HEIGHT)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "ContentItemPrecentCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: CONTENT_ITEM_ORECENT_CELL)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        regist()
       
    }
}

extension MyRecitedCollectionViewCell : RefreshDataCacheDelegate{
    private func regist(){
        AppRefreshManager.instance.regist(id: "MyRecitedCollectionViewCell", self)
       
    }
    
    func refresh() {
        MyRecitingContentDataCache.instance.claerData()
        loadData()
    }
    
    
  
}

extension MyRecitedCollectionViewCell{
    private func setupUI(){
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: collectionRootView.frame.height)
        loadData()
       // backgroundColor = UIColor.white
        initListener()
    }
    
    private func initListener(){
        self.add2MyReciteButton.addTarget(self, action: #selector(MyRecitedCollectionViewCell.add2MyReciteHandler), for: .touchDown)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MyRecitedCollectionViewCell.showMore))
        moreLabel.isUserInteractionEnabled = true
        moreLabel.addGestureRecognizer(gesture)
        
    }
    
    @objc private func showMore(){
        guard let delegate = self.delegate  else{
            return
        }
        
        delegate.showMoreMyContents()
    }
    
    @objc private func add2MyReciteHandler(){
        guard let delegate = self.delegate  else{
            return
        }
        
        delegate.addMoreReciteContents()
    }
}

extension MyRecitedCollectionViewCell{
    private func loadData(){
      MyRecitingContentDataCache.instance.load(){
            (datas) in
            self.reciteContentDatas = datas
            self.collectionView.reloadData()
            self.myRecitNumberLabel.text = "我的背诵(\(self.reciteContentDatas!.count))"
        }
        
    }
}

extension MyRecitedCollectionViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (reciteContentDatas?.count)!
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemPrecentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CONTENT_ITEM_ORECENT_CELL, for: indexPath) as! ContentItemPrecentCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        cell.setItem(item: reciteContentDatas![indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = reciteContentDatas![indexPath.item]
        
        guard let de = self.delegate else{
            return
        }
        
        de.myRecitedCollectionViewCell(clickItem: selected)
    }
}
