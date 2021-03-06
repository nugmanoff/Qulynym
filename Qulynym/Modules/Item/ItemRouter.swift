/*
 * Qulynym
 * ItemRouter.swift
 *
 * Created by: Metah on 2/24/19
 *
 * Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation
import UIKit

protocol ItemRouterProtocol: class {
    func closeView()
    func openQuiz(_ cards: [String], with categoryName: String, and count: Int)
}

class ItemRouter {
    // MARK:- Properties
    weak var controller: ItemViewController!
    
    required init(_ controller: ItemViewController) {
        self.controller = controller
    }
}

extension ItemRouter: ItemRouterProtocol {
    // MARK:- Protocol Methods
    func closeView() {
        if let firstViewController = controller.navigationController?.viewControllers[1] {
            controller.navigationController?.popToViewController(firstViewController, animated: true)
        }
    }
    
    func openQuiz(_ cards: [String], with categoryName: String, and count: Int) {
        let vc = QuizViewController()
        controller.quizViewController = vc
        controller.quizViewController.cards = cards
        controller.quizViewController.categoryName = categoryName
        controller.quizViewController.count = count
        controller.quizViewController.areImagesTransparent = controller.areImagesTransparent
        vc.itemView = controller
        controller.show(vc, sender: nil)
    }
}
