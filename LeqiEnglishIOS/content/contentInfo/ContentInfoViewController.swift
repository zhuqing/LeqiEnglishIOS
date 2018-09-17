//
//  ContentInfoViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/16.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ContentInfoViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var add2MyReciteButton: UIButton!
    @IBOutlet weak var collectionRootView: UIView!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
   
    var content:Content?{
        didSet{
            guard let c = content else {return}
            
            setContent(c)
        }
    }
    
    var segments:[Segment] = [Segment]()
    
    private lazy var collectionView:UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: SEGMENT_CELL_WIDTH, height: SEGMENT_CELL_HEIGHT)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ContentItemPrecentCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: CONTENT_ITEM_ORECENT_CELL)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the vie.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

extension ContentInfoViewController{
    private func setupUI(){
           // self.navigationController.navigationBar.trans
        self.navigationItem.leftBarButtonItem
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: collectionRootView.frame.height)
    }
    
    
    func setContent(_ content:Content){
        // self.content = content
        self.titleLabel.text = content.title!
        loadData()
    }
    
    private func loadData(){
        let segmentDatas = ContentInfoViewModel(content: self.content)
        segmentDatas.load(){
            (segments) in
            if let ss = segments {
                self.segments = ss
            }else{
                 self.segments = [Segment]()
            }
            
            self.collectionView.reloadData()
           
        }
    }
}

extension ContentInfoViewController : UICollectionViewDataSource{
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segments.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ContentItemPrecentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CONTENT_ITEM_ORECENT_CELL, for: indexPath) as! ContentItemPrecentCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        // cell.setItem(item: reciteContentDatas[indexPath.item])
        return cell
    }
}
