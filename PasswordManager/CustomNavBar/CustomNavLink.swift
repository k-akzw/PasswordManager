//
//  CustomNavLink.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

// This is basically NavigationLink in SwiftUI
// but instead of next view is in NavigationView
// it is contained inside CustomNavView
// so that the title can be customized on the next view as well
struct CustomNavLink<Destination: View, Label: View>: View {

  class BindingContainer: ObservableObject {
    @Binding var isActive: Bool

    init(isActive: Binding<Bool>) {
      _isActive = isActive
    }
  }

  let destination: Destination
  @ObservedObject private var bindingContainer: BindingContainer
  let label: Label

  init(destination: Destination, isActive: Binding<Bool>, @ViewBuilder label: () -> Label) {
    self.destination = destination
    self.bindingContainer = BindingContainer(isActive: isActive)
    self.label = label()
  }

  var body: some View {
    NavigationLink(destination: CustomNavBarContainerView(content: {
      destination
    }).navigationBarBackButtonHidden(true)
      .navigationBarTitleDisplayMode(.inline), isActive: $bindingContainer.isActive) {
        label
      }
  }
}
