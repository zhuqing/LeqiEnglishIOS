//
//  PageContentView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(pageContentView:PageContentView,progress:CGFloat,sourceIdex:Int,targetIndex:Int)
    
}

let INDENTIFIER = "PageContentViewCell"
class PageContentView: UIView {
    
    private var pauseDelegate:Bool = false
    private var startOffsetX:CGFloat = 0.0
    private var childVCs:[UIViewController]
    private weak var parentVC:UIViewController?
    weak var delegate:PageContentViewDelegate?
    
    private lazy var collectionView:UICollectionView = { [weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let uiCollectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: layout)
        uiCollectionView.showsHorizontalScrollIndicator = false
        uiCollectionView.isPagingEnabled = true
        uiCollectionView.bounces = false
        uiCollectionView.dataSource = self
        uiCollectionView.delegate = self
        uiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: INDENTIFIER)
        
        return uiCollectionView
       // uiCollectionView.accessibilityScroll(.)
    }()
    
    init(frame:CGRect,childVCs:[UIViewController],parentVC:UIViewController?){
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }

}

// MARK 设置UI

extension PageContentView{
    private func setupUI(){
        for childVC in childVCs{
            parentVC?.addChildViewController(childVC)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
        
        
    }
}
// MARK  设置数据源
extension PageContentView:UICollectionViewDataSource {
   
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: INDENTIFIER, for: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let uiViewController = childVCs[indexPath.item]
        uiViewController.view.frame = cell.bounds
        
        cell.contentView.addSubview(uiViewController.view)
        return cell
    }
}
//MARK 公开的分页设置接口
extension PageContentView{
    func setPageIndex(index:Int)  {
        pauseDelegate = true
        let offX = CGFloat(index) * collectionView.frame.width
        
        collectionView.setContentOffset(CGPoint(x:offX,y:0), animated: true)
    }
}

//MARK:-  实现设置代理

extension PageContentView : UICollectionViewDelegate{
   
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        pauseDelegate = false
        startOffsetX = scrollView.contentOffset.x
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(pauseDelegate){
            return
        }
        
        var progress:CGFloat = 0
        var sourceIndex:Int = 0
        var targetIndex:Int = 0
        
        let currentOffsex = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if(currentOffsex > startOffsetX){//向左划
            progress = currentOffsex/scrollViewW - floor(currentOffsex/scrollViewW)
            
            sourceIndex = Int(currentOffsex/scrollViewW)
            
            targetIndex = sourceIndex+1
            
            if(targetIndex >= childVCs.count){
                targetIndex = childVCs.count-1
            }
            
            //完全滚动
            
            if (currentOffsex - startOffsetX == scrollViewW){
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//向右划
            progress = 1 - (currentOffsex/scrollViewW - floor(currentOffsex/scrollViewW))
            
            targetIndex = Int(currentOffsex/scrollViewW)
            
            sourceIndex = targetIndex + 1
            if(sourceIndex >= childVCs.count){
                sourceIndex = childVCs.count - 1
            }
        }
        
        delegate?.pageContentView(pageContentView: self, progress: progress, sourceIdex: sourceIndex, targetIndex: targetIndex)
    }
}
