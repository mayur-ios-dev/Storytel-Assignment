//
//  QueryResultsViewController.swift
//  Storytel-Assignment
//
//  Created by Mayur Deshmukh on 2022-09-18.
//

import UIKit
import Combine

final class QueryResultsViewController: UIViewController {
    private let viewModel: QueryResultsViewModelType
    private let input = PassthroughSubject<QueryResultsViewModel.Input, Never>()
    private var subscriptions =  Set<AnyCancellable>()
    
    // MARK: UI properties
    private var tableView: UITableView!
    
    init(viewModel: QueryResultsViewModelType) {
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
        bind()
    }
}

// MARK: - View Setup
private extension QueryResultsViewController {
    func setupView() {
        let (mainView, constraints) = makeMainView()
        view.addSubview(mainView)
        view.addConstraints(constraints)
    }
    
    func makeMainView() -> (UIView, [NSLayoutConstraint]) {
        tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray4
        tableView.separatorInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        return (tableView, constraints)
    }
}

// MARK: - UITableViewDelegate
extension QueryResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        input.send(.willDisplayCell(at: indexPath))
    }
}

// MARK: - UITableViewDataSource
extension QueryResultsViewController: UITableViewDataSource {
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
            headerCell.set(query: viewModel.queryString)
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
                try resultCell.set(queryResult: viewModel.queryResult(at: indexPath.row))
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
            return loaderCell
        default:
            assertionFailure("Unexpected section requested - \(indexPath.section)")
            return UITableViewCell()
        }
    }
}

private extension QueryResultsViewController {
    func bind() {
        viewModel.map(
            input.eraseToAnyPublisher()
        ).sink { [weak self] output in
            self?.handleOutput(output)
        }.store(in: &subscriptions)
    }
    
    func handleOutput(_ output: QueryResultsViewModel.Output) {
        switch output {
        case .dataFetched:
            tableView.reloadData()
        }
    }
}


// MARK: Cell Reuse Identifiers

private extension String {
    static let queryHeaderCellReuseIdentifier = "QueryHeaderTableViewCellReuseIdentifer"
    static let queryResultCellReuseIdentifier = "QueryResultTableViewCellReuseIdentifer"
    static let queryLoaderCellReuseIdentifier = "QueryLoaderTableViewCellReuseIdentifer"
}

