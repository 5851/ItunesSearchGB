import UIKit

protocol SearchSongsViewInput: class {
    var searchResults: [ITunesSong] { get set }
    func showError(error: Error)
    func showNoResult()
    func hideNoResults()
    func throbber(show: Bool)
}

protocol SearchSongsViewOutput: class {
    func viewDidSearch(with query: String)
    func viewDidSelectApp(_ song: ITunesSong)
}
