import UIKit

final class AppDetailViewController: UIViewController {
    
    let app: ITunesApp
    
    lazy var headerViewController = AppDetailHeaderViewController(app: self.app)
    lazy var descriptionViewController = AppDescriptionController(app: self.app)
    lazy var screenshotsViewController = AppDetailScreenshotsController(app: self.app)
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        self.view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
        self.addHeaderViewController()
        self.addDescriptionViewController()
        self.addScreenshotsViewController()
    }
    
    private func addHeaderViewController() {
        self.addChild(self.headerViewController)
        self.scrollView.addSubview(self.headerViewController.view)
        self.headerViewController.didMove(toParent: self)
        
        headerViewController.view.anchor(top: scrollView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
    }
    
    private func addDescriptionViewController() {
        
        self.addChild(descriptionViewController)
        self.scrollView.addSubview(descriptionViewController.view)
        descriptionViewController.didMove(toParent: self)
        
        descriptionViewController.view.anchor(top: headerViewController.view.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
    }
    
    private func addScreenshotsViewController() {
        
        self.addChild(screenshotsViewController)
        self.scrollView.addSubview(screenshotsViewController.view)
        screenshotsViewController.didMove(toParent: self)
        
        screenshotsViewController.view.anchor(top: descriptionViewController.view.bottomAnchor, leading: view.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 20, right: 0))
        screenshotsViewController.view.heightAnchor.constraint(equalToConstant: 350).isActive = true
    }
}
