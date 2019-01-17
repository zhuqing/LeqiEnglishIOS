//
//  PercentView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/17.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

//绘制百分比的图像
class PercentView: CircleView {

    var percentColor:UIColor = UIColor.green
    //百分比，从0到1
    var perscent:CGFloat = 0{
        didSet{
            self.setNeedsDisplay()
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    */
    
   
    
    
    override func draw(_ rect: CGRect) {
       super.draw(rect)
      
        percentColor.set()
        let radius = rect.width/2
       
        let arcCenter = CGPoint(x: radius, y: radius)
        let startAngle = CGFloat(M_PI_F * 3 / 2)
        var engAngle = CGFloat(perscent * 2 * M_PI_F) - CGFloat(M_PI_F / 2)
        
        if(engAngle < 0){
            engAngle = M_PI_F * 2 + engAngle
        }
        
       let arcPath =  UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: engAngle, clockwise: true)
        
        
        arcPath.addLine(to: arcCenter)
        arcPath.close()
        arcPath.lineWidth = 2.0 // 线条宽度
        
        //    aPath.stroke() // Draws line 根据坐标点连线，不填充
        arcPath.fill() // Draws line 根据坐标点连线，填充
    }
}
