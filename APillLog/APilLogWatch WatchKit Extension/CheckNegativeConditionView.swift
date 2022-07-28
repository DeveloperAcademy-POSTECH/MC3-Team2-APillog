//
//  CheckNegativeConditionView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct CheckNegativeConditionView: View {
    @Environment(\.dismiss) var dismiss
    let data: [String] = ["A", "B", "C", "D", "E", "F"]
    
    var body: some View {
        List{
            ForEach(data, id:\.self) { item in
                ConditionCellView(textLabel: item)
            }
            
            Button {
                
                
                dismiss()
            } label: {
                Text("저장하기")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.headline)
            }
            .listRowPlatterColor(Color(uiColor: UIColor.AColor.accent))
        }
    }
}

struct CheckNegativeConditionView_Previews: PreviewProvider {
    static var previews: some View {
        CheckNegativeConditionView()
    }
}

struct ConditionCellView: View {
    let textLabel: String
    @State var isSelected: Bool = false
    
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
