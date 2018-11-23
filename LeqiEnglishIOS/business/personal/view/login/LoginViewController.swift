//
//  LoginViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private let LOG = LOGGER("LoginViewController")
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
        
//        weiboButton.addTarget(self, action: #selector(LoginViewController.weiboHandler), for: .touchDown)
//        
//        weixinButton.addTarget(self, action: #selector(LoginViewController.weixinHandler), for: .touchDown)
        
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
        // thirdPartLoginHandler(SSDKPlatformType.typeWechat,type: 2)
       // SharePlateformUtil.share()
    }
    
    @objc private func qqHandler(){
        thirdPartLoginHandler(SSDKPlatformType.typeQQ,type: 1)
    }
    
    @objc private func weiboHandler(){
        thirdPartLoginHandler(SSDKPlatformType.typeSinaWeibo,type: 3)
    }
    
    private func thirdPartLoginHandler(_ platformType:SSDKPlatformType,type:Int){
        ShareSDK.authorize(platformType, settings: nil, onStateChanged: {
            (state,user,error) in
            switch state{
                
            case SSDKResponseState.success:
                self.register(user!,type: type)
                
            case SSDKResponseState.fail:
                 self.showAlert(message: "授权失败")
                 self.LOG.error(error.debugDescription)
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
        })
    }
    //ssUserssUser 419882849
    private func register(_ ssUser:SSDKUser,type:Int){
        print(ssUser.gender)
        print(ssUser.icon)
        print(ssUser.nickname)
        //根据uid查询，检测是否已经注册，已注册返回
        UserDataCache.instance.getUserByOtherSysId(ssUser.uid){
            (user) in
            if(user == nil){
                self.startRegist(ssUser,type:type)
                return;
            }
             self.LOG.info("已注册过")
            UserDataCache.instance.cacheData(data: user)
            self.dismiss(animated: true, completion: nil)
        }
        
     
    }
    
    private func startRegist(_ ssUser:SSDKUser,type:Int){
        let user = User()
        user.imagePath = ssUser.icon
        user.name = ssUser.nickname
        user.sex = ssUser.gender
        user.otherSysId = ssUser.uid
        user.type = type
        
        UserDataCache.instance.regist(user: user, error: {
            (mess) in
            self.showAlert(message: "登录失败")
        }, finished: {
            (user) in
            guard user != nil else{
                 self.showAlert(message: "登录失败")
                return
            }
            
            self.LOG.info("注册成功")
            self.dismiss(animated: true, completion: nil)
        })
        
    }
}

