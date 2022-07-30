//
//  APillLog+Font.swift
//  APillLog
//
//  Created by Yeni Hwang on 2022/07/18.
//

import UIKit

// 폰트 적용 예시
// UILabel.font = UIFont.AFont.tableViewBody

enum AppleSDGothicNeoWeight: String {
    case ultraLight = "AppleSDGothicNeoUL00"
    case thin = "AppleSDGothicNeoT00"
    case light = "AppleSDGothicNeoL00"
    case regular = "AppleSDGothicNeoR00"
    case medium = "AppleSDGothicNeoM00"
    case semiBold = "AppleSDGothicNeoSB00"
    case bold = "AppleSDGothicNeoB00"
    case extraBold = "AppleSDGothicNeoEB00"
    case heavy = "AppleSDGothicNeoH00"
}

private let customFonts: [UIFont.TextStyle: UIFont] = [
    .largeTitle: UIFont(name: "AppleSDGothicNeoB00", size: 24)!,
    .title1: UIFont(name: "AppleSDGothicNEOB00", size: 20)!,
    .title2: UIFont(name: "AppleSDGothicNEOB00", size: 18)!,
    .title3: UIFont(name: "AppleSDGothicNEOB00", size: 17)!,
    .headline: UIFont(name: "AppleSDGothicNEOEB00", size: 17)!,
    .body: UIFont(name: "AppleSDGothicNeoR00", size: 16)!,
    .callout: UIFont(name: "AppleSDGothicNeoR00", size: 15)!,
    .subheadline: UIFont(name: "AppleSDGothicNeoR00", size: 15)!,
    .footnote: UIFont(name: "AppleSDGothicNeoB00", size: 12)!,      // MedicationView Pill Button
    .caption1: UIFont(name: "AppleSDGothicNeoL00", size: 14)!,
    .caption2: UIFont(name: "AppleSDGothicNeoL00", size: 12)!
]

extension UIFont {
    // 기기 폰트 사이즈 대응하도록 Scale 조정
    private static func APillLogFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        let customFont = customFonts[style]!
        let metrics = UIFontMetrics(forTextStyle: style)
        let scaledFont = metrics.scaledFont(for: customFont)
        
        return scaledFont
    }
    
    // 필요한 폰트 종류는 여기에 추가하기
    enum AFont {
        static var thanksToTitle: UIFont{ UIFont.APillLogFont(forTextStyle: .title3)}
        static var thanksToName: UIFont{ UIFont.APillLogFont(forTextStyle: .body)}
        
        static var calenderText: UIFont { UIFont.APillLogFont(forTextStyle: .title1) }
        static var modalViewTitle: UIFont { UIFont.APillLogFont(forTextStyle: .title1) }
        static var halfModalViewTitle: UIFont { UIFont.APillLogFont(forTextStyle: .title1) }
        
        static var navigationTitle: UIFont { UIFont.APillLogFont(forTextStyle: .title2) }
        static var datePickerText: UIFont { UIFont.APillLogFont(forTextStyle: .title2) }
        static var tableViewTitle: UIFont { UIFont.APillLogFont(forTextStyle: .title2) }
        static var navigationButtonDescriptionLabel: UIFont { UIFont.APillLogFont(forTextStyle: .footnote) }
        static var calendarWeekDayFont: UIFont { UIFont.APillLogFont(forTextStyle: .title3) }

        static var cardViewTitle: UIFont { UIFont.APillLogFont(forTextStyle: .title3) }
        static var cardViewPillName: UIFont { UIFont.APillLogFont(forTextStyle: .title3) }
        static var chipTitle: UIFont { UIFont.APillLogFont(forTextStyle: .title3) }
        
        static var tableViewBody: UIFont { UIFont.APillLogFont(forTextStyle: .body) }
        static var searchResult: UIFont { UIFont.APillLogFont(forTextStyle: .body) }
        static var chipText: UIFont { UIFont.APillLogFont(forTextStyle: .body) }
        static var articleBody: UIFont { UIFont.APillLogFont(forTextStyle: .body) }
        
        static var placeholder: UIFont { UIFont.APillLogFont(forTextStyle: .caption1) }
        
        static var buttonTitle: UIFont {
            UIFont.APillLogFont(forTextStyle: .title3)
        }
        static var buttonText: UIFont { UIFont.APillLogFont(forTextStyle: .footnote) }
        
        static var explainText: UIFont { UIFont.APillLogFont(forTextStyle: .caption2) }
        static var segmentedControl: UIFont { UIFont.APillLogFont(forTextStyle: .caption2) }
        static var caption: UIFont { UIFont.APillLogFont(forTextStyle: .caption2) }
        
        static var historyCategory: UIFont { UIFont.APillLogFont(forTextStyle: .body)}
    }
}
