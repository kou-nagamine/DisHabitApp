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
//        print(dict.description)
        return dict
    }
    
    @State var selectedTasks: [SchemaV1.StandbyTask] = []
    
    @State var isSubmitPressed: Bool = false
    
    private func createQuest() {
        isSubmitPressed = true
        
        if !validateAll {
            print("validate fail")
        }
        
        print("validate pass")
        
        let newQuest = SchemaV1.Quest(activatedDayOfWeeks: self.weekDayDict, reward: SchemaV1.Reward(text: self.rewardName), tasks: self.selectedTasks)
        
        modelContext.insert(newQuest)
    }
    
    /// validator: true == success; false == error
    
    /// rule: Name should not be empty.
    var validateName: Bool {
        return rewardName != ""
    }
    
    /// rule: Quest should occur at least once per week.
    var validateOccurence: Bool {
        return weekDayDict.occasionCount() > 0
    }
    
    /// rule: At least one task should be selected.
    var validateSelectedTasks: Bool {
        return selectedTasks.count > 0
    }
    
    var validateAll: Bool {
        return validateName && validateOccurence && validateSelectedTasks
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
                    VStack (spacing: 0){
                        VStack(alignment: .leading) {
                            TextField("楽しいこと", text: $rewardName)
                                .font(.largeTitle)
                                .padding(.bottom, 10)
                                .overlay(alignment: .bottom) {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray)
                                }
                            if isSubmitPressed && !validateName {
                                Text("*楽しいことを入力してください")
                                    .font(.callout).foregroundColor(.red)
                                    .frame(height:22, alignment: .leading)
                            } else {
                                Spacer().frame(height:30)
                            }
                        }

                        
                        VStack(alignment: .leading, spacing: 5){
                            HStack {
                                Text("頻度: \(weekDayDict.weeklyOccasionDescription())")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                if isSubmitPressed && !validateOccurence {
                                    Text("*週1回以上を選択してください")
                                        .font(.callout).foregroundColor(.red)
                                }
                            }


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
                HStack(alignment: .bottom) {
                    Text("やることリスト")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        .padding(.bottom, 15)
                    
                    if isSubmitPressed && !validateSelectedTasks {
                        Text("*追加してください")
                            .font(.callout).foregroundColor(.red)
                            .padding(.bottom, 20)
                    }
                }

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
                       Text("作成")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(validateAll ? Color.blue : Color.gray)
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
