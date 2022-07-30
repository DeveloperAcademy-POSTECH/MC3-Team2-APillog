//
//  ContentView.swift
//  ApillLogWatch WatchKit Extension
//
//  Created by Park Sungmin on 2022/07/30.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    RecordPrimaryPillView()
                        .navigationTitle("약 복용 기록하기")
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
            .navigationTitle("Apillog")
        }
    }
}
