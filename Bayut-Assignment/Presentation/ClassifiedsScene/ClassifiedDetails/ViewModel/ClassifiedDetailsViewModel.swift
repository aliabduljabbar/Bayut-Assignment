//
//  ClassifiedDetailViewModel.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

protocol ClassifiedDetailsViewModelInput {
    func updateClassifiedImage(width: Int)
}

protocol ClassifiedDetailsViewModelOutput {
    var name: String { get }
    var classifiedImage: Observable<Data?> { get }
    var isClassifiedImageHidden: Bool { get }
    var price: String { get }
}

protocol ClassifiedDetailsViewModel: ClassifiedDetailsViewModelInput, ClassifiedDetailsViewModelOutput { }

final class DefaultClassifiedDetailsViewModel: ClassifiedDetailsViewModel {
    
    private let classifiedImagePath: String?
    private let classifiedImagesRepository: ClassifiedImagesRepository
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    // MARK: - OUTPUT
    let name: String
    let classifiedImage: Observable<Data?> = Observable(nil)
    let isClassifiedImageHidden: Bool
    let price: String
    
    init(classified: Classified,
         classifiedImagesRepository: ClassifiedImagesRepository) {
        self.name = classified.name ?? ""
        self.price = classified.price ?? ""
        self.classifiedImagePath = classified.imageUrls?.first
        self.isClassifiedImageHidden = classified.imageUrls?.first == nil
        self.classifiedImagesRepository = classifiedImagesRepository
    }
}

// MARK: - INPUT. View event methods
extension DefaultClassifiedDetailsViewModel {
    
    func updateClassifiedImage(width: Int) {
        guard let classifiedImagePath = classifiedImagePath else { return }

        imageLoadTask = classifiedImagesRepository.fetchImage(with: classifiedImagePath, width: width) { result in
            guard self.classifiedImagePath == classifiedImagePath else { return }
            switch result {
            case .success(let data):
                self.classifiedImage.value = data
            case .failure: break
            }
            self.imageLoadTask = nil
        }
    }
}
