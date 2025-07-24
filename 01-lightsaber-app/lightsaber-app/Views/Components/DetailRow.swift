//
//  DetailRow.swift
//  lightsaber-app
//
//  Created by Claude on 24/07/25.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    var color: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    VStack {
        DetailRow(title: "Blade Color", value: "Blue", color: .blue)
        DetailRow(title: "Creator", value: "Luke Skywalker")
    }
    .padding()
}