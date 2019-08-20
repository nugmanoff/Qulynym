/*
* Kulynym
* QuizViewController.swift
*
* Created by: Metah on 7/31/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import UIKit

#warning("cell border color")

protocol QuizViewControllerProtocol: class {
    var categoryName: String { get set }
    var randomCard: String { get set }
    var cards: [String]! { get set }
    
    func returnCellState(_ cellIndex: Int)
    func shuffleCards()
}

class QuizViewController: UIViewController, QuizViewControllerProtocol {
    // MARK:- Properties
    var categoryName = "" {
        didSet {
            AudioPlayer.setupExtraAudio(with: categoryName + "Q", audioPlayer: .question)
        }
    }
    var randomCard = "" {
        didSet {
            AudioPlayer.setupExtraAudio(with: randomCard, audioPlayer: .content)
        }
    }
    var cards: [String]!    
    var presenter: QuizPresenterProtocol!
    weak var itemView: ItemViewControllerProtocol!
    
    private var cardsCollectionView: UICollectionView!
    private var closeBtn: UIButton!
    private var soundsBtn: UIButton!
    
    private var quizView: QuizViewProtocol!
    private var configurator: QuizConfiguratorProtocol = QuizConfigurator()
    
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        initView()
        quizView.setupLayout()
        assignViews()
        setupCV()
        assignActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.setCards()
        presenter.getRandom()
        presenter.playAudio()
    }
    
    
    // MARK:- Layout
    private func initView() {
        quizView = QuizView(view)
    }
    
    private func assignViews() {
        self.cardsCollectionView = quizView.cardsCollectionView
        self.closeBtn = quizView.closeBtn
        self.soundsBtn = quizView.soundsButton
    }
    
    private func setupCV() {
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
    }
    
    
    // MARK:- Actions
    private func assignActions() {
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        soundsBtn.addTarget(self, action: #selector(soundsBtnPressed), for: .touchUpInside)
    }
    
    @objc
    private func closeBtnPressed() {
        presenter.closeView()
    }
    
    @objc
    private func soundsBtnPressed() {
        presenter.playAudio()
    }
}

extension QuizViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath) as! ImageCollectionViewCell
        cell.imageName = cards[indexPath.row]
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        let indexOfRandCard = cards.firstIndex(of: randomCard)
        if indexPath.row == indexOfRandCard {
            presenter.deleteItem()
            cell!.layer.borderWidth = 5
            cell!.layer.borderColor = UIColor.green.cgColor
        } else {
            presenter.backToItemWithRepeat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.4, height: view.frame.width * 0.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let distance = (view.frame.width - view.frame.width * 0.8) / 3
        return UIEdgeInsets(top: 40, left: distance, bottom: 40, right: distance)
    }
}

extension QuizViewController {
    // MARK:- Protocol Methods
    func returnCellState(_ cellIndex: Int) {
        let indexPath = IndexPath(item: cellIndex, section: 0)
        let cell = cardsCollectionView.cellForItem(at: indexPath)
        cell!.layer.borderColor = UIColor.white.cgColor
    }
    
    func shuffleCards() {
        self.cards = cards.shuffled()
        self.cardsCollectionView.reloadData()
    }
}