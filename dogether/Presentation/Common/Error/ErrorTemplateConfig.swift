//
//  ErrorTemplateConfig.swift
//  dogether
//
//  Created by yujaehong on 6/23/25.
//

import UIKit

struct ErrorTemplateConfig {
    let image: UIImage
    let title: String
    let subtitle: String?
    let leftButtonTitle: String
    let rightButtonTitle: String?
    let leftActionType: ErrorActionType
    let rightActionType: ErrorActionType?
}

enum ErrorActionType {
    case goBack
    case goHome
    case retry
    case goGroupCreate
}
