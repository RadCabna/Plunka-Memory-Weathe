//
//  MainMenu.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 27.11.2025.
//

import SwiftUI

enum MainMenuTab {
    case today
    case album
    case statistic
}

struct MainMenu: View {
    @State private var selectedTab: MainMenuTab = .today
    
    var body: some View {
        ZStack {
            // Main content based on selected tab
            switch selectedTab {
            case .today:
                TodayView(selectedTab: $selectedTab)
            case .album:
                AlbumView()
            case .statistic:
                StatisticView()
            }
            
            // Bottom Bar
            VStack {
                Spacer()
                BottomBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Today View
struct TodayView: View {
    @State private var showAddMemory = false
    @State private var selectedMemory: MemoryRecord?
    @ObservedObject private var memoryManager = MemoryManager.shared
    @Binding var selectedTab: MainMenuTab
    
    private let weatherMoods: [Int: (emoji: String, text: String)] = [
        1: ("emoji_1", "Clear — joy, clarity"),
        2: ("emoji_2", "Rain — sadness, reflection"),
        3: ("emoji_3", "Rainbow — miracle, inspiration"),
        4: ("emoji_4", "Storm — chaos, stress"),
        5: ("emoji_5", "Fog — confusion, uncertainty"),
        6: ("emoji_6", "Thunderstorm — anger, tension"),
        7: ("emoji_7", "Light wind — calm, ease"),
        8: ("emoji_8", "Snowstorm — isolation, inner cold"),
        9: ("emoji_9", "Through the clouds — hope"),
        10: ("emoji_10", "Moonlit night — dreaminess, intuition")
    ]
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top image
                Image("topImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
            
            // Content
            VStack(spacing: screenHeight * 0.02) {
                Spacer()
                    .frame(height: screenHeight * 0.0)
                
                // Title
                HStack {
                    Text("What's the weather like in you today?")
                        .font(.custom("Poppins-SemiBold", size: screenHeight * 0.024))
                        .foregroundColor(Color("text_1Color"))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, screenWidth * 0.08)
                    Spacer()
                }
                // Add Memory Frame
                ZStack {
                    Image("addMemoryFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.9)
                    
                    HStack(spacing: screenWidth * 0.04) {
                        // Quote section
                        VStack(alignment: .leading, spacing: screenHeight * 0.008) {
                            Text("quote of the day")
                                .font(.custom("Poppins-SemiBold", size: screenHeight * 0.02))
                                .foregroundColor(Color("text_1Color"))
                                .textCase(.uppercase)
                            
                            Text("Every feeling is a clue about what is important to you.")
                                .font(.custom("Poppins-SemiBold", size: screenHeight * 0.02))
                                .foregroundColor(Color("text_2Color"))
                                .lineLimit(3)
                        }
                        .frame(maxWidth: screenWidth * 0.45)
                        
                        Spacer()
                        
                        // Add Memory button
                        Button(action: {
                            showAddMemory = true
                        }) {
                            Image("addMemory")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.3)
                        }
                    }
                    .padding(.horizontal, screenWidth * 0.04)
                }
                .padding(.horizontal, screenWidth * 0.05)
                
                // Latest posts header
                HStack {
                    Text("Latest posts")
                        .font(.custom("Poppins-SemiBold", size: screenHeight * 0.025))
                        .foregroundColor(Color("text_2Color"))
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = .album
                    }) {
                        Text("See All")
                            .font(.custom("Poppins-Regular", size: screenHeight * 0.016))
                            .foregroundColor(Color("text_1Color"))
                            .underline()
                    }
                }
                .padding(.horizontal, screenWidth * 0.08)
                
                // Latest posts list
                VStack(spacing: screenHeight * 0.015) {
                    ForEach(memoryManager.getMemoriesSortedByDate().prefix(3)) { memory in
                        MemoryPostItem(memory: memory, weatherMoods: weatherMoods)
                            .onTapGesture {
                                selectedMemory = memory
                            }
                    }
                }
                .padding(.horizontal, screenWidth * 0.05)
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showAddMemory) {
            AddMemoryView()
        }
        .fullScreenCover(item: $selectedMemory) { memory in
            PostDetailView(memory: memory)
        }
    }
}

// MARK: - Album View
struct AlbumView: View {
    var body: some View {
        FilterView()
    }
}

// MARK: - Statistic View
struct StatisticView: View {
    @ObservedObject private var memoryManager = MemoryManager.shared
    @State private var showMonthlyStatistics = false
    
    private let weatherQuotes: [Int: String] = [
        1: "Your inner sunshine is lighting up your path. Keep shining bright!",
        2: "Even storms pass, leaving room for growth. This too shall change.",
        3: "Magic happens when you embrace all your colors. You're extraordinary!",
        4: "In chaos, you discover your strength. You're weathering this beautifully.",
        5: "Clarity comes with patience. Trust yourself through uncertainty.",
        6: "Your feelings are valid. Channel this energy into positive change.",
        7: "You're flowing with grace and ease. This is your natural state.",
        8: "Warmth begins within. Be gentle with yourself during this time.",
        9: "Your hope is a powerful force. Brighter days are ahead.",
        10: "Your intuition is your guide. Trust the whispers of your soul."
    ]
    
    private let weatherColors: [Int: Color] = [
        1: Color("weatherColor_1"),
        2: Color("weatherColor_2"),
        3: Color("weatherColor_3"),
        4: Color("weatherColor_4"),
        5: Color("weatherColor_5"),
        6: Color("weatherColor_6"),
        7: Color("weatherColor_7"),
        8: Color("weatherColor_8"),
        9: Color("weatherColor_9"),
        10: Color("weatherColor_10")
    ]
    
    var weatherStatistics: [Int: Int] {
        var stats: [Int: Int] = [:]
        let memories = memoryManager.getMemoriesSortedByDate()
        
        for memory in memories {
            stats[memory.weatherMoodId, default: 0] += 1
        }
        
        return stats
    }
    
    var dominantWeather: Int {
        weatherStatistics.max(by: { $0.value < $1.value })?.key ?? 1
    }
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top image
                Image("topImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
            
            VStack(spacing: screenHeight * 0.02) {
                    Spacer()
                        .frame(height: screenHeight * 0.005)
                    
                    // Statistics title
                    HStack {
                        Text("Statistics")
                            .font(.custom("Poppins-SemiBold", size: screenHeight * 0.028))
                            .foregroundColor(Color("text_1Color"))
                        Spacer()
                    }
                    .padding(.horizontal, screenWidth * 0.08)
                    
                    // Statistic Frame
                    ZStack {
                        Image("statisticFrame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.9)
                        
                        HStack(spacing: screenWidth * 0.04) {
                            // Left side - text and weather icons
                            VStack(alignment: .leading, spacing: screenHeight * 0.0) {
                                // Text
                                HStack(spacing: 0) {
                                    Text("Distribution of ")
                                        .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                        .foregroundColor(Color("text_2Color"))
                                }
                                HStack {
                                    Text("\"weather\"")
                                        .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                        .foregroundColor(Color("text_1Color"))
                                    Text(" for the")
                                        .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                        .foregroundColor(Color("text_2Color"))
                                }
                                Text("month")
                                    .font(.custom("Poppins-Regular", size: screenHeight * 0.018))
                                    .foregroundColor(Color("text_2Color"))
                                    .padding(.bottom)
                                // Weather icons grid
                                VStack(spacing: screenHeight * 0.01) {
                                    // Row 1
                                    HStack(spacing: screenWidth * 0.02) {
                                        ForEach(1...3, id: \.self) { index in
                                            Image("weatherStatistic_\(index)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: screenWidth * 0.14)
                                        }
                                    }
                                    // Row 2
                                    HStack(spacing: screenWidth * 0.02) {
                                        ForEach(4...6, id: \.self) { index in
                                            Image("weatherStatistic_\(index)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: screenWidth * 0.14)
                                        }
                                    }
                                    // Row 3
                                    HStack(spacing: screenWidth * 0.02) {
                                        ForEach(7...9, id: \.self) { index in
                                            Image("weatherStatistic_\(index)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: screenWidth * 0.14)
                                        }
                                    }
                                    // Row 4
                                    HStack(spacing: screenWidth * 0.02) {
                                        Image("weatherStatistic_10")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: screenWidth * 0.14)
                                        Spacer()
                                            .frame(width: screenWidth * 0.14)
                                        Spacer()
                                            .frame(width: screenWidth * 0.14)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            // Right side - pie chart
                            PieChartView(statistics: weatherStatistics, colors: weatherColors)
                                .frame(width: screenWidth * 0.28, height: screenWidth * 0.28)
                        }
                        .padding(.horizontal, screenWidth * 0.08)
                    }
                    
                    // Quote Frame
                    ZStack {
                        Image("quoteFrame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.9)
                        
                        HStack(spacing: screenWidth * 0.03) {
                            // Quote image
                            Image("quoteImage")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 0.15)
                            
                            // Quote text
                            VStack(alignment: .leading, spacing: screenHeight * 0.008) {
                                Text("Weather-matched quote")
                                    .font(.custom("Poppins-SemiBold", size: screenHeight * 0.014))
                                    .foregroundColor(Color("text_1Color"))
                                    .textCase(.uppercase)
                                
                                Text(weatherQuotes[dominantWeather] ?? "")
                                    .font(.custom("Poppins-Regular", size: screenHeight * 0.013))
                                    .foregroundColor(Color("text_2Color"))
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, screenWidth * 0.08)
                    }
                    
                    // Show All Months button
                    Button(action: {
                        showMonthlyStatistics = true
                    }) {
                        Image("showAllMonths")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.9)
                    }
                    
                    Spacer()
            }
        }
        .fullScreenCover(isPresented: $showMonthlyStatistics) {
            MonthlyStatisticsView()
        }
    }
}

// MARK: - Pie Chart View
struct PieChartView: View {
    let statistics: [Int: Int]
    let colors: [Int: Color]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if statistics.isEmpty {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                } else {
                    ForEach(Array(pieSlices.enumerated()), id: \.offset) { index, slice in
                        PieSlice(startAngle: slice.startAngle, endAngle: slice.endAngle)
                            .fill(colors[slice.weatherId] ?? .gray)
                    }
                }
            }
        }
    }
    
    var pieSlices: [(weatherId: Int, startAngle: Angle, endAngle: Angle)] {
        let total = statistics.values.reduce(0, +)
        guard total > 0 else { return [] }
        
        var slices: [(Int, Angle, Angle)] = []
        var currentAngle: Double = -90
        
        for weatherId in 1...10 {
            let count = statistics[weatherId] ?? 0
            let percentage = Double(count) / Double(total)
            let angle = percentage * 360
            
            if count > 0 {
                let startAngle = Angle(degrees: currentAngle)
                let endAngle = Angle(degrees: currentAngle + angle)
                slices.append((weatherId, startAngle, endAngle))
                currentAngle += angle
            }
        }
        
        return slices
    }
}

// MARK: - Pie Slice Shape
struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Bottom Bar
struct BottomBar: View {
    @Binding var selectedTab: MainMenuTab
    
    var body: some View {
        ZStack {
            // Bottom bar background
            Rectangle()
                .fill(Color.black)
                .frame(width: screenWidth, height: screenHeight * 0.12)
            
            // Bottom bar items
            HStack(spacing: 0) {
                // Today button
                BottomBarItem(
                    icon: selectedTab == .today ? "tadayOn" : "todayOff",
                    title: "Today",
                    isSelected: selectedTab == .today
                )
                .onTapGesture {
                    selectedTab = .today
                }
                
                Spacer()
                
                // Album button
                BottomBarItem(
                    icon: selectedTab == .album ? "albumOn" : "albumOff",
                    title: "Album",
                    isSelected: selectedTab == .album
                )
                .onTapGesture {
                    selectedTab = .album
                }
                
                Spacer()
                
                // Statistic button
                BottomBarItem(
                    icon: selectedTab == .statistic ? "statisticOn" : "statisticOff",
                    title: "Statistic",
                    isSelected: selectedTab == .statistic
                )
                .onTapGesture {
                    selectedTab = .statistic
                }
            }
            .padding(.horizontal, screenWidth * 0.1)
            .padding(.bottom, screenHeight * 0.024)
        }
    }
}

// MARK: - Memory Post Item
struct MemoryPostItem: View {
    let memory: MemoryRecord
    let weatherMoods: [Int: (emoji: String, text: String)]
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image("postFrame")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.9)
            
            HStack(spacing: screenWidth * 0.03) {
                // Emoji frame with emoji
                ZStack {
                    Image("emojiFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.15)
                    
                    if let mood = weatherMoods[memory.weatherMoodId] {
                        Image(mood.emoji)
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.1)
                    }
                }
                
                // Weather info
                VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                    Text("Weather of the day")
                        .font(.custom("Poppins-SemiBold", size: screenHeight * 0.014))
                        .foregroundColor(Color("text_1Color"))
                        .textCase(.uppercase)
                    
                    if let mood = weatherMoods[memory.weatherMoodId] {
                        Text(mood.text)
                            .font(.custom("Poppins-Regular", size: screenHeight * 0.013))
                            .foregroundColor(Color("text_2Color"))
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                // Arrow
                Image("arrowRight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.06)
                    .padding(.trailing, screenWidth * 0.04)
            }
            .padding(.leading, screenWidth * 0.04)
        }
    }
}

// MARK: - Bottom Bar Item
struct BottomBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: screenHeight * 0.005) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(height: screenHeight * 0.023)
            
            Text(title)
                .font(.custom("Poppins-Regular", size: screenHeight * 0.013))
                .foregroundColor(Color(isSelected ? "text_3Color" : "text_2Color"))
        }
    }
}

#Preview {
    MainMenu()
}
