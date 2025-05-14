//
//  RegisterView.swift
//  SyncSports
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = DependencyInjection.shared
        .provideAuthViewModel()
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""

    @Binding var isRegistering: Bool

    init(
        isRegistering: Binding<Bool>
    ) {
        self._isRegistering = isRegistering
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 80, height: 80)

                    Image(systemName: "figure.run")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)

                Text("Create Account")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                VStack(spacing: 16) {
                    AuthField(
                        text: $username,
                        icon: "person.fill",
                        title: "Username",
                        placeholder: "Enter your username"
                    )

                    AuthField(
                        text: $email,
                        icon: "envelope.fill",
                        title: "Email",
                        placeholder: "Enter your email",
                        keyboardType: .emailAddress
                    )

                    AuthField(
                        text: $password,
                        icon: "lock.fill",
                        title: "Password",
                        placeholder: "Create a password",
                        isSecure: true
                    )

                    AuthField(
                        text: $repeatPassword,
                        icon: "lock.shield.fill",
                        title: "Confirm Password",
                        placeholder: "Repeat your password",
                        isSecure: true
                    )
                }

                if viewModel.errorMessage != nil {
                    Text(viewModel.errorMessage!)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.7))
                        )
                        .padding(.top, 5)
                }

                VStack(spacing: 15) {
                    if !viewModel.isLoading {
                        Button(action: {
                            Task {
                                if !viewModel.isLoading {
                                    await viewModel.register(
                                        email: email,
                                        password: password,
                                        repeatPassword: repeatPassword,
                                        name: username)
                                }
                            }
                        }) {
                            HStack {
                                Text("Register")
                                    .font(
                                        .system(
                                            size: 18, weight: .bold,
                                            design: .rounded))
                                Image(systemName: "person.badge.plus.fill")
                            }
                            .foregroundColor(Color(hex: "1a2a6c"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(
                                        color: Color.black.opacity(0.1),
                                        radius: 5, x: 0, y: 3)
                            )
                        }

                        HStack {
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)

                            Text("or")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)

                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 5)
                    } else {
                        // Loading state
                        VStack {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .scaleEffect(1.5)

                            Text("Creating your account...")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                        .frame(height: 100)
                    }
                }
                .padding(.top, 5)

                Button(action: {
                    if !viewModel.isLoading {
                        withAnimation {
                            isRegistering = false
                        }
                    }
                }) {
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 16, design: .rounded))

                        Text("Login!")
                            .font(
                                .system(
                                    size: 16, weight: .bold, design: .rounded)
                            )
                    }
                    .foregroundColor(.white)
                    .padding(.top, 10)
                }
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 30)
        }
        .withAppBackground()
        .navigationBarBackButtonHidden(true)

    }

}

#Preview {
    struct PreviewWrapper: View {
        @State private var isRegistering = true

        var body: some View {
            RegisterView(
                isRegistering: $isRegistering)
        }
    }

    return PreviewWrapper()
}
