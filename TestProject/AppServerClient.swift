//
//  AppServerClient.swift
//  TestProject
//
//  Created by Рома Комаров on 09/09/2019.
//  Copyright © 2019 Рома Комаров. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

class AppServerClient {
    enum GetWeatherFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    func getWeather() -> Observable<CurrentWeather> {
        return Observable.create { observer -> Disposable in
            AF.request("http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&APPID=ec2f966be112bd5e75ae23878e7457da")
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? GetWeatherFailureReason.notFound)
                            return
                        }
                        do {
                            let decoder = JSONDecoder()
                            let weatherResponse = try decoder.decode(CurrentWeather.self, from: data)
                            observer.onNext(weatherResponse)
                        }
                        catch let error {
                            observer.onError(error)
                            print("error\(error)")
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = GetWeatherFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }
    
//    func alertView() -> UIAlertController {
//        let alertController = UIAlertController(title: "Погода", message: "На \(self.date) в городе \(self.city) температура \(self.temp) C", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
//        return alertController
//    }
}
