//
//  QueryResultsViewController.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-18.
//

import UIKit
import Combine

final class QueryResultsViewController<VM: QueryResultTableViewModelType>: UIViewController {
    private let viewModel: VM
    private var bridge: UITableViewBridge!
    private var subscriptions =  [AnyCancellable]()
    
    // MARK: UI properties
    private var tableView: UITableView!
    
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - View Setup
private extension QueryResultsViewController {
    func setupView() {
        let (mainView, constraints) = makeMainView()
        view.addSubview(mainView)
        NSLayoutConstraint.activate(constraints)
    }
    
    func makeMainView() -> (UIView, [NSLayoutConstraint]) {
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray4
        tableView.separatorInset = .zero
        
        bridge = UITableViewBridge()
        bridge.delegate = self
        tableView.delegate = bridge
        tableView.dataSource = bridge
        
        tableView.register(
            QueryHeaderTableViewCell.self,
            forCellReuseIdentifier: .queryHeaderCellReuseIdentifier
        )
        tableView.register(
            QueryResultTableViewCell.self,
            forCellReuseIdentifier: .queryResultCellReuseIdentifier
        )
        tableView.register(
            QueryLoaderTableViewCell.self,
            forCellReuseIdentifier: .queryLoaderCellReuseIdentifier
        )
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        return (tableView, constraints)
    }
}

// MARK: - UITableViewDelegate
extension QueryResultsViewController: UITableViewBridgeDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }
        viewModel.loadData()
    }
}

// MARK: - UITableViewDataSource
extension QueryResultsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let headerCell = tableView.dequeueReusableCell(
                withIdentifier: .queryHeaderCellReuseIdentifier,
                for: indexPath
            ) as? QueryHeaderTableViewCell else {
                assertionFailure(
                    "QueryHeaderTableViewCell not registered for \(String.queryHeaderCellReuseIdentifier)"
                )
                return UITableViewCell()
            }
            headerCell.set(query: viewModel.query)
            return headerCell
        case 1:
            guard let resultCell = tableView.dequeueReusableCell(
                withIdentifier: .queryResultCellReuseIdentifier,
                for: indexPath
            ) as? QueryResultTableViewCell else {
                assertionFailure("QueryResultTableViewCell not registered for \(String.queryResultCellReuseIdentifier)")
                return UITableViewCell()
            }
            do {
                try resultCell.set(queryResult: viewModel.queryCellModel(at: indexPath.row))
            } catch {
                assertionFailure("\(error)")
                return UITableViewCell()
            }
            
            return resultCell
        case 2:
            guard let loaderCell = tableView.dequeueReusableCell(
                withIdentifier: .queryLoaderCellReuseIdentifier,
                for: indexPath
            ) as? QueryLoaderTableViewCell else {
                assertionFailure("QueryLoaderTableViewCell not registered for \(String.queryLoaderCellReuseIdentifier)")
                return UITableViewCell()
            }
            loaderCell.startAnimating()
            return loaderCell
        default:
            assertionFailure("Unexpected section requested - \(indexPath.section)")
            return UITableViewCell()
        }
    }
}

// MARK: Cell Reuse Identifiers

private extension String {
    static let queryHeaderCellReuseIdentifier = "QueryHeaderTableViewCellReuseIdentifer"
    static let queryResultCellReuseIdentifier = "QueryResultTableViewCellReuseIdentifer"
    static let queryLoaderCellReuseIdentifier = "QueryLoaderTableViewCellReuseIdentifer"
}

