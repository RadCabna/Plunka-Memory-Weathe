//
//  MemoryRecord.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 30.11.2025.
//

import Foundation
import UIKit

struct MemoryRecord: Identifiable, Codable {
    let id: UUID
    let photoFileName: String?
    let date: Date
    let weatherMoodId: Int
    let whatHappened: String
    
    init(id: UUID = UUID(), photoFileName: String?, date: Date = Date(), weatherMoodId: Int, whatHappened: String) {
        self.id = id
        self.photoFileName = photoFileName
        self.date = date
        self.weatherMoodId = weatherMoodId
        self.whatHappened = whatHappened
    }
}

class MemoryManager: ObservableObject {
    static let shared = MemoryManager()
    
    @Published var memories: [MemoryRecord] = []
    
    private let memoriesKey = "savedMemories"
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    init() {
        loadMemories()
    }
    
    // MARK: - Save Memory
    func saveMemory(photo: UIImage?, weatherMoodId: Int, whatHappened: String) {
        var photoFileName: String? = nil
        
        // Save photo if exists
        if let photo = photo {
            photoFileName = "\(UUID().uuidString).jpg"
            if let photoData = photo.jpegData(compressionQuality: 0.8) {
                let photoURL = documentsDirectory.appendingPathComponent(photoFileName!)
                try? photoData.write(to: photoURL)
            }
        }
        
        // Create memory record
        let memory = MemoryRecord(
            photoFileName: photoFileName,
            weatherMoodId: weatherMoodId,
            whatHappened: whatHappened
        )
        
        memories.insert(memory, at: 0) // Add to beginning
        saveMemories()
    }
    
    // MARK: - Load Photo
    func loadPhoto(fileName: String?) -> UIImage? {
        guard let fileName = fileName else { return nil }
        let photoURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: photoURL) else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Delete Memory
    func deleteMemory(_ memory: MemoryRecord) {
        // Delete photo file if exists
        if let photoFileName = memory.photoFileName {
            let photoURL = documentsDirectory.appendingPathComponent(photoFileName)
            try? FileManager.default.removeItem(at: photoURL)
        }
        
        // Remove from array
        memories.removeAll { $0.id == memory.id }
        saveMemories()
    }
    
    // MARK: - Persistence
    private func saveMemories() {
        if let encoded = try? JSONEncoder().encode(memories) {
            UserDefaults.standard.set(encoded, forKey: memoriesKey)
        }
    }
    
    private func loadMemories() {
        if let data = UserDefaults.standard.data(forKey: memoriesKey),
           let decoded = try? JSONDecoder().decode([MemoryRecord].self, from: data) {
            memories = decoded
        }
    }
    
    // MARK: - Sorting & Filtering
    func getMemoriesSortedByDate() -> [MemoryRecord] {
        return memories.sorted { $0.date > $1.date }
    }
    
    func getMemoriesByWeather(_ weatherId: Int) -> [MemoryRecord] {
        return memories.filter { $0.weatherMoodId == weatherId }
    }
    
    func getMemoriesByDateRange(from: Date, to: Date) -> [MemoryRecord] {
        return memories.filter { $0.date >= from && $0.date <= to }
    }
}

