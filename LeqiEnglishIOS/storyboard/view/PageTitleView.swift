//
//  PageTitleView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/8.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate :class {
    func pageTitleView(pageTitleView:PageTitleView,selectIndex index:Int)
}

//MARK 常量
let scrollbarH:CGFloat = 2


let NORMAL_COLOR:(CGFloat,CGFloat,CGFloat) = (85,85,85)
let SELECTED_COLOR:(CGFloat,CGFloat,CGFloat) = (255,128,0)

class PageTitleView: UIView {
    
    private var titles:[String]
    
    weak var pageTitleViewDelegate:PageTitleViewDelegate?
    
    private var currentSelectedIndex:Int = 0
    
    private lazy var scrollView:UIScrollView = {
        let scrollerView = UIScrollView()
       
        scrollerView.showsHorizontalScrollIndicator = false

        scrollerView.scrollsToTop = false
        scrollerView.isPagingEnabled = false
        scrollerView.bounces = false
      
            scrollerView.contentInsetAdjustmentBehavior = .never;
        
       // scrollerView.contentInsetAdjustmentBehavior = nil
        return scrollerView
        }()
    
    
    private lazy var scrollLine:UIView={
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    
    private lazy var titleLabels:[UILabel] = [UILabel]()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   
     init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame:frame)
        setupUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      //  super.init(coder)
    }
    
}


// MARK- 设置UI界面

extension PageTitleView{
    
    private func setupUI(){
        addSubview(scrollView)
        scrollView.frame = bounds
        
        setupTitleLabels()
        setupBottomLine()
    }
    
    private func setupTitleLabels(){

        let labelW:CGFloat = frame.width/CGFloat(titles.count)
        let labelH:CGFloat = frame.height-scrollbarH
        let labelY:CGFloat = 0
        
        for (index , title) in titles.enumerated(){
            let label = UILabel()
            
            label.text = title
            label.tag = index
            
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: NORMAL_COLOR.0, b: NORMAL_COLOR.1, y: NORMAL_COLOR.2)
            label.textAlignment = .center
           // label.backgroundColor = UIColor.black
            
       
            let labelX:CGFloat = labelW*CGFloat(index)
            
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            titleLabels.append(label)
            scrollView.addSubview(label)
            
            label.isUserInteractionEnabled = true
            let labelGet = UITapGestureRecognizer(target: self, action:#selector(self.labelClick(uiGet:)))
            label.addGestureRecognizer(labelGet)
            
        }
    }
    
    private func setupBottomLine(){
        let bottomLine = UIView();
        let lineH:CGFloat = 1
        bottomLine.backgroundColor = UIColor.lightGray
        
        bottomLine.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        
        addSubview(bottomLine)
        guard let firstLabel = titleLabels.first else {return}
        scrollView.addSubview(scrollLine)
 
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-scrollbarH, width: firstLabel.frame.width, height: scrollbarH)
        firstLabel.textColor = UIColor.orange
        
    }
}
// MARK anction  x
extension PageTitleView{

    @objc private func labelClick(uiGet:UIGestureRecognizer){
        guard let label = uiGet.view as? UILabel else {return}
        
        if(currentSelectedIndex == label.tag){
            return
        }
        
        label.textColor = UIColor(r: SELECTED_COLOR.0, b: SELECTED_COLOR.1, y: SELECTED_COLOR.2)
      
        
        let oldLabel = titleLabels[currentSelectedIndex]
        oldLabel.textColor = UIColor(r: NORMAL_COLOR.0, b: NORMAL_COLOR.1, y: NORMAL_COLOR.2)
        
         currentSelectedIndex = label.tag
        
        let scorllX = CGFloat(currentSelectedIndex) * label.frame.width
        
        UIView.animate(withDuration: 0.5) {
            self.scrollLine.frame.origin.x = scorllX
        }
        
        pageTitleViewDelegate?.pageTitleView(pageTitleView: self, selectIndex: currentSelectedIndex)
       
    }
}
//MARK 公开API
extension PageTitleView{
    func moveScrollLine(progress:CGFloat,sourceIndex:Int,targetIndex:Int)  {
        if(sourceIndex == targetIndex){
            return
        }
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let movex = moveTotalX*progress
        
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + movex
        
        //MARK 颜色渐变
        
        let colorDelta = (SELECTED_COLOR.0 - NORMAL_COLOR.0,SELECTED_COLOR.1 - NORMAL_COLOR.1,SELECTED_COLOR.2 - NORMAL_COLOR.2)
        
        sourceLabel.textColor = UIColor(r: SELECTED_COLOR.0 - colorDelta.0*progress, b: SELECTED_COLOR.1 - colorDelta.1*progress, y: SELECTED_COLOR.2 - colorDelta.2*progress)
        
        targetLabel.textColor = UIColor(r: NORMAL_COLOR.0 + colorDelta.0*progress, b: NORMAL_COLOR.1 + colorDelta.1*progress, y: NORMAL_COLOR.2 + colorDelta.2*progress)
        
        currentSelectedIndex = targetIndex
    }
}
