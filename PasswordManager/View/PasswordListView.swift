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
          @State var showDetailView = false
          @State var showEditView = false
          CustomNavLink(destination: PasswordDetailView(pw: pw), isActive: $showDetailView) {
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
          .onTapGesture {
            showDetailView = true
          }
        }
        .onDelete(perform: deletePassword)
      }

      CustomNavLink(destination: AddPasswordView(), isActive: $showAddView) {
        EmptyView()
      }

      Spacer()
    }
    .customNavBarItems(title: "Password List", backButtonHidden: true, showAddButton: false, buttonName: "plus.circle") {
      showAddView = true
    }
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					showAddView.toggle()
				} label: {
					Label("Add View", systemImage: "plus.circle")
				}
			}
		}
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
