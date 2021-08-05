//
//  ViewController.swift
//  MTG Cards
//
//  Created by Ben Erekson on 8/4/21.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var descriptionTextLable: UILabel!
    
   //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewsAndFetchData(id: nil)
    }
    
    //MARK: - Properties
    var viewedCards: [String] = []

    //MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: Any) {
        let searchBox = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        searchBox.addTextField { (textField) in
            textField.placeholder = "Enter name of card to search"
        }
        let cancle = UIAlertAction(title: "Cancle", style: .destructive, handler: nil)
        let search = UIAlertAction(title: "Search", style: .default) { _ in
            let textField = searchBox.textFields![0]
            guard let searchTerm = textField.text, !searchTerm.isEmpty else { return }
            let finalSearchTerm = "named?fuzzy=\(searchTerm)"
            self.updateViewsAndFetchData(id: finalSearchTerm)
        }
        searchBox.addAction(search)
        searchBox.addAction(cancle)
        self.present(searchBox, animated: true, completion: nil)
    }
    @IBAction func nextButtonTapped(_ sender: Any) {
        updateViewsAndFetchData(id: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if viewedCards.count != 1 {
            let cardID = viewedCards[viewedCards.count-2]
            viewedCards.remove(at: viewedCards.count-1)
            updateViewsAndFetchData(id: cardID)
        } else {
            let AlertController = UIAlertController(title: "Oh no!", message: "Oh no! there are are no more cards to go back to!", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            AlertController.addAction(okayAction)
            self.present(AlertController, animated: true, completion: nil)
        }
    }
    
    func updateViewsAndFetchData(id: String?){
        let finalID: String
        if let id = id {
            finalID = id
        } else {
            finalID = "random"
        }
        
        MTGCardController.shared.fetchCards(with: finalID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let card):
                    self.title = card.name
                    self.descriptionTextLable.text = card.oracle_text
                    if let index = self.viewedCards.firstIndex(of: card.id) {
                        self.viewedCards.remove(at: index)
                    }
                    self.fetchPhoto(card: card)
                    self.viewedCards.append(card.id)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
    }
    
    func fetchPhoto(card: MTGCard){
        MTGCardController.shared.fetchCardImage(imageURL: card.image_uris.normal) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.cardImageView.image = image
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

