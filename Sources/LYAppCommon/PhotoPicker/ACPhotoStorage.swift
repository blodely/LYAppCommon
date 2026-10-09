//
//  ACPhotoStorage.swift
//  LYAppCommon
//
//  Created by Rick Luo on 8/10/2026.
//	Email: blodely@gmail.com
//
//	The MIT License (MIT)
//
//	Copyright (c) 2019 骆昱(Luo Yu). All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in
//	the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//	the Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

final class ACPhotoStorage {

	@MainActor static let shared = ACPhotoStorage()

	private let directory: URL

	private init() {
		let applicationSupport = FileManager.default.urls(
			for: .applicationSupportDirectory,
			in: .userDomainMask
		)[0]

		directory = applicationSupport.appendingPathComponent(
			"FormImages",
			isDirectory: true
		)

		try? FileManager.default.createDirectory(
			at: directory,
			withIntermediateDirectories: true
		)
	}

	// MARK: Save
	@discardableResult
	func save(_ image: UIImage) throws -> URL {
		let filename = UUID().uuidString + ".jpg"
		let url = directory.appendingPathComponent(filename)

		guard let data = image.jpegData(compressionQuality: 0.9) else {
			throw ACPhotoStorageError.invalidPhoto
		}

		try data.write(to: url, options: .atomic)

		return url
	}
	
	/*
	 
	 let imageURL = try ACPhotoStorage.shared.save(image)
	 
	 */

	// MARK: Load
	func load(from url: URL) -> UIImage? {
		UIImage(contentsOfFile: url.path)
	}
	
	/*
	 
	 let image = ACPhotoStorage.shared.load(from: imageURL)
	 
	 */

	// MARK: Delete
	func delete(at url: URL) throws {
		guard FileManager.default.fileExists(atPath: url.path) else {
			return
		}

		try FileManager.default.removeItem(at: url)
	}
	
	/*
	 
	 try? ACPhotoStorage.shared.delete(at: url)
	 
	 */
}

enum ACPhotoStorageError: Error {
	case invalidPhoto
}
