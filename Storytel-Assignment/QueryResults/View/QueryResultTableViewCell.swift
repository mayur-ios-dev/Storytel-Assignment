//
//  QueryResultTableViewCell.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-18.
//

import UIKit

class QueryResultTableViewCell: UITableViewCell {
    
    var coverImageView: UIImageView!
    var bookTitleLabel: UILabel!
    var authorsLabel: UILabel!
    var narratorsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

// MARK: - View setup

private extension QueryResultTableViewCell {
    func setupView() {
        contentView.backgroundColor = .white
        var constraints: [NSLayoutConstraint] = []
        let mainStackView = makeMainStackView()
        
        coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFit
        constraints.append(
            contentsOf: [
                coverImageView.widthAnchor.constraint(equalToConstant: .coverImageThumbnailSize),
                coverImageView.heightAnchor.constraint(equalToConstant: .coverImageThumbnailSize)
            ]
        )
        coverImageView.image = .defaultCoverImage
        
        mainStackView.addArrangedSubview(coverImageView)
        
        let detailsStackView = makeDetailsStackView()
        
        bookTitleLabel = UILabel()
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsStackView.addArrangedSubview(bookTitleLabel)
        
        authorsLabel = UILabel()
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsStackView.addArrangedSubview(authorsLabel)
        
        narratorsLabel = UILabel()
        narratorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailsStackView.addArrangedSubview(narratorsLabel)
        
        mainStackView.addArrangedSubview(detailsStackView)
        contentView.addSubview(mainStackView)
        
        constraints.append(
            contentsOf: [
                contentView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
            ]
        )
        
        contentView.addConstraints(constraints)
        
        func makeMainStackView() -> UIStackView {
            let horizontalStackView = UIStackView(frame: .zero)
            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .leading
            horizontalStackView.spacing = UIStackView.spacingUseSystem
            horizontalStackView.isLayoutMarginsRelativeArrangement = true
            horizontalStackView.directionalLayoutMargins = .init(
                top: .mainStackViewPadding,
                leading: .mainStackViewPadding,
                bottom: .mainStackViewPadding,
                trailing: .mainStackViewPadding
            )
            return horizontalStackView
        }
        
        func makeDetailsStackView() -> UIStackView {
            let detailsStackView = UIStackView(frame: .zero)
            detailsStackView.translatesAutoresizingMaskIntoConstraints = false
            detailsStackView.axis = .vertical
            detailsStackView.alignment = .fill
            detailsStackView.spacing = UIStackView.spacingUseSystem
            detailsStackView.isLayoutMarginsRelativeArrangement = true
            detailsStackView.directionalLayoutMargins = .init(
                top: .detailsStackViewPadding,
                leading: .detailsStackViewPadding,
                bottom: .detailsStackViewPadding,
                trailing: .detailsStackViewPadding
            )
            return detailsStackView
        }
    }
}

// MARK: View layout constants

private extension CGFloat {
    static let mainStackViewPadding: CGFloat = 8
    static let detailsStackViewPadding: CGFloat = 0
    static let coverImageThumbnailSize: CGFloat = 64
}

private extension UIImage {
    static let defaultCoverImage = {
        let rect = CGRect(origin: .zero, size: .init(width: .coverImageThumbnailSize, height: .coverImageThumbnailSize))
        let color = UIColor.lightGray
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return UIImage() }
        return UIImage(cgImage: cgImage)
    }()
}
