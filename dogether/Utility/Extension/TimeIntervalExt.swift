//
//  TimeIntervalExt.swift
//  dogether
//
//  Created by seungyooooong on 3/12/25.
//

import Foundation

extension TimeInterval {
    func formatToHHmmss() -> String {
        let hours = Int(self) / (60 * 60)
        let minutes = (Int(self) % (60 * 60)) / 60
        let seconds = Int(self) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func getTimeProgress() -> CGFloat {
        return 1 - CGFloat(self / (24 * 60 * 60))
    }
}
