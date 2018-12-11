import Foundation

enum STLWriterError: Error {
	case outputPathCantBeCreatedError
	case stlDataFileWriteError
}

final class STLWriter: Writer {
	typealias FileType = STLFile

	func write(file: STLFile, toPath: String) throws {
		guard let outputPath = toPath.components(separatedBy: ".").first else {
			throw STLWriterError.outputPathCantBeCreatedError
		}
		let url = URL(fileURLWithPath: outputPath + ".stl")
		let data = file.serialize()
		do {
			try data.write(to: url)
		} catch {
			throw STLWriterError.stlDataFileWriteError
		}
	}
}
