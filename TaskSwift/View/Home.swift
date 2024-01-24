//
//  Home.swift
//  TaskSwift
//
//  Created by Phyo Thiengi  on 01/01/2024.
//

import SwiftUI

struct Home: View {
    ///Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlides: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @Namespace private var animation
    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
            
            ScrollView(.vertical) {
                VStack {
                    TasksView(currentDate: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(.darkBlue.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
            })
            .padding(15)
        })
        .onAppear(perform: {
            if weekSlides.isEmpty {
                let currentWeek = Date().fetchWeek()
                weekSlides.append(currentWeek)
                
                if let firstDate = currentWeek.first?.date {
                    weekSlides.append(firstDate.createPreviousWeek())
                }
                weekSlides.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlides.append(lastDate.createNextWeek())
                }
            }
        })
        .sheet(isPresented: $createNewTask, content: {
            NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.BG)
        })
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(.darkBlue)
                
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(.gray)
            }
            .font(.title.bold())
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
            
            ///Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlides.indices, id: \.self) { index in let week = weekSlides[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: {
            Button(action: {}, label: {
                Image(.pic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(.circle)
            })
        })
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in 
            if newValue == 0 || newValue == weekSlides.count - 1 {
                createWeek = true
            }
        }
    }
    ///Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) {day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.darkBlue)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            /// Indicator to Show, Which is Today:s Date
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    ///Updating current Date
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }

        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
                
            }
        }
    }
    
    func paginateWeek() {
        if weekSlides.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlides[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlides.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlides.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlides[currentWeekIndex].last?.date, currentWeekIndex == -1 {
                weekSlides.append(lastDate.createNextWeek())
                weekSlides.removeFirst()
                currentWeekIndex = weekSlides.count - 2
            }
        }
            print(weekSlides.count)
    }
}

#Preview {
    ContentView()
}
