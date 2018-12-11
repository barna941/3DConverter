import Foundation

struct Triangle: DataSerializable {

	let normalVector: Vector3D
	let vertex1: Vector3D
	let vertex2: Vector3D
	let vertex3: Vector3D

	func serialize() -> Data {
		var data = Data()
		data.append(normalVector.serialize())
		data.append(vertex1.serialize())
		data.append(vertex2.serialize())
		data.append(vertex3.serialize())
		return data
	}

}
