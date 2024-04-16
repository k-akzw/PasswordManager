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
	
	var body: some View {
		Form {
			Section {
				TextFieldView(title: "\(pw.title!)", text: $title)
				TextFieldView(title: "\(pw.username!)", text: $username)
				TextFieldView(title: "\(password)", text: $password)
			}
			.padding()
			
			HStack {
				Spacer()
				Button(action: {
					pwManager.editPassword(Password(title: title, username: username, password: password), to: pw, context: managedObjContext)
					dismiss()
				}, label: {
					Text("Submit")
				})
			}
			
			Spacer()
		}
		.padding()
		.onAppear {
			title = pw.title!
			username = pw.username!
			password = pwManager.getPassword(pw.password!)
		}
		.customNavigationTitle("Edit Password")
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
					Image(systemName: "xmark.circle.fill")
						.padding()
						.foregroundColor(Color.secondary)
						.onTapGesture {
							text = ""
						}
				}
			}
	}
}

//#Preview {
//	EditPasswordView()
//}
