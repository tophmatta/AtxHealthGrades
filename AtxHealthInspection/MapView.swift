//
//  MapView.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/8/24.
//

import SwiftUI
import MapKit
import Collections

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    @State private var selected: LocationReportGroup?
    @State private var showDetail = false
    
    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
            ForEach(viewModel.currentPOIs.elements, id: \.key) { element in
                Annotation("", coordinate: element.value.coordinate) {
                    MapMarker(group: element.value, selected: $selected)
                }
            }
        }
        .sheet(item: $selected) {
            MapSheet(group: $0)
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                MapActionButton(type: .radius) {
                    viewModel.triggerProximitySearch()
                }
                MapActionButton(type: .location) {
                    viewModel.goToUserLocation()
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            ClearButton()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: viewModel.currentPOIs) { _, new in
            if new.count == 1 {
                viewModel.cameraPosition = .camera(.init(centerCoordinate: new.values.first!.coordinate, distance: 1000))
            } else {
                viewModel.cameraPosition = .automatic
            }
        }
        .onAppear {
            viewModel.checkLocationAuthorization()
        }
    }
}

private struct MapSheet: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    let group: LocationReportGroup
    
    var body: some View {
        VStack(spacing: 10) {
            NavigationView {
                List(group.data) { data in
                    NavigationLink {
                        LocationReportDetail(data: data)
                    } label: {
                        LocationReportRow(data: data)
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

private struct MapMarker: View {
    let group: LocationReportGroup
    
    @Binding var selected: LocationReportGroup?
    
    var body: some View {
        Image(systemName: "mappin.square.fill")
            .resizable()
            .annotationSize()
            .foregroundStyle(.white, .yellow)
            .onTapGesture {
                selected = selected == group ? nil : group
            }
    }
}

private struct LocationReportRow: View {
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

private struct LocationReportDetail: View {
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

private struct ClearButton: View {
    @EnvironmentObject var viewModel: MapViewModel
    
    var body: some View {
        if !viewModel.currentPOIs.isEmpty {
            Button {
                viewModel.clear()
            } label: {
                Text("Clear")
                    .foregroundStyle(.green)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7)
            }
            .background(
                Capsule()
                    .fill(.surface)
                    .shadow(radius: 5)
            )
            .padding(.trailing)
        }
    }
}

private struct MapActionButton: View {
    let type: ActionButtonType
    let action: () -> ()
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            Image(systemName: type.rawValue)
                .frame(width: 10, height: 10)
                .padding()
                .background(Rectangle().fill(.surface))
                .clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                )
                .foregroundColor(Color.green)
                .padding([.trailing, .bottom])
                .shadow(radius: 5)
        }
    }
}

enum ActionButtonType: String {
    case location = "location.fill"
    case radius = "circle.dotted"
}

#Preview {
    MapView()
        .environmentObject(MapViewModel(SocrataAPIClient(), locationModel: LocationModel(), poiGroup: LocationReportGroup.test))
}
