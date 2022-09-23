//
//  QueryLoaderTableViewCell.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-22.
//

import UIKit

class QueryLoaderTableViewCell: UITableViewCell {
    
    private var activityIndicator: UIActivityIndicatorView!

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
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
}

private extension QueryLoaderTableViewCell {
    func setupView() {
        contentView.backgroundColor = .systemGray6
        
        let (mainView, constraints) = makeMainView()
        contentView.addSubview(mainView)
        contentView.addConstraints(constraints)
    }
    
    func makeMainView() -> (UIView, [NSLayoutConstraint]) {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.tintColor = .systemGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        return (activityIndicator, constraints)
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
}
