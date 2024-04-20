//
//  EditPasswordView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct PasswordDetailView: View {
  @Environment(\.dismiss) var dismiss

  var pwManager = PasswordManager.shared
  var pw: FetchedResults<Passwords>.Element

  @State var hidePassword = true
  @State var showEditView = false
  @State private var showCopy = false

  var body: some View {
    ZStack {
      VStack {
        TextView(title: "Username", 
                 text: pw.username!,
                 showCopy: $showCopy)
        if hidePassword {
          // display password as "●"
          TextView(title: "Password", 
                   text: String(repeating: "●", 
                                count: pwManager.getPassword(pw.password!).count),
                   showCopy: $showCopy)
            .onTapGesture {
              hidePassword = false
            }
        } else {
          TextView(title: "Password",
                   text: pwManager.getPassword(pw.password!),
                   showCopy: $showCopy)
            .onTapGesture {
              hidePassword = true
            }
        }

        Spacer()
      }
      .onChange(of: showCopy) { _, newVal in
        if newVal {
          // show copy popup view for a second
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showCopy = false
          }
        }
      }

      PopupView(text: "Text Copied", show: $showCopy)
    }
    .navigationDestination(isPresented: $showEditView, destination: {
      EditPasswordView(pw: pw)
    })
    .padding()
    .navigationTitle(pw.title!)
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
					showEditView = true
				} label: {
					Label("Edit", systemImage: "edit")
				}
			}
		}
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }
}

struct TextView: View {
  var title: String
  var text: String
  @Binding var showCopy: Bool

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
				// copies entered text
        if !text.contains("●") {
          HStack {
            Spacer()
            Image(systemName: "doc")
              .padding()
              .opacity(0.5)
              .onTapGesture {
                showCopy = true
                UIPasteboard.general.string = text
              }
          }
        }
      }
  }
}

struct PopupView: View {
  var text: String
  @Binding var show: Bool

  var body: some View {
    VStack {
      Spacer()
      Text("Text Copied")
        .padding()
        .frame(width: 280, alignment: .center)
        .foregroundStyle(Color.white)
        .background(Color(.orange))
        .cornerRadius(12)
    }
    .opacity(show ? 1 : 0)
  }
}

//#Preview {
//  PasswordDetailView(title: "Title", username: "Username", password: "Password")
//}
