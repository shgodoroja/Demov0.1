import Foundation

public enum APIClientError: Error {
  case invalidURL
  case noData
  case decodingError
  case networkError(Error)
}

public protocol APIClientProtocol {
  func get<T: Decodable>(from url: URL) async throws -> T
}

public final class APIClient: APIClientProtocol, Sendable {
    public static let shared = APIClient()

    public func get<T: Decodable>(from url: URL) async throws -> T {
      let (data, response) = try await URLSession.shared.data(from: url)

      guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
          throw APIClientError.networkError(NSError(domain: "", code: -1))
      }

      do {
          let decoder = JSONDecoder()
          
          return try decoder.decode(T.self, from: data)
      } catch {
          throw APIClientError.decodingError
      }
  }
}
