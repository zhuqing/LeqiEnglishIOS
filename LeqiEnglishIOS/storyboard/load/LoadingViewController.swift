//
//  LoadingViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/5.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var downLoadPersent: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    var callback:(()->())?
    
    var filePath:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load( path:String,callback:@escaping ()->()){
        self.callback = callback
        self.filePath = path
        load()
    }
    
    private func load(){
        guard let filePath = self.filePath else{
            return
        }
        
        Service.download(filePath: filePath, hasLoaded: {
            (precent) in
            self.progressView.setProgress(Float(precent), animated: true)
            self.downLoadPersent.text = "已下载\(Int(precent*100))%"
        }, finishedCallback:{
            (path) in
            if(self.callback != nil){
                self.callback!()
            }
        })
        
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
