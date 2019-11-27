import UIKit
import AVKit

class MusicDetailController: UIViewController {
    
//    private let viewModel: SongViewModel
//
//    init(viewModel: SongViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
    private var song: ITunesSong!
    
    init(song: ITunesSong) {
        self.song = song
        super.init(nibName: nil, bundle: nil)
    }

    var songView: SongView = {
        let view = SongView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setupPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupPlayer() {
        songView.playMusic(song: song)
//        songView.playMusic(song: viewModel.song)
        songView.observePlayerCurrentTime()
//        songView.observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        songView.player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.songView.enlargeEpisodeImageView()
        }
    }
    
    private func configure() {
        view.addSubview(songView)
        songView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 40, right: 16))
        tabBarController?.tabBar.isHidden = true
    }
    
    private func loadData() {
        songView.songTitle.text = song.trackName
        songView.songArtist.text = song.artistName
        songView.songImage.sd_setImage(with: URL(string: song.artwork ?? ""))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
