//
//  TextSearchResultView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import SwiftUI

struct TextSearchResultView: View {
    let reports: [Report]
    
    var body: some View {
        Spacer()
        Text("Reports")
            .font(.title)
            .fontDesign(.rounded)
            .padding()
        Divider()
        List(reports) {
            ReportItem(report: $0)
        }
        .listStyle(.inset)
    }
}

struct ReportItem: View {
    @Environment(MapViewModel.self) var mapViewModel
    @Environment(SearchViewModel.self) var searchViewModel
    @State private var showError = false
    
    let report: Report
        
    var body: some View {
        HStack {
            ScoreItem(report.score)
            VStack(alignment: .leading) {
                Text(report.restaurantName)
                Text(report.address)
                Text("Last Insp: " + report.date.toReadable())
            }
            .padding(.leading, 20)
            Spacer()
            Button {
                if let location = report.coordinate {
                    searchViewModel.clear()
                    let result = [report.parentId : LocationReportGroup(data: [report], address: report.address, coordinate: location)]
                    mapViewModel.updatePOIs(result)
                } else {
                    showError = true
                }
            } label: {
                Image(systemName: "map.fill")
                    .foregroundStyle(Color.green)
                    .contentShape(Rectangle()) // makes only the button (not row) tappable
            }
            .buttonStyle(PlainButtonStyle()) // makes only the button (not row) tappable
            Spacer()
            FavoriteButton(report: report)
                .padding(.trailing, 15)
        }
        .alert(isPresented: $showError, error: ClientError.invalidLocation) {
            Button("OK") {
                showError = false
            }
        }
    }
}
