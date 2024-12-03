import UIKit
import Combine
import DesignSystem

final class FeedViewController: UIViewController {
    private let viewModel: FeedViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(RecipeCell.self, forCellReuseIdentifier: "RecipeCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        return indicator
    }()

    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.retryAction = { [weak self] in
            self?.viewModel.refreshRecipes()
        }

        return view
    }()

    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        title = "Recipes"
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func bindViewModel() {
        cancellables.removeAll()

        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
    }

    private func handleState(_ state: FeedViewState) {
        switch state {
        case .loading:
            showLoading()
        case .success(let recipes):
            showContent(recipes)
        case .error(let message):
            showError(message)
        }
    }

    private func showLoading() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        errorView.isHidden = true
    }

    private func showContent(_ recipes: [Recipe]) {
        activityIndicator.stopAnimating()
        tableView.isHidden = false
        errorView.isHidden = true
        tableView.reloadData()
    }

    private func showError(_ message: String) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        errorView.isHidden = false
        errorView.configure(with: message)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cachedRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }

        // Could be improved by returning a view model for the cell. Avoid returning a model.
        let recipe = viewModel.cachedRecipes[indexPath.row]
        cell.configure(with: recipe.title, summary: recipe.summary)

        return cell
    }
}
