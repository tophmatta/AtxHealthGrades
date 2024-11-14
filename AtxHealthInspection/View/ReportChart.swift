//
//  ReportChart.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/13/24.
//

import SwiftUI
import Charts

struct ReportChart: View {
    let data: [ReportDataPoint]
    
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Month", $0.date),
                y: .value("Health Score", $0.score)
            )
            .foregroundStyle(.green)
        }
        .padding()
    }
}

struct ReportDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let score: Int
    
    init(date: Date, score: Int) {
        let calendar = Calendar.autoupdatingCurrent
        let components = calendar.dateComponents([.year, .month], from: date)
        self.date = calendar.date(from: DateComponents(year: components.year, month: components.month))!
        self.score = score
    }
}

extension Collection where Element == Report {
    func toPlottableData() -> [ReportDataPoint] {
        return self.map { ReportDataPoint(date: $0.date, score: $0.score) }
    }
}

