//
//  ViewController.swift
//  07. 날씨 앱 만들기
//
//  Created by YHChoi on 2022/05/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfCityName: UITextField!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherStackView.alpha = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func btnFetchWeather(_ sender: UIButton) {
        if let cityName = self.tfCityName.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=77f5f0cf0837ddf5012ed9786f9ebb82") else { return }
        // URLsession에 해당 url을 넘겨줘 api 호출할 것임
        // 먼저 session configuration을 결정한 후에 session 생성함
        let session = URLSession(configuration: .default)  // default : 기본세션이 되게 설정
        // 서버로 데이터 요청하고 응답을 받을 것임
        session.dataTask(with: url) { [weak self] data, response, error in  // dataTask가 api를 호출하고 서버에서 응답이 오면
                                                                // 다음 {} 핸들러가 호출되는데, 핸들러 안에
                                                                // data: 서버에서 응답받은 data가 저장되고,
                                                                // response: http 해더 및 상태코드와 같은 응답 데이터가 전달되고
                                                                // error: 요청 실패시 에러 객체가 전달됨, 요청 성공 시 nil 반환
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            
            //에러 message 처리
            let successRange = (200..<300)  // error가 아닌 코드
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                // 네트워크 작업은 별도의 쓰레드에서 작업되고, 응답이 온다고 해도 자동으로 메인 쓰레드로 오지 않기 때문에 UI작업을 위해 메인 쓰레드에서 작업을 할 수 있도록 만들어 줘야 함
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.weatherStackView.alpha = 1
                    })
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                // ui 매소드는 메인 쓰레들에서 처리
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.lblCityName.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {  //
            self.lblWeatherDescription.text = weather.description
        }
        self.lblCurrentTemp.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.lblMinTemp.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.lblMaxTemp.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
        self.lblHumidity.text = "습도: \(Int(weatherInformation.temp.humidity))%"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


