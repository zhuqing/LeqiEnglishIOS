//
//  HomeViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/7.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit





class HomeViewController:MainViewController{
    
    @IBOutlet weak var headerView: UIView!
    //已经背诵的天数
    @IBOutlet weak var hasLearnDays: UILabel!
    //已经背诵的时间
    @IBOutlet weak var hasRecitedMinutes: UILabel!
    //用户图像
    @IBOutlet weak var userImage: UIImageView!
    
    let RECITING_HEIGHT:CGFloat = 230
    let V_SPCING:CGFloat = 10
    
    private lazy var recitingContentView:RecitingContentView={[weak self] in
        return RecitingContentView(frame: CGRect(x: 0, y: headerView.frame.origin.y+headerView.frame.height+V_SPCING, width: view.frame.width, height: RECITING_HEIGHT))
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension HomeViewController{
    private func setupUI(){

        self.view.addSubview(recitingContentView)
    }
    
    private func initRecitingCollectionView(){
      //  recitingCollectionView.layou
    }
}


