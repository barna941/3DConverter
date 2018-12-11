import Foundation

final class ObjFile: File {

	static let vertexElement = "v"
	static let vertexTextureElement = "vt"
	static let vertexNormalElement = "vn"
	static let faceElement = "f"

	struct Texture {
		let u: Float
		let v: Float
		let w: Float
	}

	struct Face {
		let faceVertices: [FaceVertex]
	}

	struct FaceVertex {
		let vertexIndex: Int
		let vertexTextureIndex: Int?
		let vertexNormalIndex: Int?
	}

	var vertices = [Vector3D]()
	var vertexTextures = [Texture]()
	var normals = [Vector3D]()
	var faces = [Face]()

}
