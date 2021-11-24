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

protocol UserSettingsServiceDependency {
    var userSettingsService: UserSettingsService! { get set }
}

protocol AuthServiceDependency {
    var authService: AuthService! { get set }
}

protocol IdentityServiceDependency {
    var identityService: IdentityService! { get set }
}

protocol BanklessServiceDependency {
    var banklessService: BanklessService! { get set }
}

protocol AchievementsServiceDependency {
    var achievementsService: AchievementsService! { get set }
}

protocol TimelineServiceDependency {
    var timelineService: TimelineService! { get set }
}

protocol NewsServiceDependency {
    var newsService: NewsService! { get set }
}

protocol BountyBoardServiceDependency {
    var bountyBoardService: BountyBoardService! { get set }
}

protocol AcademyServiceDependency {
    var academyService: AcademyService! { get set }
}
