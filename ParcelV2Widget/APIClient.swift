//
//  APIClient.swift
//  ParcelV2
//
//  Created by Milkyo on 6/24/23.
//

import Foundation
import WidgetKit

final class APIClient {
  static var shared = APIClient()

  private func requestData(urlRequest: URLRequest) async throws -> Parcel {
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    let jsonData = try JSONDecoder().decode(Parcel.self, from: data)
    return jsonData
  }

  func getParcel() async throws -> Parcel? {
      
      if let invoiceNumber = UserDefaults.shared.string(forKey: "invoiceNumber") {
          let url = URL(string: "https://apis.tracker.delivery/carriers/kr.kdexp/tracks/\(invoiceNumber)")!
          var urlRequest = URLRequest(url: url)
          urlRequest.httpMethod = "GET"
          return try await requestData(urlRequest: urlRequest)
      } else {
          let url = URL(string: "https://apis.tracker.delivery/carriers/kr.kdexp/tracks/3112331831600")!
          var urlRequest = URLRequest(url: url)
          urlRequest.httpMethod = "GET"
          return try await requestData(urlRequest: urlRequest)
      }
  }
}
