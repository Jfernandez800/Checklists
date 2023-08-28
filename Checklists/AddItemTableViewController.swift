//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by James Fernandez on 8/27/23.
//

import UIKit

//delegate protocol contract between Screen B
protocol AddItemTableViewControllerDelegate: AnyObject {
    //when cancel is pressed.
    func addItemViewTableControllerDidCancel(
    _ controller: AddItemTableViewController)
    //when done is pressed.
    func addItemTableViewController(
    _ controller: AddItemTableViewController,
    //this will pass the parameter to ChecklistItem object.
    didFinishAdding item: ChecklistItem
  )
}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate { //can now be a delegate for text fields.
    //connects the row from addItem to done.
    @IBOutlet weak var textField: UITextField!
    //sends messages from within view controller to enable or disable done bar button.
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //
    weak var delegate: AddItemTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    //sends message to delegate that cancel was tapped.
    @IBAction func cancel() {
      delegate?.addItemViewTableControllerDidCancel(self)
    }

    // This variable refers to the other view controller
    var checklistViewController: ChecklistViewController
    
    //sends message to delegate that done was tapped and passes new Checklist object from text field.
    @IBAction func done() {
      let item = ChecklistItem()
      item.text = textField.text!
      delegate?.addItemTableViewController(self, didFinishAdding: item)
    }
    
    // MARK: - Table View Delegates
    //disables selections on the row that is being created.
    override func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {       //question mark gives it the ability to return nil. so it tells the row to do nothing when tapped.
    return nil
    }
    
    //This method will automatically bring the keyboard out when addItem is active.
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      textField.becomeFirstResponder()
    }
    
    // MARK: - Text Field Delegates
    //This method changes the text every time user taps or cut/paste.
    func textField(
      _ textField: UITextField,
      shouldChangeCharactersIn range: NSRange,
      replacementString string: String
    ) -> Bool {
        //figures out what the new text is.
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        //once the text us done it checks to see if text field is empty to enable or disable done.
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
}
