//
//  QueryResultTableViewCell.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-18.
//

import UIKit
import Combine

class QueryResultTableViewCell: UITableViewCell {
    
    private var coverImageView: UIImageView!
    private var bookTitleLabel: UILabel!
    private var authorsLabel: UILabel!
    private var narratorsLabel: UILabel!
    
    private var subscriptions: Set<AnyCancellable> = []
    
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
        
        let (mainView, constraints) = makeMainView()
        contentView.addSubview(mainView)
        contentView.addConstraints(constraints)
    }
    
    func makeMainView() -> (UIView, [NSLayoutConstraint]) {
        var constraints: [NSLayoutConstraint] = []
        
        let mainStackView = makeMainStackView()
        
        let (coverImageView, coverImageViewConstraints) = makeCoverImageView()
        self.coverImageView = coverImageView
        constraints.append(contentsOf: coverImageViewConstraints)
        mainStackView.addArrangedSubview(coverImageView)
        mainStackView.addArrangedSubview(
            makeDetailsView()
        )
        
        constraints.append(
            contentsOf: [
                contentView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
            ]
        )
        
        return (mainStackView, constraints)
    }
    
    // MARK: MainStackView setup
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
    
    func makeCoverImageView() -> (UIImageView, [NSLayoutConstraint]) {
        let coverImageView = UIImageView()
        coverImageView.image = .defaultCoverImage
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFit
        let coverImageViewConstraints = [
            coverImageView.widthAnchor.constraint(equalToConstant: .coverImageThumbnailSize),
            coverImageView.heightAnchor.constraint(equalToConstant: .coverImageThumbnailSize)
        ]
        return (coverImageView, coverImageViewConstraints)
    }
    
    // MARK: DetailsStackView setup
    func makeDetailsView() -> UIView {
        let detailsStackView = makeDetailsStackView()
        
        bookTitleLabel = UILabel()
        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bookTitleLabel.font = .bookTitleFont
        bookTitleLabel.textColor = .black
        
        detailsStackView.addArrangedSubview(bookTitleLabel)
        
        authorsLabel = UILabel()
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        authorsLabel.font = .authorsFont
        authorsLabel.textColor = .gray
        
        detailsStackView.addArrangedSubview(authorsLabel)
        
        narratorsLabel = UILabel()
        narratorsLabel.translatesAutoresizingMaskIntoConstraints = false
        narratorsLabel.font = .narratorFont
        narratorsLabel.textColor = .gray
        
        detailsStackView.addArrangedSubview(narratorsLabel)
        return detailsStackView
    }
    
    func makeDetailsStackView() -> UIStackView {
        let detailsStackView = UIStackView(frame: .zero)
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.axis = .vertical
        detailsStackView.alignment = .leading
        detailsStackView.distribution = .fill
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

// MARK: View layout constants

private extension UIFont {
    static let bookTitleFont = UIFont.systemFont(ofSize: .bookTitleFontSize, weight: .medium)
    static let authorsFont = UIFont.systemFont(ofSize: .authorFontSize, weight: .light)
    static let narratorFont = UIFont.systemFont(ofSize: .narratorFontSize, weight: .light)
}

private extension CGFloat {
    static let mainStackViewPadding: CGFloat = 8
    static let detailsStackViewPadding: CGFloat = 0
    static let coverImageThumbnailSize: CGFloat = 64
    static let bookTitleFontSize: CGFloat = 15
    static let authorFontSize: CGFloat = 12
    static let narratorFontSize: CGFloat = 12
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

// MARK: - Interface

protocol QueryResultCellModelType {
    var image: AnyPublisher<UIImage, Never> { get }
    var bookTitle: String { get }
    var authors: String { get }
    var narrators: String { get }
}

extension QueryResultTableViewCell {
    func set(queryResult: QueryResultCellModelType) {
        bookTitleLabel.text = queryResult.bookTitle
        authorsLabel.text = queryResult.authors
        narratorsLabel.text = queryResult.narrators
        
        queryResult.image.sink { [weak self] image in
            self?.imageView?.image = image
        }.store(in: &subscriptions)
    }
}

