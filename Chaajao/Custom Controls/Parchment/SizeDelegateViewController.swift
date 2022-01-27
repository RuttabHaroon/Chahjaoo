import UIKit

final class SizeDelegateViewController: PagingViewController {

  var viewControllers: [UIViewController]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.sizeDelegate =  self
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

extension SizeDelegateViewController: PagingViewControllerDataSource {
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


extension SizeDelegateViewController: PagingViewControllerSizeDelegate {
  
  // We want the size of our paging items to equal the width of the
  // city title. Parchment does not support self-sizing cells at
  // the moment, so we have to handle the calculation ourself. We
  // can access the title string by casting the paging item to a
  // PagingTitleItem, which is the PagingItem type used by
  // FixedPagingViewController.
  func pagingViewController(_ pagingViewController: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
    guard let item = pagingItem as? PagingIndexItem else { return 0 }
    
    let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: pagingViewController.options.menuItemSize.height)
    let attributes = [NSAttributedString.Key.font: pagingViewController.options.font]
    
    let rect = item.title.boundingRect(with: size,
                                       options: .usesLineFragmentOrigin,
                                       attributes: attributes,
                                       context: nil)
    
    let width = ceil(rect.width) + insets.left + insets.right
    
    if isSelected {
      return width * 1.5
    } else {
      return width
    }
  }
  
}

