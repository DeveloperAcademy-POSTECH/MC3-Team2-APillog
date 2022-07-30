//
//  CoreDataManager.swift
//  APillLog
//
//  Created by 종건 on 2022/07/18.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    //사용법
    // CoreDataManager.shared.함수
    
    static let shared: CoreDataManager = CoreDataManager()
    
    //coredataManager.함수
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "APillLog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
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
            for data in pillArray {
                // 토글 변경
                if data.id == pill.id
                {
                    data.isShowing.toggle()
                }
                //토글 값이 false면 ShowPrimaryPill 삭제
                if(!data.isShowing && data.id == pill.id){
                    deleteShowPrimaryPill(pill: data)
                }
            }
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
        saveToContext()
    }
    func deleteShowPrimaryPill(pill: PrimaryPill){
        let request : NSFetchRequest<ShowPrimaryPill> = ShowPrimaryPill.fetchRequest()
        //현재의 날짜를 선택
        let todayDate: String = changeSelectedDateToString(Date())
        do {
            let pillArray = try context.fetch(request)
            
            for item in pillArray {
                if (item.selectDate == todayDate && item.name == pill.name &&
                    item.dosage == pill.dosage && ((item.cycle & pill.dosingCycle) != 0))
                {
                    
                    self.context.delete(item)
                    saveToContext()
                    
                }
            }
            
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
       
    }
    
    func deleteShowSecondaryPill(pill: ShowSecondaryPill){
        let request : NSFetchRequest<ShowSecondaryPill> = ShowSecondaryPill.fetchRequest()
        //현재의 날짜를 선택
        let todayDate: String = changeSelectedDateToString(Date())
        do {
            let pillArray = try context.fetch(request)
            
            for item in pillArray {
                if (item.selectDate == todayDate && item.name == pill.name &&
                    item.dosage == pill.dosage)
                {
                    self.context.delete(item)
                    saveToContext()
                }
            }
            
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
       
    }
    
    func deletePrimaryPill(pill: PrimaryPill) {
        let request : NSFetchRequest<PrimaryPill> = PrimaryPill.fetchRequest()
        
        do {
            let pillArray = try context.fetch(request)
            
            for index in pillArray.indices {
                if pillArray[index].id == pill.id
                {
                    deleteShowPrimaryPill(pill: pill)
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
        showPrimaryPill.takeTime = nil
        
        saveToContext()
    }
    
    func addShowSecondaryPill(name: String, dosage: String?, selectDate: Date){
        let showSecondaryPill = ShowSecondaryPill(context: persistentContainer.viewContext)
        let selectedDate: String = changeSelectedDateToString(selectDate)
        showSecondaryPill.id = UUID()
        showSecondaryPill.name = name
        showSecondaryPill.dosage = dosage
        showSecondaryPill.isTaking = true
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
    
    func addCBT(selectDate: Date, mistakeContext: String, recognizeContext: String, actionContext: String) {
        let selectedDate: String = changeSelectedDateToString(selectDate)
        let cbt = CBT(context: persistentContainer.viewContext)
        cbt.cbtId = UUID()
        cbt.selectDate = selectedDate
        cbt.mistakeContext = mistakeContext
        cbt.recognizeContext = recognizeContext
        cbt.actionContext = actionContext
        cbt.createTime = Date()
        
        saveToContext()
    }
    
    
    
    func addHistory(pillId: UUID?, pillName: String?, dosage: String?, isMainPill: Bool?, pillNames: [String]?, dosages: [String]?, sideEffect: [String]?, medicinalEffect: [String]?, detailContext: String?){
        let history = History(context: persistentContainer.viewContext)
        history.id = UUID()
        history.pillId = pillId
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
    
    func addRecentAddedSecondaryPill(name: String) {
        let request : NSFetchRequest<RecentAddedSecondaryPill> = RecentAddedSecondaryPill.fetchRequest()
        
        do {
            let recentArray = try context.fetch(request)
            
            // 이전에 복용했던 기록이 있는 약이라면 지우고 상단으로 올리기
            for pill in recentArray {
                if pill.name == name {
                    context.delete(pill)
                }
            }
            
            // 10개가 넘으면 한 개 빼기
            if recentArray.count >= 10 {
                self.context.delete(recentArray[0])
            }
            
            // 약 최상단에 추가하기
            let recentAddedSecondaryPill = RecentAddedSecondaryPill(context: persistentContainer.viewContext)
            
            recentAddedSecondaryPill.id = UUID()
            recentAddedSecondaryPill.name = name
            
        } catch{
            print("-----fetchShowPrimaryPill error-------")
        }
        
        saveToContext()
    }
    
    // MARK: - page별 기능 추가
    //오늘의 복용약에서 복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeShowPrimaryIsTaking(showPrimaryPill: ShowPrimaryPill) {
        showPrimaryPill.takeTime = Date()
        showPrimaryPill.isTaking = true
        saveToContext()
        addHistory(pillId:showPrimaryPill.id ,pillName: showPrimaryPill.name, dosage: showPrimaryPill.dosage, isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
    }
    
    func deletePillHistory(pillId: UUID){
        let request : NSFetchRequest<History> = History.fetchRequest()
        do {
            let historyArray = try context.fetch(request)
            for history in historyArray{
                if history.pillId == pillId
                {
                    context.delete(history)
                    saveToContext()
                    break
                }
            }
        }
        catch{
            print("---------error---------")
        }
    }
    
    func changePrimaryIsTakingAndCancelHistory(showPrimaryPill: ShowPrimaryPill){
        showPrimaryPill.takeTime = nil
        showPrimaryPill.isTaking = false
        deletePillHistory(pillId: showPrimaryPill.id ?? UUID())
    }

    func changeSecondaryIsTakingAndCancelHistory(showSecondaryPill: ShowSecondaryPill){
        showSecondaryPill.takeTime = nil
        showSecondaryPill.isTaking = false
        saveToContext()
        deletePillHistory(pillId: showSecondaryPill.id ?? UUID())
    }

    //오늘의 복용약에서 '모두'복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeAllPrimaryIsTaking(selectDate: Date, dosingCycle: Int16) {
        
        let selectedDate: String = changeSelectedDateToString(selectDate)
        let request : NSFetchRequest<ShowPrimaryPill> = ShowPrimaryPill.fetchRequest()
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray {
                if(pill.selectDate == selectedDate && pill.cycle == dosingCycle && pill.isTaking == false){
                    pill.takeTime = Date()
                    pill.isTaking = true
                    addHistory(pillId: pill.id, pillName: pill.name, dosage: pill.dosage, isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
                    saveToContext()
                }
            }
            
        } catch{
            print("-----isTaking error-------")
        }
        
    }
    
    //오늘의 복용약에서 서브 복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeShowSecondaryIsTaking(showSecondaryPill: ShowSecondaryPill) {
        showSecondaryPill.takeTime = Date()
        showSecondaryPill.isTaking = true
        let request : NSFetchRequest<ShowSecondaryPill> = ShowSecondaryPill.fetchRequest()
        
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray {
                if pill.id == showSecondaryPill.id {
                    pill.isTaking = true
                }
            }
            
            addHistory(pillId: showSecondaryPill.id, pillName: showSecondaryPill.name, dosage: showSecondaryPill.dosage, isMainPill: false, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
            
        } catch{
            print("-----isTaking error-------")
        }
        
        saveToContext()
        
    }
    
    //오늘의 서브복용약에서 '모두'복약을 누르면 약의 istaking의 정보가 바뀌고 히스토리에 저장하는 함수
    func recordHistoryAndChangeAllSecondaryIsTaking(selectDate: Date){
        
        let selectedDate: String = changeSelectedDateToString(selectDate)
        let request : NSFetchRequest<ShowSecondaryPill> = ShowSecondaryPill.fetchRequest()
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray {
                if(pill.selectDate == selectedDate && pill.isTaking == false){
                    pill.takeTime = Date()
                    pill.isTaking = true
                    addHistory(pillId:pill.id ,pillName: pill.name, dosage: pill.dosage, isMainPill: true, pillNames: nil, dosages: nil, sideEffect: nil, medicinalEffect: nil, detailContext: nil)
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
        
        addHistory(pillId: nil, pillName: nil, dosage: nil, isMainPill: true, pillNames: name, dosages: dosage, sideEffect: sideEffect, medicinalEffect: medicinalEffect, detailContext: detailContext)
    }
    
    
    func checkPrimaryPillIsSameShowPrimaryPill(pill:PrimaryPill) -> Bool{
        let request : NSFetchRequest<ShowPrimaryPill> = ShowPrimaryPill.fetchRequest()
        let selectedDate: String = changeSelectedDateToString(Date())
        do {
            let pillArray = try context.fetch(request)
            for item in pillArray{
                if (item.selectDate == selectedDate && item.name == pill.name
                    && item.dosage == pill.dosage) {
                    if (item.cycle & pill.dosingCycle >= 1) {
                        return false
                    }
                }
            }
        }
        catch{
            print("check error")
        }
        return true
    }
    
    
    //
    
    
    //primaryPill에서 ShowPrimaryPill로 추가하는 함수
    // TODO: 오늘날짜부터 불러와야돼
    func sendPrimarypillToShowPrimaryPill(){
        
        let request : NSFetchRequest<PrimaryPill> = PrimaryPill.fetchRequest()
        let selectedDate: String = changeSelectedDateToString(Date())
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray{
                if pill.isShowing && checkPrimaryPillIsSameShowPrimaryPill(pill: pill){
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
        let selectDate: String = changeSelectedDateToString(selectedDate)
        do {
            let pillArray = try context.fetch(request)
            for pill in pillArray{
//                print("pill selectedData",pill.selectDate)
                if pill.selectDate == selectDate
                {
                    pillArrayResult.append(pill)
                }
            }
            return pillArrayResult
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
    func fetchHistory(selectedDate: Date) -> [History] {
        //let sortDescriptor = NSSortDescriptor(key: "selectDate", ascending: true)
        let request : NSFetchRequest<History> = History.fetchRequest()
      //  request.sortDescriptors = [sortDescriptor]
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
            print("-----fetchHistory error-------")
        }
        return historyResult
    }
    
    //실수노트 리스트 read함수
    func fetchCBT() -> [CBT] {
        
        let request : NSFetchRequest<CBT> = CBT.fetchRequest()
        do {
            let cbtArray = try context.fetch(request)
            return cbtArray
        } catch{
            print("-----CBT error-------")
        }
        return [CBT()]
        
    }
    // UUID값을 받아서 디테일뷰에 보여주는 함수
    func fetchOneCBT(cbtUUID: UUID) -> CBT{
        let request : NSFetchRequest<CBT> = CBT.fetchRequest()
        do {
            let cbtArray = try context.fetch(request)
            for data in cbtArray{
                if data.cbtId == cbtUUID{
                    return data
                }
            }
            return CBT()
        } catch{
            print("-----CBT error-------")
        }
        
        return CBT()
    }

    
    func fetchRecentAddedSecondaryPill() -> [RecentAddedSecondaryPill] {
        let request : NSFetchRequest<RecentAddedSecondaryPill> = RecentAddedSecondaryPill.fetchRequest()
        
        do {
            let recentArray = try context.fetch(request)
            return recentArray
        } catch{
            print("-----CBT error-------")
        }
        return [RecentAddedSecondaryPill()]
    }
    


    //CBT를 업데이트 하는 함수
    func updateOneCBT(receivedCBT : CBT) {

        let request : NSFetchRequest<CBT> = CBT.fetchRequest()
        do {
            let cbtArray = try context.fetch(request)
            for data in cbtArray{
                if data.cbtId == receivedCBT.cbtId{
                    data.mistakeContext = receivedCBT.mistakeContext
                    data.recognizeContext = receivedCBT.recognizeContext
                    data.actionContext = receivedCBT.actionContext
                    saveToContext()
                    break
                }
            }
            
        } catch{
            print("-----CBT error-------")
        }
        
        
    }
    //선택한 CBT를 삭제하는 함수
    func deleteCBT(CBT : CBT){
        self.context.delete(CBT)
        saveToContext()
    }
    
    func fetchMonthDosingPillDate(date: Date) -> [String]{
        
        var resultDate: [String] = []
        
        let selectedDate: String = changeDateToMonth(date)
        var tempDateArray: [ShowPrimaryPill] = []
        
        let request : NSFetchRequest<ShowPrimaryPill> = ShowPrimaryPill.fetchRequest()
        do {
            let pillArray = try context.fetch(request)
            var i: Int = 0
            while i<32 {
                let compareDate: String
                var checkPillIsTaking: Bool = false
                
                if i < 10
                {
                     compareDate = selectedDate + "-0" + "\(i)"
                }
                else{
                    compareDate = selectedDate + "-\(i)"
                }
                
                for pill in pillArray{
                    if pill.selectDate == compareDate
                    {    checkPillIsTaking = true
                        tempDateArray.append(pill)
                    }
                }
                
                for pill in tempDateArray{
                    if pill.isTaking == false{
                        checkPillIsTaking = false
                        break;
                    }
                }
                
                if checkPillIsTaking {
                    resultDate.append(compareDate)
                }
                i += 1
            }
            
           
            
        } catch{
            print("-----fetchMonthSideEffectDate error-------")
        }
        
        return resultDate
    }
    
    func fetchMonthSideEffectDate(date: Date) -> [String] {
        var resultDate:[String] = []
        let selectedDate: String = changeDateToMonth(date)
        let request : NSFetchRequest<History> = History.fetchRequest()
        do {
            let historyArray = try context.fetch(request)
            for history in historyArray{
                if history.sideEffect != [] &&  changeDateToMonth(history.createTime ?? Date()) == selectedDate
                {
                    resultDate.append(changeSelectedDateToString(history.createTime ?? Date()))
                }
            }
            
        } catch{
            print("-----fetchMonthSideEffectDate error-------")
        }
        
        return resultDate
    }
    func fetchMotnDetailSideEffectDate(date: Date) -> [String]{
        var resultDate:[String] = []
        let selectedDate: String = changeDateToMonth(date)
        let request : NSFetchRequest<History> = History.fetchRequest()
        do {
            let historyArray = try context.fetch(request)
            for history in historyArray{
                if history.detailContext != "" &&  changeDateToMonth(history.createTime ?? Date()) == selectedDate
                {
                    
                    resultDate.append(changeSelectedDateToString(history.createTime ?? Date()))
                }
            }
            
        } catch{
            print("-----fetchMotnDetailSideEffectDate error-------")
        }
        
        return resultDate
    }
    //선택한 데이터를 2022-07-16 의 형태의 String으로 바꿔주는 함수
    func changeSelectedDateToString(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 2022-08-13
        
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate
    }
    func changeDateToMonth(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM" // 2022-08-13
        
        let selectedDate: String = dateFormatter.string(from: date)
        return selectedDate
    }
    
    
}

