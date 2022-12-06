# SpotifyPayWall

## 🍎 작동 화면
| 작동 화면 |
| :-: |
| ![](https://i.imgur.com/T2RVprv.gif) |

## 🍎 section.orthogonalScrollingBehavior의 역할
- [여기](https://github.com/KayAhn0126/iOS-Study/tree/main/GrammarAndKnowledge/ModernCollectionView)서 "사이즈 관련 헷갈리는 item, group, section 분석" 카테고리를 보자.

## 🍎 section은 가로 스크롤 설정이 되었는데 세로로 움직이는 현상 수정 
- 아래 현상과 같이 section은 가로 스크롤만 가능하게 되어있는데 세로로 바운스가 되는 현상을 찾았다.
- Section의 영역이 아니라 ScrollView를 상속받은 collectionView의 영역!
    - **정확히는 ScrollView의 프로퍼티!**
    ![](https://i.imgur.com/zCFBbTX.gif)
- 해결 방법: viewDidLoad 메서드에 아래 코드를 추가하면 된다.
    ```swift
    collectionView.alwaysBounceVertical = false
    ```
- alwaysBounceVertical 프로퍼티는 세로 스크롤이 콘텐츠뷰의 끝에 도달할 때 튀어 오르기가 항상 발생하는지를 결정하는 Bool 값이다.

## 🍎 Page Control 페이지 설정
- numberOfPages: Int
    - page의 총 갯수를 결정하는 UIPageControl의 프로퍼티
    ```swift
    pageControl.numberOfPages = info.count
    ```
![](https://i.imgur.com/RrH7FoB.png)
- currentPage: Int
    - 현재 page를 설정하는 UIPageControl의 프로퍼티
    ```swift
    pageControl.currentPage = index
    ```

## 🍎 visibleItemsInvalidationHandler 프로퍼티 역할
- NSCollectionLayoutSection 클래스의 프로퍼티.
- A closure called before each layout cycle to allow modification of the items in the section immediately before they’re displayed.
```swift
private func layout() -> UICollectionViewCompositionalLayout {
        
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 15
    section.orthogonalScrollingBehavior = .groupPagingCentered
        
    section.visibleItemsInvalidationHandler = { (item, offset, env) in
        let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
        print(">>>> \(index)")
        self.pageControl.currentPage = index
    }
        
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
}
```
