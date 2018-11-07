//
//  LoginViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var forgetPasswordLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var quickRegistButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var weixinButton: UIButton!
    
    @IBOutlet weak var qqButton: UIButton!
    
    @IBOutlet weak var weiboButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

//MARK：事件处理
extension LoginViewController{
    
    private func navigation(){
        self.back.action = #selector(LoginViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func initListener(){
        loginButton.addTarget(self, action: #selector(LoginViewController.loginHandler), for: .touchDown)
        quickRegistButton.addTarget(self, action: #selector(LoginViewController.registHandler), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(LoginViewController.cancelHandler), for: .touchDown)
        
        weiboButton.addTarget(self, action: #selector(LoginViewController.weiboHandler), for: .touchDown)
        
        weixinButton.addTarget(self, action: #selector(LoginViewController.weixinHandler), for: .touchDown)
        
        qqButton.addTarget(self, action: #selector(LoginViewController.qqHandler), for: .touchDown)
   navigation()
    }
    
    @objc private func loginHandler(){
        
        guard let userName = self.userNameField.text else{
            return
        }
        
        guard let password = self.passwordField.text else{
            return
        }
        
        UserDataCache.instance.login(name: userName, password: password,error: {
            (message) in
            self.showAlert(message: message!)
        },finished: {
            (user) in
             self.showAlert(message: "登录成功")
        })
    }
    
   
    
    @objc private func registHandler(){
        let vc = UserRegistViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func cancelHandler(){
        
    }
    
    @objc private func weixinHandler(){
        
    }
    
    @objc private func qqHandler(){
        ShareSDK.authorize(.subTypeQZone, settings: nil, onStateChanged: {
            (state,user,error) in
            switch state{
                
            case SSDKResponseState.success:
                
                print("授权成功,用户信息为\(user)\n ----- 授权凭证为\(user?.icon)")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
        })
    }
    
    @objc private func weiboHandler(){
        
    }
}

