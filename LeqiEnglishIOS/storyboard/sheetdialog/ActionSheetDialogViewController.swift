//
//  ActionSheetDialogViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/1.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

protocol  ActionSheetDialogViewControllerDelegate{
    func getContentViewHeight(viewController:ActionSheetDialogViewController)->CGFloat?
    
    func getContentView(viewController:ActionSheetDialogViewController)->UIView?
    
    func getOperation(viewController:ActionSheetDialogViewController)->[String:()->()]?
    
    func closeEventHandler(viewController:ActionSheetDialogViewController)
}

class ActionSheetDialogViewController: UIViewController {
    
    let LOG = LOGGER("ActionSheetDialogViewController")

    var data:NSObject?
    
     lazy var rootView: UIView? = {
        let root  = UIView(frame: CGRect.zero)
        root.backgroundColor = UIColor.white
        return root
    }()
    
      lazy var operationView: UIView? = {
        let root  = UIView(frame: CGRect.zero)
          root.backgroundColor = UIColor.white
        return root
    }()
    
     lazy var contentView: UIView? = {
        let root  = UIView(frame: CGRect.zero)
          root.backgroundColor = UIColor.white
        return root
    }()
    
    lazy var outsideView:UIView? = {
        let root  = UIView(frame: CGRect.zero)
        root.backgroundColor = UIColor.clear
        return root
    }()
    
    private lazy var closeButton: UIButton? = {
        let button = UIButton(frame:CGRect.zero )
        button.setTitle("关闭", for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(ActionSheetDialogViewController.closeEventHandler), for: .touchDown)
        return button
    }()
    
    
    var delegate:ActionSheetDialogViewControllerDelegate?
    
    private var operations:[String:()->()]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewUI()
        initListener()
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
        
        clickOutside()
        
       var y = CGFloat(20)
      var rootViewHeight = 90
        
      let contentHeight = delegate.getContentViewHeight(viewController: self)
        
        if contentHeight != nil{
            rootViewHeight += Int(contentHeight!)
          
        }
        
        if let operations = delegate.getOperation(viewController: self){
            rootViewHeight += operations.count*50
           
        }
        self.view.addSubview(rootView!)
        
        self.rootView?.frame = CGRect(x: CGFloat(0), y: SCREEN_HEIGHT - CGFloat(rootViewHeight)-10, width: SCREEN_WIDTH, height: CGFloat(rootViewHeight))
        
     
        
        if let contentView = delegate.getContentView(viewController: self){
            self.rootView?.addSubview(self.contentView!)
            self.contentView?.frame = CGRect(x: CGFloat(0), y: y, width: SCREEN_WIDTH, height: contentHeight!)
            
            
            self.contentView?.addSubview(contentView)
            self.contentView?.layer.cornerRadius = 5
            
            contentView.frame =  CGRect(x: CGFloat(10), y: 10, width: SCREEN_WIDTH-20, height: contentHeight!)
              y += contentHeight!
           
        }
        
        self.operations = delegate.getOperation(viewController: self)
        
        if let operations = self.operations {
            self.rootView?.addSubview(self.operationView!)
            self.operationView?.frame = CGRect(x: CGFloat(20), y: y, width: SCREEN_WIDTH - 40, height: CGFloat(operations.count*50))
           
            setOperation(operations: operations)
        }
        
        self.rootView?.addSubview(self.closeButton!)
        self.closeButton?.frame = CGRect(x: 20, y: (self.rootView?.frame.height)! - CGFloat(50), width: SCREEN_WIDTH - 40, height: CGFloat(40));
      
      
        self.view.addSubview(self.outsideView!)
        self.outsideView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(rootViewHeight))
    }
    
    private func clickOutside(){
        self.outsideView?.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ActionSheetDialogViewController.clickOutsideHandler))
        
        self.outsideView?.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func clickOutsideHandler(){
        
        self.dismiss(animated: false, completion: nil)
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.closeEventHandler(viewController: self)
    }
    
    private func setOperation(operations:[String:()->()]){
    
        
        var y = CGFloat(0)
        
        for (title,_) in operations{
            let button = UIButton(frame: CGRect.zero)

            button.setTitle(title, for: .normal)
            button.backgroundColor = UIColor.green
            button.layer.cornerRadius = 20
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(ActionSheetDialogViewController.customeButtonEventHandler(button:)), for: .touchDown)
            
            self.operationView?.addSubview(button)
            button.frame =  CGRect(x: 0, y: y, width: SCREEN_WIDTH - 40, height: CGFloat(40))
            
            y += CGFloat(50)
        }
    }
    
    private func initListener(){
        self.closeButton?.addTarget(self, action: #selector(ActionSheetDialogViewController.closeEventHandler), for: .touchDown)
    }
    
    @objc private func customeButtonEventHandler(button:UIButton){
        LOG.info((button.titleLabel?.text)!)
        self.dismiss(animated: true, completion: nil)
        guard let operation = operations![(button.titleLabel?.text)!] else{
            return;
        }
       
       operation()
        
    }
    
    @objc private func closeEventHandler(){
        self.dismiss(animated: true, completion: nil)
        
        guard let delegate = self.delegate else{
            return
        }
        
        delegate.closeEventHandler(viewController: self)
    }
}

