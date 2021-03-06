/*
* Qulynym
* Global Functions.swift
*
* Created by: Metah on 7/6/20
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

func setupPlaylistSlider(value: Int, secondColor: UIColor) -> UISlider {
    let slider = UISlider()
    
    slider.minimumTrackTintColor = .darkViolet
    slider.maximumTrackTintColor = secondColor
    slider.thumbTintColor = .white
    
    slider.minimumValue = 0
    slider.maximumValue = 1
    slider.setValue(Float(value), animated: false)
    
    return slider
}

func constraintSubviewToFitSuperview(subview: UIView, superview: UIView) {
    NSLayoutConstraint.activate([
        subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
        subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        subview.topAnchor.constraint(equalTo: superview.topAnchor),
        subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    ])
}

func configureImagesCollectionView(scroll direction: UICollectionView.ScrollDirection, background type: UIColor?) -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = direction
    
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    
    cv.backgroundColor = type
    
    cv.setCollectionViewLayout(layout, animated: false)
    cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
    
    cv.allowsMultipleSelection = false
    return cv
}

