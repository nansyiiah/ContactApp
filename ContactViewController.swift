//
//  ContactViewController.swift
//  ContactApp
//
//  Created by Adrian K on 27/05/22.
//

import UIKit
import CoreData

class ContactViewController: UIViewController, UITextFieldDelegate {
    
    var currentUser: UserListItem?
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var phoneError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.isEnabled = false
        
        if currentUser != nil {
            txtFirstName.text = currentUser!.firstName
            txtEmail.text = currentUser!.email
            txtPhoneNumber.text = currentUser!.mobilePhone
        }
           
           let textFields: [UITextField] = [txtFirstName, txtPhoneNumber, txtEmail]

        for textField in textFields {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentUser?.firstName = txtFirstName.text
        currentUser?.email = txtEmail.text
        currentUser?.mobilePhone = txtPhoneNumber.text
        return true
    }
    
    func resetForm() {
        txtFirstName.text = ""
        txtEmail.text = ""
        txtPhoneNumber.text = ""
    }
    
    @IBAction func emailChanged(_ sender: Any)
    {
        if let email = txtEmail.text
        {
            if let errorMessage = invalidEmail(email)
            {
                emailError.text = errorMessage
                emailError.isHidden = false
            }
            else
            {
                emailError.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    @IBAction func phoneChanged(_ sender: Any)
    {
        if let phone = txtPhoneNumber.text
        {
            if let errorMessage = invalidPhone(phone)
            {
                phoneError.text = errorMessage
                phoneError.isHidden = false
            }
            else
            {
                phoneError.isHidden = true
            }
        }
        
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?
    {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address Format"
        }
        
        return nil
    }
    
    func invalidPhone(_ value: String) -> String?
    {
        let PHONE_REGEX = "[0-9]{3}.*[0-9]{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        
        if !phoneTest.evaluate(with: value)
        {
            return "Invalid Phone Number Format"
        }
        return nil
    }
    
    func checkForValidForm()
    {
        if emailError.isHidden && phoneError.isHidden
        {
            saveBtn.isEnabled = true
        }
        else
        {
            saveBtn.isEnabled = false
        }
    }
    
    @objc func saveContact() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{ return }
        if currentUser == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentUser = UserListItem(context: context)
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserListItem", in: managedContext)
        let record = NSManagedObject(entity: entity!, insertInto: managedContext)
        record.setValue(txtFirstName.text, forKey: "firstName")
        record.setValue(txtEmail.text, forKey: "email")
        record.setValue(txtPhoneNumber.text, forKey: "mobilePhone")
        do{
            try managedContext.save()
            print("Record Added !")
            let alertController = UIAlertController(title: "Message", message: "Save Contact Successfully !", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }catch let err as NSError {
            print("Could not save because. \(err), \(err.userInfo)")
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if currentUser != nil {
            txtFirstName.text = currentUser!.firstName
            txtEmail.text = currentUser!.email
            txtPhoneNumber.text = currentUser!.mobilePhone
        }
        saveContact()
        resetForm()
    }
}
