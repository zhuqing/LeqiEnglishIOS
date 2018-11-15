//
//  PersonalViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit

class PersonalViewController:UIViewController{
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
        layout.minimumLineSpacing = 10
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
    
    // @objc private func
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addCatalogs()
        changeUserLister()
        loadUser()
    }
    
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
       
    }
    
    private func loadUser(){
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        
        if(user.status  == 0 ){
            chengUserButton.setTitle("登录", for: .normal)
        }
        userNameLabel.text = user.name ?? ""
       loadUserImage()
        
        
    }
    
    //加载用户的图像
    private func loadUserImage(){
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        
        guard let imagePath = user.imagePath else{
            return
        }
        
        Service.download(filePath: imagePath){
            (path) in
            self.user_imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    private func addCatalogs(){
        catalogs.removeAll()
        catalogs.append(createCatalog(id:"01",title:"意见反馈"))
        
        catalogs.append(createCatalog(id:"03",title:"演讲背诵"))
        catalogs.append(createCatalog(id:"04",title:"单词背诵"))
        if let version = VersionDataCache.instance.getFromCache() {
             catalogs.append(createCatalog(id:"02",title:"当前版本\t\(version.versionCode ?? "1.0.1")"))
        }else{
             catalogs.append(createCatalog(id:"02",title:"当前版本\t 1.0.1"))
        }
       
       
        
        collectionView.reloadData()
        
    }
    
    private func createCatalog(id:String,title:String) -> Catalog{
        let catalog = Catalog()
        catalog.title = title
        catalog.id = id
        
        return catalog
    }
    
    private func turn2(_ catalog:Catalog){
        switch catalog.id {
        case "01":
            let vc = FeedbackViewController()
            self.present(vc, animated: true, completion: nil)
        case "02":
            checkVersion()
        case "03":
            let vc = MyContentsViewController()
            self.present(vc, animated: true, completion: nil)
        case "04":
            let vc = MyWordListViewController()
            self.present(vc, animated: true, completion: nil)
       
        default:
            print(catalog)
        }
    }
    
    private func checkVersion(){
        VersionDataCache.instance.checkUpdate(callback: {
            (version) in
            
                guard let v = version else{
                    self.showAlert(message: "已经是最新版本了")
                    return
                }
            self.update2NewVersion(v)
        })
    }
    
    private func update2NewVersion(_ version:Version){
        let alertView = UIAlertController(title: "有最新版本了", message: nil, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "更新", style: .default, handler: {
            (a) in
              VersionDataCache.instance.cacheData(data: version)
        }))
        
        alertView.addAction(UIAlertAction(title: "不更新", style: .cancel, handler: nil))
        
        self.present(alertView, animated: true, completion: nil)
      
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
        let catalog = self.catalogs[indexPath.item]
        cell?.setText(catalog.title!)
        
        return cell!
    }
}


