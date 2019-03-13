// swift-tools-version:4.0
// Generated automatically by Perfect Assistant
// Date: 2019-03-05 07:48:26 +0000
import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	products: [
		.executable(name: "PerfectTemplate", targets: ["PerfectTemplate"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", "3.0.0"..<"4.0.0"),
        .package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", from:"2.0.0")
	],
	targets: [
		.target(name: "PerfectTemplate", dependencies: ["PerfectHTTPServer", "MySQL"])
	]
)
