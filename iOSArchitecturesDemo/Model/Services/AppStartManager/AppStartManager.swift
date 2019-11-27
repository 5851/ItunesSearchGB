import UIKit

final class AppStartManager {
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let tabBarController = self.configurationTabBarController
        tabBarController.viewControllers = [
            createNavController(viewController: SearchModuleBuilder.build(), title: "Search via iTunes", imageName: "app"),
            createNavController(viewController: SearchModuleBuilder.buildSong(), title: "Search music", imageName: "music")
        ]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private lazy var configurationTabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        return tabBarController
    }()
    
    private func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.barTintColor = UIColor.varna
        navController.navigationBar.tintColor = .white
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.tabBarItem.title = title
        viewController.navigationItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}

final class SearchModuleBuilder {
    
    static func build() -> (UIViewController & SearchViewInput) {
        let presenter = SearchPresenter()
        let viewController = SearchViewController(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }
    
    static func buildSong() -> (UIViewController & SearchSongsViewInput) {
        let presenter = SearchSongsPresenter()
        let viewController = SearchSongViewController(presenter: presenter)
        presenter.viewInput = viewController
        return viewController
    }
}
