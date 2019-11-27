import UIKit

final class SearchSongsPresenter {
    
    weak var viewInput: (UIViewController & SearchSongsViewInput)?
    private let searchService = ITunesSearchService()
    
    private func requestSongs(with query: String) {
        self.searchService.getSongs(forQuery: query) { [weak self] result in
            guard let self = self else { return }
            self.viewInput?.throbber(show: false)
            result
                .withValue { apps in
                    guard !apps.isEmpty else {
                        self.viewInput?.hideNoResults()
                        return
                    }
                    self.viewInput?.hideNoResults()
                    self.viewInput?.searchResults = apps
            }
            .withError {
                self.viewInput?.showError(error: $0)
            }
        }
    }
    
    private func openSongDetails(with app: ITunesSong) {
        let appDetailViewController = MusicDetailController(song: app)
        appDetailViewController.title = app.trackName
        self.viewInput?.navigationController?.pushViewController(appDetailViewController, animated: true)
    }
}

extension SearchSongsPresenter: SearchSongsViewOutput {
    
    func viewDidSearch(with query: String) {
        self.viewInput?.throbber(show: true)
        self.requestSongs(with: query)
    }
    
    func viewDidSelectApp(_ song: ITunesSong) {
        self.openSongDetails(with: song)
    }
}
