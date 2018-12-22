//
//  SimpleTextCollectionViewCell.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/30.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol SimpleTextCollectionViewCellDelegate {
    func selected(cell:SimpleTextCollectionViewCell)
    func deSelected(cell:SimpleTextCollectionViewCell)
}

class SimpleTextCollectionViewCell: UICollectionViewCell {
    
    static let SIMPLE_TEXT_CELL_INDENTIFY = "SIMPLE_TEXT_CELL_INDENTIFY"

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var rootView: UIView!
    var delegate:SimpleTextCollectionViewCellDelegate?
    
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(_ text:String){
        textLabel.text = text
    }
    
     func selectCell() {
     
        guard let delegate = self.delegate else{
            rootView.layer.borderWidth = 1
            rootView.layer.borderColor = UIColor.blue.cgColor
            
            return;
        }
        
        delegate.selected(cell: self)
        
    }
    
    func deselectCell(){
        
        guard let delegate = self.delegate else{
             rootView.layer.borderWidth = 0
            return;
        }
        
        delegate.deSelected(cell: self)
       
       // rootView.layer.borderColor = UIColor.blue
    }
 

}
