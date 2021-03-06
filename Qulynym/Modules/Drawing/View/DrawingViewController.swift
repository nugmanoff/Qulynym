/*
 * Qulynym
 * DrawingViewController.swift
 *
 * Created by: Metah on 5/30/19
 *
 * Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

protocol DrawingViewControllerProtocol: class {
    var currentImageName: String? { get set }
    var selectedTool: UIButton! { get set }
    
    func clearCanvas()
    func closeMenu()
}

class DrawingViewController: QulynymVC, DrawingViewControllerProtocol {
    // MARK:- Properties
    var presenter: DrawingPresenterProtocol!
    
    var currentImageName: String? {
        didSet {
            updateImage()
        }
    }
        
    lazy var colors: [UIColor] = [.red, .orange, .yellow, .green, whiteBlue, .blue, .purple, .brown, .black]
    private let whiteBlue = UIColor(red: 102/255, green: 1, blue: 1, alpha: 1)

    private var drawingView: DrawingViewProtocol!
    private weak var closeBtn: UIButton!
    private weak var toolsCV: UICollectionView!
    private weak var pictureImageView: UIImageView!
    private weak var canvasView: CanvasViewProtocol!
    private weak var resetBtn: UIButton!
    private weak var slideOutBtn: UIButton!
    private weak var marker: UIButton!
    private weak var pencil: UIButton!
    private weak var brush: UIButton!
    private weak var eraser: UIButton!
    
    private let configurator: DrawingConfiguratorProtocol = DrawingConfigurator()
    
    private var previousColor: UIColor?
    private var previousTool: UIButton?
    var selectedTool: UIButton! {
        didSet {
            previousTool = oldValue
            movePreviousToolDown()
        }
    }
    
    
    // MARK:- Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Home Indicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        initLayout()
        drawingView.setupLayout()
        assignViews()
        setupCV()
        assignActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedTool = pencil
        moveUp(tool: pencil)
        setupDrawingLineComponents()
    }
    
    
    // MARK:- Layout
    private func initLayout() {
        drawingView = DrawingView(self)
    }
    
    private func assignViews() {
        self.closeBtn = drawingView.closeBtn
        self.toolsCV = drawingView.toolsCollectionView
        self.pictureImageView = drawingView.drawingImageView
        self.canvasView = drawingView.canvasView
        self.resetBtn = drawingView.resetBtn
        self.slideOutBtn = drawingView.slideOutBtn
        self.marker = drawingView.marker
        self.pencil = drawingView.pencil
        self.brush = drawingView.brush
        self.eraser = drawingView.eraser
    }
    
    private func setupCV() {
        toolsCV.delegate = self
        toolsCV.dataSource = self
    }
    
    private func updateImage() {
        guard let name = currentImageName else {
            pictureImageView.image = nil
            return
        }
        pictureImageView.image = UIImage(named: name)
    }
    
    func moveUp(tool: UIButton) {
        UIView.animate(withDuration: 0.4) {
            tool.transform = CGAffineTransform(translationX: 0, y: -20)
        }
    }
    
    func moveDown(tool: UIButton) {
        UIView.animate(withDuration: 0.4) {
            tool.transform = CGAffineTransform(translationX: 0, y: 20)
        }
    }
    
    func setupDrawingLineComponents() {
        if selectedTool == eraser {
            canvasView.brushWidth = 25
            canvasView.color = .white
            return
        }
        if canvasView.color == .white {
            canvasView.color = previousColor ?? .red
        }
        if selectedTool == brush {
            canvasView.brushWidth = view.frame.height * 0.04
            canvasView.color = canvasView.color.withAlphaComponent(1)
        } else if selectedTool == pencil {
            canvasView.brushWidth = view.frame.height * 0.007
            canvasView.color = canvasView.color.withAlphaComponent(0.7)
        } else {
            canvasView.brushWidth = view.frame.height * 0.02
            canvasView.color = canvasView.color.withAlphaComponent(0.5)
        }
    }
    
    private func toolsCVItemSize() -> CGSize {
        if traitCollection.verticalSizeClass == .compact {
            return CGSize(width: toolsCV.frame.height - 20, height: toolsCV.frame.height - 20)
        } else {
            return CGSize(width: toolsCV.frame.height * 0.6, height: toolsCV.frame.height * 0.6)
        }
    }
    
    
    
    // MARK:- Actions
    private func assignActions() {
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        resetBtn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        slideOutBtn.addTarget(self, action: #selector(slideOut), for: .touchUpInside)
        marker.addTarget(self, action: #selector(markerBtnPressed), for: .touchUpInside)
        pencil.addTarget(self, action: #selector(pencilBtnPressed), for: .touchUpInside)
        brush.addTarget(self, action: #selector(brushBtnPressed), for: .touchUpInside)
        eraser.addTarget(self, action: #selector(eraserBtnPressed), for: .touchUpInside)
        
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        touchGesture.cancelsTouchesInView = false 
        view.addGestureRecognizer(touchGesture)
    }
    
    func movePreviousToolDown() {
        if previousTool != nil && previousTool != selectedTool {
            moveDown(tool: previousTool!)
        }
    }
    
    @objc
    func brushBtnPressed() {
        closeMenu()
        moveUp(tool: brush)
        selectedTool = brush
        setupDrawingLineComponents()
    }
    
    @objc
    func pencilBtnPressed() {
        closeMenu()
        moveUp(tool: pencil)
        selectedTool = pencil
        setupDrawingLineComponents()
    }
    
    @objc
    func markerBtnPressed() {
        closeMenu()
        moveUp(tool: marker)
        selectedTool = marker
        setupDrawingLineComponents()
    }
    
    @objc
    func eraserBtnPressed() {
        closeMenu()
        moveUp(tool: eraser)
        if canvasView.color != .white {
            previousColor = canvasView.color
        }
        selectedTool = eraser
        setupDrawingLineComponents()
    }
    
    @objc
    private func closeBtnPressed() {
        presenter.closeView()
    }
    
    @objc
    func closeMenu() {
        if drawingView.isOpen == true {
            drawingView.toggleDrawingsCV()
        }
    }
    
    @objc
    private func slideOut() {
        drawingView.toggleDrawingsCV()
    }
    
    @objc
    private func reset() {
        closeMenu() 
        canvasView.clear()
    }
}


extension DrawingViewController {
    func clearCanvas() {
        canvasView.clear()
    }
}


extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectionView Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        
        if indexPath.row < 2 || indexPath.row > 4 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = .black
        }
        cell.imageView.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = cell.frame.width * 0.5
        cell.clipsToBounds = true 
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return toolsCVItemSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedTool != eraser else { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        UIView.animate(withDuration: 0.1, animations: {
            cell.imageView.backgroundColor = self.colors[indexPath.row].withAlphaComponent(0.5)
        }, completion: { _ in
            cell.imageView.backgroundColor = self.colors[indexPath.row]
        })
        closeMenu()
        canvasView.color = colors[indexPath.row]
        setupDrawingLineComponents()
        AudioPlayer.setupExtraAudio(with: "bloop", audioPlayer: .effects)
    }
}

