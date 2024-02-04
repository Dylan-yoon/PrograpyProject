# PrograpyProject
> Project 기간: 24.01.29 ~ 24.02.04

## List
1. [Introduce](#introduce)
2. [사용 기술](#사용-기술)
3. [실행 화면](#실행-화면)
4. [생각 및 고민](#생각-및-고민)
5. [회고](#회고)

<br>

## Introduce

[Unsplash](https://unsplash.com/ko) 사이트의 Image를 다양한 방법으로 보여주는 Project
</br>

## 사용 기술
- CollectioView****
  - Compositional Layout
  - Diffable Datasource
- UIAnimation
- UIActivityIndicatorView
- LocalDB
  - CoreData
- URLSession
- GitFlow

<br>

## 실행 화면

| Main View | 다크모드 | 북마크 클릭 |
|:--------:|:--------:|:--------:|
|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/5e966a13-67f9-401b-90f5-2b4c1aadf2f7" width="300">|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/749310fa-79b6-4b0e-9a03-57145181c878" width="300">|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/4935186b-87d8-41a2-944f-ebcc87518e95" width="300">|

| X버튼 클릭 | Tap2 Detail | Tap2|
|:--------:|:--------:|:--------:|
|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/1c336d34-add5-407e-b728-cdfdf21a6357" width="300">|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/74bf2f64-c281-4caa-a416-4afec1789f4d" width="300">|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/75a11815-3b0e-4ca3-8b17-b075425c83a8" width="300">|

SwipeAction
| 우 -> 좌 | 좌 -> 우 |
|:--------:|:--------:|
|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/a697f614-5818-48ba-9755-a441ccfceadd" width="300">|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/1971c098-fb06-4b82-96a6-53c212fc3553" width="300">|

| 북마크 저장 | 페이지 네이션 |
|:--------:|:--------:|
|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/dd26b0c6-1cdc-4a4b-a99a-84c32231cb84" width="300">|<img src="https://github.com/Dylan-yoon/PrograpyProject/assets/77507952/b96d5c4c-ca76-48da-bf16-0b0ece25875f" width="300">|




## 생각 및 고민
### 어떤 CollectioView를 사용해야 할지에 대한 고민
- 북마크와 최근 이미지를 표현하기 위해 collectionView를 1개를 사용할 것인지 2개를 사용할 것인지에 대해 고민함.
- 2개의 CollectionVIew를 사용하게 된다면, 각각의 DataSource를 사용하게 될 것.
  - bookmark, recent가 나누어져 있기 때문에, Header, footer 구현이 용이함
  - 데이터 소스 사용하기에 편리하다고 생각됨
- 1개의 CollectionView를 사용한다면 DiffableDataSource + Compositional Layout
  - DiffableDataSource가 매우 편리함
  - 하지만 사용 경험이 없어 구현 정보가 부족함
 
### 2번째 탭의 Layout
- CollectioView VS View
  - View에 Gesture를 넣어주어서 카드를 넘기는 형식으로 구현 할 수 있다고 생각하고 View로 구현.
  - subview가 카드 자체가 되면서 UISwipeGestureRecognizer 를 Subview인 CardView에 담아주었다.

### Image를 CoreData에 저장해야할까?
- 처음에는 URL만 가지고 있었다.
  - 바꾼 이유
    - 계속해서 URL을 사용해 네트워킹을 하는 것 보다, LocalData로 가지고 있는것이 유리하다고 생각함.
    - (해당 키가 시간당 50번 호출이 가능함으로.. 호출을 줄이기 위해.)
### Git전력
- 1인 개발이기 때문에, Git전략을 쓰기에는 과할 수 있지만, 좀 더 구현부를 나누기 위해 사용함.

## 회고
- 전반적으로 UI구현하고 어떻게 사용해야할지 공부 하다가 많은 시간이 지체되어, 아키텍쳐를 적용하지 못한 점이 아쉽다.
- 좀 더 체계적으로 Model을 구현 해야 함.
- WaterFall Layout에 대해서 더 고민.
- MVVM, Rx를 사용하용하지 못했지만, 좀 더 UI에 익숙해지고 바로 MVVM으로 구현 할 수 있도록 노력해야 겠다고 생각함.
- CoreData, Network를 동시에 사용하거나 URL을 받아와 다시 URLSession을 사용할 때 더 유기적으로 구현하는 것을 고민해봐야 함.
- 결국엔 UI구현만을 위한 Project가 되어서 아쉽지만, 추후 더 프로젝트를 다듬을 예정.
