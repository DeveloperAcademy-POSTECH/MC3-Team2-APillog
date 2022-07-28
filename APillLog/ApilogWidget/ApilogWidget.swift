//
//  ApilogWidget.swift
//  ApilogWidget
//
//  Created by dohankim on 2022/07/28.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @Environment(\.widgetFamily) private var widgetFamily
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),content : "실수노트를 추가해주세요",morningData1: "콘서타",morningData2: "인데놀정",lunchData1: "콘서타",lunchData2: "인데놀정",dinnerData1: "콘서타",dinnerData2: "인데놀정")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
            let entry = SimpleEntry(date: Date(),content : "실수노트를 추가해주세요",morningData1: "콘서타",morningData2: "인데놀정",lunchData1: "콘서타",lunchData2: "인데놀정",dinnerData1: "콘서타",dinnerData2: "인데놀정")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let contentString = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "content")
        let morningPill1 = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "morning1")
        let morningPill2 = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "morning2")
        let lunchPill1 = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "lunch1")
        let lunchPill2 = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "lunch2")
        let dinnerPill1 = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "dinner1")
        let dinnerPill2 = UserDefaults(suiteName: "group.com.varcode.APillLog.ApilogWidget")!.string(forKey: "dinner2")
        let entry = SimpleEntry(date: Date(),content : contentString ?? "실수노트를 추가해 주세요",morningData1: morningPill1 ?? "",morningData2: morningPill2 ?? "",lunchData1: lunchPill1 ?? "",lunchData2: lunchPill2 ?? "",dinnerData1: dinnerPill1 ?? "",dinnerData2: dinnerPill2 ?? "")
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
    let morningData1 : String
    let morningData2 : String
    let lunchData1 : String
    let lunchData2 : String
    let dinnerData1 : String
    let dinnerData2 : String
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
        case .systemLarge:
            ZStack{
                Color.white
                VStack{
                    Rectangle()
                        .fill(Color("AccentColor"))
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.06)
                        .ignoresSafeArea()
                    Line()
                        .stroke(.green,style: StrokeStyle(lineWidth: 1, dash: [3]))
                        .frame(height: 1)
                    VStack{
                        HStack{
                            Text("아침").font(.headline)
                                .padding(.bottom,3)
                            Spacer()
                        }
                        HStack{
                            Text(entry.morningData1)
                                .padding([.leading],10)
                                .padding(.bottom,1)
                            Spacer()
                        }
                        HStack{
                            Text(entry.morningData2)
                                .padding([.leading],10)
                                .padding(.bottom,10)
                            Spacer()
                        }
                    }
                    .padding(.leading,40)
                    VStack{
                        HStack{
                            Text("점심").font(.headline)
                                .padding(.bottom,3)
                            Spacer()
                        }
                        HStack{
                            Text(entry.lunchData1)
                                .padding([.leading],10)
                                .padding(.bottom,1)
                            Spacer()
                        }
                        HStack{
                            Text(entry.lunchData2)
                                .padding([.leading,.bottom],10)
                            Spacer()
                        }
                       
                        
                    }
                    .padding(.leading,40)
                    VStack{
                        HStack{
                            Text("저녁").font(.headline)
                                .padding(.bottom,3)
                            Spacer()
                        }
                        HStack{
                            Text(entry.dinnerData1)
                                .padding([.leading],10)
                                .padding(.bottom,1)
                            Spacer()
                        }
                        HStack{
                            Text(entry.dinnerData2)
                                .padding([.leading,.bottom],10)
                            Spacer()
                        }
                    }
                    .padding(.leading,40)
                    Spacer()
                        
                }
                
                .ignoresSafeArea()
            }
        case .systemMedium:
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
        .supportedFamilies([.systemSmall,.systemLarge])
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

//struct ApillogWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        ApilogWidgetEntryView(entry: SimpleEntry(date: Date(),content : "실수노트를 추가해주세요",morningData1: "콘서타",morningData2: "인데놀정",lunchData1: "콘서타",lunchData2: "인데놀정",dinnerData1: "콘서타",dinnerData2: "인데놀정"))
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
//    }
//}

