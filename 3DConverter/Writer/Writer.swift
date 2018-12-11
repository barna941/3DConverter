import Foundation

protocol Writer {
	associatedtype FileType
	func write(file: FileType, toPath: String) throws
}
