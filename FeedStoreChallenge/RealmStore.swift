//
//  RealmStore.swift
//  FeedStoreChallenge
//
//  Created by Пильтенко Роман on 13.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmStore: FeedStore {
	
	private let configuration: Realm.Configuration
	
	public init(fileURL: URL) {
		self.configuration = Realm.Configuration(fileURL: fileURL, schemaVersion: 1, migrationBlock: { _, oldSchemaVersion in
			if (oldSchemaVersion < 1) {
			  // Nothing to do!
			  // Realm will automatically detect new properties and removed properties
			  // And will update the schema on disk automatically
			}
		})
	}
	
	public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		do {
			let database = try Realm(configuration: configuration)
			try database.write {
				database.deleteAll()
			}
			completion(nil)
		} catch {
			completion(error)
		}
	}
	
	public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		do {
			let database = try Realm(configuration: configuration)
			let realmImages: [ImageRealmObject] = feed.map { ImageRealmObject(value: ["imageIdString": $0.id.uuidString,
																					  "imageDescription": $0.description,
																					  "imageLocation": $0.location,
																					  "imageUrlString": $0.url.absoluteString]) }
			try database.write {
				let realmFeed = FeedRealmObject(value: ["timestamp": timestamp,
														"images": realmImages])
				database.add(realmFeed, update: .all)
			}
			completion(nil)
		} catch {
			completion(error)
		}
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		do {
			let database = try Realm(configuration: configuration)
			let result = database.objects(FeedRealmObject.self)
			guard let storedObject = result.first else {
				completion(.empty)
				return
			}
			
			let timestamp = storedObject.timestamp
			let localImages: [LocalFeedImage] = try storedObject.images.map { item in
				guard let id = UUID(uuidString: item.imageIdString),
					  let url = URL(string: item.imageUrlString) else {
					throw NSError(domain: "retrieval error", code: 0)
				}
				return LocalFeedImage(id: id,
									  description: item.imageDescription,
									  location: item.imageLocation,
									  url: url)
			}
			
			completion(localImages.isEmpty ? .empty : .found(feed: localImages, timestamp: timestamp))
		} catch {
			completion(.failure(error))
		}
	}
}
