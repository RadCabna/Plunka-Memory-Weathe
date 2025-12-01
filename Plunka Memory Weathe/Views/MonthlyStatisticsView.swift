//
//  MonthlyStatisticsView.swift
//  Plunka Memory Weathe
//
//  Created by Алкександр Степанов on 30.11.2025.
//

import SwiftUI

struct MonthlyStatisticsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var memoryManager = MemoryManager.shared
    
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
    
    private let monthNames = [
        "January", "February", "March", "April",
        "May", "June", "July", "August",
        "September", "October", "November", "December"
    ]
    
    var body: some View {
        ZStack {
            // Background
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: screenHeight * 0.02) {
                // Header
                HStack {
                    // Back button
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
                    
                    // Title
                    Text("Statistics all months")
                        .font(.custom("Poppins-SemiBold", size: screenHeight * 0.028))
                        .foregroundColor(Color("text_1Color"))
                }
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.top, screenHeight * 0.02)
                
                // Monthly statistics grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: screenWidth * 0.05),
                        GridItem(.flexible(), spacing: screenWidth * 0.05)
                    ], spacing: screenHeight * 0.02) {
                        ForEach(0..<12, id: \.self) { monthIndex in
                            MonthStatisticCard(
                                month: monthIndex + 1,
                                monthName: monthNames[monthIndex],
                                statistics: getStatisticsForMonth(monthIndex + 1),
                                colors: weatherColors
                            )
                        }
                    }
                    .padding(.horizontal, screenWidth * 0.05)
                    .padding(.bottom, screenHeight * 0.15)
                }
            }
        }
    }
    
    private func getStatisticsForMonth(_ month: Int) -> [Int: Int] {
        var stats: [Int: Int] = [:]
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        let memories = memoryManager.getMemoriesSortedByDate()
        
        for memory in memories {
            let memoryMonth = calendar.component(.month, from: memory.date)
            let memoryYear = calendar.component(.year, from: memory.date)
            
            if memoryMonth == month && memoryYear == currentYear {
                stats[memory.weatherMoodId, default: 0] += 1
            }
        }
        
        return stats
    }
}

// MARK: - Month Statistic Card
struct MonthStatisticCard: View {
    let month: Int
    let monthName: String
    let statistics: [Int: Int]
    let colors: [Int: Color]
    
    var body: some View {
        ZStack {
            Image("monthStatisticFrame")
                .resizable()
                .scaledToFit()
            
            VStack(spacing: screenHeight * 0.01) {
                Spacer()
                
                // Pie chart
                if statistics.isEmpty {
                    Circle()
                        .fill(Color(red: 255/255, green: 179/255, blue: 102/255))
                        .frame(width: screenWidth * 0.25, height: screenWidth * 0.25)
                } else {
                    PieChartView(statistics: statistics, colors: colors)
                        .frame(width: screenWidth * 0.25, height: screenWidth * 0.25)
                }
                
                Spacer()
                
                // Month name
                Text(monthName)
                    .font(.custom("Poppins-SemiBold", size: screenHeight * 0.016))
                    .foregroundColor(Color("text_2Color"))
                    .padding(.bottom, screenHeight * 0.015)
            }
        }
    }
}

#Preview {
    MonthlyStatisticsView()
}

