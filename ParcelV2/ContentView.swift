//
//  ContentView.swift
//  ParcelV2
//
//  Created by Milkyo on 6/24/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    
    @State var invoiceNumber: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            TextField("경동 택배 번호 입력", text: $invoiceNumber)
            Button("저장") {
                Swift.print("##", invoiceNumber)
                UserDefaults.shared.set(invoiceNumber, forKey: "invoiceNumber")
                WidgetCenter.shared.reloadTimelines(ofKind: "ParcelV2Widget")
                Swift.print("## Called")
            }
        }
    }
}
