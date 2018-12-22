//
//  PlayContentViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/12/21.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit
import AVFoundation

class PlayContentViewController: UIViewController {

    @IBOutlet weak var addRciteButton: UIButton!
    @IBOutlet weak var playBarRoot: UIView!
    @IBOutlet weak var contentListRoot: UIView!
    @IBOutlet weak var nav: UIBarButtonItem!
    
    private var currentPlayIndex = -1;
    
    private lazy var playBarView:PlayBarView = {
        let playBar = PlayBarView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 90))
        playBar.delegate = self
        return playBar
    }()
    
    
    private var datas:[Content]? = [Content]();
    
    
    private lazy var collectionView:UICollectionView={ [weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: SCREEN_WIDTH-10, height: 30)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical

        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
      //  self.collectionView.allowsSelection = true
        collectionView.register(UINib(nibName: "SimpleTextCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY)
        
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         load()
         navigation()
        initEventHandler()
           beginReceivingRemoteControlEvents()
        // Do any additional setup after loading the view.
    }


    override func viewWillDisappear(_ animated: Bool) {
     endReceivingRemoteControlEvents()
        self.playBarView.stop()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    

    
    func beginReceivingRemoteControlEvents(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
    }
    
    func endReceivingRemoteControlEvents(){
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {

        
        if event?.type == UIEventType.remoteControl {
            switch event!.subtype {
            case .remoteControlTogglePlayPause:
                print("暂停/播放")
            case .remoteControlPreviousTrack: // ##  <-  ##
                print("上一首")
            case .remoteControlNextTrack: // ## -> ##
                print("下一首")
            case .remoteControlPlay: // ## > ##
                print(">")
            case .remoteControlPause: // ## || ##
                print("||")
            default:
                break
            }
        }
    }
    
    
    func setBackground() {
    
        //大标题 - 小标题  - 歌曲总时长 - 歌曲当前播放时长 - 封面
   //   PlayIng
        
       
    }
    
    private func initEventHandler(){
        addRciteButton.addTarget(self, action: #selector(PlayContentViewController.backEventHandler), for: .touchDown)
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

extension PlayContentViewController{
    private func setUI(){
        self.playBarRoot.addSubview(self.playBarView)
        self.contentListRoot.addSubview(self.collectionView)
        collectionView.frame = CGRect(x: 5, y: 0, width:SCREEN_WIDTH-10, height: self.contentListRoot.bounds.height)
       
       
    }
    
    private func load(){
        MyContentDataCache.instance.load(){
            (contents) in
            self.datas?.removeAll()
            if let list = contents {
                   self.datas?.append(contentsOf: list)
            }else{
                
            }
            
            if(self.datas == nil  || (self.datas?.isEmpty)! ){
               
            }else{
                self.setUI();
                self.collectionView.reloadData()
            }
         
            
        }
    }
    
    private func navigation(){
        self.nav.action = #selector(PlayContentViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
    
   
   //加载content下的段
    private func loadSegments(content:Content)  {
       
        let contentInfoViewModel = ContentInfoViewModel(content: content)
        contentInfoViewModel.load(){
            (segments) in
            guard let arr = segments else{
                return
            }
            self.createSegmentPlayEntity(segments: arr)
        }
        
        
    }
    
    private func createSegmentPlayEntity(segments:[Segment]){
        var segmentPlayEntities = [SegmentPlayEntity]()
        for segment in segments {
            guard let entity = SegmentPlayEntity.createSegmentPlayEntity(segment: segment) else{
                continue
            }
            segmentPlayEntities.append(entity)
        }
        
        
        
        if segmentPlayEntities.count == 0{
            return;
        }
        
        var lastPlayEntity:SegmentPlayEntity?
        
        for playEntity in segmentPlayEntities {
            if(lastPlayEntity != nil){
                
                playEntity.startTime = Int(lastPlayEntity!.endTime!)
                playEntity.endTime =  Int(lastPlayEntity!.endTime! + playEntity.endTime!)
            }
            
            lastPlayEntity = playEntity
        }
        
        Service.download(filePath: segmentPlayEntities[0].filePath ?? "") { (filePath) in
            segmentPlayEntities[0].filePath = filePath
            
            self.playBarView.play(segmentPlayEnties: segmentPlayEntities)
            self.loadFile(segmentPlayEntities: segmentPlayEntities, index: 1)
        }
    }
    
    private func loadFile( segmentPlayEntities:[SegmentPlayEntity],index:Int){
        if(index < 0 || index >= segmentPlayEntities.count){
            return ;
        }
       
        Service.download(filePath: segmentPlayEntities[index].filePath ?? "") { (filePath) in
            segmentPlayEntities[index].filePath = filePath
            self.loadFile(segmentPlayEntities: segmentPlayEntities, index: index+1)
            
        }
    }
    
    
    
}

//MARK: 实现集合的代理
extension PlayContentViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SimpleTextCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY, for: indexPath) as! SimpleTextCollectionViewCell
       
         let content = self.datas![indexPath.item]

        cell.setText(content.title ?? "")
        cell.textLabel.textAlignment = .left
        cell.delegate = self
        
        if(self.currentPlayIndex == indexPath.item){
            cell.selectCell()
        }else{
            cell.deselectCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let cell:SimpleTextCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
        cell.selectCell()
        self.currentPlayIndex = indexPath.item
        self.loadSegments(content: self.datas![indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell:SimpleTextCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
        
        cell.deselectCell()
    }
}



//MARK: 实现SimpleTextCollectionViewCell代理
extension PlayContentViewController:SimpleTextCollectionViewCellDelegate{
     func selected(cell: SimpleTextCollectionViewCell) {
        cell.textLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    
     func deSelected(cell: SimpleTextCollectionViewCell) {
        cell.textLabel.font = UIFont.systemFont(ofSize: 17)
    }
}

extension PlayContentViewController:PlayBarViewDelegate{
    func next(playBarView: PlayBarView) {
      
        
        self.currentPlayIndex  += 1
        if(self.currentPlayIndex >= (self.datas?.count)! ){
            self.currentPlayIndex = 0
        }
        self.play(index: currentPlayIndex)
    }
    
    func play(playBarView: PlayBarView) {
        next(playBarView: playBarView)
    }
    
    func previous(playBarView: PlayBarView) {
        self.currentPlayIndex  -=  1
        if(currentPlayIndex < 0){
            currentPlayIndex = (self.datas?.count)! - 1
        }
        
        self.play(index: currentPlayIndex)
    }
    
    func finished(playBarView: PlayBarView) {
        self.next(playBarView: playBarView)
    }
    
    private func play(index:Int){
       
        if(index<0 || index >= (self.datas?.count)!){
            return
        }
        
         self.collectionView.reloadData()
        self.loadSegments(content: (self.datas?[index])!)
    }
}

