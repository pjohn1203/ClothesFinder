//
//  NetworkManager.swift
//  ClothesFinder
//
//  Created by Phil John on 1/30/22.
//

//
//  NetworkManager.swift
//  FlowerClassifier
//
//  Created by Phil John on 1/10/22.
//

import SwiftyJSON


protocol NetworkManagerDelegate {
    func didSuccessfulNetworkCall(shoppingResultsJson: JSON)
    func didFailWithError(with error: Error)
}

struct NetworkManager {

    var delegate: NetworkManagerDelegate?
    
    func performGETRequest(queryItems: [String], serviceName: String){
        if serviceName == "SerpAPI" {
            let getQueryURL = "\(NetworkConstants.SerpAPI.serpAPIHost)\(NetworkConstants.SerpAPI.searchEndpoint)"
            var urlBuilder = URLComponents(string: getQueryURL)
            urlBuilder?.queryItems = [
                URLQueryItem(name: "engine", value: "google"),
                URLQueryItem(name: "google_domain", value: "google.com"),
                URLQueryItem(name: "gl", value: "us"),
                URLQueryItem(name: "hl", value: "en"),
                URLQueryItem(name: "q", value: queryItems.joined(separator: "+")),
                URLQueryItem(name: "tbm", value: "shop"),
                URLQueryItem(name: "api_key", value: NetworkConstants.SerpAPI.serpAPIKey)
            ]
            
            guard let url = urlBuilder?.url else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    
                    // Step 1: Get API Key from SerpAPI
                    // Step 2: Test GET request & see response
                    // Step 3: Integrate SwiftyJSON Pod to make json life easier
                    // Step 4: Implement delegate calls & be able to pass appropriate data to ViewController
                    // Step 5: Handle segue to UIListView in main
                    print(response)
                    if let safeData = data {
                        do {
                            let json = try JSON(data: safeData)
                            delegate?.didSuccessfulNetworkCall(shoppingResultsJson: json["shopping_results"])
                        } catch {
                            delegate?.didFailWithError(with: error)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
}


/* if let safeData = data {
 do{
     /* example usage via SwiftyJSON
     let json = try JSON(data: safeData)
     print("TWEET")
     let tweet = json["data"]
     print(tweet)
     print("TWEET") */
     
     // Step 1: Decode Data
     // Step 2:
     let decodedData = try decoder.decode(TwitterDataModel.self, from: safeData)
     self.delegate?.didSuccessfulNetworkCall(data: decodedData)
 } catch {
     self.delegate?.didFailWithError(with: error)
 }
}*/
