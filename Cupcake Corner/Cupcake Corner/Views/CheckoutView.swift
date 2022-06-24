//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by Jan Andrzejewski on 23/06/2022.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertTitle = "Thank you!"
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed.")
            // Show an error to the user
            alertTitle = "Error"
            confirmationMessage = "Connecting to our server has failed. Please check your internet connection."
            showingConfirmation = true
        }
    }
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertTitle = ""
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                            .font(.title)

                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                            .padding()
                    }
                }
                .navigationTitle("Check out")
                .navigationBarTitleDisplayMode(.inline)
                .alert(alertTitle, isPresented: $showingConfirmation) {
                    Button("OK") { }
                } message: {
                    Text(confirmationMessage)
                }
            }
        }

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
