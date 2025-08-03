//
//  ColumnModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import Foundation

struct Column: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String?
//    var subtitle: String?
    var url: String?
    var thumbnailUrl: String?
    
    static let empty: Column = .init(id: UUID(), title: nil, url: nil, thumbnailUrl: nil)
    
    static let placeholder: Column = .init(
        id: UUID(),
        title: "노원구, 빈교실을 문화예술 힐링공간으로 '뚝딱'",
        url: "https://www.sijung.co.kr/news/articleView.html?idxno=260248",
        thumbnailUrl: "https://cdn.sijung.co.kr/news/photo/202102/260248_85120_5921.jpg"
    )
}
