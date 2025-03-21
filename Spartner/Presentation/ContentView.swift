//
//  ContentView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var trackManager: TrackManager
    @StateObject private var authViewModel = DependencyInjection.shared
        .provideAuthViewModel()
    var challengeViewModel = DependencyInjection.shared
        .provideDashboardViewModel()

    @State private var selectedIndex: Int = 0
    @State private var isRegistering = false
    @State private var isAuthenticated = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        NavigationStack {
            if authViewModel.showSplash {
                SplashView()
            } else {
                if !hasSeenOnboarding {
                    OnBoardingView()
                } else {
                    if authViewModel.isLoggedIn {
                        ZStack(alignment: .bottom) {
                            TabView(selection: $selectedIndex) {
                                NavigationStack {
                                    Dashboard()
                                }
                                .tag(0)

                                NavigationStack {
                                    ProfileView(
                                        user: SportUser(
                                            name: "John Doe",
                                            email: "john.doe@example.com",
                                            points: 275
                                        ))
                                }
                                .tag(1)
                            }
                            .tabViewStyle(
                                PageTabViewStyle(indexDisplayMode: .never)
                            )
                            .withAppBackground()
                            CustomTabBar(selectedIndex: $selectedIndex)
                        }
                    } else {
                        if isRegistering {
                            RegisterView(
                                isRegistering: $isRegistering
                            )
                        } else {
                            LoginView(
                                isRegistering: $isRegistering,
                                isAuthenticated: $isAuthenticated
                            )
                        }
                    }
                }
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedIndex: Int

    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                icon: selectedIndex == 0
                    ? "flag.checkered.circle.fill" : "flag.checkered.circle",
                title: "Dashboard",
                isSelected: selectedIndex == 0,
                action: { selectedIndex = 0 }
            )

            TabButton(
                icon: selectedIndex == 1
                    ? "person.crop.circle.fill" : "person.crop.circle",
                title: "Profile",
                isSelected: selectedIndex == 1,
                action: { selectedIndex = 1 }
            )
        }
        .background(TabBarBackground())
        .cornerRadius(30)
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22))

                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                Color.black.opacity(0.04)
            )
        }
    }
}

struct TabBarBackground: View {
    var body: some View {
        Color.black.opacity(0.6)
            .background(.ultraThinMaterial)
            .blur(radius: 0.5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TrackManager())
    }
}
