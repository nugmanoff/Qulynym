/*
* Kulynym
* KaraokeInteractor.swift
*
* Created by: Metah on 8/4/19
*
* Copyright © 2019 Automatization X Software. All rights reserved.
*/

import Foundation

protocol KaraokeInteractorProtocol: class {
    func getMaxCount(_ isKaraoke: Bool) -> Int
    func getLyricsText(_ index: Int) -> String
    func getTextViewTimepoints(_ index: Int) -> [Int: Int]
    func getPreviousAudioName(_ index: inout Int, isKaraoke: Bool) -> String
    func getNextAudioName(_ index: inout Int, isKaraoke: Bool) -> String
}

class KaraokeInteractor: KaraokeInteractorProtocol {
    weak var presenter: KaraokePresenterProtocol!
    
    required init(_ presenter: KaraokePresenterProtocol) {
        self.presenter = presenter
    }
}

extension KaraokeInteractor {
    // MARK:- Protocol Methods
    func getMaxCount(_ isKaraoke: Bool) -> Int {
        if isKaraoke {
            return ContentService.songs.count - 1
        }
        return ContentService.stories.count - 1
    }
    
    func getLyricsText(_ index: Int) -> String {
        return ContentService.songs[index].lyrics
    }
    
    func getTextViewTimepoints(_ index: Int) -> [Int: Int] {
        return ContentService.songs[index].textViewTimepoints
    }
    
    func getPreviousAudioName(_ index: inout Int, isKaraoke: Bool) -> String {
        index -= 1
        if isKaraoke {
            return ContentService.songs[index].name
        }
        return ContentService.stories[index]
    }
    
    func getNextAudioName(_ index: inout Int, isKaraoke: Bool) -> String {
        index += 1
        if isKaraoke {
            return ContentService.songs[index].name
        }
        return ContentService.stories[index]
    }
}
