//
//  PostDetailView.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 30.11.2025.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var memoryManager = MemoryManager.shared
    
    let memory: MemoryRecord
    
    private let weatherMoods: [(id: Int, emoji: String, text: String)] = [
        (1, "emoji_1", "Clear — joy, clarity"),
        (2, "emoji_2", "Rain — sadness, reflection"),
        (3, "emoji_3", "Rainbow — miracle, inspiration"),
        (4, "emoji_4", "Storm — chaos, stress"),
        (5, "emoji_5", "Fog — confusion, uncertainty"),
        (6, "emoji_6", "Thunderstorm — anger, tension"),
        (7, "emoji_7", "Light wind — calm, ease"),
        (8, "emoji_8", "Snowstorm — isolation, inner cold"),
        (9, "emoji_9", "Through the clouds — hope"),
        (10, "emoji_10", "Moonlit night — dreaminess, intuition")
    ]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, d"
        return formatter
    }
    
    var body: some View {
        ZStack {
            // Background
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: screenHeight * 0.02) {
                    // Back button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.3)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        Spacer()
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.top, screenHeight * 0.02)
                    .zIndex(100)
                    
                    // Photo
                    if let photo = memoryManager.loadPhoto(fileName: memory.photoFileName) {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(height: screenHeight * 0.23)
                            .mask(
                                Image("addPhotoFrame")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: screenHeight * 0.23)
                            )
                    }
                    
                    // Date section
                    VStack(spacing: screenHeight * 0.01) {
                        HStack {
                            Text("Date")
                                .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                                .foregroundColor(Color("text_2Color"))
                            Spacer()
                        }
                        .padding(.horizontal, screenWidth * 0.08)
                        
                        ZStack {
                            Image("dateFrame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.9)
                            HStack {
                                Text(dateFormatter.string(from: memory.date))
                                    .font(.custom("Poppins-Regular", size: screenHeight * 0.02))
                                    .foregroundColor(Color("text_2Color"))
                                Spacer()
                            }
                            .frame(width: screenWidth*0.8)
                        }
                    }
                    
                    // Weather Mood section
                    VStack(spacing: screenHeight * 0.01) {
                        HStack {
                            Text("Weather Mood")
                                .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                                .foregroundColor(Color("text_2Color"))
                            Spacer()
                        }
                        .padding(.horizontal, screenWidth * 0.08)
                        
                        ZStack(alignment: .leading) {
                            Image("dateFrame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.9)
                            
                            HStack(spacing: screenWidth * 0.03) {
                                // Emoji frame with emoji
                                ZStack {
                                    Image("emojiFrame")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screenWidth * 0.13)
                                    
                                    if let mood = weatherMoods.first(where: { $0.id == memory.weatherMoodId }) {
                                        Image(mood.emoji)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: screenWidth * 0.1)
                                    }
                                }
                                
                                // Weather text
                                if let mood = weatherMoods.first(where: { $0.id == memory.weatherMoodId }) {
                                    Text(mood.text)
                                        .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                        .foregroundColor(Color("text_2Color"))
                                        .lineLimit(2)
                                }
                                
//                                Spacer()
                            }
                            .padding(.leading, screenWidth * 0.03)
                        }
                    }
                    
                    // Notes section
                    VStack(spacing: screenHeight * 0.01) {
                        HStack {
                            Text("Notes")
                                .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                                .foregroundColor(Color("text_2Color"))
                            Spacer()
                        }
                        .padding(.horizontal, screenWidth * 0.08)
                        
                        ZStack {
                            Image("whatHappendFrame")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.9)
                            
                            Text(memory.whatHappened)
                                .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                .foregroundColor(Color("text_2Color"))
                                .frame(width: screenWidth * 0.75, alignment: .topLeading)
                                .padding(.top, screenHeight * 0.0)
                        }
                    }
                    
                    Spacer()
                        .frame(height: screenHeight * 0.05)
                }
            }
        }
    }
}

#Preview {
    PostDetailView(memory: MemoryRecord(
        photoFileName: nil,
        weatherMoodId: 1,
        whatHappened: "Test memory"
    ))
}

