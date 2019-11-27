import UIKit

final class SearchViewController: UIViewController {
    
    private let presenter: SearchViewOutput
    init(presenter: SearchViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
//    private let viewModel: SearchViewModel
//    private var searchResults = [SearchAppCellModel]()
//
//    init(viewModel: SearchViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private var searchView: SearchView {
        return self.view as! SearchView
    }
    
    private let searchService = ITunesSearchService()
    var searchResults = [ITunesApp]() {
        didSet {
            self.searchView.tableView.isHidden = false
            self.searchView.tableView.reloadData()
            self.searchView.searchBar.resignFirstResponder()
        }
    }
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = SearchView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.searchView.searchBar.delegate = self
        self.searchView.tableView.register(AppCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.searchView.tableView.delegate = self
        self.searchView.tableView.dataSource = self
        
        self.bindViewModel()
    }
    
    private func bindViewModel() {
//        // Во время загрузки данных показываем индикатор загрузки
//        self.viewModel.isLoading.addObserver(self) { [weak self] (isLoading, _) in
//            self?.throbber(show: isLoading)
//        }
//        // Если пришла ошибка, то отобразим ее в виде алерта
//        self.viewModel.error.addObserver(self) { [weak self] (error, _) in
//            if let error = error {
//                self?.showError(error: error)
//            }
//        }
//        // Если вью-модель указывает, что нужно показать экран пустых результатов, то делаем это
//        self.viewModel.showEmptyResults.addObserver(self) { [weak self] (showEmptyResults, _) in
//            self?.searchView.emptyResultView.isHidden = !showEmptyResults
//            self?.searchView.tableView.isHidden = showEmptyResults
//        }
//        // При обновлении данных, которые нужно отображать в ячейках, сохраняем их и перезагружаем tableView
//        self.viewModel.cellModels.addObserver(self) { [weak self] (searchResults, _) in
//            self?.searchResults = searchResults
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.throbber(show: false)
    }
    
    // MARK: - Private
    
//    private func throbber(show: Bool) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = show
//    }
//
//    private func showError(error: Error) {
//        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
//        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alert.addAction(actionOk)
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    private func showNoResults() {
//        self.searchView.emptyResultView.isHidden = false
//    }
//
//    private func hideNoResults() {
//        self.searchView.emptyResultView.isHidden = true
//    }
    
//    private func requestApps(with query: String) {
//        self.throbber(show: true)
//        self.searchResults = []
//        self.searchView.tableView.reloadData()
//
//        self.searchService.getApps(forQuery: query) { [weak self] result in
//            guard let self = self else { return }
//            self.throbber(show: false)
//            result
//                .withValue { apps in
//                    guard !apps.isEmpty else {
//                        self.searchResults = []
//                        self.showNoResults()
//                        return
//                    }
//                    self.hideNoResults()
//                    self.searchResults = apps
//
//                    self.searchView.tableView.isHidden = false
//                    self.searchView.tableView.reloadData()
//
//                    self.searchView.searchBar.resignFirstResponder()
//                }
//                .withError {
//                    self.showError(error: $0)
//                }
//        }
//    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? AppCell else {
            return dequeuedCell
        }
        let app = self.searchResults[indexPath.row]
        let cellModel = AppCellModelFactory.cellModel(from: app)
        cell.configure(with: cellModel)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        let app = searchResults[indexPath.row]
        presenter.viewDidSelectApp(app)
//        let appDetaillViewController = AppDetailViewController(app: app)
////        appDetaillViewController.app = app
//        navigationController?.pushViewController(appDetaillViewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            searchBar.resignFirstResponder()
            return
        }
        if query.count == 0 {
            searchBar.resignFirstResponder()
            return
        }
//        self.requestApps(with: query)
        self.presenter.viewDidSearch(with: query)
    }
}

extension SearchViewController: SearchViewInput {
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoResult() {
        self.searchView.emptyResultView.isHidden = false
        self.searchResults = []
        self.searchView.tableView.reloadData()
    }
    
    func hideNoResults() {
        self.searchView.emptyResultView.isHidden = true
    }
    
    func throbber(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
}
