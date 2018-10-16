//
//  FeedbackViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/9.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var feedBackView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var connectField: UITextField!
    @IBOutlet weak var editRootView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setRootViewBorder()
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

extension FeedbackViewController{
    
    private func initListener(){
        self.commitButton.addTarget(self, action: #selector(FeedbackViewController.commit), for: .touchDown)
        
        self.closeButton.addTarget(self, action: #selector(FeedbackViewController.close), for: .touchDown)
    }
    
    @objc private func commit(){
        let suggestion = Suggestion()
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        suggestion.userId = user.id
        suggestion.contact = self.connectField.text
        suggestion.message = self.feedBackView.text
        
        Service.post(path: "suggestion/create",params: DictionaryUtil.toStringString(data: suggestion.toDictionary())){
            (results) in
            
            let alert = UIAlertController(title: "感谢您的建议", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: {(al) in
                self.close()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setRootViewBorder(){
        editRootView.layer.borderWidth = 1
        editRootView.layer.cornerRadius = 10
        editRootView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
