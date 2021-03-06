 /*
* Qulynym
* DrawingsCollectionView.swift
*
* Created by: Metah on 8/5/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
 */

import UIKit

class DrawingsCollectionView: QulynymVC {
    // MARK:- Properties
    var pictures = ["whiteCanvas", "flowerDrawing", "penguinDrawing", "catterpilarDrawing", "butterflyDrawing"]
    weak var drawingView: DrawingViewControllerProtocol!
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.layer.zPosition = 1
        btn.setImage(UIImage(named: "torg'aiClose"), for: .normal)
        btn.addTarget(self, action: #selector(exitFromMenu), for: .touchUpInside)
        return btn
    }()
    private lazy var mainCollectionView: UICollectionView = {
        return configureImagesCollectionView(scroll: .vertical, background: .white)
    }()
    private lazy var invisibleButtonToExit: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        view.addSubview(mainCollectionView)
        view.addSubview(closeBtn)
//        view.addSubview(invisibleButtonToExit)
        setupCollectionView()
        setupAppearence()
        setAutoresizingToFalse()
        activateConstraints()
    }
    
    private func setupCollectionView() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    private func setupAppearence() {
        view.layer.zPosition = 1
        view.backgroundColor = .white
        
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
    }
    
    private func setAutoresizingToFalse() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false 
        }
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            closeBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            closeBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
            closeBtn.heightAnchor.constraint(equalTo: closeBtn.widthAnchor),
            
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.topAnchor.constraint(equalTo: closeBtn.bottomAnchor, constant: 8),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    // MARK:- Methods
    @objc
    private func exitFromMenu() {
        drawingView.closeMenu()
    }
}

extension DrawingsCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK:- UICollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        
        if indexPath.row == 0 {
            cell.image = UIImage(named: "noDrawing")
        } else {
            cell.image = UIImage(named: pictures[indexPath.row])
            
            cell.layer.borderColor = UIColor(red: 0.4, green: 0.2, blue: 0, alpha: 1).cgColor
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true 
            cell.constant = 5
            cell.layer.borderWidth = 2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let constant = collectionView.frame.width * 0.7
        return CGSize(width: constant, height: constant)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            drawingView.currentImageName = nil
        }
        drawingView.currentImageName = pictures[indexPath.row]
        drawingView.closeMenu()
        drawingView.clearCanvas()
    }
}

