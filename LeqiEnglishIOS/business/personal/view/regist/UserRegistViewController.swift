//
//  UserRegistViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/10.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class UserRegistViewController: UIViewController {
    
    let LOG = LOGGER("UserRegistViewController")
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var checkPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var manOrWomenControl: UISegmentedControl!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        checkPasswordField.isSecureTextEntry = true
        passwordField.isSecureTextEntry = true
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
    private func navigation(){
        self.back.action = #selector(UserRegistViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension UserRegistViewController{
    private func initListener(){
        registButton.addTarget(self, action: #selector(UserRegistViewController.registHandler), for: .touchDown)
        
          cancelButton.addTarget(self, action: #selector(UserRegistViewController.backEventHandler), for: .touchDown)
        
    }
    
    @objc private func registHandler(){
        guard let email = self.userNameField.text else{
            self.showAlert(message: "请输入邮箱地址！！")
            return
        }
        
        if(email.count == 0){
            self.showAlert(message: "请输入邮箱地址！！")
            return
        }
        
        guard let password = self.passwordField.text else{
             self.showAlert(message: "请输入密码！！")
            return
        }
        
        if(password.count == 0){
            self.showAlert(message: "请输入密码！！")
        }
        
        guard let checkPassword = self.checkPasswordField.text else{
            self.showAlert(message: "两次密码输入不同！！")
            return
        }
        
        if(password.caseInsensitiveCompare(checkPassword).rawValue != 0){
            self.showAlert(message: "两次密码输入不同！！")
            return
        }
        
        let sex = self.manOrWomenControl.selectedSegmentIndex
        
        
        guard var user = UserDataCache.userDataCache.getFromCache() else {
            return
        }
        
        if(user.status != 0){
            user = User()
        }
        user.name = email
        user.email = email
        user.password = password.md5()
        user.sex = sex
        user.status = 1
        
        LOG.info("\(user.toDictionary())")
        
        UserDataCache.userDataCache.regist(user: user, error:{
            (message) in
            self.showAlert(message: message!)
        }, finished: {
            (user) in
            self.showAlert(message: "注册成功",closeHandler: {
                self.returnHome()
            })
            
        })
        
        
        
    }
    
   
}
