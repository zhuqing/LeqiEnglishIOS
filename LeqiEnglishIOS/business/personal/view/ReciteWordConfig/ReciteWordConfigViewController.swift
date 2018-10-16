//
//  ReciteWordConfigViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/29.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ReciteWordConfigViewController: UIViewController {

    @IBOutlet weak var countTextFile: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var refreshDelegate:RefreshDelegate?
    
    var rectieWordConfig:ReciteWordConfig?{
        didSet{
            guard let rwc = rectieWordConfig else{
                return
            }
            setItem(item:rwc)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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

extension ReciteWordConfigViewController{
    private func initListener(){
        self.cancelButton.addTarget(self, action: #selector(ReciteWordConfigViewController.cancelHandler), for: .touchDown)
        self.okButton.addTarget(self, action: #selector(ReciteWordConfigViewController.okHandler), for: .touchDown)
    }
    
    
    private func setItem(item:ReciteWordConfig){
         countTextFile.text = "\(item.reciteNumberPerDay ?? 0)"
    }
   
    
    @objc private func okHandler(){
        guard let reciteWordConfig = MyReciteWordConfig.instance.getFromCache() else{
             self.dismiss(animated: true, completion: nil)
            return
        }
        guard let user = UserDataCache.instance.getFromCache() else{
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let number = StringUtil.exceptEmpty(self.countTextFile.text) else{
            return
        }
        
        Service.put(path: "reciteWordConfig/updateReciteNumberPerDay?userId=\(user.id ?? "")&number=\(number)"){(results) in
            
            reciteWordConfig.reciteNumberPerDay = Int(number)
            MyReciteWordConfig.instance.cacheData(data: reciteWordConfig)
            if let delegate = self.refreshDelegate{
                delegate.refresh()
            }
             self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc private func cancelHandler(){
        self.dismiss(animated: true, completion: nil)
    }
}
