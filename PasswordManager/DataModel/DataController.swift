//
//  DataController.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "Passwords")

  init() {
    container.loadPersistentStores { desc, error in
      if let error = error {
        print("Failed to load the data \(error.localizedDescription)")
      }
    }
  }

  func save(context: NSManagedObjectContext) {
    do {
      try context.save()
      print("Data saved")
    } catch {
      print("could not save the data...")
    }
  }

  func addPassword(title: String, username: String, password: Data, context: NSManagedObjectContext) {
    let pw = Passwords(context: context)
    pw.id = UUID()
    pw.title = title
    pw.username = username
    pw.password = password

    save(context: context)
  }

  func editPassword(_ pw: Passwords, title: String, username: String, password: Data, context: NSManagedObjectContext) {
    pw.title = title
    pw.username = username
    pw.password = password

    save(context: context)
  }
}
