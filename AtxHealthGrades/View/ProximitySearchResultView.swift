//
//  RestaurantHistorySelectionView.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 11/11/24.
//

import SwiftUI


struct RestaurantHistorySelectionView: View {
    @Environment(MapViewModel.self) var viewModel
    
    let group: LocationReportGroup
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationView {
                List(group.data) { data in
                    NavigationLink {
                        RestaurantHistoryDetailView(data: data)
                    } label: {
                        RestaurantSelectionRow( data: data)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationCompactAdaptation(.none)
    }
}

struct RestaurantSelectionRow: View {
    let data: Report
    
    var body: some View {
        HStack {
            GradeIcon(score: data.score)
                .frame(width: 50, height: 50)
                .padding(.trailing)
            Text(data.restaurantName)
                .font(.title3)
            Spacer()
        }
    }
}

struct RestaurantHistoryDetailView: View {
    @Environment(MapViewModel.self) var viewModel
    @State private var isLoading = true
    let data: Report
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Report History")
                .font(.title)
            ZStack {
                ReportChart(data: viewModel.historicalData.toPlottableData())
                AppProgressView(isEnabled: $isLoading)
                if !isLoading && viewModel.historicalData.count < 2 {
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
            List(viewModel.historicalData) { result in
                HStack {
                    GradeIcon(score: result.score)
                        .frame(width: 50, height: 50)
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
            if viewModel.historicalData.isEmpty {
                _ = await viewModel.getAllReports(with: data.facilityId)
            }
            isLoading = false
        }
        .onDisappear {
            viewModel.clearHistoricalData()
        }
    }
}

