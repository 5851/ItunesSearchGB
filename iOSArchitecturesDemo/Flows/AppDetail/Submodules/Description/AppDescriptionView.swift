import UIKit

class AppDescriptionView: UIView {
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
         self.addSubview(self.descriptionLabel)
         
         NSLayoutConstraint.activate([
             self.descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
             self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
             self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
             self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 12.0),
         ])
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
