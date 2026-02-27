import UIKit

final class RootTabBarController: UITabBarController {
    private let dictionaryNavigationController: UINavigationController
    private let otherViewController: UIViewController

    init(dictionaryNavigationController: UINavigationController, otherViewController: UIViewController) {
        self.dictionaryNavigationController = dictionaryNavigationController
        self.otherViewController = otherViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [dictionaryNavigationController, otherViewController]
    }
}
