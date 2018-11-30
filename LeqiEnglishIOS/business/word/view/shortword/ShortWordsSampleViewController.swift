//
//  ShortWordsSampleViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class ShortWordsSampleViewController: UIViewController {
    
    var shortWords:[ShortWord]?{
        didSet{
            shortWordChange()
        }
    }
    
    
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-40, height: 300)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
      
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        collectionView.register(UINib(nibName: "ShortWordCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ShortWordCollectionViewCell.INDENTIFIER)
        
        
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.frame = self.view.bounds

        // Do any additional setup after loading the view.
    }
    
    private func shortWordChange(){
        self.collectionView.reloadData()
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ShortWordsSampleViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.shortWords == nil){
            return 0
        }
        return  self.shortWords!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =    collectionView.dequeueReusableCell(withReuseIdentifier: ShortWordCollectionViewCell.INDENTIFIER, for: indexPath) as? ShortWordCollectionViewCell
        
        
        cell?.shortWord = self.shortWords?[indexPath.item]
        
        return cell!
    }
    
    
}
