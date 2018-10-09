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
    @IBOutlet weak var back: UIBarButtonItem!
    
    private lazy var playBar:PlaySegmentBar? = {
     
        let playBar = PlaySegmentBar(frame: CGRect.zero, mp3Path: "")
        return playBar
    }()
    
    private var lastCell:PlaySementItemCollectionViewCell?
    
    private var selectIndex:Int = -1;
    
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
        self.setupUI()
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSegment(item:Segment,mp3Path:String){
        playBar?.mp3Path = mp3Path
        
        UISegmentPlayViewController.LOG.error(item.content!)
        segmentPlayItems = SegmentPlayItem.toItems(str: item.content!)!
        collectionView.reloadData()
        insertUserAndWord(item)
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

extension UISegmentPlayViewController{
    
    private func setupUI(){
        collectionRootView.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: collectionRootView.bounds.height)
        navigation()
        self.startRecite.addTarget(self, action: #selector(UISegmentPlayViewController.startReciteHandler), for: .touchDown)
    }
    private func navigation(){
        self.back.action = #selector(UISegmentPlayViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //跳转到背诵界面
    @objc private func startReciteHandler(){
        let vc = ReciteSegmentViewController()
        
        self.present(vc, animated: true){
            
            vc.during = Double((self.segmentPlayItems.last?.endTime)! - self.segmentPlayItems[0].startTime! )/1000.0
        }
    }
    
}

extension UISegmentPlayViewController{
    //插入本段单词和用户的关系
    private func insertUserAndWord(_ item:Segment){
        guard  let user =  UserDataCache.userDataCache.getFromCache() else{
            return
        }
    
        Service.post(path: "userAndWord/insertAllBySegmentId?userId=\(user.id ?? "")&segmentId=\(item.id ?? "")",params: ["userId":user.id ?? "","segmentId":item.id ?? ""]){_ in }
        
    }
}

extension UISegmentPlayViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = segmentPlayItems[indexPath.row]
        guard let engStr = item.englishSenc else{
            return CGSize(width: SCREEN_WIDTH, height: 60)
        }
        
        
        var height = StringUtil.computerHeight(text: engStr, font: UIFont.systemFont(ofSize: 18), fixedWidth: SCREEN_WIDTH-20)+20
        
       
        if let chstr = item.chineseSenc {

             height += StringUtil.computerHeight(text: chstr, font: UIFont.systemFont(ofSize: 13), fixedWidth: SCREEN_WIDTH-20)+20
            
        }
        
        if(indexPath.item == selectIndex){
            height += PlaySegmentBar.HEIGHT
        }
        
        return CGSize(width: SCREEN_WIDTH, height:height)
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let lastCell = self.lastCell{
            lastCell.stop(bar: playBar!)
        }
        let cell:PlaySementItemCollectionViewCell = collectionView.cellForItem(at: indexPath) as! PlaySementItemCollectionViewCell
        
       UISegmentPlayViewController.LOG.info("selected\(indexPath.item)")
    
      self.selectIndex = indexPath.item
       collectionView.reloadItems(at: [indexPath])
       lastCell = cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentPlayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PlaySementItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaySementItemCollectionViewCell.PALY_SEGMENT_ITEM_CELL, for: indexPath) as! PlaySementItemCollectionViewCell
   
        cell.setItem(item: segmentPlayItems[indexPath.item])
        
        if(indexPath.item == self.selectIndex){
            cell.play(bar: playBar!)
            playBar?.segmentPlayItem = segmentPlayItems[indexPath.item]
        }
        return cell
    }
}
