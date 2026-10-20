//
//  BookingScreen.swift
//  Example
//
//  Created by Danil Kristalev on 19.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderScrollView

struct BookingScreen: View {

    private static let bookButtonHeight: CGFloat = 60
    private static let footerVerticalPadding: CGFloat = 16

    @StateObject private var viewModel = BookingScreenViewModel()

    @State var snapTo: SnapHeaderState?

    var body: some View {
        VStack(spacing: 0) {
            ScalingHeaderScrollView { _, _ in
                BookingMapView(viewModel: viewModel)
            } content: {
                bookingContentView
            }
            .snapHeaderToState($snapTo)

            footer
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("") {
                    print("Share")
                    snapTo = .collapsed
                }
                .buttonStyle(CircleButtonStyle(imageName: "arrowshape.turn.up.forward.fill"))
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("") {
                    print("Like")
                    snapTo = .expanded
                }
                .buttonStyle(CircleButtonStyle(imageName: "heart.fill", foreground: .appRed))
            }
        }
    }

    private var footer: some View {
        HStack {
            price
            Spacer()
            bookButton
        }
        .padding(.vertical, Self.footerVerticalPadding)
        .background(
            Color.appBookingFooterBackground
                .ignoresSafeArea()
        )
    }

    private var price: some View {
        HStack {
            Text("$ \(viewModel.price)")
                .fontBold(color: .black, size: 24)
            Text("/night")
                .fontRegular(color: .black, size: 16)
        }
        .padding(.leading, 16)
    }

    private var bookButton: some View {
        Button("Book now", action: { print("book") })
            .buttonStyle(BookButtonStyle())
            .padding(.trailing, 16)
            .frame(width: 211, height: Self.bookButtonHeight, alignment: .bottom)
    }

    private var bookingContentView: some View {
        VStack {
            contentHeader
            details
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)
    }

    private var contentHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Text(viewModel.placeName)
                    .fontBold(color: .appDarkGray, size: 24)
                Spacer()
                stars
            }
            address
        }
    }

    private var stars: some View {
        HStack(alignment: .center , spacing: 8) {
            Image("Star")
                .offset(y: -3)
            Text(String(format: "%.1f", viewModel.stars))
                .fontBold(color: .appYellow, size: 18)
        }
    }

    private var address: some View {
        HStack(spacing: 6.5) {
            Image(systemName: "mappin")
                .foregroundColor(.appBookingBlue)
                .frame(width: 11, height: 14)
            Text(viewModel.address)
                .fontRegular(color: .appBookingBlue, size: 16)
            Spacer()
        }
    }

    private var details: some View {
        VStack(spacing: -2) {
            detailsHeader
            roomDesription
            badges
            description
        }
        .padding(.top, 30)
    }

    private var detailsHeader: some View {
        HStack {
            Text("Details")
                .fontBold(color: .appDarkGray, size: 18)
            Spacer()
        }
    }

    private var roomDesription: some View {
        HStack {
            Text(viewModel.roomDesription)
                .fontRegular(color: .appGray, size: 16)
            Spacer()
        }
    }

    private var badges: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.badges, id: \.self) { badge in
                    badgeView(image: badge.imageName, title: badge.label)
                }
            }
        }
        .padding(.top, 20)
    }

    private func badgeView(image: String, title: String) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.04))
            .overlay(
                VStack {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 21)
                    Text(title)
                        .fontRegular(color: .appGray, size: 12)
                }
                .padding(.top, 5)
            )
            .frame(width: 80, height: 80)
    }

    private var description: some View {
        Text(viewModel.description)
            .fontRegular(color: .appGray, size: 16)
            .padding(.top, 32)
    }

}

struct BookingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookingScreen()
    }
}
