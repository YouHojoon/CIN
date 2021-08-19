//
//  AppComponet.swift
//  CIN
//
//  Created by 유호준 on 2021/08/19.
//

import Foundation
import RIBs
class AppComponent: Component<EmptyComponent>, RootDependency {
    init() {
        super.init(dependency: EmptyComponent())
    }
}
