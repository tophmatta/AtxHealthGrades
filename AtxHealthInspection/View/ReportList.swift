//
//  ReportList.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import SwiftUI

struct ReportList: View {
    @Binding var selectedTab: Tab
    @Binding var showSheet: Bool
    
    let reports: [Report]
    
    init(_ reports: [Report], selectedTab: Binding<Tab>, showSheet: Binding<Bool>) {
        self.reports = reports
        _selectedTab = selectedTab
        _showSheet = showSheet
    }
    
    var body: some View {
        Spacer()
        Text("Reports")
            .font(.title)
            .fontDesign(.rounded)
            .padding()
        Divider()
        List(reports) {
            ReportItem($0, selectedTab: $selectedTab, showSheet: $showSheet)
        }
        .listStyle(.inset)
    }
}

struct ReportItem: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    @Binding var selectedTab: Tab
    @Binding var showSheet: Bool
    @State private var showError = false
    
    let report: Report
    
    init(_ report: Report, selectedTab: Binding<Tab>, showSheet: Binding<Bool>) {
        self.report = report
        _selectedTab = selectedTab
        _showSheet = showSheet
    }
    
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
                    selectedTab = .map
                    showSheet = false
                    let data = ReportData(name: report.restaurantName, facilityId: report.facilityId, score: report.score, date: report.date)
                    let result = [report.address : LocationReportGroup(data: [data], address: report.address, coordinate: location)]
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
            FavoriteButton(id: report.favoriteId)
                .padding(.trailing, 15)
        }
        .alert(isPresented: $showError, error: ClientError.invalidLocation) {
            Button("OK") {
                showError = false
            }
        }
    }
}
