//
//  SimpleTextCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/30.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class SimpleTextCollectionViewCell: UICollectionViewCell {
    
    static let SIMPLE_TEXT_CELL_INDENTIFY = "SIMPLE_TEXT_CELL_INDENTIFY"

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var rootView: UIView!
    
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(_ text:String){
        textLabel.text = text
    }
    
     func selectCell() {
     
        rootView.layer.borderWidth = 1
        rootView.layer.borderColor = UIColor.blue.cgColor
    }
    
    func deselectCell(){
        rootView.layer.borderWidth = 0
       // rootView.layer.borderColor = UIColor.blue
    }
 

}
