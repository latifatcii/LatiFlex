//
//  LatiFlexDeeplinkResponse.swift
//  LatiFlex
//
//  Created by Abdüllatif Atçı on 24.07.2022.
//  Copyright © 2022 Trendyol. All rights reserved.
//

public final class LatiFlexDeeplinksResponse: Decodable {
    let deeplinkList: [Deeplinks]
    
    init(deeplinkList: [Deeplinks]) {
        self.deeplinkList = deeplinkList
    }
}

public final class Deeplinks: Decodable {
    let domainName: String
    var deeplinks: [DeeplinkList]
    
    init(domainName: String, deeplinks: [DeeplinkList]) {
        self.domainName = domainName
        self.deeplinks = deeplinks
    }
}

public final class DeeplinkList: Decodable {
    let name: String
    let deeplink: String
    
    init(name: String, deeplink: String) {
        self.name = name
        self.deeplink = deeplink
    }
}
