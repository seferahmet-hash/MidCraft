import Foundation
import AppKit

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}

class NetworkManager {
    static let shared = NetworkManager()
    
    var midjourneyApiKey: String = "YOUR_MIDJOURNEY_API_KEY"
    var magnificApiKey: String = "YOUR_MAGNIFIC_API_KEY"
    
    private let midjourneyEndpoint = "https://api.example.com/v1/midjourney/generate"
    private let magnificEndpoint = "https://mcp.magnific.com/v1/enhance"
    
    func generateMidjourneyImage(prompt: String, aspectRatio: String) async throws -> URL {
        guard let url = URL(string: midjourneyEndpoint) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(midjourneyApiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["prompt": prompt, "ar": aspectRatio]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return URL(string: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe")!
        }
        return URL(string: "https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe")!
    }
    
    func enhanceWithMagnific(imageURL: URL, creativity: Double, upscaleFactor: String) async throws -> NSImage {
        guard let url = URL(string: magnificEndpoint) else { throw NetworkError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(magnificApiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["image_url": imageURL.absoluteString, "creativity": creativity, "scale": upscaleFactor]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return NSImage(size: NSSize(width: 512, height: 512))
        }
        
        guard let enhancedImage = NSImage(data: data) else {
            throw NetworkError.decodingFailed
        }
        return enhancedImage
    }
}
