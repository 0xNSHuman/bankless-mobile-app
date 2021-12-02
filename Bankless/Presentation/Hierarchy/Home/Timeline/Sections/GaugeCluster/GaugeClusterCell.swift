//
//  Created with ♥ by BanklessDAO contributors on 2021-10-14.
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

class GaugeClusterCell: BaseTableViewCell<GaugeClusterViewModel> {
    class var reuseIdentifier: String {
        return String(describing: GaugeClusterCell.self)
    }
    
    // MARK: - Subviews -
    
    private var gaugeClusterView: GaugeClusterView!
    
    // MARK: - Lifecycle -
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gaugeClusterView.disposer = DisposeBag()
        gaugeClusterView.viewModel?.disposer = DisposeBag()
    }
    
    // MARK: - Setup -
    
    override func setUpSubviews() {
        backgroundColor = .backgroundBlack
        
        separatorInset = .init(
            top: 0,
            left: CGFloat.greatestFiniteMagnitude,
            bottom: 0,
            right: 0
        )
        
        gaugeClusterView = GaugeClusterView()
        contentView.addSubview(gaugeClusterView)
    }
    
    override func setUpConstraints() {
        constrain(gaugeClusterView, contentView) { (cluster, view) in
            cluster.edges == view.edges
                .inseted(
                    by: .init(
                        top: Appearance.contentInsets.top / 2,
                        left: 0,
                        bottom: Appearance.contentInsets.bottom / 2,
                        right: 0
                    )
                )
        }
    }
    
    override func bindViewModel() {
        gaugeClusterView.viewModel = viewModel
        gaugeClusterView.bindViewModel()
    }
}
