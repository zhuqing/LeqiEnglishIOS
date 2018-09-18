//
//  UISegmentPlayViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/18.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UISegmentPlayViewController: UIViewController {
    static let  LOG = LOGGER("UISegmentPlayViewController")
    @IBOutlet weak var startRecite: UIButton!
    @IBOutlet weak var collectionRootView: UIView!
    
    var segmentPlayItems = [SegmentPlayItem]()
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        //layout.itemSize = CGSize(width: SCREEN_WIDTH, height: 200)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PlaySementItemCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: PlaySementItemCollectionViewCell.PALY_SEGMENT_ITEM_CELL)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 5, y: 0, width: SCREEN_WIDTH, height: collectionRootView.frame.height)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSegment(item:Segment){
        UISegmentPlayViewController.LOG.error(item.content!)
        segmentPlayItems = SegmentPlayItem.toItems(str: item.content!)!
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UISegmentPlayViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = segmentPlayItems[indexPath.row]
        guard let engStr = item.englishSenc else{
            return CGSize(width: SCREEN_WIDTH, height: 60)
        }
        
        let nsstr = NSString(string: engStr)
        let length = nsstr.length
        
        var height = CGFloat((length/40+1)*40)
        
        UISegmentPlayViewController.LOG.info("height = \(height)")
        if let chstr = item.chineseSenc {
             let nsChStr = NSString(string: chstr)
            let chlength = nsChStr.length
            
             height = height + CGFloat((chlength/40+1)*30)
              UISegmentPlayViewController.LOG.info("成 height = \( CGFloat((chlength/40+1)*30))")
        }
        
        return CGSize(width: SCREEN_WIDTH, height:height)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentPlayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PlaySementItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaySementItemCollectionViewCell.PALY_SEGMENT_ITEM_CELL, for: indexPath) as! PlaySementItemCollectionViewCell
   
        cell.setItem(item: segmentPlayItems[indexPath.item])
        return cell
    }
}
