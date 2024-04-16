//
//  PasswordListView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct PasswordListView: View {
  @Environment(\.managedObjectContext) var managedObjContext
  @FetchRequest(sortDescriptors: [SortDescriptor(\Passwords.title)]) var pw: FetchedResults<Passwords>

  private var pwManager = PasswordManager.shared

  @State private var username = ""
  @State private var showAddView = false

  var body: some View {
    VStack {
      List {
        ForEach(pw) { pw in
          NavigationLink(destination: PasswordDetailView(pw: pw)) {
            VStack {
              Text(pw.title!)
                .font(.subheadline)
                .bold()
                .opacity(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)

              Text(pw.username!)
                .font(.footnote)
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }
        .onDelete(perform: deletePassword)
      }

      NavigationLink(destination: AddPasswordView(), isActive: $showAddView) {
        EmptyView()
      }

      Spacer()
    }
    .navigationTitle("Password List")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showAddView.toggle()
				} label: {
					Label("Add", systemImage: "plus.circle")
				}
			}
		}
    .toolbarBackground(.orange, for: .navigationBar)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarColorScheme(.dark, for: .navigationBar)
    .navigationBarBackButtonHidden()
  }

  private func deletePassword(offsets: IndexSet) {
    withAnimation {
      offsets.map { pw[$0] }.forEach(managedObjContext.delete)

      DataController().save(context: managedObjContext)
    }
  }
}


//#Preview {
//  PasswordListView()
//}
