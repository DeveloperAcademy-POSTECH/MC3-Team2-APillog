//
//  HistoryDetailChartView.swift
//  APillLog
//
//  Created by 이지원 on 2022/07/30.
//

import UIKit
import Charts

@IBDesignable
class HistoryDetailChartView: UIView {
    
    @IBOutlet var barChartView: BarChartView!

    var condition: [String]!
    var conditionCount: [Double]!
    
    let barCornerRadius = CGFloat(10.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
    }
    
    private func loadView() {
        guard let view = Bundle.main.loadNibNamed("HistoryDetailChartView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        
        self.addSubview(view)
        
        
        barChartView.noDataText = "아직 남긴 기록이 없어요"
        barChartView.noDataTextColor = .lightGray
        
        condition = ["불면", "두근거림", "두통", "어지러움", "불안", "식욕감소", "구역", "입안건조", "과민성", "땀과다증"]

        conditionCount = [5, 10, 7, 3, 2, 5, 3, 7, 9, 12]
        
        setChart(dataPoints: condition, values: conditionCount)
        
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
        
        
        // Text 관련
        barChartView.xAxis.labelFont = UIFont.AFont.articleBody
        //        chartDataSet.valueFont = UIFont.AFont.navigationTitle
        chartDataSet.valueColors = [UIColor.clear]
        barChartView.leftAxis.labelFont = UIFont.AFont.navigationTitle
        
        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
}
