//
//  ContentView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) var managedObjContext

  private var pwManager = PasswordManager.shared

  @State var accessGranted = false

  var body: some View {
    NavigationView {
      VStack {
        Spacer()

        Image(systemName: "lock")
          .resizable()
          .frame(width: 150, height: 200)
          .foregroundColor(.secondary)

        Text("Password Locked")
          .font(.headline)
          .opacity(0.5)
          .bold()

        Spacer()
          .frame(height: 10)

        MasterPasswordView(accessGranted: $accessGranted)

        NavigationLink(destination: PasswordListView(), isActive: $accessGranted) {
          EmptyView()
        }

        Spacer()
      }
      .padding()
      .navigationTitle("Password")
      .navigationBarTitleDisplayMode(.inline)
      .toolbarBackground(.orange, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarColorScheme(.dark, for: .navigationBar)
    }
  }
}

struct MasterPasswordView: View {
  var pwManager = PasswordManager.shared
  @State var masterPassword = ""
  @State var pwEntered = false

  @Binding var accessGranted: Bool

  var body: some View {
    if !pwManager.doesMasterPasswordExist() {
      Text("Set Password")
        .font(.subheadline)
        .bold()
        .opacity(0.5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
    }
    Section {
      TextField("Password", text: $masterPassword)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay {
          HStack {
            Spacer()
            Image(systemName: "xmark.circle.fill")
              .padding()
              .foregroundColor(Color.secondary)
              .onTapGesture {
                masterPassword = ""
              }
          }
          .opacity(masterPassword.isEmpty ? 0.0 : 1.0)
        }
        .onChange(of: masterPassword, { _, newVal in
          // when user deletes the wrong password previously entered
          // reset @passwordEntered
          // so that it doesn't give error message
          // while retyping the password
          if newVal.isEmpty {
            pwEntered = false
          }
        })
        .onSubmit {
          if pwManager.doesMasterPasswordExist() {
            accessGranted = pwManager.doesMasterPasswordMatch(masterPassword)
            if !accessGranted {
              pwEntered = true
            }
          } else {
            pwManager.setMasterPassword(masterPassword)
            accessGranted = true
          }
        }
    } footer: {
      Text("You entered wrong password")
        .foregroundStyle(.red)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(x: 10)
        .opacity(!masterPassword.isEmpty && pwEntered ? 1 : 0)
    }
  }
}

//#Preview {
//  ContentView()
//}
