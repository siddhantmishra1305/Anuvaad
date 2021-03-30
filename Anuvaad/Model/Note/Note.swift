//
//  Notes.swift
//  Anuvaad
//
//  Created by Siddhant Mishra on 18/03/21.
//

import Foundation

struct Note :Codable{
    var text : String!
    var date : Date!
    var title : String!
    var id : Int!
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case date
        case title
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        date = try values.decodeIfPresent(Date.self, forKey: .date)
    }
    
    init(title:String,body:String){
        id = Int.random(in: 1231...993435)
        self.text = body
        self.title = title
        self.date = Date()
    }
}
