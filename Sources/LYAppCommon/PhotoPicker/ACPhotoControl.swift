//
//	ACPhotoControl.swift
//	LYAppCommon
//
//	Created by Rick Luo on 13/10/2026.
//	Email: blodely@gmail.com
//
//	The MIT License (MIT)
//
//	Copyright (c) 2026 骆昱(Luo Yu). All rights reserved.
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
import LYExt

final public class ACPhotoControl: LYControl {
	
	private(set) var imageURL: URL?
	private weak var presentingViewController: UIViewController?
	private let photopicker = ACPhotoPicker()
	
	weak var photoView: UIImageView?
	weak var addButton: UIButton?
	weak var editButton: UIButton?
	weak var deleteButton: LYCircularIconButton?
	
	// MARK: - INIT
	public override func initial() {
		super.initial()
		
		do {
			// MARK: BUILD PHOTO VIEW
			let size: CGFloat = 100
			
			let view = UIImageView()
			view.translatesAutoresizingMaskIntoConstraints = false
			view.contentHuggingPriority(for: .horizontal)
			addSubview(view)
			photoView = view
			
			NSLayoutConstraint.activate([
				view.leftAnchor.constraint(equalTo: leftAnchor),
				view.rightAnchor.constraint(equalTo: rightAnchor),
				view.topAnchor.constraint(equalTo: topAnchor),
				
				view.widthAnchor.constraint(equalToConstant: size),
				view.heightAnchor.constraint(equalToConstant: size),
			])
		}
		
		do {
			// MARK: BUILD BUTTON ADD
			let view = UIButton(type: .roundedRect)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.setTitle("Add Photo", for: .normal)
			addSubview(view)
			addButton = view
			
			NSLayoutConstraint.activate([
				view.centerXAnchor.constraint(equalTo: centerXAnchor),
				view.heightAnchor.constraint(equalToConstant: 44),
				view.topAnchor.constraint(equalTo: photoView!.bottomAnchor, constant: 8),
				view.bottomAnchor.constraint(equalTo: bottomAnchor),
			])
		}
		
		do {
			// MARK: BUILD BUTTON EDIT
			let view = UIButton(type: .roundedRect)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.setTitle("Edit", for: .normal)
			view.isHidden = true
			addSubview(view)
			editButton = view
			
			NSLayoutConstraint.activate([
				view.centerXAnchor.constraint(equalTo: centerXAnchor),
				view.heightAnchor.constraint(equalToConstant: 44),
				view.topAnchor.constraint(equalTo: photoView!.bottomAnchor, constant: 8),
			])
		}
		
		do {
			// MARK: BUILD BUTTON DELETE
			let size: CGFloat = 30
			
			let view = LYCircularIconButton(systemName: "minus", buttonSize: size, iconPointSize: floor(size * 0.6))
			view.translatesAutoresizingMaskIntoConstraints = false
			view.isHidden = true
			addSubview(view)
			deleteButton = view
			
			NSLayoutConstraint.activate([
				view.widthAnchor.constraint(equalToConstant: size),
				view.heightAnchor.constraint(equalToConstant: size),
				view.centerXAnchor.constraint(equalTo: photoView!.trailingAnchor),
				view.topAnchor.constraint(equalTo: photoView!.topAnchor),
			])
		}
		
		do {
			photoView?.border1Px()
			
			addButton?.addTarget(self, action: #selector(selectPhotoButtonPressed), for: .touchUpInside)
		}
	}
	
	// MARK: - ACTIONS
	@objc func selectPhotoButtonPressed() {
		presentingViewController = self.findViewController()
		
		guard let presentingViewController else { return }
		
		photopicker.present(from: presentingViewController) { [weak self] url in
			guard let self, let url else { return }
			
			// TODO: change PHOTO
			
			self.imageURL = url
			
			self.updateAppearance()
		}
	}
	
	// MARK: - METHOD
	private func updateAppearance() {
		if let url = imageURL, let image = UIImage(contentsOfFile: url.path) {
			
			photoView?.image = image
			photoView?.isHidden = false
			
			deleteButton?.isHidden = false
			editButton?.isHidden = false
			addButton?.isHidden = true
		} else {
			
			photoView?.image = nil
			
			deleteButton?.isHidden = true
			editButton?.isHidden = true
			addButton?.isHidden = false
		}
	}
}
