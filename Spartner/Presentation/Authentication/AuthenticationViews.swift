//
//  AuthenticationViews.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 08.03.25.
//

import SwiftUI

struct AuthenticationHeader: View {
    var text: String

    var body: some View {
        Text(text)
            .foregroundColor(.black)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
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


struct AuthField: View {
    @Binding var text: String
    var icon: String
    var title: String
    var placeholder: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(width: 20)

                if isSecure {
                    SecureField("", text: $text)
                        .placeholder(when: $text.wrappedValue.isEmpty) {
                            Text(placeholder).foregroundColor(
                                .white.opacity(0.7))
                        }
                        .foregroundColor(.white)
                } else {
                    TextField("", text: $text)
                        .placeholder(when: $text.wrappedValue.isEmpty) {
                            Text(placeholder).foregroundColor(
                                .white.opacity(0.7))
                        }
                        .foregroundColor(.white)
                        .keyboardType(keyboardType)
                        .autocapitalization(
                            keyboardType == .emailAddress ? .none : .words
                        )
                        .disableAutocorrection(keyboardType == .emailAddress)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.2))
            )
        }
    }

}
