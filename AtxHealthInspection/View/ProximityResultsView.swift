//
//  ProximityResultsView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/11/24.
//

import SwiftUI


struct ProximityResultsView: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    let group: LocationReportGroup
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationView {
                List(group.data) { data in
                    NavigationLink {
                        ProximityReportDetail(data: data)
                    } label: {
                        ProximityReportRow(data: data)
                    }
                }
            }
            Divider()
            Button {
                viewModel.openInMaps(coordinate: group.coordinate, placeName: group.address)
            } label: {
                Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                    .resizable()
                    .buttonSize()
                    .foregroundColor(.green)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationCompactAdaptation(.none)
    }
}

struct ProximityReportRow: View {
    let data: ReportData
    
    var body: some View {
        HStack {
            ScoreItem(data.score)
                .padding(.trailing)
            Text(data.name)
                .font(.title3)
            Spacer()
        }
    }
}

struct ProximityReportDetail: View {
    let data: ReportData
    
    var body: some View {
        HStack {
            Text(data.name)
                .font(.title)
                .foregroundStyle(.onSurface)
            Spacer()
            ScoreItem(data.score)
        }
    }
}

