//
//  BehaviorRelayExt.swift
//  dogether
//
//  Created by seungyooooong on 9/14/25.
//

import RxRelay

extension BehaviorRelay {
    func update(_ transform: (inout Element) -> Void) {
        var newValue = value
        transform(&newValue)
        accept(newValue)
    }
}
