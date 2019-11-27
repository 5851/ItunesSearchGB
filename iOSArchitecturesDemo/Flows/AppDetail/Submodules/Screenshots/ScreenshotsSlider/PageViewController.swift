import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
 
    var imageNames: [String] = []
    var app: ITunesApp?
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Закрыть", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        dataSource = self
        view.backgroundColor = .black
        
        app?.screenshotUrls.forEach({ (imageString) in
            imageNames.append(imageString)
        })
        
        let frameViewController = FrameViewController()
        frameViewController.imageName = imageNames.last
        
        let viewControllers = [frameViewController]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        configureUI()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)
        
        if currentIndex! < imageNames.count - 1 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = imageNames[currentIndex! + 1]
            return frameViewController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)
        
        if currentIndex! > 0 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = imageNames[currentIndex! - 1]
            return frameViewController
        }
        
        return nil
    }
    
    private func configureUI() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 0, bottom: 0, right: 16))
    }
    
    @objc private func handleCloseButton() {
        navigationController?.popViewController(animated: true)
    }
}


class FrameViewController: UIViewController {
    
    var imageName: String? {
        didSet {
            imageView.sd_setImage(with: URL(string: imageName ?? ""))
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
}
