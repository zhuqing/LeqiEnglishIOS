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
    override func viewDidLoad() {
        super.viewDidLoad()
        initEventListner()
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
        MyReciteWordConfig.myReciteWordConfig.load(){(reciteWordConfig) in
            
        }
    }
    
    private func initEventListner(){
        startWriteButton.addTarget(self, action: #selector(MyReciteWordInfoViewController.startWriteEventHandler), for: .touchDown)
        
        startReciteButton.addTarget(self, action: #selector(MyReciteWordInfoViewController.startReciteEventHandler), for: .touchDown)
    }
    
    //开始背诵
    @objc private func startReciteEventHandler(){
       let vc = ReciteWordViewController()
        
       self.present(vc, animated: true, completion: nil)
    }
    //开始默写
    @objc private func startWriteEventHandler(){
        
    }
}
