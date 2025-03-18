//
//  ContentView.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = DependencyInjection.shared
        .provideAuthViewModel()
    @State private var email = ""
    @State private var password = ""

    @Binding var isRegistering: Bool
    @Binding var isAuthenticated: Bool

    init(
        isRegistering: Binding<Bool>, isAuthenticated: Binding<Bool>
    ) {
        self._isRegistering = isRegistering
        self._isAuthenticated = isAuthenticated
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                AuthenticationHeader(text: "Welcome Back")

                EmailInputView(email: $email)
                PasswordInputView(
                    password: $password, placeholder: "Password")

                if viewModel.errorMessage != nil {
                    Text(viewModel.errorMessage!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(10)
                } else {
                    Spacer().frame(height: 20)
                }

                Button(action: {
                    Task {
                        if !viewModel.isLoading {
                            isAuthenticated = await viewModel.login(
                                email: email, password: password)
                        }
                    }
                }) {
                    if !viewModel.isLoading {
                        AuthenticationButtonContent(text: "Login")
                    } else {
                        LoadingView()
                    }
                }.padding(.bottom, 20)

                Button("Don't have an account? Register!") {
                    if !viewModel.isLoading {
                        isRegistering = true
                    }
                }
                .font(.subheadline)
                .foregroundColor(.gray)

            }.padding()
        }

    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isRegistering = false
        @State private var isAuthenticated = false

        var body: some View {
            LoginView(
                isRegistering: $isRegistering,
                isAuthenticated: $isAuthenticated)
        }
    }

    return PreviewWrapper()
}
