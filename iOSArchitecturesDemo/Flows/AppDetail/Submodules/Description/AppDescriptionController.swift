import UIKit

class AppDescriptionController: UIViewController {
    
    // MARK: - Properties
    
    private let app: ITunesApp
    
    private var addDescriptionView: AppDescriptionView {
        return self.view as! AppDescriptionView
    }
    
    // MARK: - Init
    
    init(app: ITunesApp) {
        self.app = app
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDescriptionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
    }
    
    // MARK: - Private
    
    private func fillData() {
        self.addDescriptionView.descriptionLabel.text = app.appDescription
    }
}
