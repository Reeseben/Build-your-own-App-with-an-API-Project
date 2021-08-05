//
//  MTGCardController.swift
//  MTG Cards
//
//  Created by Ben Erekson on 8/4/21.
//

import Foundation
import UIKit.UIImage

class MTGCardController {
    static var shared = MTGCardController()
    
    static let imageCache = NSCache<NSString, UIImage>()
    static let textCache = NSCache<NSString, MTGCard>()
    
    func fetchCards(with cardID: String, completion: @escaping (Result<MTGCard, MTGCardError>) -> Void){
//        https://api.scryfall.com/cards/random
        let baseURL = "https://api.scryfall.com/cards/\(cardID)"
        guard let finalURL = URL(string: baseURL) else { return completion(.failure(.invalidURL))}
        
        if let card = MTGCardController.textCache.object(forKey: NSString(string: cardID)){
            return completion(.success(card))
        }
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error reaching out to server: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Response code: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            let decoder = JSONDecoder()
            
            do{
                let card = try decoder.decode(MTGCard.self, from: data)
                
                MTGCardController.textCache.setObject(card, forKey: NSString(string: card.id))
                
                return completion(.success(card))
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
            
        }.resume()
        
    }
    
    func fetchCardImage(imageURL: String, completion: @escaping (Result<UIImage,MTGCardError>) -> Void ){
        
        if let image = MTGCardController.imageCache.object(forKey: NSString(string: imageURL)){
            return completion(.success(image))
        }
        
        guard let finalURL = URL(string: imageURL) else { return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print("Error reaching the server! \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("Response code: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            
            guard let image = UIImage(data: data) else { return completion(.failure(.couldNotDecode))}
            
            MTGCardController.imageCache.setObject(image, forKey: NSString(string: imageURL))
            
            return completion(.success(image))
            
        }.resume()
        
    }
    
}
