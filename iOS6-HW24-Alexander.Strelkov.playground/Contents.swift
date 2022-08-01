import UIKit

let urlProtocol = "https"
let urlHost = "api.magicthegathering.io"
let urlPath = "/v1/cards"
let queryItems = [URLQueryItem(name: "name", value: "Black Lotus|Opt")]

var urlComponents = URLComponents()
urlComponents.scheme = urlProtocol
urlComponents.host = urlHost
urlComponents.path = urlPath
urlComponents.queryItems = queryItems

let magicCardsURL = urlComponents.url?.absoluteString ?? ""

func getData(urlRequest: String) {
    
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { fatalError("some error") }
    
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: url) { data, response, error in
        if error != nil {
            print(error?.localizedDescription ?? "")
            return
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            guard let data = data else { return }
            print("Код от сервера: \(response.statusCode)")
            parseJSON(magicData: data)
        }
    }.resume()
}

func parseJSON(magicData: Data) {
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode(MagicData.self, from: magicData)
        decodedData.cards.filter { $0.name == "Black Lotus" || $0.name == "Opt" }
        
        for cards in decodedData.cards {
            if cards.setName == "Unlimited Edition" || cards.setName == "Ixalan" {
                print("""
        _________________________
        Card name: \(cards.name)
        Mana cost: \(cards.manaCost ?? "no information:(")
        Type: \(cards.type)
        Power: \(cards.power ?? "no information:(")
        Rarity level: \(cards.rarity)
        Set name: \(cards.setName)
        """)
            }
        }
    } catch {
        print("Failed to decode JSON: \(error)")
    }
}

struct MagicData: Decodable {
    var cards: [Cards]
}

struct Cards: Decodable {
    let name: String
    let manaCost: String?
    let type: String
    let power: String?
    let rarity: String
    let setName: String
}

getData(urlRequest: magicCardsURL)
