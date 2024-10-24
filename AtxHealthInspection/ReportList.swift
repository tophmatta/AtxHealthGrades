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
    
    let reports: [Report]
    
    init(_ reports: [Report], selectedTab: Binding<Tab>) {
        self.reports = reports
        _selectedTab = selectedTab
    }
    
    var body: some View {
        Spacer()
        Text("Reports")
            .font(.title)
            .fontDesign(.rounded)
            .padding()
        Divider()
        List(reports) {
            ReportItem($0, selectedTab: $selectedTab)
        }
        .listStyle(.inset)
    }
}

struct ReportItem: View {
    @EnvironmentObject var mapViewModel: MapViewModel
    @Binding var selectedTab: Tab
    
    let report: Report
    
    init(_ report: Report, selectedTab: Binding<Tab>) {
        self.report = report
        _selectedTab = selectedTab
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
                selectedTab = .map
            } label: {
                Image(systemName: "map.fill")
                    .foregroundStyle(Color.green)
            }
            .padding(.trailing, 15)
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
