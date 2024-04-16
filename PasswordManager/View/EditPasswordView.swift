//
//  EditPasswordView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/16/24.
//

import SwiftUI

struct EditPasswordView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @Environment(\.dismiss) var dismiss

  var pwManager = PasswordManager.shared
  var pw: FetchedResults<Passwords>.Element

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
    .padding()
    .onAppear {
      title = pw.title!
      username = pw.username!
      password = pwManager.getPassword(pw.password!)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          if title.isEmpty || username.isEmpty || password.isEmpty {
            pwEntered = true
          } else {
            pwManager.editPassword(Password(title: title, username: username, password: password), to: pw, context: managedObjContext)
            dismiss()
          }
        } label: {
          Label("Done", systemImage: "done")
        }
      }

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
    }
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

struct TextFieldView: View {
  var title: String
  var showFooter: Bool
  @Binding var text: String
  @Binding var pwEntered: Bool

  var body: some View {
    Section {
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
            Image(systemName: "xmark.circle.fill")
              .padding()
              .foregroundColor(Color.secondary)
              .onTapGesture {
                text = ""
              }
          }
        }
        .onChange(of: text) { _, newVal in
          // when user deletes the wrong password previously entered
          // reset @passwordEntered
          // so that it doesn't give error message
          // while retyping the password
          if newVal.isEmpty {
            pwEntered = false
          }
        }
    } footer: {
      Text("This field cannot be empty. ")
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
        .opacity(showFooter && pwEntered && text.isEmpty ? 1 : 0)
        .padding(0)
    }
  }
}

//#Preview {
//	EditPasswordView()
//}
