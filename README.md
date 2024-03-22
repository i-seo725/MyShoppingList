## MyShoppingList - 나의 소중한 쇼핑 목록
<p align="center">
 <img width="1018" align src="./recap2_screenshot.001.png">
</p>

## 앱 소개
 * 원하는 키워드로 상품을 검색하여 나만의 쇼핑 리스트 만들기
 * 다양한 조건에 따라 정렬하며 상품 탐색하기
 * 앱 상에서 네이버 쇼핑 웹사이트로 이동하여 쇼핑 상세 정보 보기 지원
 * 마음에 드는 상품만 체크하여 별도 화면에서 모아 보기 기능
 * 최근 클릭한 상품 목록 최대 30개 제공
<br/>


## 주요 기능
 * Realm DB를 통해 사용자가 좋아요 버튼을 탭한 상품 관리 및 최근 본 상품 목록 제공
 * Alamofire를 활용한 네이버 검색 API를 통해 상품 리스트 가져오기
 * KingFisher 라이브러리를 활용한 이미지 불러오기 및 캐싱
 <br/>

## 개발 기간
 * 2023.09.07. ~ 2023.09.11.(5일)
<br/>

## 개발환경
  * Xcode 14.3.1
  * Supported Destinations : iPhone
  * Minimum Deployments : 13.0
  * Orientation : Portrait
<br/>


## 사용기술 및 라이브러리
 * UIKit, Snapkit, Realm, Alamofire, KingFisher, MVC
 <br/>
 
## 트러블 슈팅     
 ### 1. 상품 검색 시 이미지 반복 호출로 인한 네트워크 리소스 낭비
   * 다음과 같은 코드로 상품 검색 시 cell이 보여질 때마다 URL에 이미지를 요청하는 코드 반복 수행
     ```swift
     if let url = URL(string: item.image) {
            DispatchQueue.global().async {
                let data = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.productImage.image = UIImage(data: data)
                }
            }
        }
     ```
   * KingFisher 라이브러리를 활용하여 이미지 캐싱 처리 및 코드 간결화
     ```swift
     cell.productImage.kf.setImage(with: URL(string: item.image))
     ```
   
 ### 2. 최근 본 상품 테이블 구조 설계 시 primary key 중복으로 인한 런타임 오류 발생
   * 좋아요 목록 테이블과 동일한 구조로 설계하여 API 리턴값 중 하나인 productID를 primary key로 설정하였으나 이로 인한 런타임 오류 발생
   * 사용자가 동일한 상품을 중복하여 확인할 경우 productID가 더 이상 고유한 값이 아니게 됨
   * primary key를 productID에서 realm에서 제공하는 objectID 타입의 프로퍼티로 변경
   * 다음과 같은 코드를 통한 예외 처리 구현

     ```swift
     class RecentItem: Object {
    
      @Persisted(primaryKey: true) var _id: ObjectId
      @Persisted var productId: String
      @Persisted var title: String
      @Persisted var mallName: String
      @Persisted var price: String
      @Persisted var image: String
      @Persisted var date: Date
    
      convenience init(title: String, productId: String, mallName: String, price: String, image: String, date: Date = Date()) {
        
        self.init()
        self.title = title
        self.productId = productId
        self.mallName = mallName
        self.price = price
        self.image = image
        self.date = date
      }
     }
     ```

<br/>

## 회고
 * 짧은 기간 안에 네트워크 요청과 데이터베이스를 다루느라 쉽지 않았으나 프로젝트를 끝내니 해당 기능에 대한 이해도가 올라갔다고 느낌
 * 데이터베이스를 각각의 VC에서 선언하는 방법이 아닌 더 효율적인 방법을 찾아 적용했다면 더 좋았을 거라는 아쉬움이 남아 추가 학습할 계획
 * 네트워크 실패 시의 에러 처리를 print로만 처리하였는데 사용자를 위한 처리 방법에 무엇이 있을지 고민하게 됨
