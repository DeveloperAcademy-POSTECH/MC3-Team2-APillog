//
//  RecordPrimaryPillView.swift
//  APilLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/28.
//

import SwiftUI

struct RecordPrimaryPillView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            List {
                Section(footer: Text("동기화가 되지 않은 경우, 아이폰의 앱을 재실행해주세요")) {
                    // 아침 버튼
                    Button {
                        ConnectionModelWatch.shared.session.sendMessage(["message": "TakePill", "time": "morning"], replyHandler: nil)
                        dismiss()
                    } label: {
                        HStack {
                            Label {
                                Text("아침약 전체 복용")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 8)
                                
                            } icon: {
                                Image(systemName: "sun.and.horizon")
                                    .foregroundColor(Color(uiColor: UIColor.AColor.accent))
                                    .font(.system(size: 20))
                            }
                        }
                        .frame(height: 65)
                        .padding(.leading, 8)
                    }
                    .frame(height: 65)
                    
                    // 점심 버튼
                    Button {
                        ConnectionModelWatch.shared.session.sendMessage(["message": "TakePill", "time": "afternoon"], replyHandler: nil)
                        dismiss()
                    } label: {
                        HStack {
                            Label {
                                Text("점심약 전체 복용")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 8)
                                
                            } icon: {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(Color(uiColor: UIColor.AColor.accent))
                                    .font(.system(size: 20))
                            }
                        }
                        .frame(height: 65)
                        .padding(.leading, 8)

                    }
                    
                    // 저녁 버튼
                    Button {
                        ConnectionModelWatch.shared.session.sendMessage(["message": "TakePill", "time": "evening"], replyHandler: nil)
                        dismiss()
                    } label: {
                        HStack {
                            Label {
                                Text("저녁약 전체 복용")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 8)
                                
                            } icon: {
                                Image(systemName: "moon.fill")
                                    .foregroundColor(Color(uiColor: UIColor.AColor.accent))
                                    .font(.system(size: 20))
                            }
                        }
                        .frame(height: 65)
                        .padding(.leading, 8)                    }
                }
            }
        }
    }
}

