//
//  AddPasswordView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct AddPasswordView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss

  private var pwManager = PasswordManager.shared

  @State private var title = ""
  @State private var username = ""
  @State private var password = ""
  @State private var pwEntered = false

  var body: some View {
    VStack {
      TextFieldView(title: "Title", showFooter: true, text: $title, pwEntered: $pwEntered)
      Divider()
      TextFieldView(title: "Username", showFooter: true, text: $username, pwEntered: $pwEntered)
      Divider()
      TextFieldView(title: "Password", showFooter: true, text: $password, pwEntered: $pwEntered)

      Spacer()
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          dismiss()
        } label: {
          HStack {
            Image(systemName: "chevron.left")
            Text("Back")
          }
        }
      }

      ToolbarItem(placement: .topBarTrailing) {
        Button {
          if title.isEmpty || username.isEmpty || password.isEmpty {
            pwEntered = true
          } else {
            pwManager.addPassword(Password(title: title, username: username, password: password), context: managedObjContext)
            dismiss()
          }
        } label: {
          Label("Done", systemImage: "done")
        }
        .disabled(title.isEmpty || username.isEmpty || password.isEmpty)
      }
    }
    .padding()
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

//#Preview {
//  AddPasswordView()
//}
