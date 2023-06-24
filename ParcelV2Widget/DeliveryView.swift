//
//  DeliveryView.swift
//  ParcelV2
//
//  Created by 강동영 on 2023/06/24.
//

import SwiftUI

struct DeliveryView : View {
    let parcel: Parcel
    
    var body: some View {
        HStack {
            ForEach(convertToWrapper(parcel.progresses), id: \.id) { context in
                if let convertedDTO = convert(type: context.status.id) {
                    VStack {
                        Image(systemName: convertedDTO.imageString)
                        Text(convertedDTO.text)
                    }
                }
            }
        }
    }
    
    private func convert(type: String)  -> DeliveryDTO? {
        if "information_received" == type {
            return .ready
        } else if "at_pickup" == type || "in_transit" == type {
            return .moving
        } else if "out_for_delivery" == type {
            return .deliveringStart
        } else if "delivered" == type {
            return .delivered
        }
        
        return nil
    }
    
    private func convertToWrapper(_ data: [Parcel.Progress]) -> [ProgressWrapper] {
        return data.map { ProgressWrapper(time: $0.time, status: $0.status, location: $0.location, description: $0.description)}
    }
    
    enum DeliveryDTO: String {
        case ready// information_received //상품준비중
        case moving// at_pickup, in_transit //상품인수, 상품이동 중 → 이동중
        case deliveringStart// out_for_delivery //배송출발
        case delivered// delivered //배송완료

        
        var stateID: String {
            switch self {
            case .ready:
                return "information_received"
            case .moving:
                return "at_pickup"  // "in_transit"
            case .deliveringStart:
                return "out_for_delivery"
            case .delivered:
                return "delivered"
            }
        }
        
        var imageString: String {
            switch self {
            case .ready:
                return "shippingbox"
            case .moving:
                return "box.truck"
            case .deliveringStart:
                return "box.truck"
            case .delivered:
                return "house"
            }
        }
        
        var text: String {
            switch self {
            case .ready:
                return "상품준비중"
            case .moving:
                return "이동중"
            case .deliveringStart:
                return "배송출발"
            case .delivered:
                return "배송완료"
            }
        }
    }
}
