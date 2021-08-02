//
//  Copyright © 2021 Microsoft. All rights reserved.
//

import UIKit

class ResettableView: UIView {
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		subviews.forEach { $0.removeFromSuperview() }
		setNeedsLayout()
		setNeedsDisplay()
		layoutIfNeeded()
	}
}

class ViewController: UIViewController {

	var imagesContainerView = ResettableView()
	let stretchingSwitch = UISwitch()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let pngButton = UIButton(frame: .zero)
		pngButton.setTitle("Draw PNG Images", for: .normal)
		pngButton.addTarget(self, action: #selector(pressedPngImages(_:)), for: .touchUpInside)

		let vectorButton = UIButton(frame: .zero)
		vectorButton.setTitle("Draw Vector Images", for: .normal)
		vectorButton.addTarget(self, action: #selector(pressedVectorImages(_:)), for: .touchUpInside)

		let pngSVGButton = UIButton(frame: .zero)
		pngSVGButton.setTitle("Draw PNG SVG Images", for: .normal)
		pngSVGButton.addTarget(self, action: #selector(pressedSVGPngImages(_:)), for: .touchUpInside)

		let vectorSVGButton = UIButton(frame: .zero)
		vectorSVGButton.setTitle("Draw Vector SVG Images", for: .normal)
		vectorSVGButton.addTarget(self, action: #selector(pressedSVGVectorImages(_:)), for: .touchUpInside)

		let switchLabel = UILabel(frame: .zero)
		switchLabel.text = "Stretch Images"

		let switchStackView = UIStackView(arrangedSubviews: [
			switchLabel,
			stretchingSwitch,
		])

		let stackView = UIStackView(arrangedSubviews: [
			imagesContainerView,
			pngButton,
			vectorButton,
			pngSVGButton,
			vectorSVGButton,
			switchStackView,
		])

		stackView.axis = .vertical

		stackView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(stackView)

		NSLayoutConstraint.activate([
			view.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
			view.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
		])
	}

	@objc func pressedPngImages(_ sender: Any) {
		let collection = imageViews(shouldStretch: stretchingSwitch.isOn, imageName: "Image")
		addCollectionToViewHierarchy(collection: collection)	}
	
	@objc func pressedVectorImages(_ sender: Any) {
		let collection = imageViews(shouldStretch: stretchingSwitch.isOn, imageName: "ImageVector")
		addCollectionToViewHierarchy(collection: collection)
	}

	@objc func pressedSVGPngImages(_ sender: Any) {
		let collection = imageViews(shouldStretch: stretchingSwitch.isOn, imageName: "SVGImage")
		addCollectionToViewHierarchy(collection: collection)    }

	@objc func pressedSVGVectorImages(_ sender: Any) {
		let collection = imageViews(shouldStretch: stretchingSwitch.isOn, imageName: "SVGImageVector")
		addCollectionToViewHierarchy(collection: collection)
	}

	func addCollectionToViewHierarchy(collection: UIView) {
		collection.translatesAutoresizingMaskIntoConstraints = false
		imagesContainerView.addSubview(collection)
		NSLayoutConstraint.activate([
			collection.leadingAnchor.constraint(equalTo: imagesContainerView.leadingAnchor),
			collection.trailingAnchor.constraint(equalTo: imagesContainerView.trailingAnchor),
			collection.topAnchor.constraint(equalTo: imagesContainerView.topAnchor),
			collection.bottomAnchor.constraint(equalTo: imagesContainerView.bottomAnchor),
			])
	}
	
	func imageViews(shouldStretch: Bool, imageName: String) -> UIView {
		var rowStack: [UIStackView] = []
		for _ in 0...numberOfRows {
			var images: [UIImageView] = []
			for _ in 0...numberOfColumns {
				let imageView = UIImageView.init(image:UIImage.init(named:imageName))
				if (shouldStretch) {
					NSLayoutConstraint.activate([
						imageView.widthAnchor.constraint(equalToConstant: 135),
						imageView.heightAnchor.constraint(equalToConstant: 131),
					])
				}
				images.append(imageView)
			}
			let columnStack = UIStackView(arrangedSubviews: images)
			columnStack.axis = .vertical
			rowStack.append(UIStackView(arrangedSubviews: images))
		}
		
		let collection = UIStackView(arrangedSubviews: rowStack)
		collection.axis = .vertical

		return collection
	}
}

fileprivate let numberOfRows = 40
fileprivate let numberOfColumns = 25
