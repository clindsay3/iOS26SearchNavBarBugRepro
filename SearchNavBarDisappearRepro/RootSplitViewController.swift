import UIKit

final class RootSplitViewController: UISplitViewController {
    private let sidebarViewController = SidebarViewController()
    private let searchViewController = SearchTableViewController()

    private var hasMigratedToTabBar: Bool = false

    private lazy var oldDictionaryNavigationController: UINavigationController = {
        searchViewController.loadViewIfNeeded()
        searchViewController.tableView.setContentOffset(CGPoint(x: 0, y: -200), animated: false)

        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    private lazy var tabBarDictionaryNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(title: "Dictionary", image: UIImage(systemName: "book"), tag: 0)
        return navigationController
    }()

    private lazy var rootTabBarController: RootTabBarController = {
        let otherViewController = UIViewController()
        otherViewController.view.backgroundColor = .systemBackground
        otherViewController.tabBarItem = UITabBarItem(title: "Other", image: UIImage(systemName: "square"), tag: 1)

        return RootTabBarController(
            dictionaryNavigationController: tabBarDictionaryNavigationController,
            otherViewController: otherViewController
        )
    }()

    init() {
        super.init(style: .doubleColumn)
        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let sidebarNavigationController = UINavigationController(rootViewController: sidebarViewController)
        setViewController(sidebarNavigationController, for: .primary)

        let detailViewController = UIViewController()
        detailViewController.view.backgroundColor = .systemBackground
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        setViewController(detailNavigationController, for: .secondary)

        setViewController(rootTabBarController, for: .compact)
    }
}

extension RootSplitViewController: UISplitViewControllerDelegate {
    func splitViewControllerDidCollapse(_ svc: UISplitViewController) {
        if !hasMigratedToTabBar {
            hasMigratedToTabBar = true
            tabBarDictionaryNavigationController.setViewControllers(oldDictionaryNavigationController.viewControllers, animated: false)
            oldDictionaryNavigationController.setViewControllers([], animated: false)

            if !tabBarDictionaryNavigationController.isNavigationBarHidden {
                tabBarDictionaryNavigationController.setNavigationBarHidden(true, animated: false)
                tabBarDictionaryNavigationController.setNavigationBarHidden(false, animated: false)
            }
        }

        sidebarViewController.searchController.dismiss(animated: false)
        sidebarViewController.navigationItem.searchController = nil

        searchViewController.attachSearchControllerIfNeeded(
            searchController: sidebarViewController.searchController,
            hidesNavigationBarDuringPresentation: true
        )
    }

    func splitViewControllerDidExpand(_ svc: UISplitViewController) {
        searchViewController.navigationItem.searchController = nil
        sidebarViewController.navigationItem.searchController = sidebarViewController.searchController
        sidebarViewController.searchController.hidesNavigationBarDuringPresentation = false
    }
}

private final class SidebarViewController: UIViewController {
    let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = false
        controller.automaticallyShowsSearchResultsController = false
        controller.searchBar.placeholder = "Search"
        controller.searchBar.searchTextField.accessibilityIdentifier = "searchField"
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Sidebar"

        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.preferredSearchBarPlacement = .stacked
    }
}
