//
//  ParcelV2Widget.swift
//  ParcelV2Widget
//
//  Created by Milkyo on 6/24/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> ParcelEntry {
        ParcelEntry(configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ParcelEntry) -> ()) {
        Task {
            guard let parcel = try? await APIClient.shared.getParcel() else {
                completion(ParcelEntry(configuration: configuration))
                return
            }
            let entry = ParcelEntry(parcel: parcel, configuration: configuration)
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            Swift.print("## Called")
            guard let parcel = try? await APIClient.shared.getParcel(),
                  let nextDate = Calendar.current.date(bySetting: .hour, value: 1, of: Date()) else {
                completion(Timeline(entries: [ParcelEntry(configuration: configuration)], policy: .atEnd))
                return
            }
            
            let entry = ParcelEntry(date: Date(), parcel: parcel, configuration: configuration)
            let timeline = Timeline(entries: [entry], policy: .after(nextDate))
            completion(timeline)
        }
    }
}

struct ParcelEntry: TimelineEntry {
    let date: Date
    let parcel: Parcel?
    let configuration: ConfigurationIntent
    
    init(
        date: Date = Date(),
        parcel: Parcel? = nil,
        configuration: ConfigurationIntent
    ) {
        self.date = date
        self.parcel = parcel
        self.configuration = configuration
    }
}

struct ParcelV2WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        if let parcel = entry.parcel {
            VStack {
                if let date = dateToString(entry.date) {
                    HStack {
                        Text("업데이트시간: \(date)")
                            .font(.system(size: 8))
                        Spacer()
                    }
                }
                
                Spacer()
                if let item = parcel.item {
                    Text(item)
                }
                Text(parcel.state.text)
                Spacer()
            }
            .padding([.all], 16)
        }
    }
    
    func dateToString(_ date: Date) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    func convert(type: String)  -> DeliveryDTO? {
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
    
    func convertToWrapper(_ data: [Parcel.Progress]) -> [ProgressWrapper] {
        return data.map { ProgressWrapper(time: $0.time, status: $0.status, location: $0.location, description: $0.description)}
    }
}

struct ParcelV2Widget: Widget {
    let kind: String = "ParcelV2Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ParcelV2WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
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
