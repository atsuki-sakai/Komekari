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
    
    var user: User? = getLocalUser()
    var gallery: GalleryController!
    var selectAreaIndex = 0
    private var imagesString: [String] = []
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
        tf.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let view = InputContainerView(image: UIImage(systemName: "leaf")!, textField: tf)
        view.setHeight(height: 32)
        return view
    }()
    
    private let priceInputView: InputContainerView = {
        
        let tf = CustomTextField(placeHolder: "販売価格", type: .decimalPad)
        tf.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let view = InputContainerView(image: UIImage(systemName: "yensign.circle")!, textField: tf)
        view.setHeight(height: 40)
        return view
    }()
    
    private let instockInputView: InputContainerView = {
        
        let tf = CustomTextField(placeHolder: "在庫数", type: .decimalPad)
        tf.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        let view = InputContainerView(image: UIImage(systemName: "seal")!, textField: tf)
        view.setHeight(height: 40)
        return view
    }()
    
    private lazy var sellerAreaPickerView: UIPickerView = {
        
        let prefecturePicker = UIPickerView()
        let label = UILabel()
        label.text = "発送地域 =>"
        prefecturePicker.addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.anchor(left: prefecturePicker.leftAnchor, padddingLeft: 12, width: 100)
        label.centerY(inView: prefecturePicker)
        prefecturePicker.setHeight(height: 120)
        return prefecturePicker
    }()
    
    private var textView: UITextView!
    private lazy var descriptionTextView: UIView = {
        
        let view = UIView()
        let lineView = UIView()
        textView = UITextView()
        
        let placeHolderLabel = UILabel()
        
        lineView.backgroundColor = .darkGray
        placeHolderLabel.text = "商品説明"
        placeHolderLabel.textColor = .black
        placeHolderLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        view.addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: view.topAnchor, left: view.leftAnchor)
        
        view.addSubview(lineView)
        lineView.anchor(top: placeHolderLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, height: 0.5)
        
        view.addSubview(textView)
        textView.anchor(top: lineView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 6)
        textView.inputAccessoryView = toolBar
        
        view.setHeight(height: 120)
        
        return view
    }()
    
    private let toolBar: UIToolbar = {
        
        let toolBar = UIToolbar()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let dismissKeyBoardButton = UIBarButtonItem(title: "入力完了", style: .done, target: self, action: #selector(dismissKeyBoard))
        toolBar.setItems([dismissKeyBoardButton, flexibleItem], animated: true)
        toolBar.sizeToFit()
        return toolBar
    }()
   
    private lazy var addItemButton: UIButton = {
        
        let button = UIButton(type: .system)
        let titleString = NSMutableAttributedString(string: "未完了", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        button.setAttributedTitle(titleString, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSaveItem), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if user != nil {
            configureUI()
            if user?.onBoard == false{
                let controller = UINavigationController(rootViewController: AddressInputController())
                present(controller, animated: true, completion: nil)
            }else{
                print("completed User Address")
            }
        }else{
            DispatchQueue.main.async {
                let controller = SignInController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.user = getLocalUser()
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissView() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleShowGallery() {
        
        showImageGallery()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 120
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChanged(_ inputField: UITextField) {
        
        if itemNameInputView.tf.text != "" && priceInputView.tf.text != "" && instockInputView.tf.text != "" && self.itemImages.count > 0 {
            self.addItemButton.isEnabled = true
            let text = NSMutableAttributedString(string: "商品登録", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            self.addItemButton.setAttributedTitle(text, for: .normal)
            self.addItemButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
            self.addItemButton.backgroundColor = .systemGreen
        }else{
            let titleString = NSMutableAttributedString(string: "未完了", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            self.addItemButton.setAttributedTitle(titleString, for: .normal)
            self.addItemButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
            self.addItemButton.backgroundColor = .lightGray
            self.addItemButton.isEnabled = false
        }
    }
    
    @objc func handleSaveItem() {
      
        self.showloader(true)
        guard let user = self.user else { return }
        
        let item = Item(sellerId: user.id,
                        sellerName: user.userName,
                        sellerImage: user.icon,
                        price: Double(self.priceInputView.tf.text!)!,
                        inStock: Int(self.instockInputView.tf.text!)!,
                        itemName: self.itemNameInputView.tf.text!,
                        images: [],
                        description: self.textView.text!,
                        sellerArea: selectAreaIndex)
        ImageLoader.uploadImages(pathType: .Item, images: self.itemImages, uid: item.id) { (error, imageUrls) in
            
            if let error = error {
                self.errorAlert(message: error.localizedDescription)
                return
            }
            item.images = imageUrls
            
            FireAPI.saveItemToFireStore(item) { (error) in
                if let error = error {
                    self.errorAlert(message: error.localizedDescription)
                    return
                }
                self.showloader(false)
                self.messageAlert(title: "登録完了", message: "ありがとうございました。") { (_) in
                    self.itemImages = []
                    self.itemNameInputView.tf.text = ""
                    self.textView.text = ""
                    self.priceInputView.tf.text = ""
                    self.instockInputView.tf.text = ""
                    self.sellerAreaPickerView.numberOfRows(inComponent: 0)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    //MARK: - SetUp UI
    fileprivate func configureUI() {
        
        view.backgroundColor = .white
        configureNavigationBar()
        configureAddImageButton()
        configureCollectionView()
        configureAddImageButton()
        setUpNotification()
        setUpToolBar()
        
        
        let stack = UIStackView(arrangedSubviews: [itemNameInputView, descriptionTextView, priceInputView, instockInputView,sellerAreaPickerView])
        
        itemNameInputView.tf.delegate = self
        priceInputView.tf.delegate = self
        instockInputView.tf.delegate = self
        textView.delegate = self
        
        stack.axis = .vertical
        stack.spacing = 12
        view.addSubview(stack)
        stack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: -16, padddingLeft: 16, paddingRight: -16)
        
        view.addSubview(addItemButton)
        addItemButton.anchor(top: stack.bottomAnchor, left: stack.leftAnchor, right: stack.rightAnchor, paddingTop: 16)
        addItemButton.setHeight(height: 64)
        sellerAreaPickerView.delegate = self
        sellerAreaPickerView.dataSource = self
        
    }
    
    fileprivate func configureNavigationBar() {
        configureNavigationBar(Title: "商品情報を入力", prefersLargeTitle: false)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismissView))
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
    
    fileprivate func setUpToolBar() {
        
        itemNameInputView.tf.inputAccessoryView = toolBar
        priceInputView.tf.inputAccessoryView = toolBar
        instockInputView.tf.inputAccessoryView = toolBar
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

extension AddItemController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
    }
}

//MARK: - TextView Delegate

extension AddItemController: UITextViewDelegate {
    
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

extension AddItemController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Prefectures.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Prefectures.init(rawValue: row)?.description
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectAreaIndex = row
    }
}
