import Foundation

enum ObjReaderError: Error {
	case invalidInputFileError
	case vertexScanError
	case vertexTextureScanError
	case vertexNormalScanError
	case vertexFaceScanError
}

final class ObjReader: Reader {
	typealias FileType = ObjFile

	private var objFile: ObjFile!

	func read(fileAtPath: String) throws -> ObjFile {
		let objContent: String!
		do {
			objContent = try String(contentsOfFile: fileAtPath)
		} catch {
			throw ObjReaderError.invalidInputFileError
		}

		let scanner = Scanner(string: objContent)

		objFile = ObjFile()

		while !scanner.isAtEnd {
			guard let element = readElementWithScanner(scanner: scanner) as String?, !element.isEmpty else {
				moveScannerToNextLine(scanner: scanner)
				continue
			}
			switch element {
			case ObjFile.vertexElement:
				let vertex = try readVertexWithScanner(scanner: scanner)
				objFile.vertices.append(vertex)
			case ObjFile.vertexTextureElement:
				let vertexTexture = try readVertexTextureWithScanner(scanner: scanner)
				objFile.vertexTextures.append(vertexTexture)
			case ObjFile.vertexNormalElement:
				let vertexNormal = try readVertexNormalWithScanner(scanner: scanner)
				objFile.normals.append(vertexNormal)
			case ObjFile.faceElement:
				let face = readFaceWithScanner(scanner: scanner)
				objFile.faces.append(face)
			default:
				moveScannerToNextLine(scanner: scanner)
			}
		}

		return objFile
	}

}

extension ObjReader {

	private func moveScannerToNextLine(scanner: Scanner) {
		scanner.scanUpToCharacters(from: .newlines, into: nil)
		scanner.scanCharacters(from: .whitespacesAndNewlines, into: nil)
	}

	private func readElementWithScanner(scanner: Scanner) -> NSString? {
		var element: NSString?
		scanner.scanUpToCharacters(from: .whitespaces, into: &element)
		return element
	}

	private func readIntWithScanner(scanner: Scanner) -> Int? {
		var intValue = Int.max
		guard scanner.scanInt(&intValue) else {
			return nil
		}
		return intValue
	}

	private func readFloatWithScanner(scanner: Scanner) -> Float? {
		var floatValue = Float.infinity
		guard scanner.scanFloat(&floatValue) else {
			return nil
		}
		return floatValue
	}

	private func readVertexWithScanner(scanner: Scanner) throws -> Vector3D {
		var x = Float.infinity
		var y = Float.infinity
		var z = Float.infinity
		guard scanner.scanFloat(&x) else { throw ObjReaderError.vertexScanError }
		guard scanner.scanFloat(&y) else { throw ObjReaderError.vertexScanError }
		guard scanner.scanFloat(&z) else { throw ObjReaderError.vertexScanError }
		return Vector3D(x: x, y: y, z: z)
	}

	private func readVertexTextureWithScanner(scanner: Scanner) throws -> ObjFile.Texture {
		var u = Float.infinity
		var v = Float.infinity
		var w: Float = 0
		guard scanner.scanFloat(&u) else { throw ObjReaderError.vertexTextureScanError }
		guard scanner.scanFloat(&v) else { throw ObjReaderError.vertexTextureScanError }
		scanner.scanFloat(&w)
		return ObjFile.Texture(u: u, v: v, w: w)
	}

	private func readVertexNormalWithScanner(scanner: Scanner) throws -> Vector3D {
		do {
			return try readVertexWithScanner(scanner: scanner)
		} catch {
			throw ObjReaderError.vertexNormalScanError
		}
	}

	private func readFaceWithScanner(scanner: Scanner) -> ObjFile.Face {
		var faceVertices = [ObjFile.FaceVertex]()
		while true {
			var v: Int = Int.max
			var vt: Int = Int.max
			var vn: Int = Int.max
			guard scanner.scanInt(&v) else {
				break
			}

			if scanner.scanString("/", into: nil) {
				if scanner.scanInt(&vt) {
					if scanner.scanString("/", into: nil) {
						scanner.scanInt(&vn)
						faceVertices.append(ObjFile.FaceVertex(vertexIndex: v, vertexTextureIndex: vt, vertexNormalIndex: vn))
					} else {
						faceVertices.append(ObjFile.FaceVertex(vertexIndex: v, vertexTextureIndex: vt, vertexNormalIndex: nil))
					}
				} else {
					if scanner.scanString("/", into: nil) {
						scanner.scanInt(&vn)
						faceVertices.append(ObjFile.FaceVertex(vertexIndex: v, vertexTextureIndex: nil, vertexNormalIndex: vn))
					}
				}
			} else {
				faceVertices.append(ObjFile.FaceVertex(vertexIndex: v, vertexTextureIndex: nil, vertexNormalIndex: nil))
			}
		}
		return ObjFile.Face(faceVertices: faceVertices)
	}

}
