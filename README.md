# 9. SpotifyPayWall

## 🍎 작동 화면

| 작동 화면 |
|:-:|
| ![](https://i.imgur.com/T2RVprv.gif) |

## 🍎 section.orthogonalScrollingBehavior의 역할
- 먼저 코드의 Compositional Layout을 구성하는 layout()메서드에서,
- let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])


## 🍎 section은 가로 스크롤 설정이 되었는데 세로로 움직이는 현상 수정
- 아래 현상과 같이 section은 가로 스크롤만 가능하게 되어있는데 세로로 바운스가 되는 현상을 찾았다. 
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
![](https://i.imgur.com/JIWzxmP.png)

- currentPage: Int
    - 현재 page를 설정하는 UIPageControl의 프로퍼티
```swift
pageControl.currentPage = index
```


## 🍎 visibleItemsInvalidationHandler프로퍼티 역할

- 현재 보여지고 있는 화면의 정보를 item, offset, env 파라미터로 알수있게 해줌.
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
