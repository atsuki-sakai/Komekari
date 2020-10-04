//
//  Extensions.swift
//  reservationApp
//
//  Created by 酒井専冴 on 2020/08/29.
//  Copyright © 2020 atsuki_sakai. All rights reserved.
//

import UIKit
import JGProgressHUD

//MARK: - UIView

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0, padddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, paddingBottom: CGFloat = 0, height: CGFloat? = nil, width: CGFloat? = nil) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: padddingLeft).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func returnAnchors(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat = 0, padddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, paddingBottom: CGFloat = 0, height: CGFloat? = nil, width: CGFloat? = nil) -> [NSLayoutConstraint] {
        
        var anchors = [] as! [NSLayoutConstraint]
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            let topAnchor = self.topAnchor.constraint(equalTo: top, constant: paddingTop)
            anchors.append(topAnchor)
        }
        if let left = left {
            let leftAnchor = self.leftAnchor.constraint(equalTo: left, constant: padddingLeft)
            anchors.append(leftAnchor)
        }
        if let right = right {
            let rightAnchor = self.rightAnchor.constraint(equalTo: right, constant: paddingRight)
            anchors.append(rightAnchor)
        }
        if let bottom = bottom {
            let bottomAnchor = self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom)
            anchors.append(bottomAnchor)
        }
        if let height = height {
            let heightAnchor = self.heightAnchor.constraint(equalToConstant: height)
            anchors.append(heightAnchor)
        }
        if let width = width {
            let widthAnchor = self.widthAnchor.constraint(equalToConstant: width)
            anchors.append(widthAnchor)
        }
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    func setDimension(height: CGFloat, widht: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.widthAnchor.constraint(equalToConstant: widht).isActive = true
    }
    
    func centerX(inView: UIView, constant: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: inView.centerXAnchor, constant: constant).isActive = true
    }
    
    func centerY(inView: UIView, constant: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: inView.centerYAnchor, constant: constant).isActive = true
    }
    
    func setHeight(height:CGFloat) {
        
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}


//MARK: - UIViewController

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func showloader(_ show: Bool, withText: String? = "Loading") {
        
        UIViewController.hud.textLabel.text = withText
        
        if show {
            UIViewController.hud.show(in: view)
        }else{
            UIViewController.hud.dismiss(animated: true)
        }
    }
    
    func showHud(error: Bool, title: String, Description: String? = nil, delay: Double = 2.0) {
        
        if error {
            UIViewController.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        }else{
            UIViewController.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        UIViewController.hud.show(in: view)
        UIViewController.hud.textLabel.text = title
        UIViewController.hud.detailTextLabel.text = Description
        UIViewController.hud.dismiss(afterDelay: delay)
        
    }
    
    func checkHasConnection() {
        if !Reachabilty.HasConnection(){
            let error = CustomError.notConnection
            self.messageAlert(title: "通信エラー", message: error.localizedDescription, completion: nil)
            return
        }
    }
    
    func errorAlert(message: String, title: String = "Error") {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func messageAlert(title: String, message: String, completion:((UIAlertAction) -> Void)?) {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: completion)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func gradintBGColor(inView: UIView,topColor:UIColor, bottomColor: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = inView.frame
        
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        inView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureNavigationBar(Title: String, prefersLargeTitle: Bool, bgColor: UIColor = .white, titleColor: UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), tintColor: UIColor = .systemBlue) {
        
        let apperarance = UINavigationBarAppearance() // Appearance: NavigationBarの外観を変更するオブジェクト
        
        apperarance.configureWithOpaqueBackground()
        apperarance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        apperarance.backgroundColor = bgColor
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitle
        navigationController?.navigationBar.backgroundColor = bgColor
        navigationItem.title = Title
        
        navigationController?.navigationBar.standardAppearance = apperarance
        navigationController?.navigationBar.compactAppearance = apperarance
        navigationController?.navigationBar.scrollEdgeAppearance = apperarance
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = true
        
        //iphoneの時間、電波、wifiの表示が白or黒
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
    }
}

extension UIImage {
    
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
}


//MARK: - Public Functions

func getCurrentTime() -> String {
    
    let formatter = DateFormatter()
    let date = Date()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.locale = Locale(identifier: "ja_JP")
    formatter.dateFormat = "MM/dd/H時m分"
    
    return formatter.string(from: date)
    
}
