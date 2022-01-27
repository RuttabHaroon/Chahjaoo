
import UIKit

open class BaseUITableViewCell: UITableViewCell {

    //MARK: - Properties
    static var cellIdentifier:String!{
        get {
            return "\(self)"
        }
    }
    
    lazy var tapgesture: UITapGestureRecognizer! = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureClicked))
        return gesture
    }()
    
    class func classname()->String {
        return "\(self)"
    }
    private var _data:Any?
    private var _otherObj:Any?
    /// Holds Table View Cell Data.
    open var data:Any? {
        get {
            return _data;
        }
        set {
            return _data = newValue
        }
    } //P.E.
    open var otheroObj:Any? {
        get {
            return _otherObj;
        }
    } //P.E.
    
    @objc func handleTapGestureClicked(gesture: UITapGestureRecognizer) {
        
    }

    /// Convenience constructor with cell reuseIdentifier - by default style = UITableViewCellStyle.default.
    ///
    /// - Parameter reuseIdentifier: Reuse identifier
    public convenience init(reuseIdentifier: String?) {
        self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier);
    } //F.E.
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameters:
    ///   - style: Table View Cell Style
    ///   - reuseIdentifier: Reuse identifier
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        //--
        self.selectionStyle = UITableViewCell.SelectionStyle.none;
        //--
        self.commonInit();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInit();
    } //F.E.
    
    /// Overridden method to receive selected states of table view cell
    ///
    /// - Parameters:
    ///   - selected: Flag for Selected State
    ///   - animated: Flag for Animation
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    } //F.E.
    
    /// Overridden methed to update layout.
    override open func layoutSubviews() {
        super.layoutSubviews();
    } //F.E.
    
    //MARK: - Methods
    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none;
        //--
        self.contentView.backgroundColor  = UIColor.clear;
        
    } //F.E.
    
    /// This method should be called in cellForRowAt:indexPath.
    /// - Parameter data: Cell Data
    open func updateData(_ data:Any?) {
        _data = data;
    } //F.E.
    
    open func updateData(_ data:Any?,otherObj:Any?) {
        _data = data;
        _otherObj = otherObj;
    } //F.E.
    

} //CLS END
