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

  var body: some View {
    Form {
      Section {
        TextField("Title", text: $title)
        TextField("Username", text: $username)
        TextField("Password", text: $password)

        HStack {
          Spacer()
          Button("Submit") {
            pwManager.addPassword(Password(title: title, username: username, password: password), context: managedObjContext)
            dismiss()
          }
          Spacer()
        }
      }
    }
  }
}

//#Preview {
//  AddPasswordView()
//}
