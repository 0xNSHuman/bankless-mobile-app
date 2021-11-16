//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    private let container: DependencyContainer
    
    var initialViewController: UIViewController!
    
    init(
        container: DependencyContainer
    ) {
        self.container = container
        initialViewController = createHomeViewController()
    }
    
    // MARK: - Initialization -
    
    private func createHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel(container: container)
        
        viewModel.actions.openAchievements
            .bind(onNext: { [weak self] in self?.openAchievements() })
            .disposed(by: viewModel.disposer)
        viewModel.actions.openBountyBoard
            .bind(onNext: { [weak self] in self?.openBountyBoard() })
            .disposed(by: viewModel.disposer)
            
        
        let viewController = HomeViewController.init(nibName: nil, bundle: nil)
        viewController.set(viewModel: viewModel)
        return viewController
    }
    
    // MARK: - Transitions -
    
    private func openAchievements() {
        let coordinator = AchievementsCoordinator(container: container)
        container.resolve(coordinator)
        
        initialViewController.navigationController?
            .pushViewController(coordinator.initialViewController, animated: true)
    }
    
    private func openBountyBoard() {
        let coordinator = BountyBoardCoordinator(container: container)
        container.resolve(coordinator)
        
        coordinator.start(from: initialViewController.navigationController!)
    }
}
