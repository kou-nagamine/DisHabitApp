//
//  AddQuestPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/08.
//

import SwiftUI

struct AddQuestPage: View {
    @State var rewardName = ""
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var modelContext
    
    @State var rewardScore: Int = -1
    @State var WeekDayList: [String] = ["日", "月", "火", "水", "木", "金", "土"]

    let RewardScoreList: Array<Int> = [1,2,3,4,5]
    let days: Array<String> = ["日", "月", "火", "水", "木", "金", "土"]
    
    var weekDayDict: [Int:Bool] {
        var dict:[Int:Bool] = [:]
        for (index, value) in self.days.enumerated() {
            dict[index+1] = WeekDayList.contains(value)
        }
        print(dict.description)
        return dict
    }
    
    @State var selectedTasks: [SchemaV1.StandbyTask] = []
    
    private func createQuest() {
        let newQuest = SchemaV1.Quest(activatedDayOfWeeks: self.weekDayDict, reward: SchemaV1.Reward(text: self.rewardName), tasks: self.selectedTasks)
        
        modelContext.insert(newQuest)
    }
    
    // validatorをcomputed propertyにする
    
    // []=pass, error=some string
    private func validate() -> [String] {
        // name is empty
        // occasion is 0
        // no tasks
        
        // rewardpoint can be nil??
        return []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Image(systemName: "xmark")
                            .font(.title)
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    .padding(.top, 30)
                    Spacer()
                    VStack (spacing: 30){
                        TextField("楽しいこと", text: $rewardName)
                            .font(.largeTitle)
                            .padding(.bottom, 10)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray)
                            }
                        VStack(alignment: .leading, spacing: 5){
                            Text("頻度: \(weekDayDict.weeklyOccasionDescription())")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)

                            HStack(spacing: 7) {
                                ForEach(days, id: \.self) { day in
                                    Text(day)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60)
                                        .background(
                                            WeekDayList.contains(day) ? Color.blue : Color.white,
                                            in: RoundedRectangle(cornerRadius: 10)
                                        )
                                        .foregroundColor(WeekDayList.contains(day) ? .white : .black) // 色も変えるとわかりやすい
                                        .onTapGesture {
                                            if WeekDayList.contains(day) {
                                                WeekDayList.removeAll { $0 == day }
                                            } else {
                                                WeekDayList.append(day)
                                            }
                                        }
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                }
                            }
                            Text("ご褒美度")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                            HStack(spacing: 10) {
                                ForEach(RewardScoreList, id: \.self) { score in
                                    Text(score.description)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60)
                                        .background(score == self.rewardScore ? Color.blue : Color.white, in: RoundedRectangle(cornerRadius: 20))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            if self.rewardScore == score {
                                                self.rewardScore = -1 // deselect
                                            } else {
                                                self.rewardScore = score
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
            .frame(height: 400)
            VStack(alignment: .leading, spacing: 0){
                Text("やることリスト")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.top, 30)
                    .padding(.bottom, 15)
                ScrollView {
                    VStack (spacing: 20){
                        ForEach (selectedTasks) { task in
                            Text(task.text)
                        }
                        AddTaskButton(selectedTasks: $selectedTasks)
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .background(.gray.gradient.opacity(0.2))
            VStack() {
                Button(
                    action: {
                        createQuest()
                    }
                   ,label:{
                    Text("登録")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }
            .frame(maxHeight: 80, alignment: .bottom)
        }
    }
}

#Preview {
    AddQuestPage()
}
