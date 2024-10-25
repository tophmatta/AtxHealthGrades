//
//  ReportList.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import SwiftUI

struct ReportList: View {
    
    @EnvironmentObject var mapViewModel: MapViewModel
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
            CircleForScore(report.score)
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
                    mapViewModel.displayLocation(PointOfInterest(name: report.restaurantName, address: report.address, coordinate: location))
                } else {
                    showError = true
                }
            } label: {
                Image(systemName: "map.fill")
                    .foregroundStyle(Color.green)
            }
            .padding(.trailing, 15)
        }
        .alert(isPresented: $showError, error: ClientError.invalidLocation) {
            Button("OK") {
                showError = false
            }
        }
    }
    
    func CircleForScore(_ score: Int) -> some View {
        let values: (letter: String, color: Color) = {
            switch score {
            case 90...100:
                return ("A", Color.green)
            case 80...89:
                return ("B", Color.blue)
            case 70...79:
                return ("C", Color.orange)
            case 60...69:
                return ("D", Color.indigo)
            case 0...59:
                return ("F", Color.red)
            default:
                return ("?", Color.gray)
            }
        }()
        
        return ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(values.color)
            Text(values.letter)
                .foregroundStyle(Color.white)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .font(.title)
        }
    }
}

//#Preview {
//    ReportList()
//}
