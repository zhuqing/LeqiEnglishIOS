//
//  ShareView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/19.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

protocol ShareViewDelegate {
    func click(view:ShareView,data:(String,String,UIImage))
}

class ShareView: UIView {
    
    var delegate:ShareViewDelegate?
    
    private lazy var datas:[(String,String,UIImage)] = {
        var datas = [(String,String,UIImage)]();
        datas.append(("1","朋友圈",UIImage(named: "wechatShare")!))
        datas.append(("2","QQ",UIImage(named: "qqSpace")!))
        return datas
    }()

    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: (self?.bounds)!, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUI()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
         collectionView.frame = self.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUI(){
        self.addSubview(self.collectionView)
        collectionView.frame = self.frame
    }

}

extension ShareView:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.datas[indexPath.item]
        if let delegate = self.delegate {
            delegate.click(view: self, data: data)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCollecionCell  = self.collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        let data = datas[indexPath.item]
        let uiImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        uiImageView.image = data.2
        userCollecionCell.contentView.addSubview(uiImageView)
        return userCollecionCell
    }
}
