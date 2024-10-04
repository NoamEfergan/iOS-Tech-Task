import Foundation
import Security

enum KeychainManager {
  private static let service = "MoneyBoxLogin"

  static func saveCredentialsToKeychain(email: String, password: String) {
    let credentials = [
      kSecClass as String: kSecClassInternetPassword,
      kSecAttrAccount as String: email,
      kSecValueData as String: password.data(using: .utf8)!,
      kSecAttrServer as String: service
    ] as [String: Any]

    // Delete any existing credential
    SecItemDelete(credentials as CFDictionary)

    // Add the new credential
    let status = SecItemAdd(credentials as CFDictionary, nil)
    if status != errSecSuccess {
      print("Error saving credentials to Keychain: \(status)")
    }
  }

  static func fetchCredentialsFromKeychain() -> (email: String, password: String)? {
    let query = [
      kSecClass as String: kSecClassInternetPassword,
      kSecAttrServer as String: service,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true
    ] as [String: Any]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)

    guard status == errSecSuccess,
          let existingItem = item as? [String: Any],
          let passwordData = existingItem[kSecValueData as String] as? Data,
          let password = String(data: passwordData, encoding: .utf8),
          let account = existingItem[kSecAttrAccount as String] as? String
    else {
      return nil
    }

    return (email: account, password: password)
  }

  static func clearCredentialsFromKeychain() {
    let query = [
      kSecClass as String: kSecClassInternetPassword,
      kSecAttrServer as String: service
    ] as [String: Any]

    let status = SecItemDelete(query as CFDictionary)

    if status == errSecSuccess {
      print("Credentials successfully cleared from Keychain")
    } else if status == errSecItemNotFound {
      print("No credentials found in Keychain to clear")
    } else {
      print("Error clearing credentials from Keychain: \(status)")
    }
  }
}
