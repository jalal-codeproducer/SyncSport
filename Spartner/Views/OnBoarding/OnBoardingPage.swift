//
//  OnBoardingPage.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 12.03.25.
//

import SwiftUI

struct OnBoardingPage: View {
    var onBoardingContent: OnBoardingContent

    var body: some View {
        ZStack {
            VStack {
                LottieView(
                    animationFileName: onBoardingContent.animation,
                    loopMode: .playOnce
                )
                .frame(width: 300, height: 300)

                Text(onBoardingContent.title)
                    .fontWeight(.heavy)
                    .font(.system(size: 50))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(onBoardingContent.headline)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                    .padding(.bottom, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)

            }
            .padding(.horizontal, 30)
            .frame(
                maxWidth: .infinity, maxHeight: .infinity, alignment: .center
            )
            .background(
                .white)
        }
    }
}

#Preview {
    var content = OnBoardingContent(
        animation: "trophy",
        title: "Track Your Progress",
        headline:
            "Log your runs, rides, and workouts in real time. Set goals, track stats, and see your improvement over time.")
    OnBoardingPage(onBoardingContent: content)
}

struct OnBoardingContent: Identifiable {
    var id = UUID()
    var animation: String
    var title: String
    var headline: String
}
