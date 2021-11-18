//
//  ClassifiedsListItemCell.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import UIKit

final class ClassifiedsListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ClassifiedsListItemCell.self)
    static let height = CGFloat(130)

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var overviewLabel: UILabel!
    @IBOutlet private var classifiedImageView: UIImageView!

    private var viewModel: ClassifiedsListItemViewModel!
    private var classifiedImagesRepository: ClassifiedImagesRepository?
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    func fill(with viewModel: ClassifiedsListItemViewModel, classifiedImagesRepository: ClassifiedImagesRepository?) {
        self.viewModel = viewModel
        self.classifiedImagesRepository = classifiedImagesRepository

        titleLabel.text = viewModel.name
        dateLabel.text = viewModel.createdAt
        overviewLabel.text = viewModel.price
        classifiedImage(width: Int(classifiedImageView.imageSizeAfterAspectFit.scaledSize.width))
    }

    private func classifiedImage(width: Int) {
        classifiedImageView.image = UIImage(named: "image-placeholder")
        guard let classifiedImagePath = viewModel.classifiedImagePath else { return }

        imageLoadTask = classifiedImagesRepository?.fetchImage(with: classifiedImagePath, width: width) { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.classifiedImagePath == classifiedImagePath else { return }
            if case let .success(data) = result, let image = UIImage(data: data) {
                self.classifiedImageView.image = image
            }
            self.imageLoadTask = nil
        }
    }
}
