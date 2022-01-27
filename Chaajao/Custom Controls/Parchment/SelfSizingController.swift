import UIKit

final class SelfSizingController: PagingViewController {
  
    var viewControllers: [UIViewController]!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
   
  }
    public init(viewControllers: [UIViewController]) {
      self.viewControllers = viewControllers
      super.init()
      dataSource = self
    }

    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelfSizingController: PagingViewControllerDataSource {
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: viewControllers[index].title ?? "")
  }
    
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    return viewControllers[index]
    
  }
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return viewControllers.count
  }
}

