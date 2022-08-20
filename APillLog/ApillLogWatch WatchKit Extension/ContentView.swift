//
//  ContentView.swift
//  ApillLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/30.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var connectionModelWatch: ConnectionModelWatch
    
    let dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy-mm-dd"
        return df
    }()
    
    let dateString: String = {
        let df = DateFormatter()
        df.dateFormat = "M/d"
        return df.string(from: Date())
    }()
    
    
    var body: some View {
        NavigationView {
            ZStack{
                List {
                    NavigationLink {
                        let pillList = CoreDataManager.shared.fetchShowPrimaryPill(selectedDate: Date())
                        RecordPrimaryPillView(connectionModelWatch: connectionModelWatch, pillList: pillList)
                            .navigationTitle("\(dateString) 복용 기록")
                    } label: {
                        HStack{
                            Label {
                                Text("약 복용 기록하기")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 8)
                                
                            } icon: {
                                Image(systemName: "pills")
                                    .foregroundColor(Color(uiColor: UIColor.AColor.accent))
                                    .font(.system(size: 18))
                            }
                        }
                        .frame(height: 65)
                        .padding(.leading, 8)
                    }
                    
                    NavigationLink {
                        CheckConditionView()
                            .navigationTitle("컨디션 기록하기")
                    } label: {
                        HStack {
                            Label {
                                Text("컨디션 기록하기")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 8)
                                
                            } icon: {
                                Image(systemName: "doc")
                                    .foregroundColor(Color(uiColor: UIColor.AColor.accent))
                                    .font(.system(size: 18))
                            }
                        }
                        .frame(height: 65)
                        .padding(.leading, 8)
                    }
                }
                
                if connectionModelWatch.sessionState != "idle" {
                    VStack(alignment: .center){
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("동기화를 위해 아이폰에서 데이터를 가져오는 중입니다")
                            .frame(alignment: .center)
                    }
                    .background(Color.black.opacity(0.3))
                }
            }
            .navigationTitle("Apillog")
        }
        .onAppear {
            checkBetweenDateAndData() 
        }
    }
    
    func checkBetweenDateAndData() {
        let date = UserDefaults.standard.string(forKey: "Date")
        
        if dateFormatter.string(from: Date()) != date {
            CoreDataManager.shared.resetShowPrimaryPillIsTaking_Watch()
            UserDefaults.standard.set(dateFormatter.string(from: Date()), forKey: "Date")
        }
    }
}
