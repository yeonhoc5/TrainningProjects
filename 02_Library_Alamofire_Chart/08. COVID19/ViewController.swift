//
//  ViewController.swift
//  08. COVID19
//
//  Created by YHChoi on 2022/05/16.
//

import UIKit
import Alamofire
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var lblTotalCase: UILabel!
    @IBOutlet weak var lblNewCase: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // indicator 스타트
        self.indicatorView.startAnimating()
        fetchOverview()
    }

    func fetchOverview() {
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            // indicator 정지 및 내용 보여주기
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.stackView.isHidden = false
            self.pieChartView.isHidden = false
            
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverviewList: covidOverviewList)
                
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.lblTotalCase.text = "\(koreaCovidOverview.totalCase)명"
        self.lblNewCase.text = "\(koreaCovidOverview.newCase)명"
    }

    func makeCovidOverviewList(cityCovidOverview:CityCovidOverview) -> [CovidOverview] {
        return [cityCovidOverview.seoul,
                cityCovidOverview.busan,
                cityCovidOverview.daegu,
                cityCovidOverview.incheon,
                cityCovidOverview.gwangju,
                cityCovidOverview.daejeon,
                cityCovidOverview.ulsan,
                cityCovidOverview.sejong,
                cityCovidOverview.gyeonggi,
                cityCovidOverview.chungbuk,
                cityCovidOverview.chungnam,
                cityCovidOverview.gyeongbuk,
                cityCovidOverview.gyeongnam,
                cityCovidOverview.jeju]
    }
    
    func configureChartView(covidOverviewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.valueTextColor = .black
        dataSet.colors = ChartColorTemplates.vordiplom()
                        + ChartColorTemplates.joyful()
                        + ChartColorTemplates.liberty()
                        + ChartColorTemplates.pastel()
                        + ChartColorTemplates.material()
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3,
                               fromAngle: self.pieChartView.rotationAngle,
                               toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    // json에서 숫자들 사이에 콤마(,) 있는 것을 double 타입으로 변환시키기
    func removeFormatString(string: String) -> Double{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }

    func fetchCovidOverview(completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = ["serviceKey": "9Ei8rd4UBgvuhnRCoAsDp6w5zyXZOa32j"]
        
        AF.request(url, method: .get, parameters: param).responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
}


extension ViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailVeiwController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailVeiwController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailVeiwController, animated: true)
    }
    
}
