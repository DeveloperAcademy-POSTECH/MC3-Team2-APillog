//
//  RecordPrimaryPillView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct RecordPrimaryPillView: View {
    
    var coreDataManager = CoreDataManager()
    @State var morningPillList: [ShowPrimaryPill] = []
    @State var afternoonPillList: [ShowPrimaryPill] = []
    @State var eveningPillList: [ShowPrimaryPill] = []
    
    @State var drawViewToggle = false
    
    var body: some View {
        List {
            if morningPillList.count != 0 {
                Section(header: Text("아침")) {
                    ForEach(morningPillList.indices) { index in
                        Button {
                            if morningPillList[index].isTaking {
                                // 약을 이미 먹은 경우
                                morningPillList[index].isTaking.toggle()
                                drawViewToggle.toggle()
                                ConnectionModelWatch.shared.session.sendMessage(["message" : "UndoTakePill", "id": morningPillList[index].id?.uuidString ?? UUID().uuidString], replyHandler: nil)
                                
                            } else {
                                // 약을 아직 먹지 않은 경우
                                morningPillList[index].isTaking.toggle()
                                drawViewToggle.toggle()
                                ConnectionModelWatch.shared.session.sendMessage(["message" : "TakePill", "id": morningPillList[index].id?.uuidString ?? UUID().uuidString], replyHandler: nil)
                            }
                            
                        } label: {
                            HStack {
                                Text(morningPillList[index].name! + " " + morningPillList[index].dosage!)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                if morningPillList[index].isTaking {
                                    // 약을 이미 먹은 경우
                                    Text("✓")
                                        .frame(width: 40, height: 25, alignment: .center)
                                        .foregroundColor(Color(uiColor: UIColor.AColor.white))
                                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(uiColor: UIColor.AColor.gray)))
                                } else {
                                    // 약을 아직 먹지 않은 경우
                                    Text("복약")
                                        .frame(width: 40, height: 25, alignment: .center)
                                        .foregroundColor(Color(uiColor: UIColor.AColor.white))
                                        .background(RoundedRectangle(cornerRadius: 15).fill(Color(uiColor: UIColor.AColor.accent)))
                                }
                            }
                        }
                        .opacity(drawViewToggle ? 1 : 1)

                    }
                }
            }
            if afternoonPillList.count != 0 {
                Section(header: Text("점심")) {
                    ForEach(afternoonPillList, id: \.self) { pill in
                        Button {
                            if pill.isTaking {
                                // 약을 이미 먹은 경우
                                
                            } else {
                                // 약을 아직 먹지 않은 경우
                                
                            }
                        } label: {
                            HStack {
                                Text(pill.name! + " " + pill.dosage!)
                            }
                        }
                    }
                }
            }
            if eveningPillList.count != 0 {
                Section(header: Text("저"
                                    )) {
                    ForEach(eveningPillList, id: \.self) { pill in
                        Button {
                            if pill.isTaking {
                                // 약을 이미 먹은 경우
                                
                            } else {
                                // 약을 아직 먹지 않은 경우
                                
                            }
                        } label: {
                            HStack {
                                Text(pill.name! + " " + pill.dosage!)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // TestCode
//                        coreDataManager.addShowPrimaryPill(name: "콘서타", dosage: "18mg", cycle: 1, selectDate: "2022-07-28")
//                        coreDataManager.addShowPrimaryPill(name: "콘서타", dosage: "18mg", cycle: 2, selectDate: "2022-07-28")
//                        coreDataManager.addShowPrimaryPill(name: "메디키넷", dosage: "1정", cycle: 1, selectDate: "2022-07-28")
//                        coreDataManager.addShowPrimaryPill(name: "메디키넷", dosage: "1정", cycle: 4, selectDate: "2022-07-28")
//                        coreDataManager.addShowPrimaryPill(name: "아세트아미노펜", dosage: "1정", cycle: 1, selectDate: "2022-07-28")
            
            
            
            let showPrimaryPillList = coreDataManager.fetchShowPrimaryPill(selectedDate: Date())
            for pill in showPrimaryPillList {
                switch pill.cycle {
                case 1:
                    morningPillList.append(pill)
                case 2:
                    afternoonPillList.append(pill)
                case 4:
                    eveningPillList.append(pill)
                default:
                    print("부적절한 데이터")
                }
            }
        }
    }
}

struct RecordPrimaryPillView_Previews: PreviewProvider {
    static var previews: some View {
        RecordPrimaryPillView()
    }
}
