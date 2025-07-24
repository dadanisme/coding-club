//
//  DateFormatters.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import Foundation

extension DateFormatter {
    static let detailFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}