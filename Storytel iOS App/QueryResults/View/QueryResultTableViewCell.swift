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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for subscription in subscriptions {
            subscription.cancel()
        }
        subscriptions = []
        coverImageView.image = .defaultAnimatedImage
        bookTitleLabel.text = nil
        authorsLabel.text = nil
        narratorsLabel.text = nil
    }
}

// MARK: - View setup

private extension QueryResultTableViewCell {
    func setupView() {
        contentView.backgroundColor = .systemBackground
        
        let (mainView, constraints) = makeMainView()
        contentView.addSubview(mainView)
        NSLayoutConstraint.activate(constraints)
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
                    .with(priority: .defaultHigh)
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
        coverImageView.image = .defaultAnimatedImage
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
        
        detailsStackView.addArrangedSubview(bookTitleLabel)
        
        authorsLabel = UILabel()
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        authorsLabel.font = .authorsFont
        authorsLabel.textColor = .systemGray
        
        detailsStackView.addArrangedSubview(authorsLabel)
        
        narratorsLabel = UILabel()
        narratorsLabel.translatesAutoresizingMaskIntoConstraints = false
        narratorsLabel.font = .narratorFont
        narratorsLabel.textColor = .systemGray
        
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
    static let defaultCoverImage1 = image(
        with: .systemGray,
        size: .init(
            width: .coverImageThumbnailSize,
            height: .coverImageThumbnailSize
        )
    )
    static let defaultCoverImage2 = image(
        with: .systemGray6,
        size: .init(
            width: .coverImageThumbnailSize,
            height: .coverImageThumbnailSize
        )
    )
    static let defaultAnimatedImage = {
        let animatingColors: [UIColor] = [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6, .systemGray5, .systemGray4, .systemGray3, .systemGray2, .systemGray]
        
        return UIImage.animatedImage(
            with: animatingColors.map {
                image(
                    with: $0,
                    size: .init(
                        width: .coverImageThumbnailSize,
                        height: .coverImageThumbnailSize
                    )
                )
            },
            duration: 3
        )
    }()
}

// MARK: - Interface

extension QueryResultTableViewCell {
    func set(queryResult: QueryResultCellModel) {
        bookTitleLabel.text = queryResult.bookTitle
        authorsLabel.text = queryResult.authors
        narratorsLabel.text = queryResult.narrators
        
        queryResult.image.sink { _ in
            // Set a failure image if provided by designer
        } receiveValue: { [weak self] image in
            self?.coverImageView.image = image
        }.store(in: &subscriptions)
    }
}

