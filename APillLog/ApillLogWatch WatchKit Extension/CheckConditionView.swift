//
//  CheckNegativeConditionView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct CheckConditionView: View {
    @Environment(\.dismiss) var dismiss

    let negativeConditionData: [String] = ["불면", "불안", "두통", "두근거림", "어지러움", "식욕 감소", "입안 건조", "구역", "땀 과다증", "과민성"]
    @State var selectedNegativeConditionData: [Bool] = []
    
    var body: some View {
        List{
            ForEach(negativeConditionData.indices, id:\.self) { idx in
                ConditionCellView(textLabel: negativeConditionData[idx], isSelected: $selectedNegativeConditionData[idx])
            }
            
            Button {
                var selectedCondition: [String] = []
                
                for index in 0..<selectedNegativeConditionData.count {
                    if selectedNegativeConditionData[index] {
                        selectedCondition.append(negativeConditionData[index])
                    }
                }
                
                ConnectionModelWatch.shared.session.sendMessage(["message" : "Condition", "sideEffect": selectedCondition], replyHandler: nil)
                
                dismiss()
            } label: {
                Text("저장하기")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.headline)
            }
            .listRowPlatterColor(Color(uiColor: UIColor.AColor.accent))
        }
        .onAppear {
            self.selectedNegativeConditionData = Array(repeating: false, count: negativeConditionData.count)
        }
    }
}

struct ConditionCellView: View {
    let textLabel: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            self.isSelected.toggle()
        } label: {
            HStack {
                Text(textLabel)
                Spacer()
                Image(systemName: isSelected ? "checkmark.square" : "square")
                    .foregroundColor(isSelected ? Color.accentColor : Color.white)
            }
            .padding(.horizontal, 10)
        }
    }
}
