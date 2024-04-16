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

  var body: some View {
    ZStack {
      HStack {
        Spacer()
        titleSection
        Spacer()
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

  private var titleSection: some View {
    VStack(spacing: 4) {
      Text(title)
        .font(.title2)
        .fontWeight(.semibold)
    }
  }

}
