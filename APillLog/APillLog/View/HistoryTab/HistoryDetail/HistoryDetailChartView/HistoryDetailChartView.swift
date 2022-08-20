//
//  HistoryDetailChartView.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import UIKit
import Charts
import Foundation


@IBDesignable
class HistoryDetailChartView: UIView {
    
    @IBOutlet var barChartView: BarChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var sideEffect: [String] = ["불면", "두근거림", "두통", "어지러움", "불안", "식욕감소", "구역", "입안건조", "과민성", "땀과다증"]
    var dateArray: [String] = ["", "", "", "", "", "", "",]
    var sideEffectCount: [Double] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var sideEffectCountPerDate: [Double] = [0, 0, 0, 0, 0, 0, 0]
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd일"
        return dateFormatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
        
        setSegmentedControlStyle()
    }
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("HistoryDetailChartView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        
        self.addSubview(view)
        
        
        barChartView.noDataText = "아직 남긴 기록이 없어요"
        barChartView.noDataTextColor = .lightGray
        
        loadData(startDate: Date(), range: 7)
        setChart(dataPoints: sideEffect, values: sideEffectCount)
    }
    
    
    // MARK: Function
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")

        // 차트 설정
        chartDataSet.highlightEnabled = false
        barChartView.doubleTapToZoomEnabled = false

        chartDataSet.colors = [.AColor.accent]

        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        barChartView.rightAxis.enabled = false

        barChartView.leftAxis.axisMinimum = 0
        
        barChartView.chartDescription.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
//        barChartView.xAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        
//        barChartView.leftAxis.enabled = false
        barChartView.drawBordersEnabled = false
        barChartView.legend.form = .none
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        barChartView.xAxis.labelPosition = .bottom
        
//        barChartView.leftAxis.calculate(min: 0, max: Double(5 * ((Int(chartDataSet.yMax)) % 5) + 1))
        barChartView.leftAxis.axisMaximum = Double(5 * ((Int(chartDataSet.yMax)) / 5 + 1))
        
        print(chartDataSet.yMax)
            
        // Text 관련
        barChartView.xAxis.labelFont = UIFont.AFont.articleBody
        //        chartDataSet.valueFont = UIFont.AFont.navigationTitle
        chartDataSet.valueColors = [UIColor.clear]
        barChartView.leftAxis.labelFont = UIFont.AFont.navigationTitle
        
        barChartView.leftAxis.granularityEnabled = true
        barChartView.leftAxis.granularity = 1
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    func setSegmentedControlStyle() {

    }
    
    func loadData(startDate: Date, range: Int) {
        
        sideEffect = ["불면", "두근거림", "두통", "어지러움", "불안", "식욕감소", "구역", "입안건조", "과민성", "땀과다증"]
        dateArray = Array(repeating: "", count: range)
        sideEffectCount = Array(repeating: 0, count: 10)
        sideEffectCountPerDate = Array(repeating: 0, count: range)
        
        for index in 0..<range {
            let date = Calendar.current.date(byAdding: .day, value: index, to: startDate)
            dateArray[index] = dateFormatter.string(from: date ?? Date())
            
            let history = CoreDataManager.shared.fetchHistory(selectedDate: date ?? Date())
            
            history.forEach { data in
                for effect in data.sideEffect ?? [] {
                    sideEffectCountPerDate[index] += Double(effect.count)
                    
                    switch effect {
                    case "불면":
                        sideEffectCount[0] += 1
                        
                    case "두근거림":
                        sideEffectCount[1] += 1
                        
                    case "두통":
                        sideEffectCount[2] += 1
                        
                    case "어지러움":
                        sideEffectCount[3] += 1
                        
                    case "불안":
                        sideEffectCount[4] += 1
                        
                    case "식욕 감소":
                        sideEffectCount[5] += 1
                        
                    case "구역":
                        sideEffectCount[6] += 1
                        
                    case "입안 건조":
                        sideEffectCount[7] += 1
                        
                    case "과민성":
                        sideEffectCount[8] += 1
                        
                    case "땀 과다증":
                        sideEffectCount[9] += 1
                        
                    default:
                        print("잘못된 부작용 명")
                    }
                }
            }
        }
        sortSideEffect()
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setChart(dataPoints: sideEffect, values: sideEffectCount)
        case 1:
            setChart(dataPoints: dateArray, values: sideEffectCountPerDate)
        default:
            print("잘못된 Segmented Control Index")
        }
    }
    
    func argsort<T:Comparable>( a : [T] ) -> [Int] {
        var r = Array(0..<a.count)
        r.sort(by: { a[$0] > a[$1] })
        return r
    }

    func sortSideEffect() {
        var sortedSideEffect:[String] = []
        var sortedSideEffectCount:[Double] = []
        
        let sortedIndex = argsort(a: sideEffectCount)
        
        for idx in sortedIndex {
            sortedSideEffect.append(sideEffect[idx])
            sortedSideEffectCount.append(sideEffectCount[idx])
        }
        
        sideEffect = sortedSideEffect
        sideEffectCount = sortedSideEffectCount
    }
    
    // MARK: @IBAction
    @IBAction func changeSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            setChart(dataPoints: sideEffect, values: sideEffectCount)

        case 1:
            setChart(dataPoints: dateArray, values: sideEffectCountPerDate)
            
        default:
            print("잘못된 Segmented Control Index")
            
        }
    }
    
}
