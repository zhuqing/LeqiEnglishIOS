//
//  ActionSheetDialogViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol  ActionSheetDialogViewControllerDelegate{
    func getContentViewWidth(viewController:ActionSheetDialogViewController)->CGFloat?
    
    func getContentView(viewController:ActionSheetDialogViewController)->UIView?
    
    func getOperation(viewController:ActionSheetDialogViewController)->[String:()->()]?
}

class ActionSheetDialogViewController: UIViewController {

    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var operationView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    var delegate:ActionSheetDialogViewControllerDelegate?
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ActionSheetDialogViewController{
    private func setViewUI(){
        
        guard let delegate = self.delegate else{
            return
        }
        
      var rootViewHeight = 90
        
      let contentHeight = delegate.getContentViewWidth(viewController: self)
        
        if contentHeight != nil{
            rootViewHeight += Int(contentHeight!)
        }
        
        
        if let operations = delegate.getOperation(viewController: self){
            rootViewHeight += operations.count*50
            setOperation(operations: operations)
        }
        
          rootView.frame = CGRect(x: CGFloat(0), y: SCREEN_WIDTH - CGFloat(rootViewHeight), width: SCREEN_WIDTH, height: CGFloat(rootViewHeight))
        
        if let contentView = delegate.getContentView(viewController: self){
            self.contentView.frame = CGRect(x: CGFloat(0), y: 10, width: self.contentView.frame.width, height: contentHeight!)
        }
        
      
    }
    
    private func setOperation(operations:[String:()->()]){
        var y = CGFloat(0)
        self.operationView.frame = CGRect(x: CGFloat(0), y: operationView.frame.origin.y -  CGFloat(operations.count*50) - CGFloat(10), width: operationView.frame.width, height: CGFloat(operations.count*50))
        for (title,_) in operations{
            let button = UIButton(frame: CGRect(x: 0, y: y, width: SCREEN_WIDTH - 40, height: CGFloat(40)))
            
            y += CGFloat(50)
            
            button.setTitle(title, for: .normal)
            button.backgroundColor = UIColor.green
            button.layer.cornerRadius = 20
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.setTitleColor(UIColor.white, for: .normal)
            self.operationView.addSubview(button)
        }
    }
}

