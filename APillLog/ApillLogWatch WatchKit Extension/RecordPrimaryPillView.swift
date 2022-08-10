//
//  RecordPrimaryPillView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct RecordPrimaryPillView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var connectionModelWatch: ConnectionModelWatch
    
    @State var pillList : [ShowPrimaryPill]
    @State var viewToggle: Bool = false
    
    @State var countPills = [0, 0, 0]
    
    var body: some View {
        ZStack{
            if connectionModelWatch.sessionState == "reset" {
                ProgressView()
                    .progressViewStyle(.circular)
                    .background(Color.black)
                    .onAppear {
                        dismiss()
                    }
            }
            
            List {
                if(countPills[0] != 0){
                    Section(header: Text("아침")) {
                        ForEach (pillList.indices, id: \.self) { idx  in
                            if pillList[idx].cycle & 1 != 0 {
                                PillButtonView(pill: $pillList[idx], viewToggle: $viewToggle)
                            }
                        }
                    }
                }
                
                if (countPills[1] != 0) {
                    Section(header: Text("점심")) {
                        ForEach (pillList.indices, id: \.self) { idx  in
                            if pillList[idx].cycle & 2 != 0 {
                                PillButtonView(pill: $pillList[idx], viewToggle: $viewToggle)
                            }
                        }
                    }
                }
                if (countPills[2] != 0) {
                    Section(header: Text("저녁")) {
                        ForEach (pillList.indices, id: \.self) { idx  in
                            if pillList[idx].cycle & 4 != 0 {
                                PillButtonView(pill: $pillList[idx], viewToggle: $viewToggle)
                                
                            }
                        }
                    }
                }
                Section(header: Text("동기화가 되지 않은 경우, 아이폰의 앱을 재실행해주세요")) {}
            }
        }
        .opacity(viewToggle ? 1 : 1)
        .onAppear {
            for pill in pillList {
                switch pill.cycle {
                case 1:
                    countPills[0] += 1
                case 2:
                    countPills[1] += 1
                case 4:
                    countPills[2] += 1
                default:
                    print("invalid cycle")
                }
            }
        }
    }
}

struct PillButtonView: View {
    @Binding var pill : ShowPrimaryPill
    @Binding var viewToggle: Bool
    
    var body: some View {
        Button {
            if pill.isTaking {
                // 방금 복용을 취소한 경우
                CoreDataManager.shared.changeShowPrimaryPillIsNotTaking(showPrimaryPill: pill)
                ConnectionModelWatch.shared.session.sendMessage(["message" : "cancelTake",
                                                                 "id" : pill.id!.uuidString ], replyHandler: nil)
            } else {
                // 방금 복용한 경우
                CoreDataManager.shared.changeShowPrimaryPillIsTaking(showPrimaryPill: pill)
                ConnectionModelWatch.shared.session.sendMessage(["message" : "take",
                                                                 "id" : pill.id!.uuidString,
                                                                 "time" : Date() ], replyHandler: nil)
            }
            
            //            pill.isTaking.toggle()
            viewToggle.toggle()
            
            
        } label: {
            HStack(alignment: .center) {
                Text("\(pill.name ?? "") \(pill.dosage ?? "")")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .padding(.leading, 8)
                    .lineLimit(1)
                
                Spacer()
                
                Label{} icon: {
                    Image(systemName: pill.isTaking ? "checkmark.square" : "square")
                        .font(.system(size: 18))
                        .foregroundColor(pill.isTaking ? Color.accentColor : Color.white)
                }
                .padding(.trailing, 10)
            }
        }
    }
}
