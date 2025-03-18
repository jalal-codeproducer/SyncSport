//
//  Register.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 02.03.25.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: AuthViewModel

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
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                AuthenticationHeader(text: "Sing up")

                UsernameInputView(username: $username)
                EmailInputView(email: $email)
                PasswordInputView(
                    password: $password, placeholder: "Password"
                )
                .padding(.bottom, 20)
                PasswordInputView(
                    password: $repeatPassword,
                    placeholder: "Repeat password")

                if viewModel.errorMessage != nil {
                    Text(viewModel.errorMessage!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(10)
                } else {
                    Spacer()
                        .frame(height: 30)
                }

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

                        AuthenticationButtonContent(text: "Register")

                    }.padding(.bottom, 10)

                    Text("or")
                        .padding(.bottom, 10)
                        .fontDesign(.rounded)
                        .foregroundColor(.black)

                    Button(action: {
                        Task {
                            if !viewModel.isLoading {
                                await viewModel.loginAnonymously()
                            }
                        }
                    }) {
                        AuthenticationButtonContent(text: "Sign in as a Guest")
                    }.padding(.bottom, 20)
                } else {
                    LoadingView()
                }

                Button("Already have an account? Login!") {
                    if !viewModel.isLoading {
                        isRegistering = false
                    }
                }
                .font(.subheadline)
                .foregroundColor(.gray)

            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isRegistering = false
        @State private var isAuthenticated = false

        var body: some View {
            RegisterView(
                isRegistering: $isRegistering)
        }
    }

    return PreviewWrapper()
}

struct RegisterText: View {
    var body: some View {
        Text("Register")
            .foregroundColor(.black)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}
