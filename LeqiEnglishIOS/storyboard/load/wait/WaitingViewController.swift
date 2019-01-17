//
//  WaitingViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2019/1/17.
//  Copyright © 2019 zhuleqi. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    @IBOutlet weak var waitingView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        waitingView.startAnimating()
    }
    
    func close(){
        waitingView.stopAnimating()
        self.dismiss(animated: false, completion: nil)
    }

}
