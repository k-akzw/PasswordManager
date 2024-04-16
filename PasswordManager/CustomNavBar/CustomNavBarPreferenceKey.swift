//
//  CustomNavBarPreferenceKey.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct CustomNavBarTitlePreferenceKey: PreferenceKey {

  static var defaultValue: String = ""

  static func reduce(value: inout String, nextValue: () -> String) {
    value = nextValue()
  }
}

extension View {

  func customNavigationTitle(_ title: String) -> some View {
    preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
  }
}

