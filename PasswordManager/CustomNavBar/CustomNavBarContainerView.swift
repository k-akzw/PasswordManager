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
  @State private var subTitle: String? = nil
  @State private var showBackButton = true
  @State private var showHideKeyboard = false
  @State private var showButton = false
  @State private var buttonName = ""

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    VStack(spacing: 0) {
      CustomNavBarView(title: title, subTitle: subTitle, showBackButton: showBackButton, showHideKeyboard: showHideKeyboard, showButton: showButton, buttonName: buttonName)

      content
    }
    .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: { value in
      self.title = value
    })
    .onPreferenceChange(CustomNavBarSubtitlePreferenceKey.self, perform: { value in
      self.subTitle = value
    })
    .onPreferenceChange(CustomNavBarBackButtonHiddenPreferenceKey.self, perform: { value in
      // since the preference key is whether it's hidden or not
      // @value will be true if hidden, false if shown
      // so, @showBackButton should be opposite of that
      self.showBackButton = !value
    })
    .onPreferenceChange(CustomNavBarHideKeyboardPreferenceKey.self) { value in
      self.showHideKeyboard = value
    }
    .onPreferenceChange(CustomNavBarShowButtonPreferenceKey.self, perform: { value in
      self.showButton = value
    })
    .onPreferenceChange(CustomNavBarButtonNamePreferenceKey.self, perform: { value in
      self.buttonName = value
    })
  }
}
