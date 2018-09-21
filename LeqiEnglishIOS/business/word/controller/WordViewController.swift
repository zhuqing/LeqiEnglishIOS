//
//  WordViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import Foundation
import UIKit


class WordViewController:MainViewController{
    @IBOutlet weak var rootView: UIView!
    private lazy var pageTitleView:PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TITLE_VIEW_HEIGHT)
        let titles=["已背" , "未背"]
        let pageTitleView = PageTitleView(frame:titleFrame,titles:titles)
        pageTitleView.pageTitleViewDelegate = self
        return pageTitleView
        }()
    
    
    private lazy var pageContentView:PageContentView = { [weak self] in
        let contentViewH:CGFloat = SCREEN_HEIGHT - (STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+TITLE_VIEW_HEIGHT)
        
        let frame = CGRect(x: 0, y: TITLE_VIEW_HEIGHT, width: SCREEN_WIDTH, height: contentViewH)
        
        var childVCS = [UIViewController]()
        
        for _ in 0..<2{
            let uiViewController:UIViewController = UIViewController()
            uiViewController.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)), y: CGFloat(arc4random_uniform(255)))
            childVCS.append(uiViewController)
        }
        
        let pageContentView = PageContentView(frame: frame, childVCs: childVCS, parentVC: self)
        
        pageContentView.delegate = self
  
        return pageContentView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
}

//MARK 界面和数据
extension WordViewController{
    private func setupUI(){
        
       automaticallyAdjustsScrollViewInsets = false

        rootView.addSubview(pageTitleView)
      
        rootView.addSubview(pageContentView)
    }
    
    private func loadData(){
        
    }
}

extension WordViewController :PageTitleViewDelegate {
    func pageTitleView(pageTitleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setPageIndex(index: index)
    }
}

//MARK: 实现PageContentViewDelegate
extension WordViewController:PageContentViewDelegate{
    func pageContentView(pageContentView: PageContentView, progress: CGFloat, sourceIdex: Int, targetIndex: Int) {
        pageTitleView.moveScrollLine(progress: progress, sourceIndex: sourceIdex, targetIndex: targetIndex)
    }
}
