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
    
    //用户图像
    @IBOutlet weak var scroller: UIScrollView!
    
    
    private let homeViewModel:HomeViewMode = HomeViewMode()
    
    let RECITING_HEIGHT:CGFloat = 230
    let HEADER_HEIGHT:CGFloat = 40
    
    private lazy var recitingContentView:RecitingContentView={[weak self] in
        return RecitingContentView(frame: CGRect(x: 0, y: HEADER_HEIGHT, width: view.frame.width, height: RECITING_HEIGHT))
    }()
    private lazy var recommend:RecomenContentView={[weak self] in
        return RecomenContentView(frame: CGRect(x: 0, y: HEADER_HEIGHT, width: view.frame.width, height: RECITING_HEIGHT))
        }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension HomeViewController{
    private func setupUI(){

        //self.scroller.addSubview(recitingContentView)
        
        //self.scroller.addSubview(recommend)
        
        scroller.alwaysBounceHorizontal = false
    }
    
    private func initRecitingCollectionView(){
      //  recitingCollectionView.layou
    }
}


