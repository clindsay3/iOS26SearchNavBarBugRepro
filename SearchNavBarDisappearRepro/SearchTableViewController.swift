import UIKit

final class SearchTableViewController: UITableViewController {
    private let items: [String] = (1...50).map { "Row \($0)" }

    private weak var attachedSearchController: UISearchController?

    init() {
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Dictionary"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func attachSearchControllerIfNeeded(
        searchController: UISearchController,
        hidesNavigationBarDuringPresentation: Bool
    ) {
        attachedSearchController = searchController
        definesPresentationContext = true

        searchController.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = false
        searchController.searchBar.barTintColor = .systemBackground
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.searchTextField.accessibilityIdentifier = "searchField"
        searchController.searchBar.searchTextField.backgroundColor = .systemBackground

        if navigationItem.searchController !== searchController {
            navigationItem.searchController = searchController
        }

        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

extension SearchTableViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        guard let searchController = attachedSearchController else {
            return true
        }

        searchController.isActive = true
        searchController.showsSearchResultsController = true
        return true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        attachedSearchController?.showsSearchResultsController = false
    }
}
