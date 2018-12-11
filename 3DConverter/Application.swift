import Foundation

final class Application {

	private var argumentCount: Int32
	private var arguments: [String]

	init(argumentCount: Int32, arguments: [String]) {
		self.argumentCount = argumentCount
		self.arguments = arguments
	}

	func start() {
		guard argumentCount == 2 else {
			print("Too few parameters")
			printHelp()
			return
		}
		let argument = arguments[1]
		if argument == "-h" {
			printHelp()
		} else {
			convert(argument: argument)
		}
	}

	private func convert(argument: String) {
		do {
			print("Reading obj file...")
			let objReader = ObjReader()
			let objFile = try objReader.read(fileAtPath: argument)

			print("Converting obj to stl...")
			let objToStlConverter = ObjToSTLConverter()
			let stlFile = try objToStlConverter.convert(fromFile: objFile)

			print("Writing stl file...")
			let stlWriter = STLWriter()
			try stlWriter.write(file: stlFile, toPath: argument)

			print("Conversion succeeded.")

		} catch let error {
			print("An error occured during conversion")
			print(error)
		}
	}

	private func printHelp() {
		print("Usages:")
		print("1. 3DConverter -h")
		print("2. 3DConverter input_file_path")
		print("   The output .stl file is created next to the input .obj file with the same name.")
	}

}
