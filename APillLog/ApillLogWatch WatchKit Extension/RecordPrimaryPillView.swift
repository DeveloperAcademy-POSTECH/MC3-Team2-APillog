//
//  RecordPrimaryPillView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct RecordPrimaryPillView: View {
    
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
                    ForEach(afternoonPillList.indices) { index in
                        Button {
                            if afternoonPillList[index].isTaking {
                                // 약을 이미 먹은 경우
                                afternoonPillList[index].isTaking.toggle()
                                drawViewToggle.toggle()
                                ConnectionModelWatch.shared.session.sendMessage(["message" : "UndoTakePill", "id": afternoonPillList[index].id?.uuidString ?? UUID().uuidString], replyHandler: nil)
                                
                            } else {
                                // 약을 아직 먹지 않은 경우
                                afternoonPillList[index].isTaking.toggle()
                                drawViewToggle.toggle()
                                ConnectionModelWatch.shared.session.sendMessage(["message" : "TakePill", "id": afternoonPillList[index].id?.uuidString ?? UUID().uuidString], replyHandler: nil)
                            }
                            
                        } label: {
                            HStack {
                                Text(afternoonPillList[index].name! + " " + afternoonPillList[index].dosage!)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                if afternoonPillList[index].isTaking {
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
            if eveningPillList.count != 0 {
                Section(header: Text("저녁")) {
                    ForEach(eveningPillList.indices) { index in
                        Button {
                            if eveningPillList[index].isTaking {
                                // 약을 이미 먹은 경우
                                
                                eveningPillList[index].isTaking.toggle()
                                drawViewToggle.toggle()
                                ConnectionModelWatch.shared.session.sendMessage(["message" : "UndoTakePill", "id": eveningPillList[index].id?.uuidString ?? UUID().uuidString], replyHandler: nil)
                                
                            } else {
                                // 약을 아직 먹지 않은 경우
                                eveningPillList[index].isTaking.toggle()
                                drawViewToggle.toggle()
                                ConnectionModelWatch.shared.session.sendMessage(["message" : "TakePill", "id": eveningPillList[index].id?.uuidString ?? UUID().uuidString], replyHandler: nil)
                            }
                            
                        } label: {
                            HStack {
                                Text(eveningPillList[index].name! + " " + eveningPillList[index].dosage!)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                if eveningPillList[index].isTaking {
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
        }
        .onAppear {
            let showPrimaryPillList = CoreDataManager.shared.fetchShowPrimaryPill(selectedDate: Date())
            for pill in showPrimaryPillList {
                print(pill.name ?? "없음")
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
