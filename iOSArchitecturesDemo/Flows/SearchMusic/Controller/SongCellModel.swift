import UIKit

struct SongCellModel {
    let trackName: String
    let artistName: String?
    let collectionName: String?
    let artwork: String?
}

final class SongCellModelFactory {
    
    static func cellModel(from model: ITunesSong) -> SongCellModel {
        return SongCellModel(trackName: model.trackName,
                             artistName: model.artistName,
                             collectionName: model.collectionName,
                             artwork: model.artwork)
    }
}
