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

public enum PermissionResult: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case allow
  case denyUrlError
  case denyLogin
  case denyBlank
  case denyDefault
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ALLOW": self = .allow
      case "DENY_URL_ERROR": self = .denyUrlError
      case "DENY_LOGIN": self = .denyLogin
      case "DENY_BLANK": self = .denyBlank
      case "DENY_DEFAULT": self = .denyDefault
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .allow: return "ALLOW"
      case .denyUrlError: return "DENY_URL_ERROR"
      case .denyLogin: return "DENY_LOGIN"
      case .denyBlank: return "DENY_BLANK"
      case .denyDefault: return "DENY_DEFAULT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PermissionResult, rhs: PermissionResult) -> Bool {
    switch (lhs, rhs) {
      case (.allow, .allow): return true
      case (.denyUrlError, .denyUrlError): return true
      case (.denyLogin, .denyLogin): return true
      case (.denyBlank, .denyBlank): return true
      case (.denyDefault, .denyDefault): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PermissionResult] {
    return [
      .allow,
      .denyUrlError,
      .denyLogin,
      .denyBlank,
      .denyDefault,
    ]
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
          reading
          post_date
          metric_id
          reach_id
          gauge_id
          gauge {
            __typename
            name
            id
          }
          reach {
            __typename
            id
            river
            section
          }
          detail
          permissions {
            __typename
            permission
            result
          }
          user {
            __typename
            uname
            image {
              __typename
              uri {
                __typename
                medium
                thumb
              }
            }
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
          GraphQLField("reading", type: .scalar(Double.self)),
          GraphQLField("post_date", type: .scalar(String.self)),
          GraphQLField("metric_id", type: .scalar(Int.self)),
          GraphQLField("reach_id", type: .scalar(String.self)),
          GraphQLField("gauge_id", type: .scalar(String.self)),
          GraphQLField("gauge", type: .object(Gauge.selections)),
          GraphQLField("reach", type: .object(Reach.selections)),
          GraphQLField("detail", type: .scalar(String.self)),
          GraphQLField("permissions", type: .nonNull(.list(.nonNull(.object(Permission.selections))))),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.object(Photo.selections))))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, postType: PostType, reading: Double? = nil, postDate: String? = nil, metricId: Int? = nil, reachId: String? = nil, gaugeId: String? = nil, gauge: Gauge? = nil, reach: Reach? = nil, detail: String? = nil, permissions: [Permission], user: User? = nil, photos: [Photo]) {
          self.init(unsafeResultMap: ["__typename": "Post", "id": id, "title": title, "post_type": postType, "reading": reading, "post_date": postDate, "metric_id": metricId, "reach_id": reachId, "gauge_id": gaugeId, "gauge": gauge.flatMap { (value: Gauge) -> ResultMap in value.resultMap }, "reach": reach.flatMap { (value: Reach) -> ResultMap in value.resultMap }, "detail": detail, "permissions": permissions.map { (value: Permission) -> ResultMap in value.resultMap }, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "photos": photos.map { (value: Photo) -> ResultMap in value.resultMap }])
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

        public var reading: Double? {
          get {
            return resultMap["reading"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "reading")
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

        public var metricId: Int? {
          get {
            return resultMap["metric_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "metric_id")
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

        public var gauge: Gauge? {
          get {
            return (resultMap["gauge"] as? ResultMap).flatMap { Gauge(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "gauge")
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

        public var permissions: [Permission] {
          get {
            return (resultMap["permissions"] as! [ResultMap]).map { (value: ResultMap) -> Permission in Permission(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Permission) -> ResultMap in value.resultMap }, forKey: "permissions")
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

        public struct Gauge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Gauge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, id: GraphQLID? = nil) {
            self.init(unsafeResultMap: ["__typename": "Gauge", "name": name, "id": id])
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

        public struct Permission: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PermissionReturn"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("permission", type: .nonNull(.scalar(String.self))),
            GraphQLField("result", type: .nonNull(.scalar(PermissionResult.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(permission: String, result: PermissionResult) {
            self.init(unsafeResultMap: ["__typename": "PermissionReturn", "permission": permission, "result": result])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var permission: String {
            get {
              return resultMap["permission"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "permission")
            }
          }

          public var result: PermissionResult {
            get {
              return resultMap["result"]! as! PermissionResult
            }
            set {
              resultMap.updateValue(newValue, forKey: "result")
            }
          }
        }

        public struct User: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("uname", type: .nonNull(.scalar(String.self))),
            GraphQLField("image", type: .object(Image.selections)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(uname: String, image: Image? = nil) {
            self.init(unsafeResultMap: ["__typename": "User", "uname": uname, "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
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
                GraphQLField("medium", type: .scalar(String.self)),
                GraphQLField("thumb", type: .scalar(String.self)),
              ]

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

              public var medium: String? {
                get {
                  return resultMap["medium"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "medium")
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
            victimname
            reach_id
            countryabbr
            state
            river
            section
            location
            waterlevel
            rellevel
            difficulty
            age
            experience
            privcomm
            boattype
            groupinfo
            numvictims
            othervictimnames
            description
            type
            cause
            contactname
            contactphone
            contactemail
            status
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
            GraphQLField("victimname", type: .scalar(String.self)),
            GraphQLField("reach_id", type: .scalar(String.self)),
            GraphQLField("countryabbr", type: .scalar(String.self)),
            GraphQLField("state", type: .scalar(String.self)),
            GraphQLField("river", type: .scalar(String.self)),
            GraphQLField("section", type: .scalar(String.self)),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("waterlevel", type: .scalar(String.self)),
            GraphQLField("rellevel", type: .scalar(String.self)),
            GraphQLField("difficulty", type: .scalar(String.self)),
            GraphQLField("age", type: .scalar(Int.self)),
            GraphQLField("experience", type: .scalar(String.self)),
            GraphQLField("privcomm", type: .scalar(String.self)),
            GraphQLField("boattype", type: .scalar(String.self)),
            GraphQLField("groupinfo", type: .scalar(String.self)),
            GraphQLField("numvictims", type: .scalar(Int.self)),
            GraphQLField("othervictimnames", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("cause", type: .scalar(Int.self)),
            GraphQLField("contactname", type: .scalar(String.self)),
            GraphQLField("contactphone", type: .scalar(String.self)),
            GraphQLField("contactemail", type: .scalar(String.self)),
            GraphQLField("status", type: .scalar(String.self)),
            GraphQLField("factors", type: .list(.nonNull(.object(Factor.selections)))),
            GraphQLField("injuries", type: .list(.nonNull(.object(Injury.selections)))),
            GraphQLField("causes", type: .list(.nonNull(.object(Cause.selections)))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, accidentdate: String? = nil, victimname: String? = nil, reachId: String? = nil, countryabbr: String? = nil, state: String? = nil, river: String? = nil, section: String? = nil, location: String? = nil, waterlevel: String? = nil, rellevel: String? = nil, difficulty: String? = nil, age: Int? = nil, experience: String? = nil, privcomm: String? = nil, boattype: String? = nil, groupinfo: String? = nil, numvictims: Int? = nil, othervictimnames: String? = nil, description: String? = nil, type: String? = nil, cause: Int? = nil, contactname: String? = nil, contactphone: String? = nil, contactemail: String? = nil, status: String? = nil, factors: [Factor]? = nil, injuries: [Injury]? = nil, causes: [Cause]? = nil) {
            self.init(unsafeResultMap: ["__typename": "Accident", "id": id, "accidentdate": accidentdate, "victimname": victimname, "reach_id": reachId, "countryabbr": countryabbr, "state": state, "river": river, "section": section, "location": location, "waterlevel": waterlevel, "rellevel": rellevel, "difficulty": difficulty, "age": age, "experience": experience, "privcomm": privcomm, "boattype": boattype, "groupinfo": groupinfo, "numvictims": numvictims, "othervictimnames": othervictimnames, "description": description, "type": type, "cause": cause, "contactname": contactname, "contactphone": contactphone, "contactemail": contactemail, "status": status, "factors": factors.flatMap { (value: [Factor]) -> [ResultMap] in value.map { (value: Factor) -> ResultMap in value.resultMap } }, "injuries": injuries.flatMap { (value: [Injury]) -> [ResultMap] in value.map { (value: Injury) -> ResultMap in value.resultMap } }, "causes": causes.flatMap { (value: [Cause]) -> [ResultMap] in value.map { (value: Cause) -> ResultMap in value.resultMap } }])
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

          public var victimname: String? {
            get {
              return resultMap["victimname"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "victimname")
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

          public var countryabbr: String? {
            get {
              return resultMap["countryabbr"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "countryabbr")
            }
          }

          public var state: String? {
            get {
              return resultMap["state"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
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

          public var rellevel: String? {
            get {
              return resultMap["rellevel"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "rellevel")
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

          public var privcomm: String? {
            get {
              return resultMap["privcomm"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "privcomm")
            }
          }

          public var boattype: String? {
            get {
              return resultMap["boattype"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "boattype")
            }
          }

          public var groupinfo: String? {
            get {
              return resultMap["groupinfo"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "groupinfo")
            }
          }

          public var numvictims: Int? {
            get {
              return resultMap["numvictims"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "numvictims")
            }
          }

          public var othervictimnames: String? {
            get {
              return resultMap["othervictimnames"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "othervictimnames")
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

          public var type: String? {
            get {
              return resultMap["type"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var cause: Int? {
            get {
              return resultMap["cause"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "cause")
            }
          }

          public var contactname: String? {
            get {
              return resultMap["contactname"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "contactname")
            }
          }

          public var contactphone: String? {
            get {
              return resultMap["contactphone"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "contactphone")
            }
          }

          public var contactemail: String? {
            get {
              return resultMap["contactemail"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "contactemail")
            }
          }

          public var status: String? {
            get {
              return resultMap["status"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "status")
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
