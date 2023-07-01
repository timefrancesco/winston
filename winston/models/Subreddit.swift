//
//  SubredditData.swift
//  winston
//
//  Created by Igor Marcossi on 26/06/23.
//

import Foundation
import Defaults


typealias Subreddit = GenericRedditEntity<SubredditData>

extension Subreddit {
  init(data: T, api: RedditAPI) {
      self.init(data: data, api: api, typePrefix: "t5_")
  }
  
  init(id: String, api: RedditAPI) {
      self.init(id: id, api: api, typePrefix: "t5_")
  }
  
  mutating func refreshSubreddit() async {
    self.loading = true
    if let displayName = data?.display_name, let data = (await redditAPI.fetchSub(displayName))?.data {
      self.data = data
    }
    self.loading = false
  }
  
  func fetchPosts(sort: SubListingSortOption = .hot, after: String? = nil) async -> ([Post]?, String?)? {
    if let url = data?.url, let response = await redditAPI.fetchSubPosts(url, sort: sort, after: after), let data = response.0 {
      return (data.map { x in Post(data: x.data, api: redditAPI) }, response.1)
    }
    return nil
  }
  
  mutating func toggleSubscribing(action: RedditAPI.SubscribeSubAction) async -> Bool? {
    let oldValue = data?.user_is_subscriber
    data?.user_is_subscriber = action == .sub ? true : false
    let result = await redditAPI.subscribeSubs(action: (data?.user_is_subscriber ?? false) ? .unsub : .sub, subs: [id])
    if let oldValue = oldValue, result == nil || !result! {
      data?.user_is_subscriber = oldValue
    }
    return result
  }
}

struct SubredditData: GenericRedditEntityDataType {
  let user_flair_background_color: String?
  let submit_text_html: String?
  let restrict_posting: Bool
  let user_is_banned: Bool
  let free_form_reports: Bool
  let wiki_enabled: Bool?
  let user_is_muted: Bool
  let user_can_flair_in_sr: Bool?
  let display_name: String
  let header_img: String?
  let title: String
  let allow_galleries: Bool
  let icon_size: [Int]?
  let primary_color: String
  let active_user_count: Int?
  let icon_img: String
  let display_name_prefixed: String
  let accounts_active: Int?
  let public_traffic: Bool
  let subscribers: Int
  //      let user_flair_richtext: [String]?
  let name: String
  let quarantine: Bool
  let hide_ads: Bool
  let prediction_leaderboard_entry_type: String
  let emojis_enabled: Bool
  let advertiser_category: String
  let public_description: String
  let comment_score_hide_mins: Int
  let allow_predictions: Bool
  let user_has_favorited: Bool
  let user_flair_template_id: String?
  let community_icon: String
  let banner_background_image: String
  let original_content_tag_enabled: Bool
  let community_reviewed: Bool
  let submit_text: String
  let description_html: String?
  let spoilers_enabled: Bool
  let comment_contribution_settings: CommentContributionSettings
  let allow_talks: Bool
  let header_size: [Int]?
  let user_flair_position: String
  let all_original_content: Bool
  let has_menu_widget: Bool
  let is_enrolled_in_new_modmail: Bool?
  let key_color: String
  let can_assign_user_flair: Bool
  let created: Double
  let wls: Int?
  let show_media_preview: Bool
  let submission_type: String
  var user_is_subscriber: Bool
  let allowed_media_in_comments: [String]
  let allow_videogifs: Bool
  let should_archive_posts: Bool
  let user_flair_type: String
  let allow_polls: Bool
  let collapse_deleted_comments: Bool
  let emojis_custom_size: [Int]?
  let public_description_html: String
  let allow_videos: Bool
  let is_crosspostable_subreddit: Bool?
  let notification_level: String
  let should_show_media_in_comments_setting: Bool
  let can_assign_link_flair: Bool
  let accounts_active_is_fuzzed: Bool
  let allow_prediction_contributors: Bool
  let submit_text_label: String
  let link_flair_position: String
  let user_sr_flair_enabled: Bool?
  let user_flair_enabled_in_sr: Bool
  let allow_chat_post_creation: Bool
  let allow_discovery: Bool
  let accept_followers: Bool
  let user_sr_theme_enabled: Bool
  let link_flair_enabled: Bool
  let disable_contributor_requests: Bool
  let subreddit_type: String
  let suggested_comment_sort: String?
  let banner_img: String
  let user_flair_text: String?
  let banner_background_color: String
  let show_media: Bool
  let id: String
  let user_is_moderator: Bool
  let over18: Bool
  let header_title: String
  let description: String
  let is_chat_post_feature_enabled: Bool
  let submit_link_label: String
  let user_flair_text_color: String?
  let restrict_commenting: Bool
  let user_flair_css_class: String?
  let allow_images: Bool
  let lang: String
  let whitelist_status: String?
  let url: String
  let created_utc: Double
  let banner_size: [Int]?
  let mobile_banner_image: String
  let user_is_contributor: Bool
  let allow_predictions_tournament: Bool
}

struct CommentContributionSettings: Codable, Hashable {
  let allowed_media_types: [String]?
}

struct SubListingSort: Codable, Identifiable {
  var icon: String
  var value: String
  var id: String {
    value
  }
}

enum SubListingSortOption: Codable, CaseIterable, Identifiable, Defaults.Serializable {
  var id: String {
    self.rawVal.id
  }
  
  case hot
  case new
  case top
  
  var rawVal: SubListingSort {
    switch self {
    case .hot:
      return SubListingSort(icon: "flame.fill", value: "hot")
    case .new:
      return SubListingSort(icon: "newspaper.fill", value: "new")
    case .top:
      return SubListingSort(icon: "arrow.up.forward.app.fill", value: "top")
    }
  }
}