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
	// singleton instance of this class
	static let shared = PasswordManager()
	
	// keys for UserDefaults
	// used to get master password and symmetric key
	private let masterPwKey = "Master Password"
	private let symmetricKey = "Symmetric Key"
	// symmetric key used for encryption
	private var key = SymmetricKey(size: .bits256)
	private let saltLength = 16
	
	// MARK: - Initialization
	
	init() {
		// if the symmetric key has already been generated, assign it to @key
		// otherwise, create new key and save it to UserDefaults
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
	
	// set the master password
	func setMasterPassword(_ pw: String) {
		// hash the password before saving
		UserDefaults.standard.set(hashPassword(pw), forKey: masterPwKey)
	}
	
	// checks if master password has already been set
	func doesMasterPasswordExist() -> Bool {
		// master password is saved in UserDefaults
		return UserDefaults.standard.string(forKey: masterPwKey) != nil
	}
	
	// checks if master password saved in UserDefaults matches @pw
	func doesMasterPasswordMatch(_ pw: String) -> Bool {
		// get master password from UserDefault
		guard let masterPw = UserDefaults.standard.string(forKey: masterPwKey) else { return false }
		// since master password is saved after being hashed
		// compare @pw after hashing
		return hashPassword(pw) == masterPw
	}
	
	// add @pw to the database after encryption
	func addPassword(_ pw: Password, context: NSManagedObjectContext) {
		// encrypting
		guard let password = encrypt(pw.password) else { return }
		DataController().addPassword(title: pw.title,
																 username: pw.username,
																 password: password,
																 context: context)
	}
	
	// edit @pw in the database after encryption
	func editPassword(_ pw: Password, to passwords: Passwords, context: NSManagedObjectContext) {
		// encrypting
		guard let password = encrypt(pw.password) else { return }
		DataController().editPassword(passwords,
																	title: pw.title,
																	username: pw.username,
																	password: password,
																	context: context)
	}
	
	// decrypts @encryptedData and return the original password as string
	func getPassword(_ encryptedData: Data) -> String {
		// decryting
		guard let pw = decryptPassword(encryptedData) else { return "" }
		return pw
	}
	
	// generates password with @length
	func generatePassword(length: Int) -> String {
		let letters = ["abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "1234567890", "!@#$%^&*()-_=+[]{}|;:,.<>?/~"]
		// list of index where each type of letters (lowercase, uppercase, number, special char) are stored
		// this ensures that there is at least one character of each type
		let randomIndexes = Array(Array(0..<length).shuffled().prefix(4))
		
		var pw = Array<Character>(repeating: " ", count: 12)
	
		// assign each type of character to random index
		for i in 0..<letters.count {
			let tmp = letters[i]
			let randomIndex = Int.random(in: 0..<tmp.count)
			let randomCharacter = tmp[tmp.index(tmp.startIndex, offsetBy: randomIndex)]
			pw[randomIndexes[i]] = randomCharacter
		}
		
		// randomly pick character from letters
		for i in 0..<length {
			// if certain character is already determined from last loop
			// don't change that character
			if !randomIndexes.contains(i) {
				// random index to determine which type of letters
				var randomIndex = Int.random(in: 0..<letters.count)
				let tmp = letters[randomIndex]
				// random index to determine which character with in the lettters
				randomIndex = Int.random(in: 0..<tmp.count)
				let randomCharacter = tmp[tmp.index(tmp.startIndex, offsetBy: randomIndex)]
				pw[i] = randomCharacter
			}
		}
		return String(pw)
	}
	
	// calculates the strength of @pw
	func getPasswordStrength(_ pw: String) -> Int {
		var strength = 0
		
		// check length
		let length = pw.count
		if length >= 8 {
			strength += 1
		}
		
		// check for uppercase letters
		let uppercaseRegex = ".*[A-Z]+.*"
		if NSPredicate(format: "SELF MATCHES %@", uppercaseRegex).evaluate(with: pw) {
			strength += 1
		}
		
		// check for lowercase letters
		let lowercaseRegex = ".*[a-z]+.*"
		if NSPredicate(format: "SELF MATCHES %@", lowercaseRegex).evaluate(with: pw) {
			strength += 1
		}
		
		// check for digits
		let digitRegex = ".*[0-9]+.*"
		if NSPredicate(format: "SELF MATCHES %@", digitRegex).evaluate(with: pw) {
			strength += 1
		}
		
		// check for special characters
		let specialCharacterRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
		if NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex).evaluate(with: pw) {
			strength += 1
		}
		
		return strength
	}
	
	// MARK: - Private Functions
	
	// hash @pw using SHA-256
	private func hashPassword(_ pw: String) -> String {
		// convert string to data
		guard let passwordData = pw.data(using: .utf8) else {
			fatalError("Failed to convert password to data")
		}
		
		// hash the password using SHA-256
		// and convert to hexadecimal string
		return SHA256.hash(data: passwordData).map { String(format: "%02x", $0) }.joined()
	}
	
	// encrypts @pw and return encrypted password as Data
	private func encrypt(_ pw: String) -> Data? {
		// add salt and converts the password string to data using UTF8
		guard let data = (pw + getSalt()).data(using: .utf8) else { return nil }
		do {
			let sealedBox = try AES.GCM.seal(data, using: key)
			return sealedBox.combined
		} catch {
			print("Encryption failed: \(error.localizedDescription)")
			return nil
		}
	}
	
	// decrypts @encryptedData and return password as string
	private func decryptPassword(_ encryptedData: Data) -> String? {
		do {
			// decrypts using AES-GCM algorithm
			let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
			let decryptedData = try AES.GCM.open(sealedBox, using: key)
			// converts data to string using UTF8
			let decrypted = String(data: decryptedData, encoding: .utf8)
			return String(decrypted!.dropLast(saltLength))
		} catch {
			print("Decryption failed: \(error.localizedDescription)")
			return nil
		}
	}
	
	// returns random characters for salt
	private func getSalt() -> String {
		var res = ""
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		// randomly pick a character from @letters
		for _ in 0..<saltLength {
			let randomIndex = Int.random(in: 0..<letters.count)
			let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
			res += String(randomCharacter)
		}
		return res
	}
}
