//
//  ContentView.swift
//  Example
//
//  Created by Alisa Mylnikova on 16/09/2021.
//  Copyright © 2019 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Simple Examples")) {
                    NavigationLink("Simple Scaling Header") {
                        SimpleScalingHeader()
                    }

                    NavigationLink("Map Scaling Header") {
                        MapScalingHeader()
                    }

                    NavigationLink("Color Scaling Header") {
                        ColorScalingHeader()
                    }

                    NavigationLink("Request Scaling Header") {
                        RequestScalingHeader()
                    }

                    NavigationLink("Tab Scaling Header") {
                        TabScalingHeader()
                    }
                }

                Section(header: Text("Beautiful Examples")) {
                    NavigationLink("Profile Screen") {
                        ProfileScreen()
                    }

                    NavigationLink("Booking Screen") {
                        BookingScreen()
                    }

                    NavigationLink("Banking Screen") {
                        BankingScreen()
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
