//
//  ViewController.swift
//  AirportList
//
//  Created by Liyu Wang on 9/11/21.
//

import UIKit
import Combine

class ListViewController: UIViewController {

    private enum Constants {
        static let estimatedRowHeight: CGFloat = 60
        static let cellReuseIdentifier = String(describing: AirportsTableViewCell.self)
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            AirportsTableViewCell.self,
            forCellReuseIdentifier: Constants.cellReuseIdentifier
        )
        return tableView
    }()

    private let loadingSpinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private var airportNavigatable: AirportNavigatable
    private let viewModel: ListViewModelType
    private var cancellables = Set<AnyCancellable>()

    init(airportNavigatable: AirportNavigatable, viewModel: ListViewModelType = ListViewModel()) {
        self.airportNavigatable = airportNavigatable
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupReactive()

        viewModel.fetchAirports()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedIndexPath, animated: animated)
    }

    private func setupViews() {
        navigationItem.title = Strings.Navigation.listVCTitle

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(loadingSpinner)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),

            loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupReactive() {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingSpinner.startAnimating()
                } else {
                    self?.loadingSpinner.stopAnimating()
                }
            }
            .store(in: &cancellables)

        viewModel.reloadTablePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.displayAlert(for: error)
            }
            .store(in: &cancellables)
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let airportCellModel = viewModel.cellModel(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier, for: indexPath) as? AirportsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(airportCellModel)
        return cell
    }

}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let airportCellModel = viewModel.cellModel(at: indexPath)
        airportNavigatable.showAirportDetails(airportCellModel.airport)
    }
}
