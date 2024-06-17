### 작업 환경
- **플랫폼**: iOS
- **IDE**: Xcode (iOS),
- **언어**: Swift (iOS)
- **버전 관리**: Git
- **빌드 시스템**: Xcode build system (iOS)

### 앱 기능
- **스플래시 화면**: 앱 실행 시 초기 로딩 화면, 2초 후 로그인 또는 메인 화면으로 전환
- **온보딩 화면**: 첫 실행 시 사용자 안내 화면, 프로필 설정 유도
- **프로필 설정**: 닉네임 및 이미지 설정 기능, 조건에 맞는 닉네임 설정 유도
- **메인 화면**: 사용자 맞춤형 화면, 최근 검색어 유무에 따른 UI 변화
- **검색 기능**: 키워드 검색, 검색 결과 조회, 하트 아이콘을 통한 관심 상품 등록
- **상품 상세 정보**: 상품 정보 및 리뷰 제공, 좋아요 기능
- **설정 화면**: 사용자 정보 및 앱 설정 기능, 알림 설정
- **프로필 수정**: 기존 프로필 정보 수정 기능

### 구현 기능
- **스플래시 화면**
  - 로고 이미지 표시
  - 2초 후 로그인 또는 메인 화면으로 전환
- **온보딩 화면**
  - 앱 최초 실행 시 표시
  - 프로필 설정 유도 (닉네임, 이미지)
- **프로필 닉네임 설정**
  - 닉네임 조건 검증 (특수문자 및 숫자 제한, 10자 이하)
  - 실시간 경고 메시지 표시
  - 완료 버튼 클릭 시 메인 화면으로 전환
- **프로필 이미지 설정**
  - 이미지 선택 기능
  - 선택된 이미지 강조 표시
  - 프로필 닉네임 설정 화면으로 반영
- **메인 화면**
  - 사용자 맞춤형 인사말 표시
  - 최근 검색어 리스트 및 검색 기능
  - 검색 결과 화면으로 전환
- **검색 결과 화면**
  - 네이버 쇼핑 API를 통한 데이터 조회
  - 페이지네이션 및 리스트 표시
  - 하트 아이콘을 통한 관심 상품 등록
- **상품 상세 화면**
  - 상품 정보 및 리뷰 표시
  - 좋아요 기능
- **설정 화면**
  - 사용자 정보 및 설정 표시
  - 프로필 수정 화면으로 전환
- **프로필 닉네임 수정**
  - 기존 프로필 정보 표시
  - 수정 후 저장 기능
- **프로필 이미지 수정**
  - 이미지 선택 및 반영 기능

### 사용 기술
- **프론트엔드**: UIKit (iOS)
- **백엔드**: 네이버 쇼핑 API
- **데이터베이스**: realm, swuft user defalut
- **네트워킹**: Alamofire (iOS)
- **UI/UX**: swift codebase

### 트러블 슈팅
- **스플래시 화면 전환 문제**: 스플래시 화면에서 메인 화면으로의 전환이 부드럽게 이루어지지 않는 문제 발생 시, 애니메이션과 스레드 조정으로 해결.
- **프로필 닉네임 검증**: 닉네임 조건 검증 로직 오류 발생 시, 정규 표현식 및 실시간 입력 검증 로직 수정.
- **네이버 쇼핑 API 통신 오류**: 네트워크 통신 실패 시, 재시도 로직 및 오류 메시지 표시 추가.
- **UI 반응성 문제**: 메인 화면 및 검색 결과 화면에서의 로딩 시간 지연 문제 발생 시, 비동기 처리 및 캐싱 기법 적용.
- **앱 설정 저장 문제**: 설정 화면에서 변경된 설정이 저장되지 않는 문제 발생 시, 데이터 저장 로직 및 SharedPreferences 검토.


# 기본 설정
- 최소 iOS 타겟 버전 15.0 지정 완료
- Device Orientation 지원은 Portrait 세로모드만 지정 완료
- 라이트모드로 설정 완료


# 구현 체크리스트

| 번호 | 항목 | 세부 조건 | 상태 |
|------|------|-----------|------|
| #0   | 스플래시 화면 | 오른 이미지와 유사한 형태로 [스플래시] 화면을 구현합니다. | [o] |
|      |                 | 스플래시 화면이 2초 유지됩니다. | [o] |
|      |                 | 이후 [로그인] 화면 또는 [메인] 화면으로 전환됩니다. | [o] |
| #1   | 온보딩 화면 | 오른 이미지와 유사한 형태로 [온보딩] 화면을 구현합니다. | [o] |
|      |                 | 최초로 앱을 실행할 경우 사용자에게 보여지는 화면입니다. 이외, | [o] |
|      |                 | - [프로필 닉네임] 설정 화면에서 아직 프로필을 설정하지 않은 경우 온보딩 화면부터 앱이 시작됩니다. | [o] |
|      |                 | - [프로필 이미지] 설정 화면에서 아직 프로필을 설정하지 않은 경우 온보딩 화면부터 앱이 시작됩니다. | [o] |
|      |                 | - 온보딩 화면부터 앱이 시작됩니다. | [o] |
|      |                 | [시작하기] 버튼을 누르면 [프로필 닉네임 설정 화면]으로 Push 됩니다. | [o] |
| #2   | 프로필 닉네임 설정 화면 | 제공된 이미지와 유사한 형태로 [프로필 닉네임 설정 화면]을 구현합니다. | [o] |
|      |                 | 프로필 이미지 | [o] |
|      |                 | - 앱에 최초 진입 시 프로필 이미지가 설정되어 있지 않기 때문에, 이를 위한 랜덤 이미지를 설정합니다. | [o] |
|      |                 | - 프로필 이미지 영역을 클릭하면 [프로필 이미지 설정 화면]으로 전환됩니다. | [o] |
|      |                 | 닉네임 | [o] |
|      |                 | - 닉네임 조건 | [o] |
|      |                 | - 글자수 이하 10글자 미만 | [o] |
|      |                 | - @, *, $, % 4가지 특수문자 및 숫자 사용 불가 | [o] |
|      |                 | - 실시간으로 달라지는 닉네임 텍스트에 따라 경고 메시지가 변경됩니다. | [o] |
|      |                 | 상태 메시지 | [o] |
|      |                 | - 조건에 맞는 경우: “사용할 수 있는 닉네임이에요” | [o] |
|      |                 | - 글자수 조건에 맞지 않는 경우: “글자수 이상 10글자 미만으로 설정해주세요” | [o] |
|      |                 | - 특수문자 조건에 맞지 않는 경우: “닉네임에 @, *, $, % 는 포함할 수 없어요” | [o] |
|      |                 | - 숫자 조건에 맞지 않는 경우: “닉네임에 숫자는 포함할 수 없어요” | [o] |
|      |                 | 완료 버튼 | [o] |
|      |                 | - 조건에 맞게 닉네임이 정상적으로 설정된 경우, Window RootViewController 가 메인 화면으로 그려집니다. | [o] |
|      |                 | - 프로필 이미지는 사용자가 전혀 설정하지 않더라도 메인으로 전환되어 이후에, 닉네임 조건만 완전히 설정되어 있는 상태의 메인 화면으로 이관되어 진행합니다. | [o] |
|      |                 | - 닉네임 조건에 맞게 정상설정 맞춘 경우, 최적 전환이 되어야 한 합니다. | [o] |
|      |                 | [더] 버튼 ([초기 설정 화면]으로 Pop 됩니다) | [o] |
|      |                 | - 이 때, 현재 사용자가 선택한 프로필 이미지와 입력한 닉네임 텍스트는 초기화 됩니다. | [o] |
| #3   | 프로필 이미지 설정 화면 | 오른 이미지와 유사한 형태로 [프로필 이미지 설정 화면]을 구현합니다. | [o] |
|      |                 | 사용자가 어떤 프로필 이미지든지 선택할 수 있도록, 선택한 이미지만 100% Alpha 값, 선택하지 않은 이미지와는 50% Alpha 값을 설정합니다. | [o] |
|      |                 | 사용자가 선택한 프로필 이미지는 상단의 이미지뷰에도 보여지도록 합니다. | [o] |
|      |                 | [확인] 버튼 ([프로필 닉네임 설정 화면]으로 Pop 됩니다. | [o] |
|      |                 | - 이 때, 사용자가 선택한 프로필 이미지는 닉네임 설정 화면의 프로필 이미지에도 반영되어야 합니다. | [o] |
| #4   | 메인 화면 - 최근 검색어 없는 경우 | 오른 이미지와 유사한 형태로 [메인] 화면을 구현합니다. | [o] |
|      |                 | 네비게이션 타이틀 영역에 OOO님의 MEANING OUT로 표현해주세요. | [o] |
|      |                 | - OOO는 사용자 닉네임이 입력됩니다. | [o] |
|      |                 | 최근 검색어가 없으면 단에 이미지화 되어 있는 Empty UI를 보여주고, 최근 검색어가 있다면 [# 메인 화면] 이미지처럼 구현해주세요. | [o] |
|      |                 | 사용자의 텍스트 입력 후 ReturnKey 를 입력하면 [검색 결과 화면]으로 Push 됩니다. | [o] |
| #5   | 메인 화면 - 최근 검색어 있는 경우 | 오른 이미지와 유사한 형태로 [메인] 화면을 구현합니다. | [o] |
|      |                 | 네비게이션 타이틀 영역에 OOO님의 MEANING OUT로 표현해주세요. | [o] |
|      |                 | - OOO는 사용자 닉네임이 입력됩니다. | [o] |
|      |                 | 최근 검색 키워드는 키워드 리스트 폼에 위치합니다. | [o] |
|      |                 | - 노출 순서는 최신 검색어가 상단에 노출됩니다. | [o] |
|      |                 | - [전체 삭제] 버튼을 누르면 모든 키워드가 삭제됩니다. | [o] |
|      |                 | 최근 / 자주 찾기 / 검색 부문은 크게 5개의 폼이며, 최근 검색 내역 리스트로 스크롤이 됩니다. | [o] |
|      |                 | 검색 리스트 중 하나를 선택하면, [검색 결과 화면]으로 Push 됩니다. | [o] |
| #6   | 검색 결과 화면 | 오른 이미지와 유사한 형태로 [검색 결과 화면]을 구현합니다. | [o] |
|      |                 | 네비게이션 타이틀 영역에 검색 키워드를 표현합니다. | [o] |
|      |                 | - 검색 키워드는 키워드 검색 시에 입력된 텍스트로 최근 검색어 리스트에 노출된 키워드 기준을 가집니다. | [o] |
|      |                 | 검색 데이터는 네이버 쇼핑 API를 활용합니다. | [o] |
|      |                 | - 데이터는 30개를 기본으로 페이지네이션 되어 리스트 합니다. | [o] |
|      |                 | - API 페이징 데이터를 기준으로 구현합니다. | [o] |
|      |                 | 쇼핑 정보 주요 키워드 정보를 노출합니다. | [o] |
|      |                 | - 데이터는 Image, mallName, title, lprice 정보를 확인할 수 있으며, title은 2줄까지 보여집니다. | [o] |
|      |                 | 검색 결과 조회 시 페이징된 영역으로 스크롤 되었으며, 검색 결과 리스트로 스크롤이 됩니다. | [o] |
|      |                 | 사용자가 하트 아이콘을 설정하거나 취소할 수 있습니다. | [o] |
|      |                 | - 설정 시 [관심 상품] 영역으로 이동합니다. | [o] |
| #7   | 상품 상세 화면 | 오른 이미지와 유사한 형태로 [상품 상세 화면]을 구현합니다. | [o] |
|      |                 | [현재 판매 정보] 에서 샘플 텍스트영역 (예 [상품 상세 화면]이 보이게 됩니다. | [o] |
|      |                 | 네비게이션 영역에 상품 타이틀과 상품의 주요 상태를 보여줍니다. | [o] |
|      |                 | 별점의 통계 상세 리뷰 페이지로 보여집니다. | [o] |
|      |                 | 사용자가 좋아요를 설정하거나 취소할 수 있습니다. | [o] |
| #8   | 설정 화면 | 오른 이미지와 유사한 형태로 [설정 화면]을 구현합니다. | [o] |
|      |                 | 타원 모양 내 영역에는 사용자가 설정한 이미지 / 닉네임 / 가입 날짜를 표시됩니다. | [o] |
|      |                 | 타원 뷰 내 영역에 선택하면 [프로필 수정 화면]으로 Push 됩니다. | [o] |
|      |                 | 나의 공지/구독/자주 하는 질문/1:1 문의/일정 설정 등을 선택되지 않지 않습니다. | [o] |
|      |                 | 나의 공지/구독/유용한 자주 하는 질문 자주 등은 설정 자주 등 보이도록 설정자 등 설정자 등 보이도록 | [o] |
|      |                 | 일별/월별 설정할 경우, Alert 이 뜨고 Alert에서 확인 버튼을 누른 행동 실행한 것 처럼 [본문영역 화면]으로 전환됩니다. | [o] |
|      |                 | Alert Title: 알림타이틀 | [o] |
|      |                 | Alert Message: 알림 메시지 현재 데이터가 모두 초기화됩니다. 할까요 시청하시겠습니까? | [o] |
|      |                 | Alert Action: 확인 / 취소 버튼 2가지 | [o] |
| #9   | 프로필 닉네임 수정 화면 | 오른 이미지와 유사한 형태로 [프로필 수정 화면]을 구현합니다. | [o] |
|      |                 | 사용자가 기존에 설정했던 이미지, 닉네임을 프로필 수정 화면에 보여줍니다. | [o] |
|      |                 | 닉네임 옆의 프로필 이미지 동작 등은 [프로필 닉네임 설정 화면]과 동일합니다. | [o] |
|      |                 | [저장] 버튼을 클릭하면 프로필 정보가 수정이 되고 Pop이 됩니다. | [o] |
| #10  | 프로필 이미지 수정 화면 | 오른 이미지와 유사한 형태로 [프로필 수정 화면]을 구현합니다. | [o] |
|      |                 | 프로필 이미지 동작 등은 [프로필 이미지 설정 화면]과 동일합니다. | [o] |
| #난이도 UP | 기타 명시되지 않은 부분은 자유롭게 개발 가능합니다. 어떤 부분을 많이 말까요? 여러 몇 가지 사례를 적성해보았습니다 :) | |
|      |                 | 최근 검색어 네임을 중복되지 않으면 검색 시간 2초 더 추가로 검색할 수 있습니다. | [o] |
|      |                 | [검색 결과 화면]에서 검색된 키워드 단어는 다른 색상으로 Highlight 처럼 볼 수 있습니다. | [x] |
|      |                 | [검색 결과 화면]에서 SkeletonView 또는 Indicator 을활용할 수 있습니다. | [x] |
|      |                 | 네트워크 통신이 단절되거나 실행할 경우 토스트 메시지(토스트 알람)과 여러지원을 할 수 있습니다. | [x] |
|      |                 | 그 외에 다양한 지점들을 생각해보셨어도 좋을 것 같습니다. | [o] |
