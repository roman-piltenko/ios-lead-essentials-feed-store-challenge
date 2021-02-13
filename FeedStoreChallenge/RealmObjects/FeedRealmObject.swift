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
	@objc dynamic var objID: ObjectId = ObjectId()
	@objc dynamic var timestamp: Date = Date.init()
	let images = List<ImageRealmObject>()
	
	override class func primaryKey() -> String? {
		"objID"
	}
}
