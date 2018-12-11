import Foundation

protocol Reader {
	associatedtype FileType
	func read(fileAtPath: String) throws -> FileType
}
