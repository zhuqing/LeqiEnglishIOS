//
//  OperationItemView.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/2.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class OperationItemView: UIView {
    
    private var title:String = ""
    private var imageName:String = "content"
    
    private lazy var imageView:UIImageView? = {
        let image = UIImageView(frame: CGRect.zero)
        image.image = UIImage(named: imageName)
        return image
    }()
    
    private lazy var titleLabel:UILabel? = {
        let label = UILabel(frame: CGRect.zero)
        label.text = title
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    func setTitle(title:String)  {
        self.title = title
        
        self.titleLabel?.text = title
    }

    func setImageName(name:String){
        self.imageName = name
        self.imageView?.image = UIImage(named: name);
    }
    
    func set(title:String,imageName:String) {
        setImageName(name: imageName )
        setTitle(title: title)
    }
    
    init(frame: CGRect , title:String, imageName:String) {
        super.init(frame: frame)
        self.title = title
        self.imageName = imageName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    */
    override func draw(_ rect: CGRect) {
       self.addSubview(self.imageView!)
    
       self.imageView?.frame = CGRect(x: rect.width/2-16, y: 5, width: 28, height: 28)
        
        self.addSubview(self.titleLabel!)
        let width = StringUtil.computerWidth(text: self.title, font: UIFont.systemFont(ofSize: 12), fixedHeight: 13)
        self.titleLabel?.frame = CGRect(x: rect.width/2 - width/2+2, y: 37, width: width, height: 13)
    }
   
}
