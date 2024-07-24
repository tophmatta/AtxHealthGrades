//
//  ReportList.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import SwiftUI

struct ReportList: View {
    
    let reports: [Report]
    
    init(_ reports: [Report]) {
        self.reports = reports
    }
    
    var body: some View {
        List(reports) {
            ReportItem($0)
        }
        .listStyle(.inset)
    }
}

struct ReportItem: View {
    let report: Report
    
    init(_ report: Report) {
        self.report = report
    }
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.green)
                Text("A")
                    .foregroundStyle(Color.systemBackground)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .font(.title)
            }
            
            VStack(alignment: .leading) {
                Text(report.restaurantName)
                Text(report.address)
                Text("Last insp: " + report.date.toReadable())
            }
            .padding(.leading, 20)
            Spacer()
            Button {
                //TODO: button action
            } label: {
                Image(systemName: "map.fill")
                    .foregroundStyle(Color.green)
            }
            .padding(.trailing, 15)
        }
    }
}

//#Preview {
//    ReportList()
//}
