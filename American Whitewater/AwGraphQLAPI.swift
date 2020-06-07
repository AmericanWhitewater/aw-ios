// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum PostType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case journal
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
  ///   - title
  ///   - detail
  ///   - postType
  ///   - postDate
  ///   - reachId
  ///   - gaugeId
  ///   - userId
  ///   - metricId
  ///   - reading
  public init(title: Swift.Optional<String?> = nil, detail: Swift.Optional<String?> = nil, postType: PostType, postDate: Swift.Optional<String?> = nil, reachId: Swift.Optional<String?> = nil, gaugeId: Swift.Optional<String?> = nil, userId: Swift.Optional<String?> = nil, metricId: Swift.Optional<Int?> = nil, reading: Swift.Optional<Double?> = nil) {
    graphQLMap = ["title": title, "detail": detail, "post_type": postType, "post_date": postDate, "reach_id": reachId, "gauge_id": gaugeId, "user_id": userId, "metric_id": metricId, "reading": reading]
  }

  public var title: Swift.Optional<String?> {
    get {
      return graphQLMap["title"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var detail: Swift.Optional<String?> {
    get {
      return graphQLMap["detail"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "detail")
    }
  }

  public var postType: PostType {
    get {
      return graphQLMap["post_type"] as! PostType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "post_type")
    }
  }

  public var postDate: Swift.Optional<String?> {
    get {
      return graphQLMap["post_date"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "post_date")
    }
  }

  public var reachId: Swift.Optional<String?> {
    get {
      return graphQLMap["reach_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reach_id")
    }
  }

  public var gaugeId: Swift.Optional<String?> {
    get {
      return graphQLMap["gauge_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gauge_id")
    }
  }

  public var userId: Swift.Optional<String?> {
    get {
      return graphQLMap["user_id"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "user_id")
    }
  }

  public var metricId: Swift.Optional<Int?> {
    get {
      return graphQLMap["metric_id"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "metric_id")
    }
  }

  public var reading: Swift.Optional<Double?> {
    get {
      return graphQLMap["reading"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reading")
    }
  }
}

public enum PhotoSectionsType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// Rougly a post
  case post
  /// attach to a rapid
  case rapid
  /// attach as the header image of a reach
  case reach
  /// attach to a reach as a new photo upload
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

public final class AlertsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Alerts($page_size: Int!, $reach_id: AWID!, $page: Int!, $gauge_id: AWID, $post_types: [PostType]) {
      posts(post_types: $post_types, reach_id: $reach_id, gauge_id: $gauge_id, first: $page_size, page: $page, orderBy: [{field: REVISION, order: DESC}]) {
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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("posts", arguments: ["post_types": GraphQLVariable("post_types"), "reach_id": GraphQLVariable("reach_id"), "gauge_id": GraphQLVariable("gauge_id"), "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page"), "orderBy": [["field": "REVISION", "order": "DESC"]]], type: .object(Post.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: Post? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: Post) -> ResultMap in value.resultMap }])
    }

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

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
        GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
      ]

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

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
          GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
          GraphQLField("total", type: .nonNull(.scalar(Int.self))),
        ]

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

        public static let selections: [GraphQLSelection] = [
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

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("river", type: .scalar(String.self)),
            GraphQLField("section", type: .scalar(String.self)),
          ]

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

          public var id: Int? {
            get {
              return resultMap["id"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
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
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uname", type: .nonNull(.scalar(String.self))),
          ]

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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("postUpdate", arguments: ["id": GraphQLVariable("id"), "post": GraphQLVariable("post")], type: .object(PostUpdate.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postUpdate: PostUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "postUpdate": postUpdate.flatMap { (value: PostUpdate) -> ResultMap in value.resultMap }])
    }

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

      public static let selections: [GraphQLSelection] = [
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

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(Int.self)),
          GraphQLField("river", type: .scalar(String.self)),
          GraphQLField("section", type: .scalar(String.self)),
        ]

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

        public var id: Int? {
          get {
            return resultMap["id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
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
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("uname", type: .nonNull(.scalar(String.self))),
        ]

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

public final class UploadPhotoFileMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UploadPhotoFile($file: Upload!, $reach_id: AWID!, $type: PhotoSectionsType!, $photo: PhotoInput) {
      photoFileCreate(fileinput: {file: $file, section: $type, section_id: $reach_id}, photo: $photo) {
        __typename
        id
        post_id
        post {
          __typename
          id
          title
          detail
          post_type
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

  public let operationName: String = "UploadPhotoFile"

  public var file: String
  public var reach_id: String
  public var type: PhotoSectionsType
  public var photo: PhotoInput?

  public init(file: String, reach_id: String, type: PhotoSectionsType, photo: PhotoInput? = nil) {
    self.file = file
    self.reach_id = reach_id
    self.type = type
    self.photo = photo
  }

  public var variables: GraphQLMap? {
    return ["file": file, "reach_id": reach_id, "type": type, "photo": photo]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("photoFileCreate", arguments: ["fileinput": ["file": GraphQLVariable("file"), "section": GraphQLVariable("type"), "section_id": GraphQLVariable("reach_id")], "photo": GraphQLVariable("photo")], type: .object(PhotoFileCreate.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(photoFileCreate: PhotoFileCreate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "photoFileCreate": photoFileCreate.flatMap { (value: PhotoFileCreate) -> ResultMap in value.resultMap }])
    }

    public var photoFileCreate: PhotoFileCreate? {
      get {
        return (resultMap["photoFileCreate"] as? ResultMap).flatMap { PhotoFileCreate(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "photoFileCreate")
      }
    }

    public struct PhotoFileCreate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Photo"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("post_id", type: .scalar(String.self)),
        GraphQLField("post", type: .object(Post.selections)),
        GraphQLField("image", type: .object(Image.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, postId: String? = nil, post: Post? = nil, image: Image? = nil) {
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

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
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

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("detail", type: .scalar(String.self)),
          GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, detail: String? = nil, postType: PostType) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "detail": detail, "post_type": postType])
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
      }

      public struct Image: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ImageInfo"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("uri", type: .object(Uri.selections)),
        ]

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

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("thumb", type: .scalar(String.self)),
            GraphQLField("medium", type: .scalar(String.self)),
            GraphQLField("big", type: .scalar(String.self)),
          ]

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

          public var thumb: String? {
            get {
              return resultMap["thumb"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "thumb")
            }
          }

          public var medium: String? {
            get {
              return resultMap["medium"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "medium")
            }
          }

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

public final class PostPhotoMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation PostPhoto($id: ID!, $post: PostInput!) {
      postUpdate(id: $id, post: $post) {
        __typename
        id
        reach_id
        title
        post_type
      }
    }
    """

  public let operationName: String = "PostPhoto"

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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("postUpdate", arguments: ["id": GraphQLVariable("id"), "post": GraphQLVariable("post")], type: .object(PostUpdate.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postUpdate: PostUpdate? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "postUpdate": postUpdate.flatMap { (value: PostUpdate) -> ResultMap in value.resultMap }])
    }

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

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .scalar(GraphQLID.self)),
        GraphQLField("reach_id", type: .scalar(String.self)),
        GraphQLField("title", type: .scalar(String.self)),
        GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, reachId: String? = nil, title: String? = nil, postType: PostType) {
        self.init(unsafeResultMap: ["__typename": "Post", "id": id, "reach_id": reachId, "title": title, "post_type": postType])
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

      public var reachId: String? {
        get {
          return resultMap["reach_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "reach_id")
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
    }
  }
}

public final class PhotosQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Photos($page_size: Int!, $reach_id: AWID!, $page: Int!, $gauge_id: AWID, $post_types: [PostType]) {
      posts(post_types: $post_types, reach_id: $reach_id, gauge_id: $gauge_id, first: $page_size, page: $page, orderBy: [{field: REVISION, order: DESC}]) {
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
          gauge_id
          detail
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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("posts", arguments: ["post_types": GraphQLVariable("post_types"), "reach_id": GraphQLVariable("reach_id"), "gauge_id": GraphQLVariable("gauge_id"), "first": GraphQLVariable("page_size"), "page": GraphQLVariable("page"), "orderBy": [["field": "REVISION", "order": "DESC"]]], type: .object(Post.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(posts: Post? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "posts": posts.flatMap { (value: Post) -> ResultMap in value.resultMap }])
    }

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

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
        GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
      ]

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

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
          GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
          GraphQLField("total", type: .nonNull(.scalar(Int.self))),
        ]

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

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("post_type", type: .nonNull(.scalar(PostType.self))),
          GraphQLField("post_date", type: .scalar(String.self)),
          GraphQLField("reach_id", type: .scalar(String.self)),
          GraphQLField("gauge_id", type: .scalar(String.self)),
          GraphQLField("detail", type: .scalar(String.self)),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.object(Photo.selections))))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, postType: PostType, postDate: String? = nil, reachId: String? = nil, gaugeId: String? = nil, detail: String? = nil, user: User? = nil, photos: [Photo]) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "post_type": postType, "post_date": postDate, "reach_id": reachId, "gauge_id": gaugeId, "detail": detail, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "photos": photos.map { (value: Photo) -> ResultMap in value.resultMap }])
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

        public var gaugeId: String? {
          get {
            return resultMap["gauge_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "gauge_id")
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

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uname", type: .nonNull(.scalar(String.self))),
          ]

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

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
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

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, caption: String? = nil, postId: String? = nil, description: String? = nil, subject: String? = nil, photoDate: String? = nil, author: String? = nil, poiName: String? = nil, poiId: String? = nil, image: Image? = nil) {
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

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
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

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("ext", type: .scalar(String.self)),
              GraphQLField("uri", type: .object(Uri.selections)),
            ]

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

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("thumb", type: .scalar(String.self)),
                GraphQLField("medium", type: .scalar(String.self)),
                GraphQLField("big", type: .scalar(String.self)),
              ]

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

              public var thumb: String? {
                get {
                  return resultMap["thumb"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "thumb")
                }
              }

              public var medium: String? {
                get {
                  return resultMap["medium"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "medium")
                }
              }

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
            accidentdate
            reach_id
            river
            section
            location
            waterlevel
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

    public static let selections: [GraphQLSelection] = [
      GraphQLField("reach", arguments: ["id": GraphQLVariable("reach_id")], type: .object(Reach.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(reach: Reach? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }])
    }

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

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("accidents", arguments: ["first": GraphQLVariable("first"), "page": GraphQLVariable("page")], type: .object(Accident.selections)),
      ]

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

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("paginatorInfo", type: .nonNull(.object(PaginatorInfo.selections))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]

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

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("total", type: .nonNull(.scalar(Int.self))),
            GraphQLField("count", type: .nonNull(.scalar(Int.self))),
            GraphQLField("currentPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("hasMorePages", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("lastPage", type: .nonNull(.scalar(Int.self))),
            GraphQLField("perPage", type: .nonNull(.scalar(Int.self))),
          ]

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

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("accidentdate", type: .scalar(String.self)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("river", type: .scalar(String.self)),
            GraphQLField("section", type: .scalar(String.self)),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("waterlevel", type: .scalar(String.self)),
            GraphQLField("difficulty", type: .scalar(String.self)),
            GraphQLField("age", type: .scalar(Int.self)),
            GraphQLField("experience", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("factors", type: .list(.nonNull(.object(Factor.selections)))),
            GraphQLField("injuries", type: .list(.nonNull(.object(Injury.selections)))),
            GraphQLField("causes", type: .list(.nonNull(.object(Cause.selections)))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, accidentdate: String? = nil, reachId: String? = nil, river: String? = nil, section: String? = nil, location: String? = nil, waterlevel: String? = nil, difficulty: String? = nil, age: Int? = nil, experience: String? = nil, description: String? = nil, factors: [Factor]? = nil, injuries: [Injury]? = nil, causes: [Cause]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Accident", "id": id, "accidentdate": accidentdate, "reach_id": reachId, "river": river, "section": section, "location": location, "waterlevel": waterlevel, "difficulty": difficulty, "age": age, "experience": experience, "description": description, "factors": factors.flatMap { (value: [Factor]) -> [ResultMap] in value.map { (value: Factor) -> ResultMap in value.resultMap } }, "injuries": injuries.flatMap { (value: [Injury]) -> [ResultMap] in value.map { (value: Injury) -> ResultMap in value.resultMap } }, "causes": causes.flatMap { (value: [Cause]) -> [ResultMap] in value.map { (value: Cause) -> ResultMap in value.resultMap } }])
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

          public var accidentdate: String? {
            get {
              return resultMap["accidentdate"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "accidentdate")
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

          public var waterlevel: String? {
            get {
              return resultMap["waterlevel"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "waterlevel")
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

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("factor", type: .scalar(String.self)),
            ]

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

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("injury", type: .scalar(String.self)),
            ]

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

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("cause", type: .scalar(String.self)),
            ]

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
