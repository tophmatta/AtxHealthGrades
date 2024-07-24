//
//  ReportList.swift
//  AtxHealthInspection
//
//  Created by Toph Matta on 7/23/24.
//

import SwiftUI

struct ReportList: View {
    
    let results = [
        Report.empty,
        Report.empty,
        Report.empty,
        Report.empty,
        Report.empty
    ]
    
    
    var body: some View {
        List(results) { item in
            <#code#>
        }
    }
}

#Preview {
    ReportList()
}
