import UIKit
import AVKit

class SongView: UIView {
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    // Первый слой
    lazy var songImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .yellow
        iv.heightAnchor.constraint(equalToConstant: 350).isActive = true
        iv.image = UIImage(named: "image1")
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.transform = shrunkenTransform
        return iv
    }()
    
    // Второй слой
    let currentTimeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00.00"
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00.00"
        return label
    }()
    
    // Третий слой
    let songTitle: UILabel = {
        let label = UILabel()
        label.text = "Название песни"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let songArtist: UILabel = {
        let label = UILabel()
        label.text = "Имя артиста"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // Четвертый слой
    let buttonBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "rewind15"), for: .normal)
        button.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
        return button
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.addTarget(self, action: #selector(handlePlayAndPause), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let buttonForward: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "fastforward15"), for: .normal)
        button.addTarget(self, action: #selector(handleForward), for: .touchUpInside)
        return button
    }()
    
    // Пятый слой
    let imageViewVolumeBack: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "muted_volume")
        return iv
    }()
    
    let imageViewVolumeForward: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "max_volume")
        return iv
    }()
    
    let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(handleVolume), for: .touchUpInside)
        slider.value = 1
        slider.maximumValue = 1
        slider.minimumValue = 0
        return slider
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Private functions
    
    private func configureUI() {
        
        let stackView = UIStackView(arrangedSubviews: [
            currentTimeLabel, UIView(), durationLabel
        ])
        
        let timerStackView = UIStackView(arrangedSubviews: [
            currentTimeSlider,
            stackView
        ])
        timerStackView.axis = .vertical
        timerStackView.spacing = 10
        
        let playerStackView = UIStackView(arrangedSubviews: [
            UIView(), buttonBack, playPauseButton, buttonForward, UIView()
        ])
        playerStackView.spacing = 10
        playerStackView.distribution = .equalCentering
        
        let volumeStackView = UIStackView(arrangedSubviews: [
            imageViewVolumeBack, volumeSlider, imageViewVolumeForward
        ])
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            songImage,
            timerStackView,
            songTitle,
            songArtist,
            playerStackView,
            volumeStackView,
            UIView()
        ])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 15
        
        self.addSubview(verticalStackView)
        verticalStackView.fillSuperview()
    }
}

extension SongView {
    
    func playMusic(song: ITunesSong) {
        guard let url = URL(string: song.previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in

            self?.currentTimeLabel.text = time.toDisplayString()
            let duration = self?.player.currentItem?.duration
            self?.durationLabel.text = duration?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        self.currentTimeSlider.value = Float(percentage)
    }
    
    func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @objc private func handleRewind() {
        seekToCurrentTime(delta: -15)
    }
    
    @objc private func handleForward() {
        seekToCurrentTime(delta: 15)
    }
    
    @objc private func handleVolume(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @objc private func handlePlayAndPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    // Aнимация
    func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.songImage.transform = .identity
        }, completion: nil)
    }
    
    private func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.songImage.transform = self.shrunkenTransform
        }, completion: nil)
    }
}
