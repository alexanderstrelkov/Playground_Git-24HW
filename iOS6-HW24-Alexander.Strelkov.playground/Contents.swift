import UIKit

let myUrl = "https://api.magicthegathering.io/v1/cards"

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
        print("""
Card name: \(decodedData.cards[0].name)
Mana cost: \(decodedData.cards[0].manaCost ?? "")
Type: \(decodedData.cards[0].type)
Power: \(decodedData.cards[0].power ?? "")
Rarity level: \(decodedData.cards[0].rarity)
""")
    } catch {
        print("Failed to decode JSON: \(error)")
    }
}

struct MagicData: Decodable {
    let cards: [Cards]
}

struct Cards: Decodable {
    let name: String
    let manaCost: String?
    let type: String
    let power: String?
    let rarity: String
}

getData(urlRequest: myUrl)
