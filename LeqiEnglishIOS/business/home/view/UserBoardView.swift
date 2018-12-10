//
//  UserBoardView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol UserBoardViewDelegate {
    func reciteWordButtonClick()
}

class UserBoardView: UICollectionViewCell {
   static let USER_BOARDER_VIEW_REUSE_IDENTIFIRE = "USER_BOARDER_VIEW_REUSE_IDENTIFIRE"
   
    static let REFRESH_ID = "UserBoardView"
    
    @IBOutlet weak var hasRecite: UILabel!
    @IBOutlet weak var reciteWordButton: UIButton!
    
    @IBOutlet weak var hasLoginDaysLabel: UILabel!
    @IBOutlet weak var userHeaderImage: UIImageView!
    
    var delegate:UserBoardViewDelegate?
    
    
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }

    
}

extension UserBoardView{
    private func setUpUI(){
        initListener()
        loadData()
        loadUserImage()
        AppRefreshManager.instance.regist(id: UserBoardView.REFRESH_ID, self)
    }
    
    private func loadData(){
        UserReciteRecordDataCache.instance.load(finished: {
            (userReciteRecord) in
            guard let userRR = userReciteRecord else{
                return
            }
            self.hasLoginDaysLabel.text = "累计打卡\(userRR.learnDay ?? 0)天"
            
            self.hasRecite.text = "\(Int((userRR.learnTime ?? 0)/60))"
        })
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
            if(path.isEmpty){
                self.userHeaderImage.image = UIImage(named: "default_head")
            }else{
                self.userHeaderImage.image = UIImage(contentsOfFile: path)
            }
            
        }
    }
    
    private func initListener(){
        
        reciteWordButton.addTarget(self, action: #selector(UserBoardView.reciteWordButtonClick), for: .touchDown)
    }
    
    @objc private func reciteWordButtonClick(){
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.reciteWordButtonClick()
    }
}

extension UserBoardView:RefreshDataCacheDelegate{
    func clearnCacheThenRefresh() {
        UserReciteRecordDataCache.instance.claerData()
        refresh()
    }
    
  
    
    func refresh() {
       self.loadData()
       self.loadUserImage()
    }
}
