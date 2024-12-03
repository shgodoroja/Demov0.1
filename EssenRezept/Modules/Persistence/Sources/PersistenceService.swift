import Foundation

public protocol PersistenceServiceProtocol {
    func save(_ data: Data, to filename: String) throws
    func load(from filename: String) throws -> Data
    func fileExists(_ filename: String) -> Bool
}

public final class PersistenceService: PersistenceServiceProtocol, Sendable {
    public static let shared = PersistenceService()

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    public func save(_ data: Data, to filename: String) throws {
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        try data.write(to: fileURL)
    }

    public func load(from filename: String) throws -> Data {
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        return try Data(contentsOf: fileURL)
    }

    public func fileExists(_ filename: String) -> Bool {
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        return FileManager.default.fileExists(atPath: fileURL.path)
    }
}
