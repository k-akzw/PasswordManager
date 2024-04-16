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

struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {

  static var defaultValue: String? = nil

  static func reduce(value: inout String?, nextValue: () -> String?) {
    value = nextValue()
  }
}

struct CustomNavBarBackButtonHiddenPreferenceKey: PreferenceKey {

  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct CustomNavBarHideKeyboardPreferenceKey: PreferenceKey {

  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct CustomNavBarShowButtonPreferenceKey: PreferenceKey {

  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}

struct CustomNavBarButtonNamePreferenceKey: PreferenceKey {

  static var defaultValue: String = ""

  static func reduce(value: inout String, nextValue: () -> String) {
    value = nextValue()
  }
}

extension View {

  // only set the title
  func customNavigationTitle(_ title: String) -> some View {
    preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
  }

  // only set the subtitle
  func customNavigationSubtitle(_ subtitle: String?) -> some View {
    preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
  }

  // only set the backbutton
  func customNavigationBackButtonHidden(_ hidden: Bool) -> some View {
    preference(key: CustomNavBarBackButtonHiddenPreferenceKey.self, value: hidden)
  }

  // only set the hide keyboard button
  func customNavigationHideKeyboardButton(_ show: Bool) -> some View {
    preference(key: CustomNavBarHideKeyboardPreferenceKey.self, value: show)
  }

  // only set the showbutton
  func customNavigationShowButton(_ show: Bool) -> some View {
    preference(key: CustomNavBarShowButtonPreferenceKey.self, value: show)
  }

  // only set the button name
  func customNavigationButtonName(_ name: String) -> some View {
    preference(key: CustomNavBarButtonNamePreferenceKey.self, value: name)
  }

  // assign all four variables
  func customNavBarItems(title: String = "", subtitle: String? = nil , backButtonHidden: Bool = false, showHideKeyboardButton: Bool = false, showAddButton: Bool = false, buttonName: String = "", view: any View = EmptyView(), action: @escaping () -> Void = {}) -> some View {
    self
      .customNavigationTitle(title)
      .customNavigationSubtitle(subtitle)
      .customNavigationBackButtonHidden(backButtonHidden)
      .customNavigationHideKeyboardButton(showHideKeyboardButton)
      .customNavigationShowButton(showAddButton)
      .customNavigationButtonName(buttonName)
  }
}

