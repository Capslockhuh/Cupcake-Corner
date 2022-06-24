//
//  Order.swift
//  Cupcake Corner
//
//  Created by Jan Andrzejewski on 23/06/2022.
//

import SwiftUI

class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        // When special request is disabled, disable other special options
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
    // Check if the user filled in all the required information.
        var hasValidAddress: Bool {
            if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
                return false
            }
            
            let cutName = name.trimmingCharacters(in: .whitespaces)
            let cutStreetAddress = streetAddress.trimmingCharacters(in: .whitespaces)
            let cutCity = city.trimmingCharacters(in: .whitespaces)
            let cutZip = zip.trimmingCharacters(in: .whitespaces)
            
            if cutName.isEmpty || cutStreetAddress.isEmpty || cutCity.isEmpty || cutZip.isEmpty {
                return false
            }
            
            return true
        }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }
    
    // Codable
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(type, forKey: .type)
            try container.encode(quantity, forKey: .quantity)

            try container.encode(extraFrosting, forKey: .extraFrosting)
            try container.encode(addSprinkles, forKey: .addSprinkles)

            try container.encode(name, forKey: .name)
            try container.encode(streetAddress, forKey: .streetAddress)
            try container.encode(city, forKey: .city)
            try container.encode(zip, forKey: .zip)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

            type = try container.decode(Int.self, forKey: .type)
            quantity = try container.decode(Int.self, forKey: .quantity)

            extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
            addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

            name = try container.decode(String.self, forKey: .name)
            streetAddress = try container.decode(String.self, forKey: .streetAddress)
            city = try container.decode(String.self, forKey: .city)
            zip = try container.decode(String.self, forKey: .zip)
    }
    
    // Use this initialazier for instances that don't need encoding.
    init() { }
}
