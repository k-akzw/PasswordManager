//
//  PasswordManager.swift
//  PasswordManager
//
//  Created by Kento Akazawa on 4/15/24.
//

import SwiftUI
import CryptoKit
import CoreData

struct Password {
  var title: String
  var username: String
  var password: String
}

class PasswordManager {
  static let shared = PasswordManager()

  private let masterPwKey = "Master Password"
  private let symmetricKey = "Symmetric Key"
  private var key = SymmetricKey(size: .bits256)

  init() {
    if let keyData = UserDefaults.standard.data(forKey: symmetricKey) {
      do {
        key = try SymmetricKey(data: keyData)
      } catch {
        // error initializing symmetric key from data
        print("Error initializing SymmetricKey from data:", error)
      }
    } else {
      // generate symmetric key if it doesn't exist yet
      key = SymmetricKey(size: .bits256)
      do {
        // convert symmetric key to Data and store in UserDefaults
        let keyData = try key.withUnsafeBytes { Data($0) }
        UserDefaults.standard.set(keyData, forKey: symmetricKey)
      } catch {
        // error converting symmetric key to data
        print("Error converting SymmetricKey to data:", error)
      }
    }
  }


  // MARK: - Public Functions

  func setMasterPassword(_ pw: String) {
    UserDefaults.standard.set(hashPassword(pw), forKey: masterPwKey)
  }

  func doesMasterPasswordExist() -> Bool {
    return UserDefaults.standard.string(forKey: masterPwKey) != nil
  }

  func doesMasterPasswordMatch(_ pw: String) -> Bool {
    guard let masterPw = UserDefaults.standard.string(forKey: masterPwKey) else { return false }
    return hashPassword(pw) == masterPw
  }

  func addPassword(_ pw: Password, context: NSManagedObjectContext) {
    guard let password = encrypt(pw.password) else { return }
    DataController().addPassword(title: pw.title, 
                                 username: pw.username,
                                 password: password,
                                 context: context)
  }
	
	func editPassword(_ pw: Password, to passwords: Passwords, context: NSManagedObjectContext) {
		guard let password = encrypt(pw.password) else { return }
		DataController().editPassword(passwords, 
                                  title: pw.title,
                                  username: pw.username,
                                  password: password,
                                  context: context)
	}

  func getPassword(_ encryptedData: Data) -> String {
    guard let pw = decryptPassword(encryptedData) else { return "" }
    return pw
  }

  // MARK: - Private Functions

  private func hashPassword(_ pw: String) -> String {
    guard let passwordData = pw.data(using: .utf8) else {
      fatalError("Failed to convert password to data")
    }

    // hash the password using SHA-256
    // and convert to hexadecimal string
    return SHA256.hash(data: passwordData).map { String(format: "%02x", $0) }.joined()
  }

  private func encrypt(_ pw: String) -> Data? {
    guard let data = pw.data(using: .utf8) else { return nil }
    do {
      let sealedBox = try AES.GCM.seal(data, using: key)
      return sealedBox.combined
    } catch {
      print("Encryption failed: \(error.localizedDescription)")
      return nil
    }
  }

  private func decryptPassword(_ encryptedData: Data) -> String? {
    do {
      let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
      let decryptedData = try AES.GCM.open(sealedBox, using: key)
      return String(data: decryptedData, encoding: .utf8)
    } catch {
      print("Decryption failed: \(error.localizedDescription)")
      return nil
    }
  }
}
