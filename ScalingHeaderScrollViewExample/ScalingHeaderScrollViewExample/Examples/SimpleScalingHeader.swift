//
//  SimpleScalingHeader.swift
//  Example
//
//  Created by Daniil Manin on 28.09.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct SimpleScalingHeader: View {

    var body: some View {
        ScalingHeaderScrollView { _, _ in
            Image("image_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        } content: {
            Text(defaultDescription)
                .padding()
        }
        .allowsHeaderGrowth()
        .allowsHeaderCollapse()
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
