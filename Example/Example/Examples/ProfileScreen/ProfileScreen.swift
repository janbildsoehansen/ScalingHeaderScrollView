//
//  ProfileScreen.swift
//  Example
//
//  Created by Danil Kristalev on 01.11.2021.
//  Copyright © 2021 Exyte. All rights reserved.
//

import SwiftUI
import ScalingHeaderView

struct ProfileScreen: View {
    
    @ObservedObject private var viewModel = ProfileScreenViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    private let minHeight = 110.0
    private let maxHeight = 372.0

    var body: some View {
        ZStack {
            ScalingHeaderView { progress in
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    largeHeader(progress: progress)
                }
            } content: {
                profilerContentView
            }
            .height(min: minHeight, max: maxHeight)
            .allowsHeaderCollapse(false)
            .allowsHeaderScale(true)
            
            topButtons
        }
        .ignoresSafeArea()
    }

    private var topButtons: some View {
        VStack {
            HStack {
                Button("", action: { self.presentationMode.wrappedValue.dismiss() })
                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward"))
                    .padding(.leading, 17)
                    .padding(.top, 50)
                Spacer()
                Button("", action: { print("Info") })
                    .buttonStyle(CircleButtonStyle(imageName: "ellipsis"))
                    .padding(.trailing, 17)
                    .padding(.top, 50)
            }
            Spacer()
        }
        .ignoresSafeArea()
    }

    private var hireButton: some View {
        VStack {
            Spacer()
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .regular))
                    .frame(height: 180)
                    .padding(.bottom, -100)
                HStack {
                    Button("Hire", action: { print("hire") })
                        .buttonStyle(HireButtonStyle())
                        .padding(.horizontal, 15)
                        .frame(width: 396, height: 60, alignment: .bottom)
                }
            }
        }
        .ignoresSafeArea()
        .padding(.bottom, 40)
    }
    
    private var smallHeader: some View {
        HStack(spacing: 12.0) {
            Image(viewModel.avatarImage)
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))

            Text(viewModel.userName)
                .font(.custom("Circe", size: 17))
        }
    }
    
    private func largeHeader(progress: CGFloat) -> some View {
        ZStack {
            Image(viewModel.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(height: maxHeight)
                .opacity(1 - progress)
            
            VStack {
                Spacer()
                
                HStack(spacing: 4.0) {
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white)
                    
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white.opacity(0.2))
                    
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white.opacity(0.2))
                }
                
                ZStack(alignment: .leading) {

                    VisualEffectView(effect: UIBlurEffect(style: .regular))
                        .mask(Rectangle().cornerRadius(40, corners: [.topLeft, .topRight]))
                        .offset(y: 10.0)
                        .frame(height: 80.0)

                    RoundedRectangle(cornerRadius: 40.0, style: .circular)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.0), .white]), startPoint: .top, endPoint: .bottom)
                        )

                    userName
                        .padding(.leading, 24.0)
                        .padding(.top, 10.0)
                        .opacity(1 - max(0, min(1, (progress - 0.75) * 4.0)))

                    smallHeader
                        .padding(.leading, 85.0)
                        .opacity(progress)
                        .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                }
                .frame(height: 80.0)
            }
        }
    }
    
    private var profilerContentView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    personalInfo
                    reviews
                    skills
                    description
                    portfolio
                    Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private var personalInfo: some View {
        VStack(alignment: .leading) {
            profession
            address
        }
    }

    private var userName: some View {
        Text(viewModel.userName)
            .foregroundColor(Color.hex("#0C0C0C"))
            .font(.custom("Circe-Bold", size: 24))
    }

    private var profession: some View {
        Text(viewModel.profession)
            .foregroundColor(Color.hex("#0C0C0C").opacity(0.8))
            .font(.custom("Circe-Regular", size: 16))
    }

    private var address: some View {
        Text(viewModel.address)
            .foregroundColor(Color.hex("#0C0C0C").opacity(0.4))
            .font(.custom("Circe-Regular", size: 16))
    }

    private var reviews: some View {
        HStack(alignment: .center , spacing: 8) {
            Image("Star")
                .offset(y: -3)
            grade
            reviewCount
        }
    }

    private var grade: some View {
        Text(String(format: "%.1f", viewModel.grade))
            .foregroundColor(Color.hex("#FFAC0C"))
            .font(.custom("Circe-Bold", size: 18))
    }

    private var reviewCount: some View {
        Text("\(viewModel.reviewCount) reviews")
            .foregroundColor(Color.hex("#0C0C0C").opacity(0.4))
            .font(.custom("Circe-Regular", size: 16))
    }

    private var skills: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Skils")
                .foregroundColor(Color.hex("#0C0C0C"))
                .font(.custom("Circe-Bold", size: 18))

            HStack {
                ForEach((0 ..< 3)) { col in
                    skillView(for: viewModel.skils[col])
                }
            }
            HStack {
                ForEach((0 ..< 3)) { col in
                    skillView(for: viewModel.skils[col + 3])
                }
            }
        }
    }

    func skillView(for skill: String) -> some View {
        Text(skill)
            .padding(.vertical, 5)
            .padding(.horizontal, 14)
            .font(.custom("Circe", size: 16))
            .foregroundColor(Color.hex("#374BFE"))
            .lineLimit(1)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.hex("#374BFE").opacity(0.08))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.hex("#374BFE")))
            )
    }

    private var description: some View {
        Text(viewModel.description)
            .foregroundColor(Color.hex("#0C0C0C").opacity(0.8))
            .font(.custom("Circe", size: 16))
    }

    private var portfolio: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(minimum: 100)),
            GridItem(.flexible(minimum: 100)),
            GridItem(.flexible(minimum: 100))
        ]) {
            ForEach(viewModel.portfolio, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileScreen()
        }
    }
}
