import Foundation
import AVKit

protocol SongViewProtocol {
    var songImage: UIImageView { get set }
    var currentTimeSlider: UISlider { get set }
    var currentTimeLabel: UILabel { get set }
    var durationLabel: UILabel { get set }
    var songTitle: UILabel { get set }
    var songArtist: UILabel { get set }
    var buttonBack: UIButton { get set }
    var playPauseButton: UIButton { get set }
    var buttonForward: UIButton { get set }
    var imageViewVolumeBack: UIImageView { get set }
    var imageViewVolumeForward: UIImageView { get set }
    var volumeSlider: UISlider { get set }
}


class SongViewModel {
    
    let song: ITunesSong
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    private let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    init(song: ITunesSong) {
        self.song = song
    }
    
    var songView: SongView!
    
    func playMusic(song: ITunesSong) {
        guard let url = URL(string: song.previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in

            self?.songView?.currentTimeLabel.text = time.toDisplayString()
            let duration = self?.player.currentItem?.duration
            self?.songView?.durationLabel.text = duration?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        
        self.songView?.currentTimeSlider.value = Float(percentage)
    }
    
    func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @objc func handleRewind() {
        seekToCurrentTime(delta: -15)
    }
    
    @objc func handleForward() {
        seekToCurrentTime(delta: 15)
    }
    
    @objc func handleVolume(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @objc func handlePlayAndPause() {
        if player.timeControlStatus == .paused {
            player.play()
            songView?.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            shrinkEpisodeImageView()
        } else {
            player.pause()
            songView?.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            enlargeEpisodeImageView()
        }
    }
    
    func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.songView?.songImage.transform = .identity
        }, completion: nil)
    }
    
    private func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.songView?.songImage.transform = self.shrunkenTransform
        }, completion: nil)
    }
}
