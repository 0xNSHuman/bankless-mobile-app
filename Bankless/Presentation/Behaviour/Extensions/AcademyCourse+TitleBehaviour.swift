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

extension AcademyCourse.Difficulty: TitleBehaviour {
    var title: String {
        switch self {
            
        case .easy:
            return NSLocalizedString(
                "academy.course.difficulty.easy.title",
                value: "🙂 Easy",
                comment: ""
            )
        case .medium:
            return NSLocalizedString(
                "academy.course.difficulty.medium.title",
                value: "🤔 Medium",
                comment: ""
            )
        case .hard:
            return NSLocalizedString(
                "academy.course.difficulty.hard.title",
                value: "🤯 Hard",
                comment: ""
            )
        }
    }
}
