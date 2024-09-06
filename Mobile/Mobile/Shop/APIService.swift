import Foundation

func submitOrder(_ order: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
    let urlString = "http://172.24.65.23:8080/api/order/orderProduct"
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: order, options: [.prettyPrinted])
        request.httpBody = jsonData
        
        // Print the request details
        print("Request URL: \(url)")
        print("Request Method: \(request.httpMethod ?? "Unknown")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: jsonData, encoding: .utf8) ?? "Unable to print request body")")
    } catch {
        completion(.failure(error))
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Network Error: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid Response: Unable to cast to HTTPURLResponse")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
            return
        }
        
        print("Response Status Code: \(httpResponse.statusCode)")
        print("Response Headers: \(httpResponse.allHeaderFields)")
        
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseString)")
        } else {
            print("No response body or unable to decode")
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.success("Order submitted successfully"))
            }
        } else {
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
        }
    }.resume()
}
