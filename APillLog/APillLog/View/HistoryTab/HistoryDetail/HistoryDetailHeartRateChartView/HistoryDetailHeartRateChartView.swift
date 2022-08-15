//
//  HistoryDetailHeartRateChartView.swift
//  APillLog
//
//  Created by Park Sungmin on 2022/08/12.
//

import UIKit
import Charts
import Foundation
import HealthKit

@IBDesignable
class HistoryDetailHeartRateChartView: UIView {
    
    @IBOutlet weak var chartView: BarChartView!
    
    var xAxisLabel: [String] = []
    var HRCount: [Double] = []
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d일"
        return dateFormatter
    }()
    
    let healthStore = HKHealthStore()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        authorizeHealthKit()
        self.loadView()
    }
    
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("HistoryDetailHeartRateChartView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        
        self.addSubview(view)
        
        authorizeHealthKit()
        loadData()
    }
    
    private func loadData() {
        
        // X축 날짜 레이블링
        var axisDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        // 1. 일 별 빈도의 경우
//        xAxisLabel = .init(repeating: " ", count: 31)
        //        for idx in 0..<7 {
        //            xAxisLabel[idx*5] = dateFormatter.string(from: axisDate)
        //            axisDate = Calendar.current.date(byAdding: .day, value: 5, to: axisDate)!
        //        }
        // 2. 시간 별 빈도의 경우
        xAxisLabel = .init(repeating: " ", count: 24)
        for idx in 0..<24 {
            xAxisLabel[idx] = (idx % 2 == 0) ? "\(idx)시" : ""
        }
        
        // 빈맥 데이터 가져오기
        setHeartRateData()
    }
    
    private func setHeartRateData() {
        var heartRateData: [Double] = .init(repeating: 0, count: 31)
        let day = Calendar.current.dateComponents([.day], from: Date()).day!
        // 데이터 가져오기
        // HealthKit에서 어떤 정보를 가져오려고 하는가? -> 심박수 데이터를 가져오기
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        // 가져올 데이터에 대한 쿼리 작성 (1달 전 부터 오늘까지의 데이터를 가져오려고 한다)
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        // 가져온 데이터를 어떻게 정렬할 것인가? -> 날짜 순으로 정렬하기
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit), // 데이터 개수 제한 없이 들고옴
                                  sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else { return }
            
            print("분당 심박수가 100 이상일 때")
            guard let result = result else { return }
            
            print(Calendar.current.dateComponents([.day], from: startDate!, to: Date()).day ?? Int(31))
            var listOnDate: [[HKQuantitySample]] = Array.init(repeating: [], count: 32)
            
            let unit = HKUnit(from: "count/min")
            
            for sample in result {
                let data = sample as! HKQuantitySample
                if data.quantity.doubleValue(for: unit) >= 100 {
                    let testDate = 31 - (Calendar.current.dateComponents([.day], from: data.startDate, to: Date()).day ?? 31)
                    listOnDate[31 - (Calendar.current.dateComponents([.day], from: data.startDate, to: Date()).day ?? 31)].append(data)
                }
            }
            
            for dataOnDay in listOnDate {
                var exist = Array.init(repeating: false, count: 24)
                
                for data in dataOnDay {
                    exist[Calendar.current.dateComponents([.hour], from: data.startDate).hour ?? 0] = true
                }
                
                for idx in 0..<24 {
                    heartRateData[idx] = heartRateData[idx] + (exist[idx] ? 1 : 0)
                }
            }
            
            self.setChart(dataPoints: self.xAxisLabel, values: heartRateData)
        }
        healthStore.execute(query)
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        
        // 차트 설정
        chartDataSet.highlightEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        chartDataSet.colors = [.AColor.accent]
        
        chartView.xAxis.setLabelCount(dataPoints.count, force: false)
        chartView.rightAxis.enabled = false
        
        chartView.leftAxis.axisMinimum = 0
        
        chartView.chartDescription.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        //        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        
        //        chartView.leftAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.legend.form = .none
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        chartView.xAxis.labelPosition = .bottom
        
        // Text 관련
        chartView.xAxis.labelFont = UIFont.AFont.articleBody
        //        chartDataSet.valueFont = UIFont.AFont.navigationTitle
        chartDataSet.valueColors = [UIColor.clear]
        chartView.leftAxis.labelFont = UIFont.AFont.navigationTitle
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
    }
    
    private func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!])
        
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if chk {
                print("접근 허용함")
                self.loadData()
            }
        }
    }
}
