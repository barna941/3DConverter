import Foundation

enum ObjToSTLConverterError: Error {
	case nonTriangularFace
}

final class ObjToSTLConverter: Converter {
	typealias FromFileType = ObjFile
	typealias ToFileType = STLFile

	func convert(fromFile: ObjFile) throws -> STLFile {
		let stlFile = STLFile()
		for face in fromFile.faces {
			guard face.faceVertices.count == 3 else {
				throw ObjToSTLConverterError.nonTriangularFace
			}

			let v1 = fromFile.vertices[face.faceVertices[0].vertexIndex-1]
			let v2 = fromFile.vertices[face.faceVertices[1].vertexIndex-1]
			let v3 = fromFile.vertices[face.faceVertices[2].vertexIndex-1]

			if let v1NormalIndex = face.faceVertices[0].vertexNormalIndex,
				let v2NormalIndex = face.faceVertices[1].vertexNormalIndex,
				let v3NormalIndex = face.faceVertices[2].vertexNormalIndex {
				let v1Normal = fromFile.normals[v1NormalIndex-1]
				let v2Normal = fromFile.normals[v2NormalIndex-1]
				let v3Normal = fromFile.normals[v3NormalIndex-1]
				let avgNormal = (v1Normal + v2Normal + v3Normal).normalized
				stlFile.triangles.append(Triangle(normalVector: avgNormal, vertex1: v1, vertex2: v2, vertex3: v3))
			} else {
				let v3v1diff = v3 - v1
				let v2v1diff = v2 - v1
				let normal = (v2v1diff * v3v1diff).normalized
				stlFile.triangles.append(Triangle(normalVector: normal, vertex1: v1, vertex2: v2, vertex3: v3))
			}
		}
		return stlFile
	}
}
