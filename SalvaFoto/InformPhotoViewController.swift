//
//  InformPhotoViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 16.09.22.
//

import UIKit

final class InformPhotoViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let createAtLabel = UILabel()
    private let makeLabel = UILabel()
    private let modelLabel = UILabel()
    private let exposureTimeLabel = UILabel()
    private let apertureLabel = UILabel()
    private let focalLengthLabel = UILabel()
    private let isoLabel = UILabel()
    private let dimensionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension InformPhotoViewController {
    private func style() {
        view.backgroundColor = .backgroundColor
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        // Labels
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.text = "Details"
        
        createAtLabel.translatesAutoresizingMaskIntoConstraints = false
        createAtLabel.textAlignment = .left
        createAtLabel.numberOfLines = 1
        createAtLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        createAtLabel.textColor = .white
        
        dimensionLabel.translatesAutoresizingMaskIntoConstraints = false
        dimensionLabel.textAlignment = .left
        dimensionLabel.numberOfLines = 1
        dimensionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dimensionLabel.textColor = .white
        
        makeLabel.translatesAutoresizingMaskIntoConstraints = false
        makeLabel.textAlignment = .left
        makeLabel.numberOfLines = 1
        makeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        makeLabel.textColor = .white
        
        modelLabel.translatesAutoresizingMaskIntoConstraints = false
        modelLabel.textAlignment = .left
        modelLabel.numberOfLines = 1
        modelLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        modelLabel.textColor = .white
        
        exposureTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        exposureTimeLabel.textAlignment = .left
        exposureTimeLabel.numberOfLines = 1
        exposureTimeLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        exposureTimeLabel.textColor = .white
        
        apertureLabel.translatesAutoresizingMaskIntoConstraints = false
        apertureLabel.textAlignment = .left
        apertureLabel.numberOfLines = 1
        apertureLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        apertureLabel.textColor = .white
        
        focalLengthLabel.translatesAutoresizingMaskIntoConstraints = false
        focalLengthLabel.textAlignment = .left
        focalLengthLabel.numberOfLines = 1
        focalLengthLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        focalLengthLabel.textColor = .white
        
        isoLabel.translatesAutoresizingMaskIntoConstraints = false
        isoLabel.textAlignment = .left
        isoLabel.numberOfLines = 1
        isoLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        isoLabel.textColor = .white
    }
    
    private func layout() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(createAtLabel)
        stackView.addArrangedSubview(dimensionLabel)
        stackView.addArrangedSubview(makeLabel)
        stackView.addArrangedSubview(modelLabel)
        stackView.addArrangedSubview(exposureTimeLabel)
        stackView.addArrangedSubview(apertureLabel)
        stackView.addArrangedSubview(focalLengthLabel)
        stackView.addArrangedSubview(isoLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }
    
    internal func configure(image: Photo){
        if let date = image.createdAt, let height = image.height , let width = image.width {
            createAtLabel.text = "Date of creation: \(date.monthDayYearString)"
            dimensionLabel.text = "Dimension: \(height) x \(width)"
        }
        makeLabel.text = "Make: \(image.exif?.make ?? "-")"
        modelLabel.text = "Model: \(image.exif?.model ?? "-")"
        exposureTimeLabel.text = "Exposure Time: \(image.exif?.exposureTime ?? "-")"
        apertureLabel.text = "Aperture (f): \(image.exif?.aperture ?? "-")"
        focalLengthLabel.text = "Focal Length (mm): \(image.exif?.focalLength ?? "-")"
        isoLabel.text = "ISO: \(image.exif?.iso ?? 0)"
    }
}
