//
//  AuthenticationViews.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 08.03.25.
//

import SwiftUI

struct AuthenticationHeader: View {
    var text : String
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}


struct UsernameInputView: View {
    @Binding var username: String

    var body: some View {
        TextField(
            "", text: $username, prompt: Text("Username").foregroundColor(.gray)
        )
        .padding()
        .foregroundColor(Color.black)
        .background(
            Color(red: 239 / 255, green: 243 / 255, blue: 244 / 255)
        )
        .cornerRadius(5)
        .padding(.bottom, 20)
    }
}


struct EmailInputView: View {
    @Binding var email: String

    var body: some View {
        TextField(
            "", text: $email, prompt: Text("Email").foregroundColor(.gray)
        )
        .keyboardType(.emailAddress)
        .padding()
        .foregroundColor(Color.black)
        .background(
            Color(red: 239 / 255, green: 243 / 255, blue: 244 / 255)
        )
        .cornerRadius(5)
        .padding(.bottom, 20)
    }
}

struct PasswordInputView: View {
    @Binding var password: String
    var placeholder : String

    var body: some View {
        SecureField(
            "", text: $password, prompt: Text(placeholder).foregroundColor(.gray)
        )
        .padding()
        .foregroundColor(Color.black)
        .background(
            Color(red: 239 / 255, green: 243 / 255, blue: 244 / 255)
        )
        .cornerRadius(5)
    }
}

struct AuthenticationButtonContent: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.black)
            .cornerRadius(20)
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            .scaleEffect(2)
            .padding()
    }
}
