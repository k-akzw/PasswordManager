//
//  CustomNavView.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI

struct CustomNavView<Content: View>: View {

  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    NavigationStack {
      CustomNavBarContainerView {
        content
      }
      .navigationBarHidden(true)
    }
  }
}

extension UINavigationController {
  open override func viewDidLoad() {
    super.viewDidLoad()
    // allows for swiping left to go back to preivous screen
    interactivePopGestureRecognizer?.delegate = nil
  }
}
