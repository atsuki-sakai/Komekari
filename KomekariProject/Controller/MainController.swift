//
//  MainController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "MainTableCell"

class MainController: UIViewController{

    //MARK: - Properties
    
    var user: User? {
        didSet{
            configureUI()
            guard let user = self.user else { return }
            
            let myPageController = MyPageController()
            myPageController.user = user
            
            let favoriteController = FavoriteController()
            favoriteController.user = user
        }
    }
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        return sc
    }()
    private var items: [Item] = []
    private var resultItems: [Item] = []
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.searchTextField.text!.isEmpty
    }
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let refreshController = UIRefreshControl()
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkFormStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(Title: "KOMEKARI", prefersLargeTitle: false)
    }
    
    //MARK: - Selectors
    
    @objc func handleShowsCancelButton() {
        self.searchController.searchBar.showsCancelButton = inSearchMode
    }
    
    @objc func handleDownloadItem() {
        fetchItemsInFirestore { (finished) in
            if finished {
                self.refreshController.endRefreshing()
            }
        }
    }

    //MARK: - SetUp UI
    
    fileprivate func configureUI() {
        
        fetchItemsInFirestore { (_) in }
        configureSearchBar()
        configureTableView()
    }
    
    fileprivate func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 380
        tableView.register(MainTableCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleDownloadItem), for: .valueChanged)
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    fileprivate func configureSearchBar() {
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = false
        
        searchController.searchBar.searchTextField.addTarget(self, action: #selector(handleShowsCancelButton), for: .touchUpInside)
        searchController.searchBar.placeholder = "商品名で検索"
        searchController.searchBar.tintColor = .systemPink
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .black
            textField.backgroundColor = .lightText
            textField.tintColor = .white
        }
    }
    
    //MARK: - Helpers
    func checkFormStates() {
        
        if Auth.auth().currentUser?.uid != nil && Auth.auth().currentUser?.isEmailVerified == true{
            if let localUser = getLocalUser() {
                self.user = localUser
                print("get Local User")
                return 
            }
            AuthService.shared.fetchUser(uid: AuthService.currentnUid()!) { (error, user) in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                    return
                }
                guard let user = user else { return }
                self.user = user
                saveUserLocalDataBase(userDictionary: userDictionaryFrom(user: user))
            }
        }else{
            DispatchQueue.main.async {
                let controller = SignInController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - API
    
    fileprivate func fetchItemsInFirestore(completion:@escaping(Bool) -> Void){
        
        let requestCount = 20
        FirebaseCollectionRef(.Item).limit(to: requestCount).getDocuments { (snapShot, error) in
            if let error = error {
                print("Error: MainController=>API, Error",error.localizedDescription)
                completion(false)
                return
            }
            self.items.removeAll()
            guard let snapShot = snapShot else { return }
            let itemsDictionary = snapShot.documents
            itemsDictionary.forEach { (itemDictionary) in
                self.items.append(Item(_dictionary: itemDictionary.data() as NSDictionary))
            }
            self.tableView.reloadData()
            completion(true)
        }
    }
}

extension MainController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        resultItems = items.filter({ (item) -> Bool in
            return item.itemName.contains(searchText) || item.description.contains(searchText)
        })
        self.tableView.reloadData()
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inSearchMode ? resultItems.count: items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MainTableCell
        cell.item = inSearchMode ? resultItems[indexPath.row] : items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let item = inSearchMode ? resultItems[indexPath.row] : items[indexPath.row]
        let controller = ItemDetailController(item: item, nibName: nil, bundle: nil)
        present(controller, animated: true, completion: nil)
    }
    
}

