//
//  Listing_ProductsUnitTests.swift
//  Listing-ProductsUnitTests
//
//  Created by Abhishek Bagela on 11/03/25.
//

import XCTest

@testable import Listing_Products

final class Listing_ProductsUnitTests: XCTestCase {

    private var sut: AddProductViewModel!
    
    override func setUp() {        
        //Initial Setup
        super.setUp()
        sut = AddProductViewModel()
    }
    
    override func tearDown() {
        //Cleanup
        sut = nil
        super.tearDown()
    }
    
    func test_validateProductPrice() {
        //GIVEN
        sut.price = "11"
        
        //WHEN
        let isValidPrice = ValidationUtility.validatePrice(sut.price)
        
        //THEN
        XCTAssert(isValidPrice, "Price is invalid")
        XCTAssertEqual(isValidPrice, true)
    }
    
    func test_invalidProductName() {
        //given
        sut.productName = ""
        
        //when
        let isValid = ValidationUtility.validateName(sut.productName)
        
        //then
        XCTAssert(isValid, "Product name invalid")
        
        XCTAssertNil(isValid)
        
        XCTAssertEqual(isValid, true)
        
        XCTAssertNotEqual(isValid, false)
    }
    
    
    func test_validProductName() {
        
        //GIVEN
        sut.productName = "Banana"
        
        //WHEN
        let isValidName = ValidationUtility.validateName(sut.productName)
        
        //THEN
        XCTAssert(isValidName, "Product Name is valid")
        XCTAssertEqual(isValidName, false)
        XCTAssertNotEqual(isValidName, true)
    }
    
    func test_validationProductTax() {

        //GIVEN
        sut.tax = "11"
        
        //WHEN
        let isValidPrice = ValidationUtility.validatePrice(sut.price)
        
        //THEN
        XCTAssert(isValidPrice, "Price is invalid")
        XCTAssertEqual(isValidPrice, true)
        
    }
    
}
