//
//  Language.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 15/03/21.
//

import Foundation


typealias Languages = [Language]

struct Language :Codable {
    var language : String?
    var name : String?
    var code : String?
    var country : String?
    
    enum CodingKeys: String, CodingKey {

        case language
        case name
        case code
        case country
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
    }
}
