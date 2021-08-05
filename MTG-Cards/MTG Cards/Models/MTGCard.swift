//
//  MTGCard.swift
//  MTG Cards
//
//  Created by Ben Erekson on 8/4/21.
//

import Foundation

class MTGCard: Decodable{
    let name: String
    let oracle_text: String
    let image_uris: images
    let id: String
}

class images: Decodable{
    let normal: String
}
