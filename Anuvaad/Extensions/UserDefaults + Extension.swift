//
//  UserDefaults + Extension.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import Foundation


extension UserDefaults {
    
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }
    
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
    
}
