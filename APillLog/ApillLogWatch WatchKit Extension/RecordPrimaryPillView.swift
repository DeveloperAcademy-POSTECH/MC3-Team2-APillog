//
//  RecordPrimaryPillView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct RecordPrimaryPillView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var pillList : [ShowPrimaryPill]
    @State var viewToggle: Bool = false
    
    var body: some View {
        ZStack{
            List {
                
                Section(header: Text("아침")) {
                    ForEach (pillList.indices, id: \.self) { idx  in
                        if pillList[idx].cycle & 1 != 0 {
                            PillButtonView(pill: $pillList[idx], viewToggle: $viewToggle)
                        }
                    }
                }
                
                Section(header: Text("점심")) {
                    ForEach (pillList.indices, id: \.self) { idx  in
                        if pillList[idx].cycle & 2 != 0 {
                            PillButtonView(pill: $pillList[idx], viewToggle: $viewToggle)
                            
                        }
                    }
                }
                
                Section(header: Text("저녁"), footer: Text("동기화가 되지 않은 경우, 아이폰의 앱을 재실행해주세요")) {
                    ForEach (pillList.indices, id: \.self) { idx  in
                        if pillList[idx].cycle & 4 != 0 {
                            PillButtonView(pill: $pillList[idx], viewToggle: $viewToggle)
                            
                        }
                    }
                }
            }
        }
        .opacity(viewToggle ? 1 : 1)
    }
}

struct PillButtonView: View {
    @Binding var pill : ShowPrimaryPill
    @Binding var viewToggle: Bool
    
    var body: some View {
        Button {
            pill.isTaking.toggle()    
            viewToggle.toggle()
            
            
        } label: {
            HStack{
                Text("\(pill.name ?? "") \(pill.dosage ?? "")")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .padding(.leading, 8)
                    .lineLimit(1)
                
                Spacer()
                
                Image(systemName: pill.isTaking ? "checkmark.square" : "square")
                    .padding(.trailing, 3)
                    .foregroundColor(pill.isTaking ? Color.accentColor : Color.white)
            }
        }
    }
}
