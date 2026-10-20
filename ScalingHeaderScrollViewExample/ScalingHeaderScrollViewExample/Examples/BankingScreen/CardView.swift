//
//  CardView.swift
//  Example
//
//  Created by Danil Kristalev on 30.12.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI

struct CardView: View {

    @Environment(\.scalingHeaderSafeAreaInsets) var safeAreaInsets

    // 0 (fully expanded) -> 1 (fully collapsed)
    var progress: CGFloat

    private var isCollapsed: Bool {
        progress > 0.7
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBankingBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                Text("Visa card")
                    .fontRegular(size: 17)
                    .frame(maxWidth: .infinity, alignment: .center)

                gradientBackgroundView
                    .frame(height: BankingScreen.maxCardHeight)
                    .mask(alignment: .top) {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: BankingScreen.minCardHeight + (1 - progress) * (BankingScreen.maxCardHeight - BankingScreen.minCardHeight))
                    }
                    .overlay {
                        VStack {
                            balanceView
                            Spacer()
                            starsView
                                .opacity(2.0 - progress * 3)
                            Spacer()
                            nameView
                                .opacity(1.0 - progress * 5)
                        }
                        .padding(20)
                    }
                    .padding(BankingScreen.cardPadding)
            }
            .padding(.top, safeAreaInsets.top)
            .padding(.trailing, safeAreaInsets.trailing)
        }
    }

    var gradientBackgroundView: some View {
        Rectangle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.hex("#2B27F3"), Color.hex("#872AFD")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .shadow(color: Color.hex("#4327F3").opacity(0.6), radius: 16, y: 8)
    }

    var balanceView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("BALANCE")
                    .tracking(1.5)
                    .fontRegular(color: Color.white.opacity(0.7), size: 8)

                Text(formattedBalance)
                    .fontBold(color: .white, size: 24)
            }

            Spacer()

            if !isCollapsed {
                Image("Visa")
                    .resizable()
                    .frame(width: 60, height: 18)
                    .opacity(1 - max(0, min(1, (progress - 0.6) * 10.0)))
            } else {
                HStack(spacing: 12) {
                    fourStars
                    Text("0777")
                }
                .fontBold(color: .white, size: 20)
                .opacity(max(0, min(1, (progress - 0.7) * 4.0)))
            }
        }
    }

    var starsView: some View {
        HStack {
            fourStars
            Spacer()
            fourStars
            Spacer()
            fourStars
            Spacer()
            Text("0777")
        }
        .fontBold(color: .white, size: 20)
    }

    var fourStars: some View {
        Text("****")
            .padding(.top, 5)
    }

    var nameView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("CARD HOLDER")
                    .tracking(1.5)
                    .fontRegular(color: Color.white.opacity(0.7), size: 8)

                Text("TOM HOLLAND")
                    .fontBold(color: .white, size: 15)
            }

            Spacer()

            VStack(alignment: .leading) {
                Text("EXPIRES")
                    .tracking(1.5)
                    .fontRegular(color: Color.white.opacity(0.7), size: 8)

                Text("11/24")
                    .fontBold(color: .white, size: 15)
            }
        }
    }

    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "

        let number = NSNumber(value: 56112.65)
        let formattedValue = formatter.string(from: number)!
        return "$\(formattedValue)"
    }
}
