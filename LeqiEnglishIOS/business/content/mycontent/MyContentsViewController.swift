//
//  MyContentsViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/15.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class MyContentsViewController: UIViewController {
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var rootView: UIView!
    
    private lazy var pageTitleView:PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TITLE_VIEW_HEIGHT)
        let titles=["已完成" , "未完成"]
        let pageTitleView = PageTitleView(frame:titleFrame,titles:titles)
        pageTitleView.pageTitleViewDelegate = self
        return pageTitleView
        }()
    
    
    private lazy var pageContentView:PageContentView = { [weak self] in
        let contentViewH:CGFloat = SCREEN_HEIGHT - (STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+TITLE_VIEW_HEIGHT)
        
        let frame = CGRect(x: 0, y: TITLE_VIEW_HEIGHT, width: SCREEN_WIDTH, height: contentViewH)
        
        var childVCS = [UIViewController]()
        
        
        let unrecite = ContentListViewController()
        self?.loadUnRecitedData(unrecite)
        unrecite.delegate = self
        childVCS.append(unrecite)
        
        
        let hasRecite = ContentListViewController()
        hasRecite.delegate = self
        self?.loadHasRecitedData(hasRecite)
        childVCS.append(hasRecite)
        
        
        let pageContentView = PageContentView(frame: frame, childVCs: childVCS, parentVC: self)
        
        pageContentView.delegate = self
        
        return pageContentView
        }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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

extension MyContentsViewController:ContentListViewControllerDelegate{
    func selected(contentListViewController:ContentListViewController,_ content: Content) {
        let vc = ContentInfoViewController()
        self.present(vc, animated: true, completion: {
            vc.content = content
        })
    }
    
    func addMoreDatas(contentListViewController:ContentListViewController,finished:(_ contents:[Content])->Void){
        
    }
    
}

extension MyContentsViewController{
    private func setUI(){
        rootView.addSubview(pageTitleView)
        
        rootView.addSubview(pageContentView)
        navigation()
    }
    
    private func loadHasRecitedData(_ contentListView:ContentListViewController){
       loadData(contentListView,path: "english/content/findUserReciting")
    }
    
    private func loadUnRecitedData(_ contentListView:ContentListViewController){
        
        loadData(contentListView,path: "english/content/findUserRecited")
    }
    
    private func loadData(_ contentListView:ContentListViewController , path:String){
        guard let user = UserDataCache.instance.getFromCache() else{
            return
        }
        
        guard let userId = user.id else {
            return
        }
        
        ContentsDataCatche(path: "\(path)?userId=\(userId)").load(){
            (contents) in
            contentListView.datas = contents
        }
    }
    
    
    private func navigation(){
        self.back.action = #selector(MyContentsViewController.backEventHandler)
    }
    
    //返回
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension MyContentsViewController : PageTitleViewDelegate{
    func pageTitleView(pageTitleView: PageTitleView, selectIndex index: Int) {
        
        pageContentView.setPageIndex(index: index)
    }
}

//MARK: 实现PageContentViewDelegate
extension MyContentsViewController:PageContentViewDelegate{
    func pageContentView(pageContentView: PageContentView, progress: CGFloat, sourceIdex: Int, targetIndex: Int) {
        pageTitleView.moveScrollLine(progress: progress, sourceIndex: sourceIdex, targetIndex: targetIndex)
    }
}
