//
//  ApilogWidget.swift
//  ApilogWidget
//
//  Created by dohankim on 2022/07/28.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),content: "실수노트를 추가해주세요")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),content : "실수노트를 추가해주세요")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        var contentString = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "content")
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, content: contentString ?? "실수노트를 추가해주세요.")
        let timeline = Timeline(
            entries:[entry],
            policy: .atEnd
        )
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let content : String
}

struct ApilogWidgetEntryView : View {
    var entry: Provider.Entry
    var contentString = "생성된 문장이 없습니다."
    //위젯 크기에 따라 분기
    @Environment(\.widgetFamily) private var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            ZStack{
                Color.white
                VStack{
                    Rectangle()
                        .fill(Color("AccentColor"))
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.06)
                    Line()
                        .stroke(.green,style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(height: 1)
                    Text(entry.content)
                        .frame(width: 120, alignment: .center)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        
                    Spacer()
                    HStack{
                        Text(entry.date.DateToString())
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding([.trailing],45)
                            .padding(.bottom,10)
                        
                    }
                    
                }
            }
            .frame(width: 158, height: 158, alignment: .center)
            .widgetURL(URL(string: "Apillog://DiaryView"))
        case .systemMedium:
            
            ZStack{
                Color.red
            }
        case .systemLarge:
            ZStack{
                Color.black
            }
        case .systemExtraLarge:
            ZStack{
                Color.red
            }
        @unknown default:
            ZStack{
                Color.green
            }
        }
    }
}

@main
struct ApilogWidget: Widget {
    let kind: String = "ApilogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ApilogWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Apillog")
        .description("실수노트 바로가기")
        .supportedFamilies([.systemSmall])
//      추후 업데이트 예정 .supportedFamilies([.systemSmall,.systemMedium,.systemLarge])
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

extension Date{
    func DateToString()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: self)
    }
}
