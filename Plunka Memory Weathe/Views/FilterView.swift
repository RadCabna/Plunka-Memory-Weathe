//
//  FilterView.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 30.11.2025.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject private var memoryManager = MemoryManager.shared
    
    @State private var selectedWeatherFilter: Int = 1 // 1-10 = specific weather (starts at 1)
    @State private var selectedMemory: MemoryRecord?
    
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
    
    var filteredMemories: [MemoryRecord] {
        let allMemories = memoryManager.getMemoriesSortedByDate()
        let filtered = allMemories.filter { $0.weatherMoodId == selectedWeatherFilter }
        let others = allMemories.filter { $0.weatherMoodId != selectedWeatherFilter }
        return filtered + others
    }
    
    var body: some View {
        ZStack {
            // Background
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: screenHeight * 0.02) {
                // Filter title
                HStack {
                    Text("Filter")
                        .font(.custom("Poppins-SemiBold", size: screenHeight * 0.028))
                        .foregroundColor(Color("text_2Color"))
                    Spacer()
                }
                .padding(.horizontal, screenWidth * 0.08)
                
                // Slider
                VStack(spacing: screenHeight * 0.01) {
                    // Slider track and thumb
                    ZStack(alignment: .leading) {
                        // Track background
                        Image("sliderBack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.84)
                        
                        // Thumb
                        Image("slider")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.02)
                            .offset(x: sliderPosition)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        updateSliderPosition(value.location.x)
                                    }
                            )
                    }
                    .frame(width: screenWidth * 0.84)
                    .padding(.horizontal, screenWidth * 0.08)
                    
                    // Emoji indicators
                    HStack(spacing: screenWidth * 0.025) {
                        ForEach(weatherMoods, id: \.id) { mood in
                            Image(mood.emoji)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.06)
                                .opacity(selectedWeatherFilter == mood.id ? 1.0 : 0.4)
                        }
                    }
                    .padding(.horizontal, screenWidth * 0.08)
                }
                
                // Posts grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: screenWidth * 0.03),
                        GridItem(.flexible(), spacing: screenWidth * 0.03)
                    ], spacing: screenHeight * 0.02) {
                        ForEach(filteredMemories) { memory in
                            FilterPostItem(memory: memory, weatherMoods: weatherMoods)
                                .onTapGesture {
                                    selectedMemory = memory
                                }
                        }
                    }
                    .padding(.horizontal, screenWidth * 0.08)
                    .padding(.bottom, screenHeight * 0.02)
                }
            }
        }
        .fullScreenCover(item: $selectedMemory) { memory in
            PostDetailView(memory: memory)
        }
    }
    
    private var sliderPosition: CGFloat {
        let trackWidth = screenWidth * 0.84
        let step = trackWidth / 9 // 9 steps for 10 positions (0-9 indices)
        return CGFloat(selectedWeatherFilter - 1) * step
    }
    
    private func updateSliderPosition(_ x: CGFloat) {
        let trackWidth = screenWidth * 0.84
        let position = max(0, min(x, trackWidth))
        let step = trackWidth / 9
        selectedWeatherFilter = Int(round(position / step)) + 1 // 1-10 range
    }
}

// MARK: - Filter Post Item
struct FilterPostItem: View {
    let memory: MemoryRecord
    let weatherMoods: [(id: Int, emoji: String, text: String)]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, d"
        return formatter
    }
    
    var body: some View {
        ZStack {
            Image("filterFrame")
                .resizable()
                .scaledToFit()
            
            VStack(spacing: screenHeight * 0.01) {
                Spacer()
                
                // Emoji
                if let mood = weatherMoods.first(where: { $0.id == memory.weatherMoodId }) {
                    Image(mood.emoji)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.2)
                }
                
                Spacer()
                
                // Date and weather text
                VStack(spacing: screenHeight * 0.001) {
                    Text(dateFormatter.string(from: memory.date))
                        .font(.custom("Poppins-SemiBold", size: screenHeight * 0.013))
                        .foregroundColor(Color("text_2Color"))
                    
                    if let mood = weatherMoods.first(where: { $0.id == memory.weatherMoodId }) {
                        Text(mood.text)
                            .font(.custom("Poppins-Medium", size: screenHeight * 0.011))
                            .foregroundColor(Color("text_2Color"))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(width: screenWidth * 0.32)
                .padding(.bottom, screenHeight * 0.003)
            }
        }
        .frame(width: screenWidth * 0.4)
    }
}

#Preview {
    FilterView()
}

