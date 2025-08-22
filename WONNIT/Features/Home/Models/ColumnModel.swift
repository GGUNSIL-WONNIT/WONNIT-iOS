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
    
    var resolvedUrl: URL? {
        guard let url = url else { return nil }
        return URL(string: url)
    }
    
    var resolvedThumbnailUrl: URL? {
        guard let url = thumbnailUrl else { return nil }
        return URL(string: url)
    }
    
    static let empty: Column = .init(id: UUID(), title: nil, url: nil, thumbnailUrl: nil)
    
    static let placeholder: Column = .init(
        id: UUID(),
        title: "노원구, 빈교실을 문화예술\n힐링공간으로 '뚝딱'",
        url: "https://www.sijung.co.kr/news/articleView.html?idxno=260248",
        thumbnailUrl: "https://cdn.sijung.co.kr/news/photo/202102/260248_85119_5821.jpg"
    )
    
    static let defaultList: [Column] = [
        .init(
            id: UUID(),
            title: "노원구, 빈교실을 문화예술\n힐링공간으로 '뚝딱'",
            url: "https://www.sijung.co.kr/news/articleView.html?idxno=260248",
            thumbnailUrl: "https://cdn.sijung.co.kr/news/photo/202102/260248_85120_5921.jpg"
        ),
        .init(
            id: UUID(),
            title: "버려진 공간을 문화로 채우다.\n유휴공간 문화재생사업",
            url: "https://kukak21.com/bbs/board.php?bo_table=news&wr_id=34377",
            thumbnailUrl: "https://www.kukak21.com/data/editor/2308/20230821152319_1336f8b47278baf72f3527070e16c2cc_4f88.jpg"
        ),
        .init(
            id: UUID(),
            title: "삶이 예술이 되는 공간\n유휴공간 문화재생",
            url: "http://iksannews.com/default/index_view_page.php?part_idx=243&idx=47440",
            thumbnailUrl: "https://images.unsplash.com/photo-1597681317170-9a0f5a350454?q=80&w=4140&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        )
    ]
}
