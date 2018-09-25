//
//  ReciteWordViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/9/25.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ReciteWordViewController: UIViewController {

    @IBOutlet weak var wordNumber: UILabel!
    @IBOutlet weak var wordInfoRootView: UIView!
    @IBOutlet weak var startWriteButton: UIButton!
    @IBOutlet weak var startReciteButton: UIButton!
    @IBOutlet weak var back: UIBarButtonItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
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

extension ReciteWordViewController{
    private func navigation(){
        self.back.action = #selector(ReciteWordViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
}
