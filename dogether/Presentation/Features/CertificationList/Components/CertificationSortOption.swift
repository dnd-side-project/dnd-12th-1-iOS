//
//  CertificationSortOption.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import Foundation

enum CertificationSortOption: String, CaseIterable, BottomSheetItemRepresentable {
    case todoCompletionDate = "투두 완료일순"
    case groupCreationDate = "그룹 생성일순"

    var displayName: String {
        return self.rawValue
    }
    
    var bottomSheetItem: BottomSheetItem {
        BottomSheetItem(displayName: displayName, value: self)
    }
}
