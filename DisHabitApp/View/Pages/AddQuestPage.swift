//
//  AddQuestPage.swift
//  DisHabitApp
//
//  Created by nagamine kousuke on 2025/04/08.
//

import SwiftUI

struct AddQuestPage: View {
    @State var inputName = ""
    @Environment(\.dismiss) private var dismiss
    
    @State var currentReward: String = ""
    @State var WeekDayList: [String] = ["日", "月", "火", "水", "木", "金", "土"]

    let RewardPointList: Array<String> = ["1", "2", "3", "4", "5"]
    let days: Array<String> = ["日", "月", "火", "水", "木", "金", "土"]
    
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
                        TextField("楽しいこと", text: $inputName)
                            .font(.largeTitle)
                            .padding(.bottom, 10)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray)
                            }
                        VStack(alignment: .leading, spacing: 5){
                            Text("頻度：毎日")
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
                                ForEach(RewardPointList, id: \.self) { rewardPoint in
                                    Text(rewardPoint)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 60)
                                        .background(currentReward == rewardPoint ? Color.blue : Color.white, in: RoundedRectangle(cornerRadius: 20))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                        .onTapGesture {
                                            currentReward = rewardPoint
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
                        AddTaskButton()
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .background(.gray.gradient.opacity(0.2))
        }
    }
}

#Preview {
    AddQuestPage()
}
