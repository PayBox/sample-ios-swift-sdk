//
//  ViewController.swift
//  sample-ios-swift-sdk
//
//  Created by Богодист Эдуард on 28.10.2021.
//

import UIKit
import PayBoxSdk

class ViewController: UIViewController, WebDelegate {
    
    var toolBar: UIToolbar!

    //Инициализация SDK:
    //Необходимо заменить тестовый secretKey и merchantId на свой
    let sdk = PayboxSdk.initialize(merchantId: 503623, secretKey: "UnPLLvWsuXPyC3wd")
    
    lazy var paymentView: PaymentView! = {
        let view = PaymentView(frame: CGRect(x: 0, y: 94, width: self.view.frame.size.width, height: self.view.frame.size.height - 94))
        view.isHidden = true
        view.autoresizesSubviews = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var initPayButton: UIButton! = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect.zero
        button.setTitle("Инициализация платежа", for: .normal)
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        return button
    }()
    
    lazy var cardListButton: UIButton! = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect.zero
        button.setTitle("Список карт", for: .normal)
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        return button
    }()
    
    lazy var addCardButton: UIButton! = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect.zero
        button.setTitle("Добавить карту", for: .normal)
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        return button
    }()
    
    lazy var deleteCardButton: UIButton! = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect.zero
        button.setTitle("Удалить карту", for: .normal)
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 10)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        return button
    }()
    
    lazy var resultLabel: UILabel! = {
        let label = UILabel()
        label.frame = CGRect(x: 10, y: self.view.frame.size.height - 300, width: self.view.frame.size.width - 20, height: 300)
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Тестовый режим:
        sdk.config().testMode(enabled: true) // По умолчанию тестовый режим включен
        //Выбор платежной системы:
        sdk.config().setPaymentSystem(paymentSystem: .NONE)
        //Выбор валюты платежа:
        sdk.config().setCurrencyCode(code: "KZT")
        //Активация автоклиринга:
        sdk.config().autoClearing(enabled: true)
        //Установка кодировки:
        sdk.config().setEncoding(encoding: "UTF-8") // по умолчанию UTF-8
        //Время жизни рекурентного профиля:
        sdk.config().setRecurringLifetime(lifetime: 0) //по умолчанию 0 месяцев
        //Время жизни платежной страницы, в течение которого платеж должен быть завершен:
        sdk.config().setPaymentLifetime(lifetime: 300)  //по умолчанию 300 секунд
        //Включение режима рекурентного платежа:
        sdk.config().recurringMode(enabled: false)  //по умолчанию отключен
        //Номер телефона клиента, будет отображаться на платежной странице. Если не указать, то будет предложено ввести на платежной странице:
        sdk.config().setUserPhone(userPhone: "")
        //Email клиента, будет отображаться на платежной странице. Если не указать email, то будет предложено ввести на платежной странице:
        sdk.config().setUserEmail(userEmail: "")
        //Язык платежной страницы:
        sdk.config().setLanguage(language: .ru)
        //Для передачи информации от платежного гейта:
        sdk.config().setCheckUrl(url: "url")
        sdk.config().setResultUrl(url: "url")
        sdk.config().setRefundUrl(url: "url")
        sdk.config().setClearingUrl(url: "url")
        sdk.config().setRequestMethod(requestMethod: .POST)
        
        //Для отображения Frame вместо платежной страницы
        sdk.config().setFrameRequired(isRequired: true) //false по умолчанию
        
        //Передайте экземпляр paymentView в sdk:
        sdk.setPaymentView(paymentView: paymentView)
        
        //Для отслеживания прогресса загрузки платежной страницы используйте WebDelegate:
        paymentView.delegate = self
        
        initViews()
    }
    
    func initViews() {
        self.view.backgroundColor = .white
        
        toolBar = UIToolbar()
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.hideView(_:)))
        )
        toolBar.setItems(items, animated: true)
        toolBar.isHidden = true
        toolBar.barTintColor = .white
        toolBar.tintColor = .systemBlue

        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let guide = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(toolBar)
        self.view.addSubview(initPayButton)
        self.view.addSubview(cardListButton)
        self.view.addSubview(addCardButton)
        self.view.addSubview(deleteCardButton)
        self.view.addSubview(resultLabel)
        self.view.addSubview(paymentView)
        
        
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0),
            toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 44),
            
            initPayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initPayButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 50),
            initPayButton.widthAnchor.constraint(equalToConstant: 250),
            initPayButton.heightAnchor.constraint(equalToConstant: 50),
            
            cardListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardListButton.topAnchor.constraint(equalTo: initPayButton.bottomAnchor, constant: 30),
            cardListButton.widthAnchor.constraint(equalToConstant: 250),
            cardListButton.heightAnchor.constraint(equalToConstant: 50),
            
            addCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addCardButton.topAnchor.constraint(equalTo: cardListButton.bottomAnchor, constant: 30),
            addCardButton.widthAnchor.constraint(equalToConstant: 250),
            addCardButton.heightAnchor.constraint(equalToConstant: 50),
            
            deleteCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteCardButton.topAnchor.constraint(equalTo: addCardButton.bottomAnchor, constant: 30),
            deleteCardButton.widthAnchor.constraint(equalToConstant: 250),
            deleteCardButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0),
            resultLabel.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        initPayButton.addTarget(self, action: #selector(self.initPay(_:)), for: .touchUpInside)
        cardListButton.addTarget(self, action: #selector(self.showAllCards(_:)), for: .touchUpInside)
        addCardButton.addTarget(self, action: #selector(self.addCard(_:)), for: .touchUpInside)
        deleteCardButton.addTarget(self, action: #selector(self.deleteCard(_:)), for: .touchUpInside)
    }
    
    @objc func hideView(_: AnyObject) {
        paymentView.isHidden = true
        toolBar.isHidden = true
    }
    
    //Создание платежа:
    @objc func initPay(_: AnyObject) {
        toolBar.isHidden = false
        paymentView.isHidden = false
        
        let amount: Float = 100
        let description = "some description"
        let orderId = "1234"
        let userId = "1234"
        
        sdk.createPayment(amount: amount, description: description, orderId: orderId, userId: userId, extraParams: nil) {
                    payment, error in {
                        self.resultLabel.text = "PaymentID: \(payment?.paymentId ?? 0)"
                        self.paymentView.isHidden = true
                        self.toolBar.isHidden = true
                    }()
            }
    }
    
    //Получить список сохраненых карт:
    @objc func showAllCards(_: AnyObject) {
        let userId = "1234"
        
        sdk.getAddedCards(userId: userId) {
                    cards, error in {
                        if cards == nil {
                            self.resultLabel.text = "Список карт пуст"
                        } else {
                            print(cards ?? "")
                        }
                    }()
            }
    }
    
    //Сохранение карты:
    @objc func addCard(_: AnyObject) {
        toolBar.isHidden = false
        paymentView.isHidden = false
        
        let userId = "1234"
        
        sdk.addNewCard(postLink: "url", userId: userId) {
                    payment, error in // Вызовется после сохранения
            }
    }
    
    //Удаление сохраненой карты:
    @objc func deleteCard(_: AnyObject) {
        let cardId = 1234
        let userId = "1234"
        
        sdk.removeAddedCard(cardId: cardId, userId: userId) {
            payment, error in {
                if(error != nil) {
                    self.resultLabel.text = error?.description
                }
                
                if(payment != nil) {
                    self.resultLabel.text = "Status: \(payment?.status ?? "")"
                }
            }()
            }
    }

    //Для отслеживания прогресса загрузки платежной страницы используйте WebDelegate:
    func loadStarted() {
        self.resultLabel.text = "Загрузка ..."
    }
    
    func loadFinished() {
        self.resultLabel.text = ""
    }
}

