//
//  PersonalViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit

class PersonalViewController:MainViewController{
    @IBOutlet weak var user_imageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var collectionRootView: UIView!
    
    @IBOutlet weak var chengUserButton: UIButton!
    
    private var catalogs = [Catalog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-10, height: 30)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        //collectionView.
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib(nibName: "NavigationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NavigationCollectionViewCell.NAVIGAAION_CELL_INDENTIFY)
        
       collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
}

extension PersonalViewController{
    
    private func changeUserLister(){
        self.chengUserButton.addTarget(self, action: #selector(PersonalViewController.changeUserHandler), for: .touchDown)
    }
    
    @objc private func changeUserHandler(){
        let vc = LoginViewController()
        
        self.present(vc, animated: true, completion: nil)
    }
    private func setUI(){
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 5, width: SCREEN_WIDTH-10, height: collectionRootView.frame.height)
        addCatalogs()
        changeUserLister()
    }
    
    private func addCatalogs(){
        let catalog = Catalog()
        catalog.title = "意见反馈"
        catalog.id = "01"
        
        catalogs.append(catalog)
        
        collectionView.reloadData()
        
    }
    
    private func turn2(_ catalog:Catalog){
        switch catalog.id {
        case "01":
            let vc = FeedbackViewController()
            self.present(vc, animated: true, completion: nil)
        default:
            print(catalog)
        }
    }
}

extension PersonalViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        turn2(catalogs[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:NavigationCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationCollectionViewCell.NAVIGAAION_CELL_INDENTIFY, for: indexPath) as? NavigationCollectionViewCell
        let catalog = self.catalogs[indexPath.row]
        cell?.setText(catalog.title!)
        
        return cell!
    }
}


