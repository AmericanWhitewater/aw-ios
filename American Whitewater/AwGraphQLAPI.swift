// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum PostType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case journal
  /// single photo post
  case photoPost
  case gaugeObservation
  case checkin
  case comment
  case complaint
  case warning
  case editorComment
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "JOURNAL": self = .journal
      case "PHOTO_POST": self = .photoPost
      case "GAUGE_OBSERVATION": self = .gaugeObservation
      case "CHECKIN": self = .checkin
      case "COMMENT": self = .comment
      case "COMPLAINT": self = .complaint
      case "WARNING": self = .warning
      case "EDITOR_COMMENT": self = .editorComment
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .journal: return "JOURNAL"
      case .photoPost: return "PHOTO_POST"
      case .gaugeObservation: return "GAUGE_OBSERVATION"
      case .checkin: return "CHECKIN"
      case .comment: return "COMMENT"
      case .complaint: return "COMPLAINT"
      case .warning: return "WARNING"
      case .editorComment: return "EDITOR_COMMENT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PostType, rhs: PostType) -> Bool {
    switch (lhs, rhs) {
      case (.journal, .journal): return true
      case (.photoPost, .photoPost): return true
      case (.gaugeObservation, .gaugeObservation): return true
      case (.checkin, .checkin): return true
      case (.comment, .comment): return true
      case (.complaint, .complaint): return true
      case (.warning, .warning): return true
      case (.editorComment, .editorComment): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PostType] {
    return [
      .journal,
      .photoPost,
      .gaugeObservation,
      .checkin,
      .comment,
      .complaint,
      .warning,
      .editorComment,
    ]
  }
}

public struct PostInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - title:  short caption of what is going on 
  ///   - detail:  paragraph description 
  ///   - postType:  post types see https://github.com/AmericanWhitewater/wh2o/wiki/Post-Types
  ///   - postDate:  date of the post 
  ///   - reachId:  reach we are attaching the post to
  ///   - gaugeId:  gauge we attaching thie post to 
  ///   - userId:  who is making the post 
  ///   - metricId:  how is flow estimated, stage? relative can be simply 
  ///   - reading:  actual numerical reading 
  ///   - observation:  relative flow if used with reach_id - too high > 1.0, flowing 0-1, low <0, consider -0.5,.5,1.5 for too low,flowing,too high 
  public init(title: Swift.Optional<String?> = nil, detail: Swift.Optional<String?> = nil, postType: PostType, postDate: String, reachId: Swift.Optional<String?> = nil, gaugeId: Swift.Optional<String?> = nil, userId: Swift.Optional<String?> = nil, metricId: Swift.Optional<Int?> = nil, reading: Swift.Optional<Double?> = nil, observation: Swift.Optional<Double?> = nil) {
    graphQLMap = ["title": title, "detail": detail, "post_type": postType, "post_date": postDate, "reach_id": reachId, "gauge_id": gaugeId, "user_id": userId, "metric_id": metricId, "reading": reading, "observation": observation]
  }

  /// short caption of what is going on
  public var title: Swift.Optional<String?> {
    get {
      return graphQLMap["title"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  /// paragraph description
  public var detail: Swift.Optional<String?> {
    get {
      return graphQLMap["detail"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "detail")
    }
  }

  /// post types see https://github.com/AmericanWhitewater/wh2o/wiki/Post-Types
  public var postType: PostType {
    get {
      return graphQLMap["post_type"] as! PostType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "post_type")
    }
  }

  /// date of the post
  public var postDate: String {
    get {
      return graphQLMap["post_date"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "post_date")
    }
  }

  /// reach we are attaching the post to
  public var reachId: Swift.Optional<String?> {
    get {
      return graphQLMap["reach_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reach_id")
    }
  }

  /// gauge we attaching thie post to
  public var gaugeId: Swift.Optional<String?> {
    get {
      return graphQLMap["gauge_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gauge_id")
    }
  }

  /// who is making the post
  public var userId: Swift.Optional<String?> {
    get {
      return graphQLMap["user_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "user_id")
    }
  }

  /// how is flow estimated, stage? relative can be simply
  public var metricId: Swift.Optional<Int?> {
    get {
      return graphQLMap["metric_id"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "metric_id")
    }
  }

  /// actual numerical reading
  public var reading: Swift.Optional<Double?> {
    get {
      return graphQLMap["reading"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reading")
    }
  }

  /// relative flow if used with reach_id - too high > 1.0, flowing 0-1, low <0, consider -0.5,.5,1.5 for too low,flowing,too high
  public var observation: Swift.Optional<Double?> {
    get {
      return graphQLMap["observation"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "observation")
    }
  }
}

public enum PhotoSectionsType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Rougly a post, section_id refers to a POST ID
  case post
  /// attach to a rapid, section_id is a rapid ID
  case rapid
  /// attach as the header image of a reach, section ID refers to the reach id
  case reach
  /// attach to a reach as a new photo upload, section ID refers to a reach_id
  case gallery
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "POST": self = .post
      case "RAPID": self = .rapid
      case "REACH": self = .reach
      case "GALLERY": self = .gallery
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .post: return "POST"
      case .rapid: return "RAPID"
      case .reach: return "REACH"
      case .gallery: return "GALLERY"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PhotoSectionsType, rhs: PhotoSectionsType) -> Bool {
    switch (lhs, rhs) {
      case (.post, .post): return true
      case (.rapid, .rapid): return true
      case (.reach, .reach): return true
      case (.gallery, .gallery): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PhotoSectionsType] {
    return [
      .post,
      .rapid,
      .reach,
      .gallery,
    ]
  }
}

/// The proper order for photo upload if complicated
/// is to get an ID from PhotoInput, quick uploads can be supported with the postPhoto
public struct PhotoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - caption:  caption of photo 
  ///   - description:  description of photo  
  ///   - postId:  post to attach to  
  ///   - subject:  person or thing in the photo  
  ///   - author:  author of he photo  
  ///   - poiName:  rapid name if free text  
  ///   - poiId:  rapid selected, if null use rapid_name  
  ///   - photoDate
  public init(caption: Swift.Optional<String?> = nil, description: Swift.Optional<String?> = nil, postId: Swift.Optional<String?> = nil, subject: Swift.Optional<String?> = nil, author: Swift.Optional<String?> = nil, poiName: Swift.Optional<String?> = nil, poiId: Swift.Optional<String?> = nil, photoDate: Swift.Optional<String?> = nil) {
    graphQLMap = ["caption": caption, "description": description, "post_id": postId, "subject": subject, "author": author, "poi_name": poiName, "poi_id": poiId, "photo_date": photoDate]
  }

  /// caption of photo
  public var caption: Swift.Optional<String?> {
    get {
      return graphQLMap["caption"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "caption")
    }
  }

  /// description of photo
  public var description: Swift.Optional<String?> {
    get {
      return graphQLMap["description"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  /// post to attach to
  public var postId: Swift.Optional<String?> {
    get {
      return graphQLMap["post_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "post_id")
    }
  }

  /// person or thing in the photo
  public var subject: Swift.Optional<String?> {
    get {
      return graphQLMap["subject"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "subject")
    }
  }

  /// author of he photo
  public var author: Swift.Optional<String?> {
    get {
      return graphQLMap["author"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "author")
    }
  }

  /// rapid name if free text
  public var poiName: Swift.Optional<String?> {
    get {
      return graphQLMap["poi_name"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "poi_name")
    }
  }

  /// rapid selected, if null use rapid_name
  public var poiId: Swift.Optional<String?> {
    get {
      return graphQLMap["poi_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "poi_id")
    }
  }

  public var photoDate: Swift.Optional<String?> {
    get {
      return graphQLMap["photo_date"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photo_date")
    }
  }
}

public final class UserInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query UserInfo {
      me {
        __typename
        uname
        uid
      }
    }
    """

  public let operationName: String = "UserInfo"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("me", type: .nonNull(.object(Me.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap])
    }

    /// Queries the system's idea of the current logged in user
    public var me: Me {
      get {
        return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("uname", type: .nonNull(.scalar(String.self))),
          GraphQLField("uid", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(uname: String, uid: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "User", "uname": uname, "uid": uid])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// User's login name
      public var uname: String {
        get {
          return resultMap["uname"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "uname")
        }
      }

      /// Effective user ID
      public var uid: GraphQLID {
        get {
          return resultMap["uid"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "uid")
        }
      }
    }
  }
}

public final class AlertsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Alerts($page_size: Int!, $reach_id: AWID!, $page: Int!, $gauge_id: AWID, $post_types: [PostType]) {
      posts(
        post_types: $post_types
        reach_id: $reach_id
        gauge_id: $gauge_id
        first: $page_size
        page: $page
        orderBy: [{field: POST_DATE, order: ASC}]
      ) {
        __typename
        paginatorInfo {
          __typename
          lastPage
          currentPage
          total
        }
        data {
          __typename
          id
          title
          post_type
          post_date
          reach_id
          revision
          reach {
            __typename
            id
            river
            section
          }
          detail
          user {
            __typename
            uname
          }
        }
      }
    }
    """

  public let operationName: String = "Alerts"

  public var page_size: Int
  public var reach_id: String
  public var page: Int
  public var gauge_id: String?
  public var post_types: [PostType?]?

  public init(page_size: Int, reach_id: String, page: Int, gauge_id: String? = nil, post_types: [PostType?]? = nil) {
    self.page_size = page_size
    self.reach_id = reach_id
    self.page = page
    self.gauge_id = gauge_id
    self.post_types = post_types
  }

  public var variables: GraphQLMap? {
    return ["page_size": page_size, "reach_id": reach_id, "page": page, "gauge_id": gauge_id, "post_types": post_types]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("posts", arguments: ["post_types": GraphQLVariable("post_types"), "reach_id": GraphQLVariable("reach_id"), "gauge_id": GraphQLVariable("gauge_id"), "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page"), "orderBy": [["field": "POST_DATE", "order": "ASC"]]], type: .object(Post.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: Post? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: Post) -> ResultMap in value.resultMap }])
    }

    /// get posts by id,post_types,reach_id or all three, intended as a search endpoint
    public var posts: Post? {
      get {
        return (resultMap["posts"] as? ResultMap).flatMap { Post(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "posts")
      }
    }

    public struct Post: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PostPaginator"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(paginatorInfo: PaginatorInfo, data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "PostPaginator", "paginatorInfo": paginatorInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Pagination information about the list of items.
      public var paginatorInfo: PaginatorInfo {
        get {
          return PaginatorInfo(unsafeResultMap: resultMap["paginatorInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "paginatorInfo")
        }
      }

      /// A list of Post items.
      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct PaginatorInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PaginatorInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("total", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(lastPage: Int, currentPage: Int, total: Int) {
          self.init(unsafeResultMap: ["__typename": "PaginatorInfo", "lastPage": lastPage, "currentPage": currentPage, "total": total])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Last page number of the collection.
        public var lastPage: Int {
          get {
            return resultMap["lastPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastPage")
          }
        }

        /// Current pagination page.
        public var currentPage: Int {
          get {
            return resultMap["currentPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "currentPage")
          }
        }

        /// Total items available in the collection.
        public var total: Int {
          get {
            return resultMap["total"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "total")
          }
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Post"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
            GraphQLField("post_date", type: .scalar(String.self)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("revision", type: .scalar(Int.self)),
            GraphQLField("reach", type: .object(Reach.selections)),
            GraphQLField("detail", type: .scalar(String.self)),
            GraphQLField("user", type: .object(User.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, postType: PostType, postDate: String? = nil, reachId: String? = nil, revision: Int? = nil, reach: Reach? = nil, detail: String? = nil, user: User? = nil) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "post_type": postType, "post_date": postDate, "reach_id": reachId, "revision": revision, "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }, "detail": detail, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var postType: PostType {
          get {
            return resultMap["post_type"]! as! PostType
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_type")
          }
        }

        public var postDate: String? {
          get {
            return resultMap["post_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_date")
          }
        }

        public var reachId: String? {
          get {
            return resultMap["reach_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "reach_id")
          }
        }

        public var revision: Int? {
          get {
            return resultMap["revision"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "revision")
          }
        }

        public var reach: Reach? {
          get {
            return (resultMap["reach"] as? ResultMap).flatMap { Reach(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "reach")
          }
        }

        public var detail: String? {
          get {
            return resultMap["detail"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detail")
          }
        }

        public var user: User? {
          get {
            return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "user")
          }
        }

        public struct Reach: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Reach"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(Int.self)),
              GraphQLField("river", type: .scalar(String.self)),
              GraphQLField("section", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: Int? = nil, river: String? = nil, section: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Reach", "id": id, "river": river, "section": section])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// ID of reach (see getNextReachID query)
          public var id: Int? {
            get {
              return resultMap["id"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// Name of the river
          public var river: String? {
            get {
              return resultMap["river"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "river")
            }
          }

          /// Name of the section
          public var section: String? {
            get {
              return resultMap["section"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "section")
            }
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uname", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uname: String) {
            self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// User's login name
          public var uname: String {
            get {
              return resultMap["uname"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "uname")
            }
          }
        }
      }
    }
  }
}

public final class PostAlertMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PostAlert($id: ID!, $post: PostInput!) {
      postUpdate(id: $id, post: $post) {
        __typename
        id
        title
        post_type
        post_date
        reach_id
        reach {
          __typename
          id
          river
          section
        }
        detail
        user {
          __typename
          uname
        }
      }
    }
    """

  public let operationName: String = "PostAlert"

  public var id: GraphQLID
  public var post: PostInput

  public init(id: GraphQLID, post: PostInput) {
    self.id = id
    self.post = post
  }

  public var variables: GraphQLMap? {
    return ["id": id, "post": post]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("postUpdate", arguments: ["id": GraphQLVariable("id"), "post": GraphQLVariable("post")], type: .object(PostUpdate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postUpdate: PostUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "postUpdate": postUpdate.flatMap { (value: PostUpdate) -> ResultMap in value.resultMap }])
    }

    /// send a post up with a UUID
    public var postUpdate: PostUpdate? {
      get {
        return (resultMap["postUpdate"] as? ResultMap).flatMap { PostUpdate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "postUpdate")
      }
    }

    public struct PostUpdate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Post"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
          GraphQLField("post_date", type: .scalar(String.self)),
          GraphQLField("reach_id", type: .scalar(String.self)),
          GraphQLField("reach", type: .object(Reach.selections)),
          GraphQLField("detail", type: .scalar(String.self)),
          GraphQLField("user", type: .object(User.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, title: String? = nil, postType: PostType, postDate: String? = nil, reachId: String? = nil, reach: Reach? = nil, detail: String? = nil, user: User? = nil) {
        self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "post_type": postType, "post_date": postDate, "reach_id": reachId, "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }, "detail": detail, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var postType: PostType {
        get {
          return resultMap["post_type"]! as! PostType
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_type")
        }
      }

      public var postDate: String? {
        get {
          return resultMap["post_date"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_date")
        }
      }

      public var reachId: String? {
        get {
          return resultMap["reach_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "reach_id")
        }
      }

      public var reach: Reach? {
        get {
          return (resultMap["reach"] as? ResultMap).flatMap { Reach(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "reach")
        }
      }

      public var detail: String? {
        get {
          return resultMap["detail"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "detail")
        }
      }

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
        }
      }

      public struct Reach: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Reach"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("river", type: .scalar(String.self)),
            GraphQLField("section", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, river: String? = nil, section: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Reach", "id": id, "river": river, "section": section])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// ID of reach (see getNextReachID query)
        public var id: Int? {
          get {
            return resultMap["id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Name of the river
        public var river: String? {
          get {
            return resultMap["river"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "river")
          }
        }

        /// Name of the section
        public var section: String? {
          get {
            return resultMap["section"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "section")
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uname", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uname: String) {
          self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// User's login name
        public var uname: String {
          get {
            return resultMap["uname"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uname")
          }
        }
      }
    }
  }
}

public final class PhotoUploadWithPropsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PhotoUploadWithProps($id: ID!, $file: Upload, $photoSectionType: PhotoSectionsType, $photoTypeId: AWID, $photoInput: PhotoInput) {
      photoFileUpdate(
        id: $id
        fileinput: {file: $file, section: $photoSectionType, section_id: $photoTypeId}
        photo: $photoInput
      ) {
        __typename
        id
        url
        caption
        description
        geom
        image {
          __typename
          uri {
            __typename
            medium
            big
            thumb
          }
        }
        post {
          __typename
          id
          title
          detail
          uid
          post_date
          revision
          reach_id
          gauge_id
          metric_id
          reading
        }
        poi {
          __typename
          id
          name
          difficulty
          distance
          description
        }
        author
        subject
        revision
        poi_name
        poi_id
        post_id
        photo_date
      }
    }
    """

  public let operationName: String = "PhotoUploadWithProps"

  public var id: GraphQLID
  public var file: String?
  public var photoSectionType: PhotoSectionsType?
  public var photoTypeId: String?
  public var photoInput: PhotoInput?

  public init(id: GraphQLID, file: String? = nil, photoSectionType: PhotoSectionsType? = nil, photoTypeId: String? = nil, photoInput: PhotoInput? = nil) {
    self.id = id
    self.file = file
    self.photoSectionType = photoSectionType
    self.photoTypeId = photoTypeId
    self.photoInput = photoInput
  }

  public var variables: GraphQLMap? {
    return ["id": id, "file": file, "photoSectionType": photoSectionType, "photoTypeId": photoTypeId, "photoInput": photoInput]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("photoFileUpdate", arguments: ["id": GraphQLVariable("id"), "fileinput": ["file": GraphQLVariable("file"), "section": GraphQLVariable("photoSectionType"), "section_id": GraphQLVariable("photoTypeId")], "photo": GraphQLVariable("photoInput")], type: .object(PhotoFileUpdate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(photoFileUpdate: PhotoFileUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "photoFileUpdate": photoFileUpdate.flatMap { (value: PhotoFileUpdate) -> ResultMap in value.resultMap }])
    }

    /// associate a photo with a section and section ID, typically this will be a POST with a post id of the container
    public var photoFileUpdate: PhotoFileUpdate? {
      get {
        return (resultMap["photoFileUpdate"] as? ResultMap).flatMap { PhotoFileUpdate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "photoFileUpdate")
      }
    }

    public struct PhotoFileUpdate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Photo"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("url", type: .scalar(String.self)),
          GraphQLField("caption", type: .scalar(String.self)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("geom", type: .scalar(String.self)),
          GraphQLField("image", type: .object(Image.selections)),
          GraphQLField("post", type: .object(Post.selections)),
          GraphQLField("poi", type: .object(Poi.selections)),
          GraphQLField("author", type: .scalar(String.self)),
          GraphQLField("subject", type: .scalar(String.self)),
          GraphQLField("revision", type: .scalar(Int.self)),
          GraphQLField("poi_name", type: .scalar(String.self)),
          GraphQLField("poi_id", type: .scalar(String.self)),
          GraphQLField("post_id", type: .scalar(String.self)),
          GraphQLField("photo_date", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, url: String? = nil, caption: String? = nil, description: String? = nil, geom: String? = nil, image: Image? = nil, post: Post? = nil, poi: Poi? = nil, author: String? = nil, subject: String? = nil, revision: Int? = nil, poiName: String? = nil, poiId: String? = nil, postId: String? = nil, photoDate: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Photo", "id": id, "url": url, "caption": caption, "description": description, "geom": geom, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }, "post": post.flatMap { (value: Post) -> ResultMap in value.resultMap }, "poi": poi.flatMap { (value: Poi) -> ResultMap in value.resultMap }, "author": author, "subject": subject, "revision": revision, "poi_name": poiName, "poi_id": poiId, "post_id": postId, "photo_date": photoDate])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// could be a video URL, most of the time filename of the last revision BUT DONT USE THIS AS FILENAME, use URI
      public var url: String? {
        get {
          return resultMap["url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      public var caption: String? {
        get {
          return resultMap["caption"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "caption")
        }
      }

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var geom: String? {
        get {
          return resultMap["geom"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "geom")
        }
      }

      /// URL to Image calculated from below for images, use this
      public var image: Image? {
        get {
          return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "image")
        }
      }

      public var post: Post? {
        get {
          return (resultMap["post"] as? ResultMap).flatMap { Post(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "post")
        }
      }

      public var poi: Poi? {
        get {
          return (resultMap["poi"] as? ResultMap).flatMap { Poi(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "poi")
        }
      }

      public var author: String? {
        get {
          return resultMap["author"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "author")
        }
      }

      public var subject: String? {
        get {
          return resultMap["subject"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "subject")
        }
      }

      public var revision: Int? {
        get {
          return resultMap["revision"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "revision")
        }
      }

      public var poiName: String? {
        get {
          return resultMap["poi_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "poi_name")
        }
      }

      public var poiId: String? {
        get {
          return resultMap["poi_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "poi_id")
        }
      }

      public var postId: String? {
        get {
          return resultMap["post_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_id")
        }
      }

      public var photoDate: String? {
        get {
          return resultMap["photo_date"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "photo_date")
        }
      }

      public struct Image: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ImageInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uri", type: .object(Uri.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uri: Uri? = nil) {
          self.init(unsafeResultMap: ["__typename": "ImageInfo", "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var uri: Uri? {
          get {
            return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "uri")
          }
        }

        public struct Uri: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ImageURI"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("medium", type: .scalar(String.self)),
              GraphQLField("big", type: .scalar(String.self)),
              GraphQLField("thumb", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(medium: String? = nil, big: String? = nil, thumb: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "ImageURI", "medium": medium, "big": big, "thumb": thumb])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// typically around 800x600
          public var medium: String? {
            get {
              return resultMap["medium"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "medium")
            }
          }

          /// unconstrained 1-2 MB per load
          public var big: String? {
            get {
              return resultMap["big"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "big")
            }
          }

          /// typically 100x200
          public var thumb: String? {
            get {
              return resultMap["thumb"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "thumb")
            }
          }
        }
      }

      public struct Post: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Post"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("detail", type: .scalar(String.self)),
            GraphQLField("uid", type: .scalar(String.self)),
            GraphQLField("post_date", type: .scalar(String.self)),
            GraphQLField("revision", type: .scalar(Int.self)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("gauge_id", type: .scalar(String.self)),
            GraphQLField("metric_id", type: .scalar(Int.self)),
            GraphQLField("reading", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, uid: String? = nil, postDate: String? = nil, revision: Int? = nil, reachId: String? = nil, gaugeId: String? = nil, metricId: Int? = nil, reading: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "uid": uid, "post_date": postDate, "revision": revision, "reach_id": reachId, "gauge_id": gaugeId, "metric_id": metricId, "reading": reading])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var detail: String? {
          get {
            return resultMap["detail"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detail")
          }
        }

        public var uid: String? {
          get {
            return resultMap["uid"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uid")
          }
        }

        public var postDate: String? {
          get {
            return resultMap["post_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_date")
          }
        }

        public var revision: Int? {
          get {
            return resultMap["revision"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "revision")
          }
        }

        public var reachId: String? {
          get {
            return resultMap["reach_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "reach_id")
          }
        }

        public var gaugeId: String? {
          get {
            return resultMap["gauge_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gauge_id")
          }
        }

        public var metricId: Int? {
          get {
            return resultMap["metric_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "metric_id")
          }
        }

        public var reading: Double? {
          get {
            return resultMap["reading"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "reading")
          }
        }
      }

      public struct Poi: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["POI"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("difficulty", type: .scalar(String.self)),
            GraphQLField("distance", type: .scalar(Double.self)),
            GraphQLField("description", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, name: String? = nil, difficulty: String? = nil, distance: Double? = nil, description: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "POI", "id": id, "name": name, "difficulty": difficulty, "distance": distance, "description": description])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// id used for updates
        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// name of the feature (e.g. rapid name "Pillow Rapid")
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// difficulty of the rapid,
        public var difficulty: String? {
          get {
            return resultMap["difficulty"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "difficulty")
          }
        }

        /// distance in miles from the start of the river, used for sort
        public var distance: Double? {
          get {
            return resultMap["distance"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "distance")
          }
        }

        /// description of the rapid
        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }
      }
    }
  }
}

public final class PhotoPostUpdateMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PhotoPostUpdate($id: ID!, $post: PostInput!) {
      postUpdate(id: $id, post: $post) {
        __typename
        id
        title
        detail
        post_type
        post_date
        revision
        metric_id
        metric {
          __typename
          shortkey
          unit
          name
        }
        reading
        reach_id
        reach {
          __typename
          id
          river
          section
        }
        user {
          __typename
          uname
        }
      }
    }
    """

  public let operationName: String = "PhotoPostUpdate"

  public var id: GraphQLID
  public var post: PostInput

  public init(id: GraphQLID, post: PostInput) {
    self.id = id
    self.post = post
  }

  public var variables: GraphQLMap? {
    return ["id": id, "post": post]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("postUpdate", arguments: ["id": GraphQLVariable("id"), "post": GraphQLVariable("post")], type: .object(PostUpdate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postUpdate: PostUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "postUpdate": postUpdate.flatMap { (value: PostUpdate) -> ResultMap in value.resultMap }])
    }

    /// send a post up with a UUID
    public var postUpdate: PostUpdate? {
      get {
        return (resultMap["postUpdate"] as? ResultMap).flatMap { PostUpdate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "postUpdate")
      }
    }

    public struct PostUpdate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Post"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("detail", type: .scalar(String.self)),
          GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
          GraphQLField("post_date", type: .scalar(String.self)),
          GraphQLField("revision", type: .scalar(Int.self)),
          GraphQLField("metric_id", type: .scalar(Int.self)),
          GraphQLField("metric", type: .object(Metric.selections)),
          GraphQLField("reading", type: .scalar(Double.self)),
          GraphQLField("reach_id", type: .scalar(String.self)),
          GraphQLField("reach", type: .object(Reach.selections)),
          GraphQLField("user", type: .object(User.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, postType: PostType, postDate: String? = nil, revision: Int? = nil, metricId: Int? = nil, metric: Metric? = nil, reading: Double? = nil, reachId: String? = nil, reach: Reach? = nil, user: User? = nil) {
        self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "post_type": postType, "post_date": postDate, "revision": revision, "metric_id": metricId, "metric": metric.flatMap { (value: Metric) -> ResultMap in value.resultMap }, "reading": reading, "reach_id": reachId, "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var detail: String? {
        get {
          return resultMap["detail"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "detail")
        }
      }

      public var postType: PostType {
        get {
          return resultMap["post_type"]! as! PostType
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_type")
        }
      }

      public var postDate: String? {
        get {
          return resultMap["post_date"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_date")
        }
      }

      public var revision: Int? {
        get {
          return resultMap["revision"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "revision")
        }
      }

      public var metricId: Int? {
        get {
          return resultMap["metric_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "metric_id")
        }
      }

      public var metric: Metric? {
        get {
          return (resultMap["metric"] as? ResultMap).flatMap { Metric(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "metric")
        }
      }

      public var reading: Double? {
        get {
          return resultMap["reading"] as? Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "reading")
        }
      }

      public var reachId: String? {
        get {
          return resultMap["reach_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "reach_id")
        }
      }

      public var reach: Reach? {
        get {
          return (resultMap["reach"] as? ResultMap).flatMap { Reach(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "reach")
        }
      }

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
        }
      }

      public struct Metric: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["GaugeReadingMetric"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("shortkey", type: .scalar(String.self)),
            GraphQLField("unit", type: .scalar(String.self)),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(shortkey: String? = nil, unit: String? = nil, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "GaugeReadingMetric", "shortkey": shortkey, "unit": unit, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// quick way of refrencing the metric
        public var shortkey: String? {
          get {
            return resultMap["shortkey"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "shortkey")
          }
        }

        /// abbreviation of unit for humans (e.g. ft)
        public var unit: String? {
          get {
            return resultMap["unit"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "unit")
          }
        }

        /// name if you need to describe it to a human (e.g. ft. stage)
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Reach: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Reach"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("river", type: .scalar(String.self)),
            GraphQLField("section", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, river: String? = nil, section: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Reach", "id": id, "river": river, "section": section])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// ID of reach (see getNextReachID query)
        public var id: Int? {
          get {
            return resultMap["id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// Name of the river
        public var river: String? {
          get {
            return resultMap["river"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "river")
          }
        }

        /// Name of the section
        public var section: String? {
          get {
            return resultMap["section"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "section")
          }
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uname", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uname: String) {
          self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// User's login name
        public var uname: String {
          get {
            return resultMap["uname"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uname")
          }
        }
      }
    }
  }
}

public final class GagesForReachQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GagesForReach($reach_id: ID!) {
      gauges: getGaugeInformationForReachID(id: $reach_id) {
        __typename
        gauges {
          __typename
          targetid
          metric {
            __typename
            id
            unit
            name
          }
          gauge {
            __typename
            name
            id
            source
            source_id
          }
        }
      }
    }
    """

  public let operationName: String = "GagesForReach"

  public var reach_id: GraphQLID

  public init(reach_id: GraphQLID) {
    self.reach_id = reach_id
  }

  public var variables: GraphQLMap? {
    return ["reach_id": reach_id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getGaugeInformationForReachID", alias: "gauges", arguments: ["id": GraphQLVariable("reach_id")], type: .object(Gauge.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(gauges: Gauge? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "gauges": gauges.flatMap { (value: Gauge) -> ResultMap in value.resultMap }])
    }

    /// Gets a deep representation of a river and its connection to gauges
    public var gauges: Gauge? {
      get {
        return (resultMap["gauges"] as? ResultMap).flatMap { Gauge(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "gauges")
      }
    }

    public struct Gauge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GaugeInformationForReach"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("gauges", type: .list(.object(Gauge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(gauges: [Gauge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "GaugeInformationForReach", "gauges": gauges.flatMap { (value: [Gauge?]) -> [ResultMap?] in value.map { (value: Gauge?) -> ResultMap? in value.flatMap { (value: Gauge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// intrepretation of the gauge, includes rc
      public var gauges: [Gauge?]? {
        get {
          return (resultMap["gauges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Gauge?] in value.map { (value: ResultMap?) -> Gauge? in value.flatMap { (value: ResultMap) -> Gauge in Gauge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Gauge?]) -> [ResultMap?] in value.map { (value: Gauge?) -> ResultMap? in value.flatMap { (value: Gauge) -> ResultMap in value.resultMap } } }, forKey: "gauges")
        }
      }

      public struct Gauge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["GaugeInterpretation"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("targetid", type: .scalar(Int.self)),
            GraphQLField("metric", type: .object(Metric.selections)),
            GraphQLField("gauge", type: .object(Gauge.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(targetid: Int? = nil, metric: Metric? = nil, gauge: Gauge? = nil) {
          self.init(unsafeResultMap: ["__typename": "GaugeInterpretation", "targetid": targetid, "metric": metric.flatMap { (value: Metric) -> ResultMap in value.resultMap }, "gauge": gauge.flatMap { (value: Gauge) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// target gauge ID -- for a correlation you'll trace a Correlation gauge
        public var targetid: Int? {
          get {
            return resultMap["targetid"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "targetid")
          }
        }

        public var metric: Metric? {
          get {
            return (resultMap["metric"] as? ResultMap).flatMap { Metric(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "metric")
          }
        }

        public var gauge: Gauge? {
          get {
            return (resultMap["gauge"] as? ResultMap).flatMap { Gauge(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "gauge")
          }
        }

        public struct Metric: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["GaugeReadingMetric"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("unit", type: .scalar(String.self)),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, unit: String? = nil, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "GaugeReadingMetric", "id": id, "unit": unit, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// id of the metric, used everywhere you see metric_id
          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// abbreviation of unit for humans (e.g. ft)
          public var unit: String? {
            get {
              return resultMap["unit"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "unit")
            }
          }

          /// name if you need to describe it to a human (e.g. ft. stage)
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }

        public struct Gauge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Gauge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("source", type: .scalar(String.self)),
              GraphQLField("source_id", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, id: GraphQLID? = nil, source: String? = nil, sourceId: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Gauge", "name": name, "id": id, "source": source, "source_id": sourceId])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// #name of the gauge
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// ID of the gauge, internal
          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// #gauge driver
          public var source: String? {
            get {
              return resultMap["source"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "source")
            }
          }

          /// #id within the gauge driver.
          public var sourceId: String? {
            get {
              return resultMap["source_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "source_id")
            }
          }
        }
      }
    }
  }
}

public final class GuageMetricsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GuageMetrics($gauge_id: ID!) {
      gauge(id: $gauge_id) {
        __typename
        id
        name
        source
        source_id
        updates {
          __typename
          metric {
            __typename
            id
            format
            unit
            name
          }
        }
      }
    }
    """

  public let operationName: String = "GuageMetrics"

  public var gauge_id: GraphQLID

  public init(gauge_id: GraphQLID) {
    self.gauge_id = gauge_id
  }

  public var variables: GraphQLMap? {
    return ["gauge_id": gauge_id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("gauge", arguments: ["id": GraphQLVariable("gauge_id")], type: .object(Gauge.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(gauge: Gauge? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "gauge": gauge.flatMap { (value: Gauge) -> ResultMap in value.resultMap }])
    }

    /// single gauge query
    public var gauge: Gauge? {
      get {
        return (resultMap["gauge"] as? ResultMap).flatMap { Gauge(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "gauge")
      }
    }

    public struct Gauge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Gauge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("source", type: .scalar(String.self)),
          GraphQLField("source_id", type: .scalar(String.self)),
          GraphQLField("updates", type: .list(.object(Update.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, name: String? = nil, source: String? = nil, sourceId: String? = nil, updates: [Update?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Gauge", "id": id, "name": name, "source": source, "source_id": sourceId, "updates": updates.flatMap { (value: [Update?]) -> [ResultMap?] in value.map { (value: Update?) -> ResultMap? in value.flatMap { (value: Update) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// ID of the gauge, internal
      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// #name of the gauge
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// #gauge driver
      public var source: String? {
        get {
          return resultMap["source"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "source")
        }
      }

      /// #id within the gauge driver.
      public var sourceId: String? {
        get {
          return resultMap["source_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "source_id")
        }
      }

      /// last two updates in gauge update format.
      public var updates: [Update?]? {
        get {
          return (resultMap["updates"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Update?] in value.map { (value: ResultMap?) -> Update? in value.flatMap { (value: ResultMap) -> Update in Update(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Update?]) -> [ResultMap?] in value.map { (value: Update?) -> ResultMap? in value.flatMap { (value: Update) -> ResultMap in value.resultMap } } }, forKey: "updates")
        }
      }

      public struct Update: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["GaugeUpdate"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("metric", type: .object(Metric.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(metric: Metric? = nil) {
          self.init(unsafeResultMap: ["__typename": "GaugeUpdate", "metric": metric.flatMap { (value: Metric) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// metric structure
        public var metric: Metric? {
          get {
            return (resultMap["metric"] as? ResultMap).flatMap { Metric(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "metric")
          }
        }

        public struct Metric: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["GaugeReadingMetric"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("format", type: .scalar(String.self)),
              GraphQLField("unit", type: .scalar(String.self)),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, format: String? = nil, unit: String? = nil, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "GaugeReadingMetric", "id": id, "format": format, "unit": unit, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// id of the metric, used everywhere you see metric_id
          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// format for a string format routine (e.g. js str.Format or sprintf)
          public var format: String? {
            get {
              return resultMap["format"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "format")
            }
          }

          /// abbreviation of unit for humans (e.g. ft)
          public var unit: String? {
            get {
              return resultMap["unit"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "unit")
            }
          }

          /// name if you need to describe it to a human (e.g. ft. stage)
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}

public final class NewsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query News($page_size: Int!, $page: Int!) {
      articles(
        orderBy: {field: POSTED_DATE, order: DESC}
        first: $page_size
        page: $page
      ) {
        __typename
        data {
          __typename
          posted_date
          release_date
          id
          image {
            __typename
            uri {
              __typename
              medium
              thumb
            }
          }
          title
          abstract
          abstractimage {
            __typename
            uri {
              __typename
              medium
              thumb
            }
          }
          author
          icon
          contents
          uid
          short_name
        }
      }
    }
    """

  public let operationName: String = "News"

  public var page_size: Int
  public var page: Int

  public init(page_size: Int, page: Int) {
    self.page_size = page_size
    self.page = page
  }

  public var variables: GraphQLMap? {
    return ["page_size": page_size, "page": page]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("articles", arguments: ["orderBy": ["field": "POSTED_DATE", "order": "DESC"], "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page")], type: .object(Article.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(articles: Article? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "articles": articles.flatMap { (value: Article) -> ResultMap in value.resultMap }])
    }

    /// search endpoint for articles
    public var articles: Article? {
      get {
        return (resultMap["articles"] as? ResultMap).flatMap { Article(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "articles")
      }
    }

    public struct Article: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ArticlePaginator"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "ArticlePaginator", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of Article items.
      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Article"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("posted_date", type: .scalar(String.self)),
            GraphQLField("release_date", type: .scalar(String.self)),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("image", type: .object(Image.selections)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("abstract", type: .scalar(String.self)),
            GraphQLField("abstractimage", type: .object(Abstractimage.selections)),
            GraphQLField("author", type: .scalar(String.self)),
            GraphQLField("icon", type: .scalar(String.self)),
            GraphQLField("contents", type: .scalar(String.self)),
            GraphQLField("uid", type: .scalar(String.self)),
            GraphQLField("short_name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(postedDate: String? = nil, releaseDate: String? = nil, id: GraphQLID? = nil, image: Image? = nil, title: String? = nil, abstract: String? = nil, abstractimage: Abstractimage? = nil, author: String? = nil, icon: String? = nil, contents: String? = nil, uid: String? = nil, shortName: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Article", "posted_date": postedDate, "release_date": releaseDate, "id": id, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }, "title": title, "abstract": abstract, "abstractimage": abstractimage.flatMap { (value: Abstractimage) -> ResultMap in value.resultMap }, "author": author, "icon": icon, "contents": contents, "uid": uid, "short_name": shortName])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var postedDate: String? {
          get {
            return resultMap["posted_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "posted_date")
          }
        }

        public var releaseDate: String? {
          get {
            return resultMap["release_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "release_date")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var image: Image? {
          get {
            return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "image")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        /// short intro to the article
        public var abstract: String? {
          get {
            return resultMap["abstract"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "abstract")
          }
        }

        public var abstractimage: Abstractimage? {
          get {
            return (resultMap["abstractimage"] as? ResultMap).flatMap { Abstractimage(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "abstractimage")
          }
        }

        public var author: String? {
          get {
            return resultMap["author"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "author")
          }
        }

        public var icon: String? {
          get {
            return resultMap["icon"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "icon")
          }
        }

        /// contents of the article
        public var contents: String? {
          get {
            return resultMap["contents"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "contents")
          }
        }

        public var uid: String? {
          get {
            return resultMap["uid"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uid")
          }
        }

        public var shortName: String? {
          get {
            return resultMap["short_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "short_name")
          }
        }

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ImageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uri", type: .object(Uri.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uri: Uri? = nil) {
            self.init(unsafeResultMap: ["__typename": "ImageInfo", "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var uri: Uri? {
            get {
              return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "uri")
            }
          }

          public struct Uri: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ImageURI"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("medium", type: .scalar(String.self)),
                GraphQLField("thumb", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(medium: String? = nil, thumb: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "ImageURI", "medium": medium, "thumb": thumb])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// typically around 800x600
            public var medium: String? {
              get {
                return resultMap["medium"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "medium")
              }
            }

            /// typically 100x200
            public var thumb: String? {
              get {
                return resultMap["thumb"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "thumb")
              }
            }
          }
        }

        public struct Abstractimage: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ImageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uri", type: .object(Uri.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uri: Uri? = nil) {
            self.init(unsafeResultMap: ["__typename": "ImageInfo", "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var uri: Uri? {
            get {
              return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "uri")
            }
          }

          public struct Uri: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ImageURI"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("medium", type: .scalar(String.self)),
                GraphQLField("thumb", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(medium: String? = nil, thumb: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "ImageURI", "medium": medium, "thumb": thumb])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// typically around 800x600
            public var medium: String? {
              get {
                return resultMap["medium"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "medium")
              }
            }

            /// typically 100x200
            public var thumb: String? {
              get {
                return resultMap["thumb"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "thumb")
              }
            }
          }
        }
      }
    }
  }
}

public final class ObservationsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Observations($page_size: Int!, $reach_id: AWID!, $page: Int!, $gauge_id: AWID, $post_types: [PostType]) {
      posts(
        post_types: $post_types
        reach_id: $reach_id
        gauge_id: $gauge_id
        first: $page_size
        page: $page
        orderBy: [{field: REVISION, order: ASC}]
      ) {
        __typename
        paginatorInfo {
          __typename
          lastPage
          currentPage
          total
        }
        data {
          __typename
          id
          title
          detail
          uid
          user {
            __typename
            uname
          }
          post_date
          post_type
          revision
          reach {
            __typename
            id
            river
            section
          }
          reach_id
          gauge_id
          metric_id
          metric {
            __typename
            shortkey
            unit
            name
          }
          reading
          photos {
            __typename
            id
            post_id
            photo_date
            image {
              __typename
              ext
              uri {
                __typename
                thumb
                medium
                big
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Observations"

  public var page_size: Int
  public var reach_id: String
  public var page: Int
  public var gauge_id: String?
  public var post_types: [PostType?]?

  public init(page_size: Int, reach_id: String, page: Int, gauge_id: String? = nil, post_types: [PostType?]? = nil) {
    self.page_size = page_size
    self.reach_id = reach_id
    self.page = page
    self.gauge_id = gauge_id
    self.post_types = post_types
  }

  public var variables: GraphQLMap? {
    return ["page_size": page_size, "reach_id": reach_id, "page": page, "gauge_id": gauge_id, "post_types": post_types]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("posts", arguments: ["post_types": GraphQLVariable("post_types"), "reach_id": GraphQLVariable("reach_id"), "gauge_id": GraphQLVariable("gauge_id"), "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page"), "orderBy": [["field": "REVISION", "order": "ASC"]]], type: .object(Post.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: Post? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: Post) -> ResultMap in value.resultMap }])
    }

    /// get posts by id,post_types,reach_id or all three, intended as a search endpoint
    public var posts: Post? {
      get {
        return (resultMap["posts"] as? ResultMap).flatMap { Post(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "posts")
      }
    }

    public struct Post: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PostPaginator"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(paginatorInfo: PaginatorInfo, data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "PostPaginator", "paginatorInfo": paginatorInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Pagination information about the list of items.
      public var paginatorInfo: PaginatorInfo {
        get {
          return PaginatorInfo(unsafeResultMap: resultMap["paginatorInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "paginatorInfo")
        }
      }

      /// A list of Post items.
      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct PaginatorInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PaginatorInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("total", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(lastPage: Int, currentPage: Int, total: Int) {
          self.init(unsafeResultMap: ["__typename": "PaginatorInfo", "lastPage": lastPage, "currentPage": currentPage, "total": total])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Last page number of the collection.
        public var lastPage: Int {
          get {
            return resultMap["lastPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastPage")
          }
        }

        /// Current pagination page.
        public var currentPage: Int {
          get {
            return resultMap["currentPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "currentPage")
          }
        }

        /// Total items available in the collection.
        public var total: Int {
          get {
            return resultMap["total"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "total")
          }
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Post"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("detail", type: .scalar(String.self)),
            GraphQLField("uid", type: .scalar(String.self)),
            GraphQLField("user", type: .object(User.selections)),
            GraphQLField("post_date", type: .scalar(String.self)),
            GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
            GraphQLField("revision", type: .scalar(Int.self)),
            GraphQLField("reach", type: .object(Reach.selections)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("gauge_id", type: .scalar(String.self)),
            GraphQLField("metric_id", type: .scalar(Int.self)),
            GraphQLField("metric", type: .object(Metric.selections)),
            GraphQLField("reading", type: .scalar(Double.self)),
            GraphQLField("photos", type: .nonNull(.list(.nonNull(.object(Photo.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, uid: String? = nil, user: User? = nil, postDate: String? = nil, postType: PostType, revision: Int? = nil, reach: Reach? = nil, reachId: String? = nil, gaugeId: String? = nil, metricId: Int? = nil, metric: Metric? = nil, reading: Double? = nil, photos: [Photo]) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "uid": uid, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "post_date": postDate, "post_type": postType, "revision": revision, "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }, "reach_id": reachId, "gauge_id": gaugeId, "metric_id": metricId, "metric": metric.flatMap { (value: Metric) -> ResultMap in value.resultMap }, "reading": reading, "photos": photos.map { (value: Photo) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var detail: String? {
          get {
            return resultMap["detail"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detail")
          }
        }

        public var uid: String? {
          get {
            return resultMap["uid"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uid")
          }
        }

        public var user: User? {
          get {
            return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "user")
          }
        }

        public var postDate: String? {
          get {
            return resultMap["post_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_date")
          }
        }

        public var postType: PostType {
          get {
            return resultMap["post_type"]! as! PostType
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_type")
          }
        }

        public var revision: Int? {
          get {
            return resultMap["revision"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "revision")
          }
        }

        public var reach: Reach? {
          get {
            return (resultMap["reach"] as? ResultMap).flatMap { Reach(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "reach")
          }
        }

        public var reachId: String? {
          get {
            return resultMap["reach_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "reach_id")
          }
        }

        public var gaugeId: String? {
          get {
            return resultMap["gauge_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gauge_id")
          }
        }

        public var metricId: Int? {
          get {
            return resultMap["metric_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "metric_id")
          }
        }

        public var metric: Metric? {
          get {
            return (resultMap["metric"] as? ResultMap).flatMap { Metric(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "metric")
          }
        }

        public var reading: Double? {
          get {
            return resultMap["reading"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "reading")
          }
        }

        public var photos: [Photo] {
          get {
            return (resultMap["photos"] as! [ResultMap]).map { (value: ResultMap) -> Photo in Photo(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Photo) -> ResultMap in value.resultMap }, forKey: "photos")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uname", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uname: String) {
            self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// User's login name
          public var uname: String {
            get {
              return resultMap["uname"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "uname")
            }
          }
        }

        public struct Reach: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Reach"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(Int.self)),
              GraphQLField("river", type: .scalar(String.self)),
              GraphQLField("section", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: Int? = nil, river: String? = nil, section: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Reach", "id": id, "river": river, "section": section])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// ID of reach (see getNextReachID query)
          public var id: Int? {
            get {
              return resultMap["id"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// Name of the river
          public var river: String? {
            get {
              return resultMap["river"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "river")
            }
          }

          /// Name of the section
          public var section: String? {
            get {
              return resultMap["section"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "section")
            }
          }
        }

        public struct Metric: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["GaugeReadingMetric"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("shortkey", type: .scalar(String.self)),
              GraphQLField("unit", type: .scalar(String.self)),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(shortkey: String? = nil, unit: String? = nil, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "GaugeReadingMetric", "shortkey": shortkey, "unit": unit, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// quick way of refrencing the metric
          public var shortkey: String? {
            get {
              return resultMap["shortkey"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "shortkey")
            }
          }

          /// abbreviation of unit for humans (e.g. ft)
          public var unit: String? {
            get {
              return resultMap["unit"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "unit")
            }
          }

          /// name if you need to describe it to a human (e.g. ft. stage)
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }

        public struct Photo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Photo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("post_id", type: .scalar(String.self)),
              GraphQLField("photo_date", type: .scalar(String.self)),
              GraphQLField("image", type: .object(Image.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, postId: String? = nil, photoDate: String? = nil, image: Image? = nil) {
            self.init(unsafeResultMap: ["__typename": "Photo", "id": id, "post_id": postId, "photo_date": photoDate, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var postId: String? {
            get {
              return resultMap["post_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "post_id")
            }
          }

          public var photoDate: String? {
            get {
              return resultMap["photo_date"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "photo_date")
            }
          }

          /// URL to Image calculated from below for images, use this
          public var image: Image? {
            get {
              return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "image")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ImageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("ext", type: .scalar(String.self)),
                GraphQLField("uri", type: .object(Uri.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(ext: String? = nil, uri: Uri? = nil) {
              self.init(unsafeResultMap: ["__typename": "ImageInfo", "ext": ext, "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var ext: String? {
              get {
                return resultMap["ext"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "ext")
              }
            }

            public var uri: Uri? {
              get {
                return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "uri")
              }
            }

            public struct Uri: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ImageURI"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("thumb", type: .scalar(String.self)),
                  GraphQLField("medium", type: .scalar(String.self)),
                  GraphQLField("big", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(thumb: String? = nil, medium: String? = nil, big: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "ImageURI", "thumb": thumb, "medium": medium, "big": big])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// typically 100x200
              public var thumb: String? {
                get {
                  return resultMap["thumb"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "thumb")
                }
              }

              /// typically around 800x600
              public var medium: String? {
                get {
                  return resultMap["medium"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "medium")
                }
              }

              /// unconstrained 1-2 MB per load
              public var big: String? {
                get {
                  return resultMap["big"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "big")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class Observations2Query: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Observations2($page_size: Int!, $reach_id: AWID!, $page: Int!, $post_types: [PostType]) {
      posts(
        post_types: $post_types
        reach_id: $reach_id
        first: $page_size
        page: $page
        orderBy: [{field: REVISION, order: ASC}]
      ) {
        __typename
        paginatorInfo {
          __typename
          lastPage
          currentPage
          total
        }
        data {
          __typename
          id
          title
          detail
          uid
          user {
            __typename
            uname
          }
          post_date
          post_type
          revision
          reach {
            __typename
            id
            river
            section
          }
          reach_id
          gauge_id
          metric_id
          metric {
            __typename
            shortkey
            unit
            name
          }
          reading
          photos {
            __typename
            id
            post_id
            photo_date
            image {
              __typename
              ext
              uri {
                __typename
                thumb
                medium
                big
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Observations2"

  public var page_size: Int
  public var reach_id: String
  public var page: Int
  public var post_types: [PostType?]?

  public init(page_size: Int, reach_id: String, page: Int, post_types: [PostType?]? = nil) {
    self.page_size = page_size
    self.reach_id = reach_id
    self.page = page
    self.post_types = post_types
  }

  public var variables: GraphQLMap? {
    return ["page_size": page_size, "reach_id": reach_id, "page": page, "post_types": post_types]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("posts", arguments: ["post_types": GraphQLVariable("post_types"), "reach_id": GraphQLVariable("reach_id"), "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page"), "orderBy": [["field": "REVISION", "order": "ASC"]]], type: .object(Post.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: Post? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: Post) -> ResultMap in value.resultMap }])
    }

    /// get posts by id,post_types,reach_id or all three, intended as a search endpoint
    public var posts: Post? {
      get {
        return (resultMap["posts"] as? ResultMap).flatMap { Post(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "posts")
      }
    }

    public struct Post: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PostPaginator"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(paginatorInfo: PaginatorInfo, data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "PostPaginator", "paginatorInfo": paginatorInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Pagination information about the list of items.
      public var paginatorInfo: PaginatorInfo {
        get {
          return PaginatorInfo(unsafeResultMap: resultMap["paginatorInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "paginatorInfo")
        }
      }

      /// A list of Post items.
      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct PaginatorInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PaginatorInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("total", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(lastPage: Int, currentPage: Int, total: Int) {
          self.init(unsafeResultMap: ["__typename": "PaginatorInfo", "lastPage": lastPage, "currentPage": currentPage, "total": total])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Last page number of the collection.
        public var lastPage: Int {
          get {
            return resultMap["lastPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastPage")
          }
        }

        /// Current pagination page.
        public var currentPage: Int {
          get {
            return resultMap["currentPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "currentPage")
          }
        }

        /// Total items available in the collection.
        public var total: Int {
          get {
            return resultMap["total"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "total")
          }
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Post"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("detail", type: .scalar(String.self)),
            GraphQLField("uid", type: .scalar(String.self)),
            GraphQLField("user", type: .object(User.selections)),
            GraphQLField("post_date", type: .scalar(String.self)),
            GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
            GraphQLField("revision", type: .scalar(Int.self)),
            GraphQLField("reach", type: .object(Reach.selections)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("gauge_id", type: .scalar(String.self)),
            GraphQLField("metric_id", type: .scalar(Int.self)),
            GraphQLField("metric", type: .object(Metric.selections)),
            GraphQLField("reading", type: .scalar(Double.self)),
            GraphQLField("photos", type: .nonNull(.list(.nonNull(.object(Photo.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, uid: String? = nil, user: User? = nil, postDate: String? = nil, postType: PostType, revision: Int? = nil, reach: Reach? = nil, reachId: String? = nil, gaugeId: String? = nil, metricId: Int? = nil, metric: Metric? = nil, reading: Double? = nil, photos: [Photo]) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "uid": uid, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "post_date": postDate, "post_type": postType, "revision": revision, "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }, "reach_id": reachId, "gauge_id": gaugeId, "metric_id": metricId, "metric": metric.flatMap { (value: Metric) -> ResultMap in value.resultMap }, "reading": reading, "photos": photos.map { (value: Photo) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var detail: String? {
          get {
            return resultMap["detail"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detail")
          }
        }

        public var uid: String? {
          get {
            return resultMap["uid"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uid")
          }
        }

        public var user: User? {
          get {
            return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "user")
          }
        }

        public var postDate: String? {
          get {
            return resultMap["post_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_date")
          }
        }

        public var postType: PostType {
          get {
            return resultMap["post_type"]! as! PostType
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_type")
          }
        }

        public var revision: Int? {
          get {
            return resultMap["revision"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "revision")
          }
        }

        public var reach: Reach? {
          get {
            return (resultMap["reach"] as? ResultMap).flatMap { Reach(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "reach")
          }
        }

        public var reachId: String? {
          get {
            return resultMap["reach_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "reach_id")
          }
        }

        public var gaugeId: String? {
          get {
            return resultMap["gauge_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gauge_id")
          }
        }

        public var metricId: Int? {
          get {
            return resultMap["metric_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "metric_id")
          }
        }

        public var metric: Metric? {
          get {
            return (resultMap["metric"] as? ResultMap).flatMap { Metric(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "metric")
          }
        }

        public var reading: Double? {
          get {
            return resultMap["reading"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "reading")
          }
        }

        public var photos: [Photo] {
          get {
            return (resultMap["photos"] as! [ResultMap]).map { (value: ResultMap) -> Photo in Photo(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Photo) -> ResultMap in value.resultMap }, forKey: "photos")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uname", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uname: String) {
            self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// User's login name
          public var uname: String {
            get {
              return resultMap["uname"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "uname")
            }
          }
        }

        public struct Reach: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Reach"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(Int.self)),
              GraphQLField("river", type: .scalar(String.self)),
              GraphQLField("section", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: Int? = nil, river: String? = nil, section: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Reach", "id": id, "river": river, "section": section])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// ID of reach (see getNextReachID query)
          public var id: Int? {
            get {
              return resultMap["id"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// Name of the river
          public var river: String? {
            get {
              return resultMap["river"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "river")
            }
          }

          /// Name of the section
          public var section: String? {
            get {
              return resultMap["section"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "section")
            }
          }
        }

        public struct Metric: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["GaugeReadingMetric"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("shortkey", type: .scalar(String.self)),
              GraphQLField("unit", type: .scalar(String.self)),
              GraphQLField("name", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(shortkey: String? = nil, unit: String? = nil, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "GaugeReadingMetric", "shortkey": shortkey, "unit": unit, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// quick way of refrencing the metric
          public var shortkey: String? {
            get {
              return resultMap["shortkey"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "shortkey")
            }
          }

          /// abbreviation of unit for humans (e.g. ft)
          public var unit: String? {
            get {
              return resultMap["unit"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "unit")
            }
          }

          /// name if you need to describe it to a human (e.g. ft. stage)
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }

        public struct Photo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Photo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("post_id", type: .scalar(String.self)),
              GraphQLField("photo_date", type: .scalar(String.self)),
              GraphQLField("image", type: .object(Image.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, postId: String? = nil, photoDate: String? = nil, image: Image? = nil) {
            self.init(unsafeResultMap: ["__typename": "Photo", "id": id, "post_id": postId, "photo_date": photoDate, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var postId: String? {
            get {
              return resultMap["post_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "post_id")
            }
          }

          public var photoDate: String? {
            get {
              return resultMap["photo_date"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "photo_date")
            }
          }

          /// URL to Image calculated from below for images, use this
          public var image: Image? {
            get {
              return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "image")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ImageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("ext", type: .scalar(String.self)),
                GraphQLField("uri", type: .object(Uri.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(ext: String? = nil, uri: Uri? = nil) {
              self.init(unsafeResultMap: ["__typename": "ImageInfo", "ext": ext, "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var ext: String? {
              get {
                return resultMap["ext"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "ext")
              }
            }

            public var uri: Uri? {
              get {
                return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "uri")
              }
            }

            public struct Uri: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ImageURI"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("thumb", type: .scalar(String.self)),
                  GraphQLField("medium", type: .scalar(String.self)),
                  GraphQLField("big", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(thumb: String? = nil, medium: String? = nil, big: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "ImageURI", "thumb": thumb, "medium": medium, "big": big])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// typically 100x200
              public var thumb: String? {
                get {
                  return resultMap["thumb"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "thumb")
                }
              }

              /// typically around 800x600
              public var medium: String? {
                get {
                  return resultMap["medium"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "medium")
                }
              }

              /// unconstrained 1-2 MB per load
              public var big: String? {
                get {
                  return resultMap["big"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "big")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class PostObservationPhotoMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PostObservationPhoto($id: ID!, $file: Upload, $type: PhotoSectionsType, $reach_id: AWID, $photo: PhotoInput) {
      photoFileUpdate(
        id: $id
        fileinput: {file: $file, section: $type, section_id: $reach_id}
        photo: $photo
      ) {
        __typename
        id
        post_id
        post {
          __typename
          id
          title
          detail
          uid
          post_date
          post_type
          revision
          reach_id
          gauge_id
          metric_id
          reading
        }
        image {
          __typename
          uri {
            __typename
            thumb
            medium
            big
          }
        }
      }
    }
    """

  public let operationName: String = "PostObservationPhoto"

  public var id: GraphQLID
  public var file: String?
  public var type: PhotoSectionsType?
  public var reach_id: String?
  public var photo: PhotoInput?

  public init(id: GraphQLID, file: String? = nil, type: PhotoSectionsType? = nil, reach_id: String? = nil, photo: PhotoInput? = nil) {
    self.id = id
    self.file = file
    self.type = type
    self.reach_id = reach_id
    self.photo = photo
  }

  public var variables: GraphQLMap? {
    return ["id": id, "file": file, "type": type, "reach_id": reach_id, "photo": photo]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("photoFileUpdate", arguments: ["id": GraphQLVariable("id"), "fileinput": ["file": GraphQLVariable("file"), "section": GraphQLVariable("type"), "section_id": GraphQLVariable("reach_id")], "photo": GraphQLVariable("photo")], type: .object(PhotoFileUpdate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(photoFileUpdate: PhotoFileUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "photoFileUpdate": photoFileUpdate.flatMap { (value: PhotoFileUpdate) -> ResultMap in value.resultMap }])
    }

    /// associate a photo with a section and section ID, typically this will be a POST with a post id of the container
    public var photoFileUpdate: PhotoFileUpdate? {
      get {
        return (resultMap["photoFileUpdate"] as? ResultMap).flatMap { PhotoFileUpdate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "photoFileUpdate")
      }
    }

    public struct PhotoFileUpdate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Photo"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("post_id", type: .scalar(String.self)),
          GraphQLField("post", type: .object(Post.selections)),
          GraphQLField("image", type: .object(Image.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, postId: String? = nil, post: Post? = nil, image: Image? = nil) {
        self.init(unsafeResultMap: ["__typename": "Photo", "id": id, "post_id": postId, "post": post.flatMap { (value: Post) -> ResultMap in value.resultMap }, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var postId: String? {
        get {
          return resultMap["post_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_id")
        }
      }

      public var post: Post? {
        get {
          return (resultMap["post"] as? ResultMap).flatMap { Post(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "post")
        }
      }

      /// URL to Image calculated from below for images, use this
      public var image: Image? {
        get {
          return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "image")
        }
      }

      public struct Post: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Post"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("detail", type: .scalar(String.self)),
            GraphQLField("uid", type: .scalar(String.self)),
            GraphQLField("post_date", type: .scalar(String.self)),
            GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
            GraphQLField("revision", type: .scalar(Int.self)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("gauge_id", type: .scalar(String.self)),
            GraphQLField("metric_id", type: .scalar(Int.self)),
            GraphQLField("reading", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, uid: String? = nil, postDate: String? = nil, postType: PostType, revision: Int? = nil, reachId: String? = nil, gaugeId: String? = nil, metricId: Int? = nil, reading: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "uid": uid, "post_date": postDate, "post_type": postType, "revision": revision, "reach_id": reachId, "gauge_id": gaugeId, "metric_id": metricId, "reading": reading])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var detail: String? {
          get {
            return resultMap["detail"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detail")
          }
        }

        public var uid: String? {
          get {
            return resultMap["uid"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uid")
          }
        }

        public var postDate: String? {
          get {
            return resultMap["post_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_date")
          }
        }

        public var postType: PostType {
          get {
            return resultMap["post_type"]! as! PostType
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_type")
          }
        }

        public var revision: Int? {
          get {
            return resultMap["revision"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "revision")
          }
        }

        public var reachId: String? {
          get {
            return resultMap["reach_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "reach_id")
          }
        }

        public var gaugeId: String? {
          get {
            return resultMap["gauge_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gauge_id")
          }
        }

        public var metricId: Int? {
          get {
            return resultMap["metric_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "metric_id")
          }
        }

        public var reading: Double? {
          get {
            return resultMap["reading"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "reading")
          }
        }
      }

      public struct Image: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ImageInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uri", type: .object(Uri.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uri: Uri? = nil) {
          self.init(unsafeResultMap: ["__typename": "ImageInfo", "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var uri: Uri? {
          get {
            return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "uri")
          }
        }

        public struct Uri: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ImageURI"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("thumb", type: .scalar(String.self)),
              GraphQLField("medium", type: .scalar(String.self)),
              GraphQLField("big", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(thumb: String? = nil, medium: String? = nil, big: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "ImageURI", "thumb": thumb, "medium": medium, "big": big])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// typically 100x200
          public var thumb: String? {
            get {
              return resultMap["thumb"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "thumb")
            }
          }

          /// typically around 800x600
          public var medium: String? {
            get {
              return resultMap["medium"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "medium")
            }
          }

          /// unconstrained 1-2 MB per load
          public var big: String? {
            get {
              return resultMap["big"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "big")
            }
          }
        }
      }
    }
  }
}

public final class PostObservationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PostObservation($id: ID!, $post: PostInput!) {
      postUpdate(id: $id, post: $post) {
        __typename
        id
        title
        detail
        uid
        user {
          __typename
          uname
        }
        post_date
        post_type
        revision
        reach_id
        gauge_id
        metric_id
        metric {
          __typename
          shortkey
          unit
          name
        }
        reading
        photos {
          __typename
          id
          caption
          post_id
          description
          subject
          photo_date
          author
          poi_name
          poi_id
          image {
            __typename
            ext
            uri {
              __typename
              thumb
              medium
              big
            }
          }
        }
      }
    }
    """

  public let operationName: String = "PostObservation"

  public var id: GraphQLID
  public var post: PostInput

  public init(id: GraphQLID, post: PostInput) {
    self.id = id
    self.post = post
  }

  public var variables: GraphQLMap? {
    return ["id": id, "post": post]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("postUpdate", arguments: ["id": GraphQLVariable("id"), "post": GraphQLVariable("post")], type: .object(PostUpdate.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postUpdate: PostUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "postUpdate": postUpdate.flatMap { (value: PostUpdate) -> ResultMap in value.resultMap }])
    }

    /// send a post up with a UUID
    public var postUpdate: PostUpdate? {
      get {
        return (resultMap["postUpdate"] as? ResultMap).flatMap { PostUpdate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "postUpdate")
      }
    }

    public struct PostUpdate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Post"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("detail", type: .scalar(String.self)),
          GraphQLField("uid", type: .scalar(String.self)),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("post_date", type: .scalar(String.self)),
          GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
          GraphQLField("revision", type: .scalar(Int.self)),
          GraphQLField("reach_id", type: .scalar(String.self)),
          GraphQLField("gauge_id", type: .scalar(String.self)),
          GraphQLField("metric_id", type: .scalar(Int.self)),
          GraphQLField("metric", type: .object(Metric.selections)),
          GraphQLField("reading", type: .scalar(Double.self)),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.object(Photo.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, uid: String? = nil, user: User? = nil, postDate: String? = nil, postType: PostType, revision: Int? = nil, reachId: String? = nil, gaugeId: String? = nil, metricId: Int? = nil, metric: Metric? = nil, reading: Double? = nil, photos: [Photo]) {
        self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "uid": uid, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "post_date": postDate, "post_type": postType, "revision": revision, "reach_id": reachId, "gauge_id": gaugeId, "metric_id": metricId, "metric": metric.flatMap { (value: Metric) -> ResultMap in value.resultMap }, "reading": reading, "photos": photos.map { (value: Photo) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var detail: String? {
        get {
          return resultMap["detail"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "detail")
        }
      }

      public var uid: String? {
        get {
          return resultMap["uid"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "uid")
        }
      }

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
        }
      }

      public var postDate: String? {
        get {
          return resultMap["post_date"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_date")
        }
      }

      public var postType: PostType {
        get {
          return resultMap["post_type"]! as! PostType
        }
        set {
          resultMap.updateValue(newValue, forKey: "post_type")
        }
      }

      public var revision: Int? {
        get {
          return resultMap["revision"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "revision")
        }
      }

      public var reachId: String? {
        get {
          return resultMap["reach_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "reach_id")
        }
      }

      public var gaugeId: String? {
        get {
          return resultMap["gauge_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "gauge_id")
        }
      }

      public var metricId: Int? {
        get {
          return resultMap["metric_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "metric_id")
        }
      }

      public var metric: Metric? {
        get {
          return (resultMap["metric"] as? ResultMap).flatMap { Metric(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "metric")
        }
      }

      public var reading: Double? {
        get {
          return resultMap["reading"] as? Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "reading")
        }
      }

      public var photos: [Photo] {
        get {
          return (resultMap["photos"] as! [ResultMap]).map { (value: ResultMap) -> Photo in Photo(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Photo) -> ResultMap in value.resultMap }, forKey: "photos")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uname", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(uname: String) {
          self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// User's login name
        public var uname: String {
          get {
            return resultMap["uname"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "uname")
          }
        }
      }

      public struct Metric: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["GaugeReadingMetric"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("shortkey", type: .scalar(String.self)),
            GraphQLField("unit", type: .scalar(String.self)),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(shortkey: String? = nil, unit: String? = nil, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "GaugeReadingMetric", "shortkey": shortkey, "unit": unit, "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// quick way of refrencing the metric
        public var shortkey: String? {
          get {
            return resultMap["shortkey"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "shortkey")
          }
        }

        /// abbreviation of unit for humans (e.g. ft)
        public var unit: String? {
          get {
            return resultMap["unit"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "unit")
          }
        }

        /// name if you need to describe it to a human (e.g. ft. stage)
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Photo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Photo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("caption", type: .scalar(String.self)),
            GraphQLField("post_id", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("subject", type: .scalar(String.self)),
            GraphQLField("photo_date", type: .scalar(String.self)),
            GraphQLField("author", type: .scalar(String.self)),
            GraphQLField("poi_name", type: .scalar(String.self)),
            GraphQLField("poi_id", type: .scalar(String.self)),
            GraphQLField("image", type: .object(Image.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, caption: String? = nil, postId: String? = nil, description: String? = nil, subject: String? = nil, photoDate: String? = nil, author: String? = nil, poiName: String? = nil, poiId: String? = nil, image: Image? = nil) {
          self.init(unsafeResultMap: ["__typename": "Photo", "id": id, "caption": caption, "post_id": postId, "description": description, "subject": subject, "photo_date": photoDate, "author": author, "poi_name": poiName, "poi_id": poiId, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var caption: String? {
          get {
            return resultMap["caption"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "caption")
          }
        }

        public var postId: String? {
          get {
            return resultMap["post_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_id")
          }
        }

        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var subject: String? {
          get {
            return resultMap["subject"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "subject")
          }
        }

        public var photoDate: String? {
          get {
            return resultMap["photo_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "photo_date")
          }
        }

        public var author: String? {
          get {
            return resultMap["author"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "author")
          }
        }

        public var poiName: String? {
          get {
            return resultMap["poi_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "poi_name")
          }
        }

        public var poiId: String? {
          get {
            return resultMap["poi_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "poi_id")
          }
        }

        /// URL to Image calculated from below for images, use this
        public var image: Image? {
          get {
            return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "image")
          }
        }

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ImageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("ext", type: .scalar(String.self)),
              GraphQLField("uri", type: .object(Uri.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(ext: String? = nil, uri: Uri? = nil) {
            self.init(unsafeResultMap: ["__typename": "ImageInfo", "ext": ext, "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var ext: String? {
            get {
              return resultMap["ext"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "ext")
            }
          }

          public var uri: Uri? {
            get {
              return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "uri")
            }
          }

          public struct Uri: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ImageURI"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("thumb", type: .scalar(String.self)),
                GraphQLField("medium", type: .scalar(String.self)),
                GraphQLField("big", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(thumb: String? = nil, medium: String? = nil, big: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "ImageURI", "thumb": thumb, "medium": medium, "big": big])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// typically 100x200
            public var thumb: String? {
              get {
                return resultMap["thumb"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "thumb")
              }
            }

            /// typically around 800x600
            public var medium: String? {
              get {
                return resultMap["medium"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "medium")
              }
            }

            /// unconstrained 1-2 MB per load
            public var big: String? {
              get {
                return resultMap["big"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "big")
              }
            }
          }
        }
      }
    }
  }
}

public final class PhotosQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Photos($page_size: Int!, $reach_id: AWID!, $page: Int!, $gauge_id: AWID, $post_types: [PostType]) {
      posts(
        post_types: $post_types
        reach_id: $reach_id
        gauge_id: $gauge_id
        first: $page_size
        page: $page
        orderBy: [{field: REVISION, order: DESC}]
      ) {
        __typename
        paginatorInfo {
          __typename
          lastPage
          currentPage
          total
        }
        data {
          __typename
          id
          title
          detail
          post_type
          post_date
          reach_id
          gauge_id
          reading
          user {
            __typename
            uname
          }
          photos {
            __typename
            id
            caption
            post_id
            description
            subject
            photo_date
            author
            poi_name
            poi_id
            image {
              __typename
              ext
              uri {
                __typename
                thumb
                medium
                big
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Photos"

  public var page_size: Int
  public var reach_id: String
  public var page: Int
  public var gauge_id: String?
  public var post_types: [PostType?]?

  public init(page_size: Int, reach_id: String, page: Int, gauge_id: String? = nil, post_types: [PostType?]? = nil) {
    self.page_size = page_size
    self.reach_id = reach_id
    self.page = page
    self.gauge_id = gauge_id
    self.post_types = post_types
  }

  public var variables: GraphQLMap? {
    return ["page_size": page_size, "reach_id": reach_id, "page": page, "gauge_id": gauge_id, "post_types": post_types]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("posts", arguments: ["post_types": GraphQLVariable("post_types"), "reach_id": GraphQLVariable("reach_id"), "gauge_id": GraphQLVariable("gauge_id"), "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page"), "orderBy": [["field": "REVISION", "order": "DESC"]]], type: .object(Post.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: Post? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: Post) -> ResultMap in value.resultMap }])
    }

    /// get posts by id,post_types,reach_id or all three, intended as a search endpoint
    public var posts: Post? {
      get {
        return (resultMap["posts"] as? ResultMap).flatMap { Post(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "posts")
      }
    }

    public struct Post: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PostPaginator"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(paginatorInfo: PaginatorInfo, data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "PostPaginator", "paginatorInfo": paginatorInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Pagination information about the list of items.
      public var paginatorInfo: PaginatorInfo {
        get {
          return PaginatorInfo(unsafeResultMap: resultMap["paginatorInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "paginatorInfo")
        }
      }

      /// A list of Post items.
      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct PaginatorInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PaginatorInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("total", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(lastPage: Int, currentPage: Int, total: Int) {
          self.init(unsafeResultMap: ["__typename": "PaginatorInfo", "lastPage": lastPage, "currentPage": currentPage, "total": total])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Last page number of the collection.
        public var lastPage: Int {
          get {
            return resultMap["lastPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastPage")
          }
        }

        /// Current pagination page.
        public var currentPage: Int {
          get {
            return resultMap["currentPage"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "currentPage")
          }
        }

        /// Total items available in the collection.
        public var total: Int {
          get {
            return resultMap["total"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "total")
          }
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Post"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("detail", type: .scalar(String.self)),
            GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
            GraphQLField("post_date", type: .scalar(String.self)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("gauge_id", type: .scalar(String.self)),
            GraphQLField("reading", type: .scalar(Double.self)),
            GraphQLField("user", type: .object(User.selections)),
            GraphQLField("photos", type: .nonNull(.list(.nonNull(.object(Photo.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, postType: PostType, postDate: String? = nil, reachId: String? = nil, gaugeId: String? = nil, reading: Double? = nil, user: User? = nil, photos: [Photo]) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "post_type": postType, "post_date": postDate, "reach_id": reachId, "gauge_id": gaugeId, "reading": reading, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "photos": photos.map { (value: Photo) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var detail: String? {
          get {
            return resultMap["detail"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "detail")
          }
        }

        public var postType: PostType {
          get {
            return resultMap["post_type"]! as! PostType
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_type")
          }
        }

        public var postDate: String? {
          get {
            return resultMap["post_date"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "post_date")
          }
        }

        public var reachId: String? {
          get {
            return resultMap["reach_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "reach_id")
          }
        }

        public var gaugeId: String? {
          get {
            return resultMap["gauge_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gauge_id")
          }
        }

        public var reading: Double? {
          get {
            return resultMap["reading"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "reading")
          }
        }

        public var user: User? {
          get {
            return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "user")
          }
        }

        public var photos: [Photo] {
          get {
            return (resultMap["photos"] as! [ResultMap]).map { (value: ResultMap) -> Photo in Photo(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Photo) -> ResultMap in value.resultMap }, forKey: "photos")
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("uname", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uname: String) {
            self.init(unsafeResultMap: ["__typename": "User", "uname": uname])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// User's login name
          public var uname: String {
            get {
              return resultMap["uname"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "uname")
            }
          }
        }

        public struct Photo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Photo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("caption", type: .scalar(String.self)),
              GraphQLField("post_id", type: .scalar(String.self)),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("subject", type: .scalar(String.self)),
              GraphQLField("photo_date", type: .scalar(String.self)),
              GraphQLField("author", type: .scalar(String.self)),
              GraphQLField("poi_name", type: .scalar(String.self)),
              GraphQLField("poi_id", type: .scalar(String.self)),
              GraphQLField("image", type: .object(Image.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, caption: String? = nil, postId: String? = nil, description: String? = nil, subject: String? = nil, photoDate: String? = nil, author: String? = nil, poiName: String? = nil, poiId: String? = nil, image: Image? = nil) {
            self.init(unsafeResultMap: ["__typename": "Photo", "id": id, "caption": caption, "post_id": postId, "description": description, "subject": subject, "photo_date": photoDate, "author": author, "poi_name": poiName, "poi_id": poiId, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var caption: String? {
            get {
              return resultMap["caption"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "caption")
            }
          }

          public var postId: String? {
            get {
              return resultMap["post_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "post_id")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          public var subject: String? {
            get {
              return resultMap["subject"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "subject")
            }
          }

          public var photoDate: String? {
            get {
              return resultMap["photo_date"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "photo_date")
            }
          }

          public var author: String? {
            get {
              return resultMap["author"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "author")
            }
          }

          public var poiName: String? {
            get {
              return resultMap["poi_name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "poi_name")
            }
          }

          public var poiId: String? {
            get {
              return resultMap["poi_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "poi_id")
            }
          }

          /// URL to Image calculated from below for images, use this
          public var image: Image? {
            get {
              return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "image")
            }
          }

          public struct Image: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ImageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("ext", type: .scalar(String.self)),
                GraphQLField("uri", type: .object(Uri.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(ext: String? = nil, uri: Uri? = nil) {
              self.init(unsafeResultMap: ["__typename": "ImageInfo", "ext": ext, "uri": uri.flatMap { (value: Uri) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var ext: String? {
              get {
                return resultMap["ext"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "ext")
              }
            }

            public var uri: Uri? {
              get {
                return (resultMap["uri"] as? ResultMap).flatMap { Uri(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "uri")
              }
            }

            public struct Uri: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ImageURI"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("thumb", type: .scalar(String.self)),
                  GraphQLField("medium", type: .scalar(String.self)),
                  GraphQLField("big", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(thumb: String? = nil, medium: String? = nil, big: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "ImageURI", "thumb": thumb, "medium": medium, "big": big])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// typically 100x200
              public var thumb: String? {
                get {
                  return resultMap["thumb"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "thumb")
                }
              }

              /// typically around 800x600
              public var medium: String? {
                get {
                  return resultMap["medium"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "medium")
                }
              }

              /// unconstrained 1-2 MB per load
              public var big: String? {
                get {
                  return resultMap["big"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "big")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class ReachAccidentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ReachAccidents($reach_id: ID!, $first: Int!, $page: Int!) {
      reach(id: $reach_id) {
        __typename
        accidents(first: $first, page: $page) {
          __typename
          paginatorInfo {
            __typename
            total
            count
            currentPage
            hasMorePages
            lastPage
            perPage
          }
          data {
            __typename
            id
            accident_date
            reach_id
            river
            section
            location
            water_level
            difficulty
            age
            experience
            description
            factors {
              __typename
              factor
            }
            injuries {
              __typename
              injury
            }
            causes {
              __typename
              cause
            }
          }
        }
      }
    }
    """

  public let operationName: String = "ReachAccidents"

  public var reach_id: GraphQLID
  public var first: Int
  public var page: Int

  public init(reach_id: GraphQLID, first: Int, page: Int) {
    self.reach_id = reach_id
    self.first = first
    self.page = page
  }

  public var variables: GraphQLMap? {
    return ["reach_id": reach_id, "first": first, "page": page]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("reach", arguments: ["id": GraphQLVariable("reach_id")], type: .object(Reach.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(reach: Reach? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }])
    }

    /// single reach query
    public var reach: Reach? {
      get {
        return (resultMap["reach"] as? ResultMap).flatMap { Reach(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "reach")
      }
    }

    public struct Reach: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Reach"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accidents", arguments: ["first": GraphQLVariable("first"), "page": GraphQLVariable("page")], type: .object(Accident.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accidents: Accident? = nil) {
        self.init(unsafeResultMap: ["__typename": "Reach", "accidents": accidents.flatMap { (value: Accident) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// all the accidents that associated with this reach
      public var accidents: Accident? {
        get {
          return (resultMap["accidents"] as? ResultMap).flatMap { Accident(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "accidents")
        }
      }

      public struct Accident: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["AccidentPaginator"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
            GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(paginatorInfo: PaginatorInfo, data: [Datum]) {
          self.init(unsafeResultMap: ["__typename": "AccidentPaginator", "paginatorInfo": paginatorInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Pagination information about the list of items.
        public var paginatorInfo: PaginatorInfo {
          get {
            return PaginatorInfo(unsafeResultMap: resultMap["paginatorInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "paginatorInfo")
          }
        }

        /// A list of Accident items.
        public var data: [Datum] {
          get {
            return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
          }
        }

        public struct PaginatorInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PaginatorInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("total", type: .nonNull(.scalar(Int.self))),
              GraphQLField("count", type: .nonNull(.scalar(Int.self))),
              GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
              GraphQLField("hasMorePages", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
              GraphQLField("perPage", type: .nonNull(.scalar(Int.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Int, count: Int, currentPage: Int, hasMorePages: Bool, lastPage: Int, perPage: Int) {
            self.init(unsafeResultMap: ["__typename": "PaginatorInfo", "total": total, "count": count, "currentPage": currentPage, "hasMorePages": hasMorePages, "lastPage": lastPage, "perPage": perPage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Total items available in the collection.
          public var total: Int {
            get {
              return resultMap["total"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "total")
            }
          }

          /// Total count of available items in the page.
          public var count: Int {
            get {
              return resultMap["count"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "count")
            }
          }

          /// Current pagination page.
          public var currentPage: Int {
            get {
              return resultMap["currentPage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "currentPage")
            }
          }

          /// If collection has more pages.
          public var hasMorePages: Bool {
            get {
              return resultMap["hasMorePages"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasMorePages")
            }
          }

          /// Last page number of the collection.
          public var lastPage: Int {
            get {
              return resultMap["lastPage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "lastPage")
            }
          }

          /// Number of items per page in the collection.
          public var perPage: Int {
            get {
              return resultMap["perPage"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "perPage")
            }
          }
        }

        public struct Datum: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Accident"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
              GraphQLField("accident_date", type: .scalar(String.self)),
              GraphQLField("reach_id", type: .scalar(String.self)),
              GraphQLField("river", type: .scalar(String.self)),
              GraphQLField("section", type: .scalar(String.self)),
              GraphQLField("location", type: .scalar(String.self)),
              GraphQLField("water_level", type: .scalar(String.self)),
              GraphQLField("difficulty", type: .scalar(String.self)),
              GraphQLField("age", type: .scalar(Int.self)),
              GraphQLField("experience", type: .scalar(String.self)),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("factors", type: .list(.nonNull(.object(Factor.selections)))),
              GraphQLField("injuries", type: .list(.nonNull(.object(Injury.selections)))),
              GraphQLField("causes", type: .list(.nonNull(.object(Cause.selections)))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, accidentDate: String? = nil, reachId: String? = nil, river: String? = nil, section: String? = nil, location: String? = nil, waterLevel: String? = nil, difficulty: String? = nil, age: Int? = nil, experience: String? = nil, description: String? = nil, factors: [Factor]? = nil, injuries: [Injury]? = nil, causes: [Cause]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Accident", "id": id, "accident_date": accidentDate, "reach_id": reachId, "river": river, "section": section, "location": location, "water_level": waterLevel, "difficulty": difficulty, "age": age, "experience": experience, "description": description, "factors": factors.flatMap { (value: [Factor]) -> [ResultMap] in value.map { (value: Factor) -> ResultMap in value.resultMap } }, "injuries": injuries.flatMap { (value: [Injury]) -> [ResultMap] in value.map { (value: Injury) -> ResultMap in value.resultMap } }, "causes": causes.flatMap { (value: [Cause]) -> [ResultMap] in value.map { (value: Cause) -> ResultMap in value.resultMap } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var accidentDate: String? {
            get {
              return resultMap["accident_date"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "accident_date")
            }
          }

          public var reachId: String? {
            get {
              return resultMap["reach_id"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "reach_id")
            }
          }

          public var river: String? {
            get {
              return resultMap["river"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "river")
            }
          }

          public var section: String? {
            get {
              return resultMap["section"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "section")
            }
          }

          public var location: String? {
            get {
              return resultMap["location"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "location")
            }
          }

          public var waterLevel: String? {
            get {
              return resultMap["water_level"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "water_level")
            }
          }

          public var difficulty: String? {
            get {
              return resultMap["difficulty"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "difficulty")
            }
          }

          public var age: Int? {
            get {
              return resultMap["age"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "age")
            }
          }

          public var experience: String? {
            get {
              return resultMap["experience"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "experience")
            }
          }

          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          public var factors: [Factor]? {
            get {
              return (resultMap["factors"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Factor] in value.map { (value: ResultMap) -> Factor in Factor(unsafeResultMap: value) } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Factor]) -> [ResultMap] in value.map { (value: Factor) -> ResultMap in value.resultMap } }, forKey: "factors")
            }
          }

          public var injuries: [Injury]? {
            get {
              return (resultMap["injuries"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Injury] in value.map { (value: ResultMap) -> Injury in Injury(unsafeResultMap: value) } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Injury]) -> [ResultMap] in value.map { (value: Injury) -> ResultMap in value.resultMap } }, forKey: "injuries")
            }
          }

          public var causes: [Cause]? {
            get {
              return (resultMap["causes"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Cause] in value.map { (value: ResultMap) -> Cause in Cause(unsafeResultMap: value) } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Cause]) -> [ResultMap] in value.map { (value: Cause) -> ResultMap in value.resultMap } }, forKey: "causes")
            }
          }

          public struct Factor: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Factor"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("factor", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(factor: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Factor", "factor": factor])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var factor: String? {
              get {
                return resultMap["factor"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "factor")
              }
            }
          }

          public struct Injury: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Injury"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("injury", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(injury: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Injury", "injury": injury])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var injury: String? {
              get {
                return resultMap["injury"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "injury")
              }
            }
          }

          public struct Cause: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Cause"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("cause", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(cause: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Cause", "cause": cause])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var cause: String? {
              get {
                return resultMap["cause"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "cause")
              }
            }
          }
        }
      }
    }
  }
}
