//
//  OnBoardingPage.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 12.03.25.
//

import SwiftUI

struct OnBoardingPage: View {
    var onBoardingContent: OnBoardingContent
    @Binding var lastPage: Bool
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(
                animationFileName: onBoardingContent.animation,
                loopMode: .playOnce
            )
            .frame(width: 300, height: 300)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(onBoardingContent.title)
                    .font(.system(size: 50, weight: .heavy))
                    .foregroundColor(.black)
                
                Text(onBoardingContent.headline)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 15)
            
            Spacer()
            
            Button(action: onNext) {
                Text(lastPage ? "Get Started" : "Next")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 150)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    OnBoardingPage(
        onBoardingContent: OnBoardingContent(
            animation: "trophy",
            title: "Track Your Progress",
            headline: "Log your runs, rides, and workouts in real time. Set goals, track stats, and see your improvement over time."
        ),
        lastPage: .constant(false),
        onNext: { print("Button Pressed!") }
    )
}

struct OnBoardingContent: Identifiable {
    let id = UUID()
    let animation: String
    let title: String
    let headline: String
}
