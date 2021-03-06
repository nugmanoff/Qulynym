/*
 * Qulynym
 * DrawingConfigurator.swift
 *
 * Created by: Metah on 5/30/19
 *
 * Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol DrawingConfiguratorProtocol: class {
    func configure(with controller: DrawingViewController)
}

class DrawingConfigurator: DrawingConfiguratorProtocol {
    func configure(with controller: DrawingViewController) {
        let presenter = DrawingPresenter(controller)
        let interactor = DrawingInteractor(presenter)
        let router = DrawingRouter(controller)
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
