//
//  SearchHistoryStorage.swift
//  Slang-App
//
//  Created by Мадияр on 4/15/20.
//  Copyright © 2020 Мадияр. All rights reserved.
//

import Foundation

typealias SubscribeCallback = () -> Bool

class SearchHistoryStorage {
    static let shared = SearchHistoryStorage()
    
    let userDefaultsKey: String = "searchHistory"
    let historyCapacity: Int = 10
    
    var subscribers = [SubscribeCallback]()
    
    private init() { }
    
    func storeSearch(_ search: String) {
        var searchHistory: [String] = []
        
        if let cachedSearchHistory = UserDefaults.standard.value(forKey: userDefaultsKey) as? [String] {
            searchHistory = cachedSearchHistory
        }
        
        guard !searchHistory.contains(search) else { return }
        
        if searchHistory.count >= historyCapacity {
            searchHistory.removeFirst()
        }
        
        searchHistory.append(search)
        UserDefaults.standard.set(searchHistory, forKey: userDefaultsKey)
        notifySubscribers()
    }
    
    func clearSearchHistory() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        notifySubscribers()
    }
    
    func onChange(_ callback: @escaping SubscribeCallback) {
        subscribers.append(callback)
    }
    
    func getRecentSearches() -> [String] {
        guard let searchHistory = UserDefaults.standard.value(forKey: userDefaultsKey) as? [String] else {
            return []
        }
        
        return searchHistory
    }
    
    private func notifySubscribers() {
        var deallocatedOwnerIndices: [Int] = []
        
        subscribers.enumerated().forEach { (index, subscriber) in
            if !subscriber() { deallocatedOwnerIndices.append(index) }
        }
        
        deallocatedOwnerIndices.reversed().forEach { (index) in
            _ = subscribers.remove(at: index)
        }
    }
}
