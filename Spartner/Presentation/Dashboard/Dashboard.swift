//
//  Dashboard.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 08.03.25.
//

import SwiftUI

struct Dashboard: View {
    @StateObject private var userViewModel = DependencyInjection.shared
        .provideAuthViewModel()
    
    @StateObject private var dashboardViewModel = DependencyInjection.shared
        .provideDashboardViewModel()
    
    @EnvironmentObject var trackManger: TrackManager
    
    var body: some View {
        if dashboardViewModel.isLoading {
            LoadingView().withAppBackground()
        } else {
            DashboardContent(
                userViewModel: userViewModel,
                dashboardViewModel: dashboardViewModel
            ).withAppBackground()
        }
    }
}

// MARK: - Dashboard Content
struct DashboardContent: View {
    @ObservedObject var userViewModel: AuthViewModel
    @ObservedObject var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                DashboardHeader(userName: userViewModel.sportUser?.name)
                
                ChallengesSectionHeader()
                
                ChallengesContent(dashboardViewModel: dashboardViewModel)
            }
            .onAppear {
                if dashboardViewModel.challenges.isEmpty {
                    dashboardViewModel.fetchChallenges()
                }
            }
        }
    }
}

// MARK: - Dashboard Header
struct DashboardHeader: View {
    let userName: String?
    @State private var rotation = 0.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hey,")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(userName ?? "Athlete")!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            ActivityIndicator(rotation: $rotation)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 15)
    }
}

// MARK: - Activity Indicator
struct ActivityIndicator: View {
    @Binding var rotation: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 50, height: 50)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: rotation))
                .onAppear {
                    withAnimation(.linear(duration: 1.5)) {
                        rotation = 360
                    }
                }
            
            Image(systemName: "figure.run")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Challenges Section Header
struct ChallengesSectionHeader: View {
    var body: some View {
        Text("Your Challenges")
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Challenges Content
struct ChallengesContent: View {
    @ObservedObject var dashboardViewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            if dashboardViewModel.challenges.isEmpty {
                EmptyStateView()
            } else {
                ForEach(dashboardViewModel.challenges) { challenge in
                    ChallengeCard(challenge: challenge)
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 4)
                    .frame(width: 100, height: 100)
                
                Image(systemName: "flag.checkered")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Text("No challenges yet")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            Text("Check back soon for new fitness challenges")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 50)
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 5)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .stroke(Color.white, lineWidth: 5)
                    .frame(width: 120, height: 120)
                
                LottieView(
                    animationFileName: "warmup", loopMode: .loop
                )
                .frame(width: 120)
                .clipShape(.circle)
            }
        }
    }
}

#Preview {
    Dashboard()
}
