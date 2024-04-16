//
//  EditPasswordView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/16/24.
//

import SwiftUI

struct EditPasswordView: View {
  var pwManager = PasswordManager.shared
  var username: String

  var body: some View {
    VStack {
      Text("Edit Password View")
      Spacer()
      Text("username: \(username)")
    }
  }
}

struct TextFieldView: View {
  var title: String
  @Binding var text: String

  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
        .bold()
        .opacity(0.5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
      Spacer()
    }
    TextField("", text: $text)
      .padding()
      .opacity(0.7)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(.systemGray6))
      .cornerRadius(10)
      .overlay {
        HStack {
          Spacer()
          Image(systemName: "doc")
            .padding()
            .opacity(0.5)
            .onTapGesture {
              UIPasteboard.general.string = text
            }
        }
      }
  }
}

//#Preview {
//  EditPasswordView()
//}
