import Foundation

final class STLFile: File {

	private let header = Array<UInt8>(repeating: 0, count: 80)
	private let attributeByteCount: UInt16 = 0

	var triangles = [Triangle]()

}

extension STLFile: DataSerializable {

	func serialize() -> Data {
		var data = Data()
		header.forEach {
			var valueCopy = $0
			data.append(UnsafeBufferPointer(start: &valueCopy, count: 1))
		}
		var triangleCount = UInt32(triangles.count)
		data.append(UnsafeBufferPointer(start: &triangleCount, count: 1))
		for triangle in triangles {
			data.append(triangle.serialize())
			var byteCount = attributeByteCount
			data.append(UnsafeBufferPointer(start: &byteCount, count: 1))
		}
		return data
	}

}
