//
//  WriteWordResultViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/30.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class WriteWordResultViewController: UIViewController {
    @IBOutlet weak var collectionRootView: UIView!
    
    @IBOutlet weak var shareToFriendsButton: UIButton!
    
    @IBOutlet weak var reReciteButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var selectedNumLabel: UILabel!
    var reciteWords:[Word]? = [Word](){
        didSet{
            updateWords(reciteWords!)
        }
    }
    
    private var selectReciteWords = [Word](){
        didSet{
            selectedChange()
        }
    }
    
    //显示单词的集合
    private lazy var collectionView:UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH/3.7, height: 30)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.isPagingEnabled = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(UINib(nibName: "SimpleTextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY)
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionRootView.addSubview(self.collectionView)
        self.collectionView.frame = CGRect(x: 0, y: 5, width: SCREEN_WIDTH - 10, height: collectionRootView.frame.height)
        initButtonEvent()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//MARK: 事件相关
extension WriteWordResultViewController{
    private func initButtonEvent(){

        self.reReciteButton.addTarget(self, action: #selector(WriteWordResultViewController.clickReReciteHandler), for: .touchDown)
        
         self.shareToFriendsButton.addTarget(self, action: #selector(WriteWordResultViewController.clickShareHandler), for: .touchDown)
        
         self.closeButton.addTarget(self, action: #selector(WriteWordResultViewController.clickCloseHandler), for: .touchDown)
    }
    
    @objc private func clickReReciteHandler(){
        updateHasRecited()
       let reciteWordVC = ReciteWordViewController()
       self.present(reciteWordVC, animated: true, completion: nil)
    }
    
    @objc private func clickShareHandler(){
        updateHasRecited()
    }
    
    @objc private func clickCloseHandler(){
        updateHasRecited()
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated: false, completion: nil)
    }
}

//MARK: 数据相关
extension WriteWordResultViewController{
    private  func  updateWords(_ items:[Word]){
        self.selectReciteWords = [Word]()
        self.collectionView.reloadData()
    }
    
    private func selectedChange(){
        selectedNumLabel.text = "(\(self.selectReciteWords.count))"
    }
    
    private func updateHasRecited(){
        guard let user = UserDataCache.userDataCache.getFromCache() else{
            return
        }
        for word in self.selectReciteWords {
        Service.put(path: "userAndWord/update2Recited?wordId=\(word.id ?? "")&userId=\(user.id ?? "")"){(_) in
           
            }
        }
        
         self.updateRciteNumber()
    }
    //更新以背诵的单词的数量
    private func updateRciteNumber(){
        guard let user = UserDataCache.userDataCache.getFromCache() else{
            return
        }
        Service.put(path: "reciteWordConfig/addHasReciteNumber?userId=\(user.id ?? "")&number=\(self.selectReciteWords.count)"){
               (_) in
            guard let reciteConfig =  MyReciteWordConfig.instance.getFromCache() else {
                return
             }
            reciteConfig.hasReciteNumber = (reciteConfig.hasReciteNumber ?? 0)+self.selectReciteWords.count
            MyReciteWordConfig.instance.cacheData(data:reciteConfig)
            
       }
    }
}

extension WriteWordResultViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let word = self.reciteWords![indexPath.item]
        if(!self.selectReciteWords.contains(word)){
            self.selectReciteWords.append(word)
            let cell = self.collectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
            cell.selectCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let word = self.reciteWords![indexPath.item]
        if(self.selectReciteWords.contains(word)){
            let index = self.selectReciteWords.index(of: word)
            self.selectReciteWords.remove(at: index!)
            let cell = self.collectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
            cell.deselectCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SimpleTextCollectionViewCell? =    collectionView.dequeueReusableCell(withReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY, for: indexPath) as? SimpleTextCollectionViewCell
        let word = self.reciteWords![indexPath.item]
        cell?.setText(word.word!)
        
        if(self.selectReciteWords.contains(word)){
            cell?.selectCell()
        }else{
            cell?.deselectCell()
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reciteWords!.count
    }
}
