//
//  CustomNavBarView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

// Model for custom navigation bar
struct CustomNavBarView: View {

  // used for back button to go back to previous screen
  @Environment(\.presentationMode) var presentationMode
  let title: String
  let subTitle: String?
  let showBackButton: Bool
  let showHideKeyboard: Bool
  let showButton: Bool
  let buttonName: String

  var body: some View {
    ZStack {
      HStack {
        if showBackButton {
          backButton
        }
        if showHideKeyboard || showButton {
          hideKeyboardButton.opacity(0)
        }
        Spacer()
        titleSection
        Spacer()
        // does not display the back button
        // but there to center the title
        if showBackButton {
          backButton.opacity(0)
        }
        if showHideKeyboard {
          hideKeyboardButton
        } else if showButton {
          newButton
        }
      }
    }
    .padding()
    .accentColor(.white)
    .font(.headline)
    .foregroundColor(.white)
    .background(
      Color.orange.opacity(0.8)
    )
  }
}

extension CustomNavBarView {

  private var backButton: some View {
    Button(action: {
      // goes back to previous screen
      // this is how the default back button works
      presentationMode.wrappedValue.dismiss()
    }, label: {
      Label("Back", systemImage: "chevron.left")
    })
  }

  private var titleSection: some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.title2)
        .fontWeight(.semibold)
      // subtitle can be nil
      // so only add if not nil
      if let subTitle = subTitle{
        Text(subTitle)
      }
    }
  }

  private var hideKeyboardButton: some View {
    Image(systemName: "keyboard.chevron.compact.down")
      .onTapGesture {
        hideKeyboard()
      }
  }

  private var newButton: some View {
    Image(systemName: buttonName)
      .onTapGesture {
      }
  }

}

extension View {
  // hides the keyboard
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil)
  }
}

