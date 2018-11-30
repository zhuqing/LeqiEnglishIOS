//
//  SegmentWordViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/11/24.
//  Copyright © 2018 zhuleqi. All rights reserved.
//

import UIKit

class SegmentWordViewController: UIViewController {
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var rootView: UIView!
    
    private var wordListView:WordListSimpleViewController =  WordListSimpleViewController()
    private var shortWordListView:ShortWordsSampleViewController = ShortWordsSampleViewController()
    
    
    //当前查看的Segment
    var currentSegment:Segment?{
        didSet{
            self.loadShortWords(shortWordListView)
            self.loadWordInSegment(wordListView)
        }
    }
    
    private lazy var pageTitleView:PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: TITLE_VIEW_HEIGHT)
        let titles=["单词" , "短语"]
        let pageTitleView = PageTitleView(frame:titleFrame,titles:titles)
        pageTitleView.pageTitleViewDelegate = self
        return pageTitleView
        }()
    
    
    
    private lazy var pageContentView:PageContentView = { [weak self] in
        let contentViewH:CGFloat = SCREEN_HEIGHT - (STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT+TITLE_VIEW_HEIGHT)
        
        let frame = CGRect(x: 0, y: TITLE_VIEW_HEIGHT, width: SCREEN_WIDTH, height: contentViewH)
        
        var childVCS = [UIViewController]()
        
        
     //  self?.wordListView = WordListSimpleViewController()
        self?.loadWordInSegment((self?.wordListView)!)
        childVCS.append((self?.wordListView)!)
        
        
       // let shortWordsSampleViewController = ShortWordsSampleViewController()
        self?.loadShortWords(shortWordListView)
        childVCS.append(shortWordListView)
        
        
        let pageContentView = PageContentView(frame: frame, childVCs: childVCS, parentVC: self)
        
        pageContentView.delegate = self
        
        return pageContentView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation()
        setupUI()
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
    
    
    private func navigation(){
        self.back.action = #selector(SegmentWordViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension SegmentWordViewController{
    private func setupUI(){
        
        // automaticallyAdjustsScrollViewInsets = false
        
        rootView.addSubview(pageTitleView)
        
        rootView.addSubview(pageContentView)
    }
    
    private func loadData(){
        
    }
    
    private func loadWordInSegment(_ wordListSimpleViewController:WordListSimpleViewController){
        guard let segment = self.currentSegment else{
            return
        }
       let cache =   WordsInSegmentDataCache(entity: segment)
        
        cache.load(finished: {
            (words) in
            wordListSimpleViewController.wordList = words
        })
    }
    
    private func loadShortWords(_ shortWordsSampleViewController:ShortWordsSampleViewController){
        //    wordListViewController.navigationBar.isHidden = true
        guard let segment = self.currentSegment else{
            return
        }
       let cache = ShortWordsInSegmentDataCache(entity: segment)
        
        cache.load(finished: {
            (shortWords) in
            shortWordsSampleViewController.shortWords = shortWords
        })
    }
}


extension SegmentWordViewController :PageTitleViewDelegate {
    func pageTitleView(pageTitleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setPageIndex(index: index)
    }
}

//MARK: 实现PageContentViewDelegate
extension SegmentWordViewController:PageContentViewDelegate{
    func pageContentView(pageContentView: PageContentView, progress: CGFloat, sourceIdex: Int, targetIndex: Int) {
        pageTitleView.moveScrollLine(progress: progress, sourceIndex: sourceIdex, targetIndex: targetIndex)
    }
}

