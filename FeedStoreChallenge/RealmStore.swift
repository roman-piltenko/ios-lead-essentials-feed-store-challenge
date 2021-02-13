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
				completion(nil)
			}
		} catch let error as NSError {
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
				completion(nil)
			}
			
		} catch let error as NSError {
			completion(error)
		}
	}
	
	public func retrieve(completion: @escaping RetrievalCompletion) {
		do {
			let database = try Realm(configuration: configuration)
			let result = database.objects(FeedRealmObject.self)
			if let firstResult = result.first {
				let timestamp = firstResult.timestamp
				let localImages: [LocalFeedImage] = firstResult.images.map { LocalFeedImage(id: UUID(uuidString: $0.imageIdString)!,
																							description: $0.imageDescription,
																							location: $0.imageLocation,
																							url: URL(string: $0.imageUrlString)!) }
				if localImages.isEmpty {
					completion(.empty)
				} else {
					completion(.found(feed: localImages, timestamp: timestamp))
				}
			} else {
				completion(.empty)
			}
		} catch let error as NSError {
			completion(.failure(error))
		}
	}
}