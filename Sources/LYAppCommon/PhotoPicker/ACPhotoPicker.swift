//
//  ACPhotoPicker.swift
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
import PhotosUI

@MainActor
final class ACPhotoPicker: NSObject {

	private var completion: ((URL?) -> Void)?

	func present(
		from viewController: UIViewController,
		completion: @escaping (URL?) -> Void
	) {
		self.completion = completion

		var configuration = PHPickerConfiguration(photoLibrary: .shared())
		configuration.filter = .images
		configuration.selectionLimit = 1
		configuration.preferredAssetRepresentationMode = .current

		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self

		viewController.present(picker, animated: true)
	}
	
	private func finish(with url: URL?) {
		completion?(url)
		completion = nil
	}
}

extension ACPhotoPicker: PHPickerViewControllerDelegate {

	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)

		guard let provider = results.first?.itemProvider else {
			finish(with: nil)
			return
		}

		guard provider.canLoadObject(ofClass: UIImage.self) else {
			finish(with: nil)
			return
		}

		provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
			
			guard let image = object as? UIImage, error == nil else {
				Task { @MainActor [weak self] in
					self?.finish(with: nil)
				}
				return
			}

			Task { @MainActor [weak self] in
				guard let self else { return }
				
				do {
					let url = try ACPhotoStorage.shared.save(image)
					self.finish(with: url)
				} catch {
					self.finish(with: nil)
				}
			}
		}
	}
}
