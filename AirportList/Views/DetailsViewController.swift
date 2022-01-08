//
//  DetailsViewController.swift
//  MockAppUIKit
//
//  Created by Liyu Wang on 31/10/21.
//

import UIKit

class DetailsViewController: UIViewController {

    private var detailsView: DetailsView {
        view as! DetailsView
    }
    private let viewModel: DetailsViewModel

    init(detailsViewModel: DetailsViewModel) {
        self.viewModel = detailsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let detailsView = DetailsView()
        detailsView.delegate = self
        view = detailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = Strings.Navigation.detailsVCTitle
        detailsView.configureViews(viewModel)
    }
    
}

extension DetailsViewController: DetailsViewDelegate {
    func detailsViewDidTapGoBack(_ detailsView: DetailsView) {
        navigationController?.popViewController(animated: true)
    }
}
