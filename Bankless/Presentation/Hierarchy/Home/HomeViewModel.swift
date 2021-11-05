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
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel, TimelineServiceDependency {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let timelineViewModel: Driver<HomeTimelineViewModel>
    }
    
    // MARK: - Actions -
    
    struct Actions {
        let openAchievements = PublishRelay<Void>()
    }
    
    let actions = Actions()
    
    // MARK: - Components -
    
    var timelineService: TimelineService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        subscribeToInputEvents()
        
        let timelineViewModel = self.timelineViewModel()
        
        return Output(
            timelineViewModel: timelineViewModel.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - Timeline -
    
    private func timelineViewModel() -> Observable<HomeTimelineViewModel> {
        let viewModel = HomeTimelineViewModel()
        self.container?.resolve(viewModel)
        
        return .just(viewModel)
    }
    
    // MARK: - Subscriptions -
    
    private func subscribeToInputEvents() {
        NotificationCenter.default.rx
            .notification(NotificationEvent.achievementsPreviewTapped.notificationName, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.actions.openAchievements.accept(())
            })
            .disposed(by: disposer)
    }
}
