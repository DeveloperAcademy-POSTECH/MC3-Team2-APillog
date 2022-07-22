//
//  PillDummyData.swift
//  APillLog
//
//  Created by 이영준 on 2022/07/20.
//

import Foundation

struct PillData {
    var pillName: String
    var pillDosage: String
    var pillAdvantage: [String : Bool]
    var pillDisadvantage: [String : Bool]
    
    static var pillData: [PillData] = [
        PillData(pillName: "콘서타", pillDosage: "18mg", pillAdvantage: [ "주의력 향상" : false, "과잉 행동 절제" : false, "충동성 감소" : false, "기억력 향상" : false, "우울감 감소" : false, "두근거림 감소" : false], pillDisadvantage: ["불면" : false, "불안" : false, "두통" : false, "빈맥" : false, "어지러움" : false, "식욕 감소" : false, "입안 건조" : false, "구역" : false, "땀 과다증" : false, "과민성" : false])
    ]
}
