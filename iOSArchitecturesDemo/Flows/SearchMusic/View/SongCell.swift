import UIKit

final class SongCell: UITableViewCell {
    
    // MARK: - Subviews
    private(set) lazy var trackName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private(set) lazy var artistName: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private(set) lazy var collectionName: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private(set) lazy var artwork: UIImageView = {
        let iv = UIImageView()
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Methods
    
    func configure(with cellModel: SongCellModel) {
        self.trackName.text = cellModel.trackName
        self.artistName.text = cellModel.artistName
        self.collectionName.text = cellModel.collectionName
        self.artwork.sd_setImage(with: URL(string: cellModel.artwork ?? ""))
    }
    
    // MARK: - UI
    
    override func prepareForReuse() {
        [self.trackName, self.artistName, self.collectionName].forEach { $0.text = nil }
        self.artwork.image = nil
    }
    
    private func configureUI() {
        let verticalStackView = UIStackView(arrangedSubviews: [
            artistName,
            trackName,
            collectionName
        ])
        verticalStackView.axis = .vertical
        
        let horizontalStackView = UIStackView(arrangedSubviews: [
            artwork, verticalStackView
        ])
        horizontalStackView.spacing = 10
        addSubview(horizontalStackView)
        horizontalStackView.fillSuperview(padding: .init(top: 5, left: 16, bottom: 5, right: 16))
    }
}
