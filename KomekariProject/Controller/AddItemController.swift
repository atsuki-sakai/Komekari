//
//  AddItemController.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/09/21.
//

import UIKit
import Gallery

private let reuseIdentifier = "ImageCell"

class AddItemController: UIViewController {
    
    //MARK: - Properties
    
    var gallery: GalleryController!
    private var itemImages: [UIImage?] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 70, height: 70)
        layout.headerReferenceSize = CGSize(width: 0, height: 12)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ItemCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView
    }()
    
    private let addImageButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("商品画像を選択", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleShowGallery), for: .touchUpInside)
        button.backgroundColor = .systemTeal
        return button
    }()
    
    private let itemNameInputView: InputContainerView = {
        let tf = CustomTextField(placeHolder: "商品名", type: .namePhonePad)
        let view = InputContainerView(image: UIImage(systemName: "leaf")!, textField: tf)
        view.setHeight(height: 50)
        return view
    }()
    
    private let priceInputView: InputContainerView = {
        
        let tf = CustomTextField(placeHolder: "販売価格", type: .decimalPad)
        let view = InputContainerView(image: UIImage(systemName: "yensign.circle")!, textField: tf)
        view.setHeight(height: 50)
        return view
    }()
    
    private let instockInputView: InputContainerView = {
        
        let tf = CustomTextField(placeHolder: "在庫数", type: .decimalPad)
        let view = InputContainerView(image: UIImage(systemName: "seal")!, textField: tf)
        view.setHeight(height: 50)
        return view
    }()
    
    private let descriptionTextView: UITextView = {
        
        let tv = UITextView()
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "商品説明"
        placeHolderLabel.textColor = .lightGray
        tv.addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: tv.topAnchor, left: tv.leftAnchor, paddingTop: 4, padddingLeft: 4)
        tv.setHeight(height: 150)
        return tv
    }()
    
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Selectors
    
    @objc func handleDismisable() {
        
        print("dismiss view")
    }
    
    @objc func handleShowGallery() {
        
        showImageGallery()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 50
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - SetUp UI
    fileprivate func configureUI() {
        
        view.backgroundColor = .white
        configureNavigationBar()
        configureAddImageButton()
        configureCollectionView()
        configureAddImageButton()
        
        
        let stack = UIStackView(arrangedSubviews: [itemNameInputView, descriptionTextView, priceInputView, instockInputView])
        
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, padddingLeft: 16, paddingRight: -16)
        
    }
    
    fileprivate func configureNavigationBar() {
        configureNavigationBar(Title: "商品情報を入力", prefersLargeTitle: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismisable))
    }
    
    fileprivate func configureCollectionView() {
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.anchor(top: addImageButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: -16, padddingLeft: 16, paddingRight: -16, height: 120)
        
    }
    
    fileprivate func configureAddImageButton() {
        
        view.addSubview(addImageButton)
        addImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor, paddingTop: 12, padddingLeft: 64, paddingRight: -64)
        addImageButton.setHeight(height: 42)
    }
    
    fileprivate func setUpNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Helpers
    
    fileprivate func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab,.cameraTab]
        Config.Camera.imageLimit = 5
        
        self.present(gallery, animated: true, completion: nil)
    }
}

//MARK: - CollectionView Delegate

extension AddItemController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemImages.count == 0 ? 5: itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionCell
        
        if itemImages.count > 0 {
            cell.image = itemImages[indexPath.row]
        }else{
            cell.image = #imageLiteral(resourceName: "image")
        }
        return cell
    }
}

//MARK: - Gallery Delegate

extension AddItemController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        return
    }

    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        self.itemImages = []
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolveImages) in
                self.itemImages = resolveImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
   
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
