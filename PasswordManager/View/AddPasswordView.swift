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
	@State private var strongPassword = ""
	@State private var showCopy = false
	@State private var pwStrength = 0
	
	var body: some View {
		ZStack {
			VStack {
				TextFieldView(title: "Title", showFooter: true, text: $title, pwEntered: $pwEntered)
				Divider()
				TextFieldView(title: "Username", showFooter: true, text: $username, pwEntered: $pwEntered)
				Divider()
				TextFieldView(title: "Password", showFooter: true, text: $password, pwEntered: $pwEntered, pwStrength: pwStrength)
				
				HStack {
					Text("Recommended Password")
						.font(.subheadline)
						.bold()
						.opacity(0.5)
						.frame(maxWidth: .infinity, alignment: .leading)
						.offset(x: 10)
					Spacer()
				}
				Text(strongPassword)
					.frame(maxWidth: .infinity, alignment: .leading)
					.offset(x: 10)
					.onLongPressGesture {
						showCopy = true
						UIPasteboard.general.string = strongPassword
					}
					.onChange(of: showCopy, { _, newVal in
						if newVal {
							password = strongPassword
							DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
								showCopy = false
							}
						}
					})
				
				Spacer()
			}
			.opacity(showCopy ? 0.7 : 1)
			
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
		.onChange(of: password, { _, _ in
			pwStrength = pwManager.getPasswordStrength(password)
		})
		.onAppear {
			strongPassword = pwManager.generatePassword(length: 12)
		}
		.toolbar {
			// back button to go back to previous screen
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
			
			// saves new password
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					// only save if all entries are entered
					if title.isEmpty || username.isEmpty || password.isEmpty {
						pwEntered = true
					} else {
						pwManager.addPassword(Password(title: title, username: username, password: password), context: managedObjContext)
						dismiss()
					}
				} label: {
					Text("Done")
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
