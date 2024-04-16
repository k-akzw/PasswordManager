//
//  CustomNavBarContainerView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct CustomNavBarContainerView<Content: View>: View {

  let content: Content
  @State private var title = ""

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    VStack(spacing: 0) {
      CustomNavBarView(title: title)

      content
    }
    .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: { value in
      self.title = value
    })
  }
}
