//
//  FeedRealmObject.swift
//  FeedStoreChallenge
//
//  Created by Пильтенко Роман on 13.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

final class FeedRealmObject: Object {
	@objc dynamic var timestamp: Date = Date()
	let feed = List<ImageRealmObject>()
	
	convenience init(feed: [ImageRealmObject], timestamp: Date) {
		self.init()
		self.feed.append(objectsIn: feed)
		self.timestamp = timestamp
	}
	
	func toLocalImages() throws -> [LocalFeedImage] {
		return try feed.map { try $0.toLocalImages() }
	}
}
