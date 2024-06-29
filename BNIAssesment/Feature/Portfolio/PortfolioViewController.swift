//
//  PortfolioViewController.swift
//  BNIAssesment
//
//  Created by MacBook on 28/06/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class PortfolioViewController: UIViewController, PortfolioView {
    var presenter: PortfolioPresenter!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    private let requestPortfolioRelay = PublishRelay<Void>()
    private let didSelectTransactionRelay = PublishRelay<DonutChart.DetailTransaksi>()
    private let disposeBag = DisposeBag()
    
    private var donutChartData: DonutChart?
    private var lineChartData: LineChart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindPresenter()
        requestPortfolioRelay.accept(())
    }
    
    private func setupUI() {
        title = "Portfolio"
    }
    
    private func bindPresenter() {
        let input = PortfolioPresenter.Input(
            requestPortfolio: self.requestPortfolioRelay.asObservable(),
            didSelectTransaction: self.didSelectTransactionRelay.asObservable()
        )
        
        let output = presenter.transform(input)
        
        output.displayPortfolio.drive(onNext: {[weak self] (portfolio) in
            guard let portfolio = portfolio else { return }
            
            portfolio.forEach { item in
                switch item {
                case .donutChart(let chart):
                    self?.donutChartData = chart
                    self?.setupDonutChart()
                case .lineChart(let chart):
                    self?.lineChartData = chart
                    self?.setupLineChart()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func setupDonutChart() {
        guard let donutChartData = self.donutChartData else { return }
        
        var entries: [PieChartDataEntry] = []
        for datum in donutChartData.data {
            if let percentage = Double(datum.percentage) {
                let entry = PieChartDataEntry(value: percentage, label: datum.label)
                entries.append(entry)
            }
        }
        let dataSet = PieChartDataSet(entries: entries, label: "Portfolio")
        dataSet.colors = ChartColorTemplates.material()
        
        dataSet.valueFormatter = PercentageValueFormatter()
        
        let pieData = PieChartData(dataSet: dataSet)
        pieChartView.data = pieData
        pieChartView.legend.enabled = false
        pieChartView.delegate = self
    }
    
    func setupLineChart() {
        guard let lineChartData = self.lineChartData else { return }
        
        var entries: [ChartDataEntry] = []
        for (index, value) in lineChartData.data.month.enumerated() {
            let entry = ChartDataEntry(x: Double(index+1), y: Double(value))
            entries.append(entry)
        }
        let dataSet = LineChartDataSet(entries: entries, label: "Monthly Data")
        
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.circleColors = [NSUIColor.systemBlue]
        dataSet.circleRadius = 3.0
        dataSet.lineWidth = 2.0
        dataSet.mode = .cubicBezier
        dataSet.valueFont = .systemFont(ofSize: 12)
        dataSet.valueFormatter = NoDecimalValueFormatter()
         
        let lineChartDataSet = LineChartData(dataSet: dataSet)
        lineChartView.data = lineChartDataSet
         
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.granularity = 1.0
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.axisMinimum = 0
        lineChartView.xAxis.axisMaximum = 12
        lineChartView.xAxis.labelCount = entries.count
        lineChartView.xAxis.forceLabelsEnabled = true
        
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.granularity = 1.0
        lineChartView.leftAxis.granularityEnabled = true
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.labelCount = entries.count
        lineChartView.leftAxis.forceLabelsEnabled = true
        
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.chartDescription.enabled = false
    }
}

class PercentageValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.1f%%", value)
    }
}

class NoDecimalValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.0f", value)
    }
}

extension PortfolioViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let pieEntry = entry as? PieChartDataEntry, let donutChartData = self.donutChartData,
              let index = pieChartView.data?.dataSets.first?.entryIndex(entry: pieEntry),
              index >= 0 && index < donutChartData.data.count else { return }
        
        let selectedData = donutChartData.data[index]
        self.didSelectTransactionRelay.accept(selectedData)
    }
}
