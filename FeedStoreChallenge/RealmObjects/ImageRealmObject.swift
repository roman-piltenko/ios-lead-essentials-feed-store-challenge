//
//  ImageRealmObject.swift
//  FeedStoreChallenge
//
//  Created by Пильтенко Роман on 13.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

final class ImageRealmObject: Object {
	@objc dynamic var imageIdString: String = ""
	@objc dynamic var imageDescription: String?
	@objc dynamic var imageLocation: String?
	@objc dynamic var imageUrlString: String = ""
	let feed = LinkingObjects(fromType: FeedRealmObject.self, property: "images")
}
