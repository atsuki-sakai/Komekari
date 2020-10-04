//
//  Prefectures.swift
//  KomekariProject
//
//  Created by 酒井専冴 on 2020/10/02.
//

import Foundation

enum Prefectures: Int, CustomStringConvertible, CaseIterable{
    case 北海道
    case 青森
    case 秋田
    case 岩手
    case 山形
    case 宮城
    case 福島
    case 新潟
    case 山梨
    case 静岡
    case 富山
    case 長野
    case 岐阜
    case 石川
    case 福井
    case 茨城
    case 千葉
    case 埼玉
    case 東京
    case 神奈川
    case 群馬
    case 栃木
    case 滋賀
    case 三重
    case 京都
    case 奈良
    case 和歌山
    case 大阪
    case 兵庫
    case 鳥取
    case 岡山
    case 島根
    case 広島
    case 山口
    case 香川
    case 愛媛
    case 徳島
    case 高知
    case 福岡
    case 大分
    case 佐賀
    case 長崎
    case 熊本
    case 宮崎
    case 鹿児島
    case 沖縄
    
    var description: String {
        switch self {
        case .北海道: return "北海道"
        case .青森: return "青森"
        case .秋田: return "秋田"
        case .岩手: return "岩手"
        case .山形: return "山形"
        case .宮城: return "宮城"
        case .福島: return "福島"
        case .新潟: return "新潟"
        case .山梨: return "山梨"
        case .静岡: return "静岡"
        case .富山: return "富山"
        case .長野: return "長野"
        case .岐阜: return "岐阜"
        case .石川: return "石川"
        case .福井: return "福井"
        case .茨城: return "茨城"
        case .千葉: return "千葉"
        case .埼玉: return "埼玉"
        case .東京: return "東京"
        case .神奈川: return "神奈川"
        case .群馬: return "群馬"
        case .栃木: return "栃木"
        case .滋賀: return "滋賀"
        case .三重: return "三重"
        case .京都: return "京都"
        case .奈良: return "奈良"
        case .和歌山: return "和歌山"
        case .大阪: return "大阪"
        case .兵庫: return "兵庫"
        case .鳥取: return "鳥取"
        case .岡山: return "岡山"
        case .島根: return "島根"
        case .広島: return "広島"
        case .山口: return "山口"
        case .香川: return "香川"
        case .愛媛: return "愛媛"
        case .徳島: return "徳島"
        case .高知: return "高知"
        case .福岡: return "福岡"
        case .大分: return "大分"
        case .佐賀: return "佐賀"
        case .長崎: return "長崎"
        case .熊本: return "熊本"
        case .宮崎: return "宮崎"
        case .鹿児島: return "鹿児島"
        case .沖縄: return "沖縄"
        }
    }
}
