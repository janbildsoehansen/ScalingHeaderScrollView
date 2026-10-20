//
//  BankingScreen.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import UIKit
import ScalingHeaderScrollView

struct BankingScreen: View {

    static let cardPadding: CGFloat = 20
    static let minCardHeight: CGFloat = 70
    static let maxCardHeight: CGFloat = 230
    static let titleTextHeight: CGFloat = 40
    private static let baseMinHeaderHeight: CGFloat = titleTextHeight + 2 * cardPadding + minCardHeight
    private static let baseMaxHeaderHeight: CGFloat = titleTextHeight + 2 * cardPadding + maxCardHeight
    private static let topButtonSize: CGFloat = 50

    @State private var isActive = true

    let service = BankingService()

    private var minHeaderHeight: CGFloat { Self.baseMinHeaderHeight + UIApplication.shared.keyWindowSafeAreaInsets.top }
    private var maxHeaderHeight: CGFloat { Self.baseMaxHeaderHeight + UIApplication.shared.keyWindowSafeAreaInsets.top }

    var body: some View {
        ScalingHeaderScrollView(minHeight: minHeaderHeight, maxHeight: maxHeaderHeight) { _ , progress in
            CardView(progress: progress)
        } content: {
            VStack {
                ForEach(service.transactions) { transaction in
                    TransactionView(transaction: transaction)
                }
            }
            .padding(.vertical, 15)
        }
        .headerAlignment(.top)
        .pullToLoadMore(isActive: isActive, contentOffset: 50) {
            isActive = false
            try? await Task.sleep(for: .seconds(2))
            Task.detached {
                try? await Task.sleep(for: .seconds(4))
                await MainActor.run {
                    isActive = true
                }
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(imageName: "ellipsis", background: .white.opacity(0), width: Self.topButtonSize, height: Self.topButtonSize))
            }
        }
    }
}

private struct TitleBottomPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct BankingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankingScreen()
    }
}
