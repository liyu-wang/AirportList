//
//  DetailsView.swift
//  MockAppUIKit
//
//  Created by Liyu Wang on 31/10/21.
//

import UIKit

protocol DetailsViewDelegate: AnyObject {
    func detailsViewDidTapGoBack(_ detailsView: DetailsView)
}

class DetailsView: UIView {
    weak var delegate: DetailsViewDelegate?

    private let airportCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let airportNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let aboveSeaLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let latitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let latitudeRadiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let longitudeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let longitudeRadiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let latitudeDirectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let longitudeDirectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeZoneNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countryCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let regionCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let regionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var goBackButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle(Strings.Buttons.goBackTitle, for: .normal)
        button.addTarget(self, action: .goBackButtonTapped, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = UIDevice.current.userInterfaceIdiom != .phone
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: .spacing1x, leading: .spacing1x, bottom: .spacing1x, trailing: .spacing1x)
        return stackView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        [
            airportCodeLabel,
            airportNameLabel,
            aboveSeaLevelLabel,
            latitudeLabel,
            latitudeRadiusLabel,
            longitudeLabel,
            longitudeRadiusLabel,
            latitudeDirectionLabel,
            longitudeDirectionLabel,
            cityCodeLabel,
            countryNameLabel,
            timeZoneNameLabel,
            countryCodeLabel,
            countryNameLabel,
            regionCodeLabel,
            regionNameLabel,
            goBackButton
        ].forEach { stackView.addArrangedSubview($0) }
        scrollView.addSubview(stackView)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

//            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    func configureViews(_ viewModel: DetailsViewModel) {
        airportCodeLabel.text = "Airport code: \(viewModel.airport.airportCode)"
        airportNameLabel.text = "Airport name: \(viewModel.airport.airportName)"
        aboveSeaLevelLabel.text = "Above sea level: \(String(describing: viewModel.airport.location.aboveSeaLevel ?? 0))"
        latitudeLabel.text = "Latitude: \(String(viewModel.airport.location.latitude))"
        latitudeRadiusLabel.text = "Latitude Radius: \(String(viewModel.airport.location.latitudeRadius))"
        longitudeLabel.text = "Longitude: \(String(viewModel.airport.location.longitude))"
        longitudeRadiusLabel.text = "Longitude radius: \(String(viewModel.airport.location.longitudeRadius))"
        latitudeDirectionLabel.text = "Latitude Direction: \(viewModel.airport.location.latitudeDirection ?? "")"
        longitudeDirectionLabel.text = "Longitude: \(viewModel.airport.location.longitudeDirection ?? "")"
        cityCodeLabel.text = "City code: \(viewModel.airport.city.cityCode)"
        cityNameLabel.text = "City name: \(viewModel.airport.city.cityName ?? "")"
        timeZoneNameLabel.text = "Time zone name: \(viewModel.airport.city.timeZoneName)"
        countryCodeLabel.text = "Country code: \(viewModel.airport.country.countryCode)"
        countryNameLabel.text = "Country name: \(viewModel.airport.country.countryName)"
        regionCodeLabel.text = "Region code: \(viewModel.airport.region.regionCode)"
        regionNameLabel.text = "Region name: \(viewModel.airport.region.regionName)"
    }

    @objc
    func goBackButtonTapped(sender: UIButton) {
        delegate?.detailsViewDidTapGoBack(self)
    }
}

fileprivate extension Selector {
    static let goBackButtonTapped = #selector(DetailsView.goBackButtonTapped)
}
