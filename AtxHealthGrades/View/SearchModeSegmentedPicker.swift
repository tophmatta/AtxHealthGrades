//
//  SearchModeSegmentedPicker.swift
//  AtxHealthGrades
//
//  Created by Toph Matta on 2/25/25.
//
import SwiftUI

struct SearchModeSegmentedPicker: View {
    @Binding var selection: Segment
    
    init(selection: Binding<Segment>) {
        self._selection = selection
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.green)], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor.surface
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Search Mode")
                .font(.callout)
                .foregroundStyle(Color.gray)
                .padding(.vertical, 3)
            Picker("", selection: $selection) {
                ForEach(Segment.allCases, id: \.self) { segment in
                    Text(segment.rawValue.capitalized).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing, .bottom], 8)
        }
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 10)
        )
    }
}
