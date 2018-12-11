import Foundation

struct Vector3D {

	let x: Float
	let y: Float
	let z: Float

	var normalized: Vector3D {
		return self / length
	}

	var length: Float {
		return sqrt(x*x + y*y + z*z)
	}

	static func +(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
		return Vector3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
	}

	static func -(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
		return Vector3D(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
	}

	static func *(lhs: Vector3D, rhs: Vector3D) -> Vector3D {
		return Vector3D(x: lhs.y*rhs.z - lhs.z*rhs.y, y: lhs.z*rhs.x - lhs.x*rhs.z, z: lhs.x*rhs.y - lhs.y*rhs.x)
	}

	static func /(lhs: Vector3D, value: Float) -> Vector3D {
		return Vector3D(x: lhs.x / value, y: lhs.y / value, z: lhs.z / value)
	}

}

extension Vector3D: DataSerializable {

	func serialize() -> Data {
		var data = Data()
		var xCopy = x
		var yCopy = y
		var zCopy = z
		data.append(UnsafeBufferPointer(start: &xCopy, count: 1))
		data.append(UnsafeBufferPointer(start: &yCopy, count: 1))
		data.append(UnsafeBufferPointer(start: &zCopy, count: 1))
		return data
	}

}
