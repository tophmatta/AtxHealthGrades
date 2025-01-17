//
//  ProximityResultsListView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 11/11/24.
//

import SwiftUI


struct ProximityResultsListView: View {
    @Environment(MapViewModel.self) var viewModel
    
    let group: LocationReportGroup
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationView {
                List(group.data) { data in
                    NavigationLink {
                        ProximityReportDetail(data: data)
                    } label: {
                        ProximityReportRow( data: data)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationCompactAdaptation(.none)
    }
}

struct ProximityReportRow: View {
    let data: Report
    
    var body: some View {
        HStack {
            ScoreItem(data.score)
                .padding(.trailing)
            Text(data.restaurantName)
                .font(.title3)
            Spacer()
        }
    }
}

struct ProximityReportDetail: View {
    @Environment(MapViewModel.self) var viewModel
    @State private var isLoading = true
    let data: Report
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Report History")
                .font(.title)
            ZStack {
                ReportChart(data: viewModel.historicalReports.toPlottableData())
                AppProgressView(isEnabled: $isLoading)
                if !isLoading && viewModel.historicalReports.count < 2 {
                    Text("Not enough data")
                        .foregroundStyle(.onSurface)
                        .padding()
                        .background {
                            Rectangle().fill(.surface)
                        }
                        .clipShape(
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                        )
                }
                
            }
            Divider()
            List(viewModel.historicalReports) { result in
                HStack {
                    ScoreItem(result.score)
                    Spacer()
                    Text(result.date.toReadable())
                        .font(.title3)
                        .foregroundStyle(.onSurface)
                }
            }
        }
        .toolbarRole(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(report: data)
            }
        }
        .task {
            await viewModel.getAllReports(with: data.facilityId)
            isLoading = false
        }
        .onDisappear {
            viewModel.clearHistorical()
        }
    }
}

