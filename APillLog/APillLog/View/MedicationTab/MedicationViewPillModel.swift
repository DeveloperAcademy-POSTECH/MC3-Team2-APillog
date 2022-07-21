//
//  MedicationViewPillModel.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/21.
//

import Foundation

// MARK: - Pill Model
struct PrimaryPillModel {
    var name: String
    var dosage: String
    var cycle: Int16
    var isTaking: Bool
    var takeTime: String
    var selectDate: String
    var id: UUID
    
    init (
        name: String,
        dosage: String,
        cycle: Int16,
        isTaking: Bool,
        takeTime: String,
        selectDate: String,
        id: UUID
    ) {
        self.name = name
        self.dosage = dosage
        self.cycle = cycle
        self.isTaking = isTaking
        self.takeTime = takeTime
        self.selectDate = selectDate
        self.id = id
    }
}

struct SecondaryPillModel {
    var name: String
    var dosage: String
    var isTaking: Bool
    var takeTime: String
    var selectDate: String
    var id: UUID
    
    init (
        name: String,
        dosage: String,
        isTaking: Bool,
        takeTime: String,
        selectDate: String,
        id: UUID
    ) {
        self.name = name
        self.dosage = dosage
        self.isTaking = isTaking
        self.takeTime = takeTime
        self.selectDate = selectDate
        self.id = id
    }
}

