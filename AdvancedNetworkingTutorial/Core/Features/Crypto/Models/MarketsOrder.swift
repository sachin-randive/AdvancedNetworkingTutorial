//
//  MarketsOrder.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 01/07/26.
//

import Foundation

enum MarketsOrder: String, CaseIterable {
    case marketCapDesc = "market_cap_desc"
    case marketCapAsc = "market_cap_asc"
    case volumeDesc = "volume_desc"
    case volumeAsc = "volume_asc"
    case idAsc = "id_asc"
    case idDesc = "id_desc"
    case geckoDesc = "gecko_desc"
    case geckoAsc = "gecko_asc"
    case developerScoreDesc = "developer_score_desc"
    case developerScoreAsc = "developer_score_asc"
    case communityScoreDesc = "community_score_desc"
    case communityScoreAsc = "community_score_asc"
    case publicInterestDesc = "public_interest_desc"
    case publicInterestAsc = "public_interest_asc"
}
