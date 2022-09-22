//
//  QueryHeaderTableViewCell.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-21.
//

import UIKit

class QueryHeaderTableViewCell: UITableViewCell {
    
    private var queryLabel: UILabel!

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
        queryLabel.text = nil
    }
}

private extension QueryHeaderTableViewCell {
    func setupView() {
        contentView.backgroundColor = .systemGray4
        
        let (mainView, constraints) = makeMainView()
        contentView.addSubview(mainView)
        contentView.addConstraints(constraints)
    }
    
    func makeMainView() -> (UIView, [NSLayoutConstraint]) {
        queryLabel = UILabel()
        queryLabel.translatesAutoresizingMaskIntoConstraints = false
        queryLabel.font = .queryFontSize
        queryLabel.textColor = .black
        queryLabel.textAlignment = .center
        queryLabel.numberOfLines = 0
        
        let constraints = [
            queryLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: .verticalPadding)
            ,
            contentView.bottomAnchor.constraint(
                equalTo: queryLabel.bottomAnchor,
                constant: .verticalPadding
            ),
            queryLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: .horizontalPadding)
            ,
            contentView.trailingAnchor.constraint(
                equalTo: queryLabel.trailingAnchor,
                constant: .horizontalPadding
            ),
            contentView.heightAnchor.constraint(equalToConstant: .headerSize)
        ]
        
        return (queryLabel, constraints)
    }
}

// MARK: View layout constants

private extension UIFont {
    static let queryFontSize = UIFont.systemFont(ofSize: .bookTitleFontSize, weight: .regular)
}

private extension CGFloat {
    static let bookTitleFontSize: CGFloat = 24
    static let verticalPadding: CGFloat = 12
    static let horizontalPadding: CGFloat = 12
    static let headerSize: CGFloat = 160
}

// MARK: - Interface

extension QueryHeaderTableViewCell {
    func set(query: String) {
        queryLabel.text = "Query: " + query
    }
}
