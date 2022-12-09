//
//  MainSettingsView.swift
//  Budget
//
//  Created by Colby Davis on 10/18/22.
//

import SwiftUI

struct MainSettingsView: View {
    @Binding var data: Budget.Data
    
    var body: some View {
        Form {
            Section(header: Text("Settings")) {
                Picker("Budget Term", selection: $data.settings.payTerm) {
                    Text("Weekly").tag(PayTerm.weekly)
                    Text("BiWeekly").tag(PayTerm.biweekly)
                    Text("Monthly").tag(PayTerm.monthly)
                }
            }
        }
    }
}

struct MainSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainSettingsView(data: .constant(Budget.sampleData.data))
        }
    }
}
