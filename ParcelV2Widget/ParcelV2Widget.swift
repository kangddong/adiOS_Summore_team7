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
            DeliveryView(parcel: parcel)
        } else {
            Text("no data")
        }
    }
    
    func dateToString(_ date: Date) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
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
