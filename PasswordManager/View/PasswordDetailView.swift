//
//  EditPasswordView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct PasswordDetailView: View {
  var pwManager = PasswordManager.shared
  var pw: FetchedResults<Passwords>.Element

  @State var hidePassword = true
  @State var showEditView = false

  var body: some View {
    VStack {
      TextView(title: "Username", text: pw.username!)
      if hidePassword {
        TextView(title: "Password", text: String(repeating: "●", count: pwManager.getPassword(pw.password!).count))
          .onTapGesture {
            hidePassword = false
          }
      } else {
        TextView(title: "Password", text: pwManager.getPassword(pw.password!))
          .onTapGesture {
            hidePassword = true
          }
      }

			CustomNavLink(destination: EditPasswordView(pw: pw), isActive: $showEditView) {
        EmptyView()
      }

      Spacer()
    }
    .padding()
    .customNavBarItems(title: pw.title!, showAddButton: true, buttonName: "Edit")
  }
}

struct TextView: View {
  var title: String
  var text: String

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
    Text(text)
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
//  PasswordDetailView(title: "Title", username: "Username", password: "Password")
//}
