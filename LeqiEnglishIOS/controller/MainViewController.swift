//
//  MainViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/6.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//
import UIKit
import Foundation

class MainViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var reciteWords: UIButton!
    
    @IBOutlet weak var hasRecitedMinute: UITextField!
    @IBOutlet weak var hasLogin: UITextField!
    
    override func viewDidLoad() {
        resetHeaderImage();
        resetRecitedButton()
    }
    
    private func resetRecitedButton(){
        reciteWords.layer.borderColor = UIColor.gray.cgColor
        
        reciteWords.layer.borderWidth = 2;
        
        reciteWords.layer.cornerRadius = 16;
    }
    
    private func resetHeaderImage(){
        userImage.layer.cornerRadius = 50
    }
}
