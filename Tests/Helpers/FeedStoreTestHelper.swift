//
//  FeedStoreTestHelper.swift
//  Tests
//
//  Created by Пильтенко Роман on 13.02.2021.
//  Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

internal final class FeedStoreTestHelper {
	internal static func clearTestStoreCache(at url: URL) {
		let fileManager = FileManager.default
		do {
			let directoryContents = try FileManager.default.contentsOfDirectory(at: url,
																				includingPropertiesForKeys: nil,
																				options: [])
			for file in directoryContents {
				do {
					try fileManager.removeItem(at: file)
				}
				catch let error as NSError {
					debugPrint("Ooops! Something went wrong: \(error)")
				}
				
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
