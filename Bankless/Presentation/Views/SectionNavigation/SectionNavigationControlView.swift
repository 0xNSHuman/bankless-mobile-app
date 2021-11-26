//
//  Created with ♥ by BanklessDAO contributors on 2021-11-18.
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
import Cartography
import RxSwift
import RxCocoa

class SectionNavigationControlView: BaseView<SectionNavigationViewModel> {
    // MARK: - Constants -
    
    private static let backgroundColor: UIColor = .backgroundGrey.withAlphaComponent(0.5)
    private static let prevNavigationIcon = UIImage(named: "arrow_left")!
    private static let nextNavigationIcon = UIImage(named: "arrow_right")!
    
    // MARK: - Properties -
    
    private var state: State!
    private var dynamicConstraints = ConstraintGroup()
    
    // MARK: - Subviews -
    
    private var progressBarView: UIView!
    private var prevNavIconView: UIImageView!
    private var prevNavButton: UIButton!
    private var nextNavIconView: UIImageView!
    private var nextNavButton: UIButton!
    private var titleLabel: UILabel!
    
    // MARK: - Initializers -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        layer.cornerRadius = Appearance.cornerRadius
        clipsToBounds = true
        backgroundColor = SectionNavigationControlView.backgroundColor
        
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        progressBarView = UIView()
        progressBarView.isHidden = true
        progressBarView.backgroundColor = .primaryRed.withAlphaComponent(0.3)
        addSubview(progressBarView)
        
        prevNavIconView = UIImageView()
        prevNavIconView.contentMode = .scaleAspectFit
        prevNavIconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        prevNavIconView.isHidden = true
        prevNavIconView.image = SectionNavigationControlView.prevNavigationIcon
        addSubview(prevNavIconView)
        
        prevNavButton = UIButton(type: .custom)
        prevNavButton.isHidden = true
        addSubview(prevNavButton)
        
        nextNavIconView = UIImageView()
        nextNavIconView.contentMode = .scaleAspectFit
        nextNavIconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nextNavIconView.isHidden = true
        nextNavIconView.image = SectionNavigationControlView.nextNavigationIcon
        addSubview(nextNavIconView)
        
        nextNavButton = UIButton(type: .custom)
        nextNavButton.isHidden = true
        addSubview(nextNavButton)
        
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Font.Label2.font(bold: true)
        addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        constrain(progressBarView, self) { progress, view in
            progress.top == view.top
            progress.bottom == view.bottom
            progress.left == view.left
        }
        
        constrain(prevNavIconView, self) { prev, view in
            prev.left == view.left + contentInsets.left
            prev.top == view.top + contentInsets.top
            prev.bottom == view.bottom - contentInsets.bottom
        }
        
        constrain(prevNavButton, self) { prev, view in
            prev.left == view.left + contentInsets.left
            prev.top == view.top + contentInsets.top
            prev.bottom == view.bottom - contentInsets.bottom
        }
        
        constrain(nextNavIconView, self) { next, view in
            next.right == view.right - contentInsets.right
            next.top == view.top + contentInsets.top
            next.bottom == view.bottom - contentInsets.bottom
        }
        
        constrain(nextNavButton, self) { next, view in
            next.right == view.right - contentInsets.right
            next.top == view.top + contentInsets.top
            next.bottom == view.bottom - contentInsets.bottom
        }
        
        constrain(titleLabel, self) { title, view in
            title.top == view.top + contentInsets.top
            title.bottom == view.bottom - contentInsets.bottom
        }
    }
    
    private func resetDymanicLayout() {
        switch state {
            
        case .start:
            titleLabel.textAlignment = .left
            prevNavIconView.isHidden = true
            prevNavButton.isHidden = true
            nextNavIconView.isHidden = false
            nextNavButton.isHidden = false
            progressBarView.isHidden = true
            
            constrain(
                titleLabel, nextNavIconView, nextNavButton, self,
                replace: dynamicConstraints
            ) { title, next, nextBtn, view in
                title.left == view.left + contentInsets.left
                title.right == next.left - contentPaddings.left
                nextBtn.width == view.width
            }
        case .middle(let progress):
            titleLabel.textAlignment = .center
            
            let validProgress = progress > 1.0 ? 1.0 : progress
            
            prevNavIconView.isHidden = false
            prevNavButton.isHidden = false
            nextNavIconView.isHidden = false
            nextNavButton.isHidden = false
            progressBarView.isHidden = false
            
            constrain(
                progressBarView, titleLabel,
                prevNavIconView, prevNavButton, nextNavIconView, nextNavButton,
                self,
                replace: dynamicConstraints
            ) { progress, title, prev, prevBtn, next, nextBtn, view in
                progress.width == view.width * validProgress
                title.left == prev.right + contentPaddings.right
                title.right == next.left - contentPaddings.left
                prevBtn.width == view.width / 2
                nextBtn.width == view.width / 2
            }
        case .end:
            titleLabel.textAlignment = .right
            
            prevNavIconView.isHidden = false
            nextNavButton.isHidden = false
            nextNavIconView.isHidden = true
            nextNavButton.isHidden = true
            progressBarView.isHidden = true
            
            constrain(
                titleLabel, prevNavIconView, prevNavButton, self,
                replace: dynamicConstraints
            ) { title, prev, prevBtn, view in
                title.right == view.right - contentInsets.right
                title.left == prev.right - contentPaddings.right
                prevBtn.width == view.width * 2
            }
        case .none:
            fatalError("unexpected state")
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(input: input())
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        Driver
            .combineLatest(output.navigationOptions, output.progress) {
                (navOptions: $0, progress: $1)
            }
            .drive(onNext: { [weak self] output in
                if output.navOptions.contains(.back) && output.navOptions.contains(.forward) {
                    self?.state = .middle(progress: CGFloat(output.progress))
                } else if output.navOptions.contains(.back) {
                    self?.state = .end
                } else if output.navOptions.contains(.forward) {
                    self?.state = .start
                }
            
                self?.resetDymanicLayout()
            })
            .disposed(by: disposer)
    }
    
    private func input() -> SectionNavigationViewModel.Input {
        return SectionNavigationViewModel.Input(
            tapNavigationOption: Driver<SectionNavigationViewModel.NavigationOption>
                .merge([
                    prevNavButton.rx.tap.asDriver().map({ .back }),
                    nextNavButton.rx.tap.asDriver().map({ .forward })
                ])
        )
    }
}

extension SectionNavigationControlView {
    enum State {
        case start
        case middle(progress: CGFloat)
        case end
    }
}
