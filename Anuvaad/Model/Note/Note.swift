//
//  Notes.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import Foundation

struct Note :Codable{
    var text : String?
    var date = Date()
    
    
    enum CodingKeys: String, CodingKey {

        case text
        case date
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        text = try values.decodeIfPresent(String.self, forKey: .text)
        
    }
}
