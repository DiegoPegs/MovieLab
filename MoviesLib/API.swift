import Foundation

struct APIResult: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let previewUrl: String
}

class API {
    private static let basePath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return config
    }()
    static let session = URLSession(configuration: configuration)
    
    static func loadTrailers(title: String, onComplete: @escaping (APIResult?) -> Void) {
        guard let encodedTitle = (title).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: basePath+encodedTitle) else {
                onComplete(nil)
                return
        }
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                onComplete(nil)
            } else {
                guard let response = response as? HTTPURLResponse,
                    let data = data,
                    response.statusCode == 200
                    else {
                        onComplete(nil)
                        return
                }
                do {
                    let apiResult = try JSONDecoder().decode(APIResult.self, from: data)
                    onComplete(apiResult)
                } catch {
                    onComplete(nil)
                }
            }
            }.resume()
    }
}
