import Foundation

protocol Converter {
	associatedtype FromFileType
	associatedtype ToFileType
	func convert(fromFile: FromFileType) throws -> ToFileType
}
