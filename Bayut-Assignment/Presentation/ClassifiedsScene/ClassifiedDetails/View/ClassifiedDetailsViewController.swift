//
//  ClassifiedDetailViewController.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import UIKit

final class ClassifiedDetailsViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private var classifiedImageView: UIImageView!
    @IBOutlet private var overviewTextView: UITextView!

    // MARK: - Lifecycle

    private var viewModel: ClassifiedDetailsViewModel!
    
    static func create(with viewModel: ClassifiedDetailsViewModel) -> ClassifiedDetailsViewController {
        let view = ClassifiedDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }

    private func bind(to viewModel: ClassifiedDetailsViewModel) {
        viewModel.classifiedImage.observe(on: self) { [weak self] value in
            if let image: UIImage? = value.flatMap(UIImage.init) {
                self?.classifiedImageView.image = image
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.updateClassifiedImage(width: Int(classifiedImageView.imageSizeAfterAspectFit.scaledSize.width))
    }

    // MARK: - Private

    private func setupViews() {
        title = viewModel.name
        overviewTextView.text = viewModel.price
        classifiedImageView.isHidden = viewModel.isClassifiedImageHidden
        view.accessibilityIdentifier = AccessibilityIdentifier.classifiedDetailsView
    }
}
