//
//  CoreDataManager.swift
//  APillLog
//
//  Created by 종건 on 2022/07/18.
//

import Foundation
import UIKit
import CoreData
class CoreDataManager{
    //사용법
    //var coredataManager: CoreDataManager = CoreDataManager()
    //coredataManager.함수
    
    // MARK: - Core Data Saving support
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "APillLog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveToContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func togglePrimaryPillIsShowing(pill: PrimaryPill){
        let request : NSFetchRequest<PrimaryPill> = PrimaryPill.fetchRequest()
        
        do {
            let pillArray = try context.fetch(request)
            for data in pillArray{
                if data.id == pill.id
                {
                    data.isShowing.toggle()
                }
            }
            
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
        saveToContext()
    }
    
    func deletePrimaryPill(pill: PrimaryPill) {
        let request : NSFetchRequest<PrimaryPill> = PrimaryPill.fetchRequest()
        
        do {
            let pillArray = try context.fetch(request)
            
            for index in pillArray.indices {
                if pillArray[index].id == pill.id
                {
                    self.context.delete(pill)
                    break
                }
            }
            
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
        saveToContext()
    }
    
    // MARK: - Core Data Create
    func addPrimaryPill(name: String, dosage: String, dosingCycle: Int16){
        let primaryPill = PrimaryPill(context: persistentContainer.viewContext)
        primaryPill.id = UUID()
        primaryPill.name = name
        primaryPill.dosage = dosage
        primaryPill.dosingCycle = dosingCycle
        primaryPill.isShowing = true
        primaryPill.createTime = Date()
        
        saveToContext()
    }
    
    func addSecondaryPill(name: String, dosage: String?){
        let secondaryPill = SecondaryPill(context: persistentContainer.viewContext)
        secondaryPill.id = UUID()
        secondaryPill.name = name
        secondaryPill.dosage = dosage
        secondaryPill.createTime = Date()
        
        saveToContext()
    }
    
    func addShowPrimaryPill(name: String, dosage: String, cycle: Int16 ,selectDate: String){
        let showPrimaryPill = ShowPrimaryPill(context: persistentContainer.viewContext)
        showPrimaryPill.id = UUID()
        showPrimaryPill.name = name
        showPrimaryPill.dosage = dosage
        showPrimaryPill.selectDate = selectDate
        showPrimaryPill.isTaking = false
        showPrimaryPill.cycle = cycle
        showPrimaryPill.takeTime = Date()
        
        saveToContext()
    }
    
    func addShowSecondaryPill(name: String, dosage: String?, selectDate: Date){
        let showSecondaryPill = ShowSecondaryPill(context: persistentContainer.viewContext)
        let selectedDate: String = changeSelectedDateToString(selectDate)
        showSecondaryPill.id = UUID()
        showSecondaryPill.name = name
        showSecondaryPill.dosage = dosage
        showSecondaryPill.isTaking = false
        showSecondaryPill.takeTime = Date()
        showSecondaryPill.selectDate = selectedDate
        saveToContext()
    }
    
    func addCondition(name: [String]?, dosage: [String]?, sideEffect: [String]?, medicinalEffect: [String]?, detailContext: String?){
        let condition = Condition(context: persistentContainer.viewContext )
        condition.id = UUID()
        condition.name = name
        condition.dosage = dosage
        condition.sideEffect = sideEffect
        condition.medicinalEffect = medicinalEffect
        condition.detailContext = detailContext
        condition.createTime = Date()
        
        saveToContext()
    }
    
    func addCBT(selectDate: Date, cbtContext: String) {
        let selectedDate: String = changeSelectedDateToString(selectDate)
        let cbt = CBT(context: persistentContainer.viewContext)
        cbt.cbtId = UUID()
        cbt.selectDate = selectedDate
        cbt.cbtContext = cbtContext
        cbt.createTime = Date()
        
        saveToContext()
    }
    
    
    
    func addHistory(pillName: String?, dosage: String?, isMainPill: Bool?, pillNames: [String]?, dosages: [String]?, sideEffect: [String]?, medicinalEffect: [String]?, detailContext: String?){
        let history = History(context: persistentContainer.viewContext)
        history.id = UUID()
        history.pillName = pillName
        history.dosage = dosage
        history.isMainPill = isMainPill ?? false
        
        history.names = pillNames
        history.dosages = dosages
        history.sideEffect = sideEffect
        history.medicinalEffect = medicinalEffect
        history.detailContext = detailContext
        
        history.createTime = Date()
        
        saveToContext()
        
    }
    // MARK: - page별 기능 추가
    //오늘의 복용약에서 복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangePrimaryIsTaking(primaryPill: ShowPrimaryPill) {
        primaryPill.isTaking = true
        saveToContext()
        addHistory(pillName: primaryPill.name, dosage: primaryPill.dosage, isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
    }
    
    //오늘의 복용약에서 '모두'복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeAllPrimaryIsTaking(selectDate: Date, dosingCycle: Int16){
        
        let selectedDate: String = changeSelectedDateToString(selectDate)
        let request : NSFetchRequest<ShowPrimaryPill> = ShowPrimaryPill.fetchRequest()
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray {
                if(pill.selectDate == selectedDate && pill.cycle == dosingCycle && pill.isTaking == false){
                    pill.isTaking = true
                    addHistory(pillName: pill.name, dosage: pill.dosage, isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
                    saveToContext()
                }
            }
            
        } catch{
            print("-----isTaking error-------")
        }
        
    }
    
    //오늘의 복용약에서 서브 복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeSecondaryIsTaking(secondaryPill: ShowSecondaryPill) {
        secondaryPill.isTaking = true
        saveToContext()
        addHistory(pillName: secondaryPill.name, dosage: secondaryPill.dosage, isMainPill: false, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
    }
    
    //오늘의 서브복용약에서 '모두'복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeAllSecondaryIsTaking(selectDate: Date){
        
        let selectedDate: String = changeSelectedDateToString(selectDate)
        let request : NSFetchRequest<ShowSecondaryPill> = ShowSecondaryPill.fetchRequest()
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray {
                if(pill.selectDate == selectedDate && pill.isTaking == false){
                    pill.isTaking = true
                    addHistory(pillName: pill.name, dosage: pill.dosage, isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
                    saveToContext()
                }
            }
            
        } catch{
            print("-----isTaking error-------")
        }
        
    }
    
    //증상입력에서 condition을 저장하고 history에 등록하는 함수
    func recordHistoryAndRecordCondition(name: [String]?, dosage: [String]?, sideEffect: [String]?, medicinalEffect: [String]?, detailContext: String?){
        addCondition(name: name, dosage: dosage, sideEffect: sideEffect, medicinalEffect: medicinalEffect, detailContext: detailContext)
        
        addHistory(pillName: nil, dosage: nil, isMainPill: true, pillNames: name, dosages: dosage, sideEffect: sideEffect, medicinalEffect: medicinalEffect, detailContext: detailContext)
    }
    
    
    //primaryPill에서 ShowPrimaryPill로 추가하는 함수
    func sendPrimarypillToShowPrimaryPill(){
        let request : NSFetchRequest<PrimaryPill> = PrimaryPill.fetchRequest()
        let selectedDate: String = changeSelectedDateToString(Date())
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray{
                if pill.isShowing {
                    switch pill.dosingCycle{
                    case Int16(1):
                        do { self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(1), selectDate: selectedDate) }
                    case Int16(2):
                        do { self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(2), selectDate: selectedDate ) }
                    case Int16(3):
                        do { self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(1), selectDate: selectedDate )
                            self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(2), selectDate: selectedDate )
                        }
                    case Int16(4):
                        do { self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(4), selectDate: selectedDate ) }
                    case Int16(5):
                        do { self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(4), selectDate: selectedDate )
                            self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(1), selectDate: selectedDate )
                        }
                    case Int16(6):
                        do { self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(2), selectDate: selectedDate )
                            self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(4), selectDate: selectedDate )
                        }
                    default:
                        do {self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(1), selectDate: selectedDate )
                            self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(2), selectDate: selectedDate )
                            self.addShowPrimaryPill(name: pill.name ?? "" , dosage: pill.dosage ?? "", cycle: Int16(4), selectDate: selectedDate )
                        }
                        
                    }
                    
                }
            }
            
        } catch{
            print("--- send ShowPrimary error ----")
        }
        
    }
    // MARK: - Core Data READ
    
    //메인약 추가 페이지에 사용할 primaryPill read함수
    func fetchPrimaryPill() -> [PrimaryPill] {
        var pillArray: [PrimaryPill] = []
        let request : NSFetchRequest<PrimaryPill> = PrimaryPill.fetchRequest()
        do {
            pillArray = try context.fetch(request)
            return pillArray
        } catch{
            print("-----fetchPrimaryPill error -------")
        }
        return pillArray
    }
    
    //showPrimaryPill read함수
    func fetchShowPrimaryPill(selectedDate: Date) -> [ShowPrimaryPill] {
        let request : NSFetchRequest<ShowPrimaryPill> = ShowPrimaryPill.fetchRequest()
        var pillArrayResult: [ShowPrimaryPill] = []
        let selectDate: String = changeSelectedDateToString(Date())
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray{
                if pill.selectDate == selectDate
                {
                    pillArrayResult.append(pill)
                }
            }
            return pillArray
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
        return pillArrayResult
    }
    
    //오늘의 메인약 아침
    func fetchShowPrimaryPillMorning(TodayTotalPrimaryPill: [ShowPrimaryPill]?) -> [ShowPrimaryPill] {
        var pillArrayResult: [ShowPrimaryPill] = []
        
        if let pillArray = TodayTotalPrimaryPill{
            
            for pill in pillArray{
                if pill.cycle == 1 || pill.cycle == 3 || pill.cycle == 5 || pill.cycle == 7
                {
                    pillArrayResult.append(pill)
                }
            }
            return pillArrayResult
        }
        return pillArrayResult
    }
    
    //오늘의 메인약 점심
    func fetchShowPrimaryPillLunch(TodayTotalPrimaryPill: [ShowPrimaryPill]?) -> [ShowPrimaryPill] {
        var pillArrayResult: [ShowPrimaryPill] = []
        if let pillArray = TodayTotalPrimaryPill{
            
            for pill in pillArray{
                if pill.cycle == 2 || pill.cycle == 3 || pill.cycle == 6 || pill.cycle == 7
                {
                    pillArrayResult.append(pill)
                }
            }
            return pillArrayResult
        }
        return pillArrayResult
    }
    
    //오늘의 메인약 저녁
    func fetchShowPrimaryPillDinner(TodayTotalPrimaryPill: [ShowPrimaryPill]?) -> [ShowPrimaryPill] {
        var pillArrayResult: [ShowPrimaryPill] = []
        
        if let pillArray = TodayTotalPrimaryPill{
            
            for pill in pillArray{
                if pill.cycle == 4 || pill.cycle == 5 || pill.cycle == 6 || pill.cycle == 7
                {
                    pillArrayResult.append(pill)
                }
            }
            return pillArrayResult
        }
        return pillArrayResult
    }
    
    
    //최근검색에 추가할 SecondartPill read 함수
    func fetchSecondaryPill() -> [SecondaryPill] {
        var pillArray:[SecondaryPill] = []
        let request : NSFetchRequest<SecondaryPill> = SecondaryPill.fetchRequest()
        do {
            pillArray = try context.fetch(request)
            return pillArray
        } catch{
            print("-----fetchSecondaryPill error-------")
        }
        return pillArray
    }
    //ShowSecondaryPill read함수
    func fetchShowSecondaryPill(selectedDate: Date) -> [ShowSecondaryPill] {
        
        let selectDate: String = changeSelectedDateToString(selectedDate)
        var pillArrayResult: [ShowSecondaryPill] = []
        let request : NSFetchRequest<ShowSecondaryPill> = ShowSecondaryPill.fetchRequest()
        
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray{
                if pill.selectDate == selectDate{
                    pillArrayResult.append(pill)
                }
            }
            return pillArrayResult
        } catch{
            print("-----fetchShowSecondaryPill error-------")
        }
        return pillArrayResult
        
    }
    //history read함수
    func fetchHistory(selectedDate: Date) -> [History]{
        let request : NSFetchRequest<History> = History.fetchRequest()
        let selectDate: String = changeSelectedDateToString(selectedDate)
        var historyResult: [History] = []
        do {
            let histroyArray = try context.fetch(request)
            for history in histroyArray{
                let historyRecordDate = changeSelectedDateToString(history.createTime ?? Date())
                if historyRecordDate == selectDate{
                    historyResult.append(history)
                }
            }
            return historyResult
        } catch{
            print("-----CBT error-------")
        }
        return historyResult
    }
    
    //실수노트 리스트 read함수
    func fetchCBT() -> [CBT] {
        
        let request : NSFetchRequest<CBT> = CBT.fetchRequest()
        do {
            let pillArray = try context.fetch(request)
            return pillArray
        } catch{
            print("-----CBT error-------")
        }
        return [CBT()]
        
    }
    //선택한 데이터를 2022-07-16 의 형태의 String으로 바꿔주는 함수
    func changeSelectedDateToString(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
        
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate
    }
    
}
