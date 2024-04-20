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
	@State private var strongPassword = ""
	@State private var showCopy = false
	@State private var pwStrength = 0

  var body: some View {
		ZStack {
			VStack {
				TextFieldView(title: "Title", 
                      showFooter: true,
                      text: $title,
                      pwEntered: $pwEntered)
				Divider()
				TextFieldView(title: "Username", 
                      showFooter: true,
                      text: $username,
                      pwEntered: $pwEntered)
				Divider()
				TextFieldView(title: "Password", 
                      showFooter: true,
                      text: $password,
                      pwEntered: $pwEntered,
                      pwStrength: pwStrength)
        Divider()
				StrongPasswordView(strongPassword: $strongPassword,
                           pw: $password,
                           showCopy: $showCopy)

				Spacer()
			}
			
			// popup view to let the user know that strong password is copied
			VStack {
				Spacer()
				Text("Text Copied")
					.padding()
					.frame(width: 280, alignment: .center)
					.foregroundStyle(Color.white)
					.background(Color(.orange))
					.cornerRadius(12)
			}
			.opacity(showCopy ? 1 : 0)
		}
    .padding()
		.onChange(of: password, { _, _ in
			pwStrength = pwManager.getPasswordStrength(password)
		})
    .onAppear {
      title = pw.title!
      username = pw.username!
      password = pwManager.getPassword(pw.password!)
			strongPassword = pwManager.generatePassword(length: 12)
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
            pwManager.editPassword(Password(title: title, username: username, password: password), to: pw, context: managedObjContext)
            dismiss()
          }
        } label: {
          Text("Done")
        }
        .disabled(title.isEmpty || username.isEmpty || password.isEmpty)
      }
    }
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

//#Preview {
//	EditPasswordView()
//}
