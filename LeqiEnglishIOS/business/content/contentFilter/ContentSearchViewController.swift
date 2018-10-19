//
//  ContentSearchViewController.swift
//  LeqiEnglishIOS
//
//  Created by zhuleqi on 2018/10/14.
//  Copyright © 2018年 zhuleqi. All rights reserved.
//

import UIKit

class ContentSearchViewController: UIViewController {
    @IBOutlet weak var catalogRootView: UIView!
    
    @IBOutlet weak var dataRootView: UIView!
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let contentListView = ContentListViewController()
    
    private var selectedContent:Content?
    
    
    private let allCatalog:Catalog = Catalog()
    
    private var catalogs = [Catalog]()
    
    private lazy var selectedCatalog = self.allCatalog
    
    private lazy var catalogCollectionView:UICollectionView  = {
    var layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 20, height: 40)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.showsVerticalScrollIndicator = true
    collectionView.isPagingEnabled = false
    collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    collectionView.bounces = false
    collectionView.backgroundColor = UIColor.white
    
    
    collectionView.contentInsetAdjustmentBehavior = .always
    collectionView.alwaysBounceVertical = true
    collectionView.register(UINib(nibName: "SimpleTextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY)
  
    
    
    return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ContentSearchViewController{
    
    private func setUI(){
        self.setCatalogView()
        self.setContentListView()
        initAllCatalog()
       
      
        loadCatalog()
        navigation()
        self.searchBar.delegate = self
        
        self.search("", catalog: self.allCatalog)
    }
    
  
    
    private func setContentListView(){
        
        contentListView.delegate = self
        self.dataRootView.addSubview(self.contentListView.view)
        contentListView.view.frame = dataRootView.bounds
        
        
    }
    
    private func setCatalogView(){
        self.catalogRootView.addSubview(self.catalogCollectionView)
        self.catalogCollectionView.frame = CGRect(x: 5, y: 0, width: SCREEN_WIDTH - 10, height: self.catalogRootView.frame.height)
        
    }
    
    private func initAllCatalog(){
        self.allCatalog.title = "全部"
        self.allCatalog.id = ""
        
        catalogs.append(self.allCatalog)
        self.catalogCollectionView.reloadData()
    }
    
    private func loadCatalog(){
        CatalogDataCache.instance.load(finished: {
            (catalogs) in
            self.catalogs.append(contentsOf: catalogs!)
            self.catalogCollectionView.reloadData()
           
            
        })
    }
    
    //根据文本和分类搜索Content
    private func search(_ text:String,catalog:Catalog){
        let cache =  ContentsDataCatche(path:"english/content/findContentsByCatalogIdAndTitle?title=\(text)&catalogId=\(catalog.id ?? "")")
        
        cache.load(finished: {
            (contents) in
                self.contentListView.datas = contents
            
        })
    }
    
    private func navigation(){
        self.back.action = #selector(ContentSearchViewController.backEventHandler)
    }
    
    @objc private func backEventHandler(){
        self.dismiss(animated: true, completion: nil)
    }
}



//MARK:UISearchBarDelegate
extension ContentSearchViewController:UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(self.searchBar.text!,catalog: selectedCatalog)
    }
    
}

//MARK:ContentListViewDelegate
extension ContentSearchViewController: ContentListViewControllerDelegate{
    func addMoreDatas(contentListViewController:ContentListViewController,finished: ([Content]) -> Void) {
        finished([Content]())
    }
    
    func selected(contentListViewController:ContentListViewController,_ content: Content) {
        let vc = ContentInfoViewController()
        ContentInfoViewController.isMyRecite = false
        self.present(vc, animated: true, completion: {
            vc.content = content
        })
    }
}

extension ContentSearchViewController :UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      self.selectedCatalog = self.catalogs[indexPath.item]
        let cell = self.catalogCollectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
        cell.selectCell()
        
        search(searchBar.text!,catalog: selectedCatalog)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.catalogCollectionView.cellForItem(at: indexPath) as! SimpleTextCollectionViewCell
        cell.deselectCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.catalogs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:SimpleTextCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleTextCollectionViewCell.SIMPLE_TEXT_CELL_INDENTIFY, for: indexPath) as! SimpleTextCollectionViewCell
        //   cell.backgroundColor = UIColor.blue
        let catalog = self.catalogs[indexPath.item]
        cell.setText(catalog.title!)
        if catalog.id! == selectedCatalog.id!{
            cell.selectCell()
        }
        return cell
    }
}
