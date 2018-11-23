//
//  MyReciteWordInfoViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/27.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyReciteWordInfoViewController: UIViewController {

   
    @IBOutlet weak var startWriteButton: UIButton!
    @IBOutlet weak var startReciteButton: UIButton!
    @IBOutlet weak var changReciteConfigButton: UIButton!
    @IBOutlet weak var hasReciteInfoLabel: UILabel!
    @IBOutlet weak var back: UIBarButtonItem!
    
    var reciteWordConfig:ReciteWordConfig?
    
    
    
    var LOG = LOGGER("MyReciteWordInfoViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initEventListner()
        loadData()
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

extension MyReciteWordInfoViewController{
    private func loadData(){
        MyReciteWordConfig.instance.load(){(reciteWordConfig) in
            guard let rwc = reciteWordConfig else{
                 self.hasReciteInfoLabel.text = "已经完成背诵0/0"
                return
            }
            self.reciteWordConfig = reciteWordConfig
            self.hasReciteInfoLabel.text = "已经完成背诵\(rwc.hasReciteNumber ?? 0 )/\(rwc.myWordsNumber ?? 0)"
        }
    }
    

    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func initEventListner(){
         self.startWriteButton.addTarget(self, action: #selector(MyReciteWordInfoViewController.startWriteEventHandler), for: .touchDown)
        
         self.startReciteButton.addTarget(self, action: #selector(MyReciteWordInfoViewController.startReciteEventHandler), for: .touchDown)
        
         self.back.action = #selector(MyReciteWordInfoViewController.backEventHandler)
        
        self.changReciteConfigButton.addTarget(self, action: #selector(MyReciteWordInfoViewController.changeReciteCountEventHandler), for: .touchDown)
    }
    
    @objc private func changeReciteCountEventHandler(){
        let alert = ReciteWordConfigViewController()
       // alert.alert
        alert.modalPresentationStyle = .overCurrentContext
       
        self.present(alert, animated: true, completion:{
            alert.refreshDelegate = self
            alert.rectieWordConfig = self.reciteWordConfig
        })
        
    }
    
    //开始背诵
    @objc private func startReciteEventHandler(){
       let vc = ReciteWordViewController()
        
       self.present(vc, animated: true, completion: nil)
    }
    //开始默写
    @objc private func startWriteEventHandler(){
        let vc = WriteWordViewController()
      
        self.present(vc, animated: true){
            vc.loadwords()
        }
    }
}

extension MyReciteWordInfoViewController :RefreshDataCacheDelegate{
    func clearnCacheThenRefresh() {
         MyReciteWordConfig.instance.claerData()
        refresh()
    }
    
    func refresh() {
        loadData()
    }
}
