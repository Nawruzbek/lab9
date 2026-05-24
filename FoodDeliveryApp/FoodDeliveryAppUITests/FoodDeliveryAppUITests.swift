import XCTest

final class FoodDeliveryAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    // Тест 1: Запуск приложения
    func testAppLaunches() {
        XCTAssertTrue(app.buttons["restaurantList"].exists)
    }
    
    // Тест 2: Существование кнопки ресторанов
    func testRestaurantButtonExists() {
        XCTAssertTrue(app.buttons["restaurantsTab"].exists)
    }
    
    // Тест 3: Существование кнопки корзины
    func testCartButtonExists() {
        XCTAssertTrue(app.buttons["cartTab"].exists)
    }
    
    // Тест 4: Наличие заголовка на главном экране
    func testMainTitleExists() {
        XCTAssertTrue(app.staticTexts["Рестораны"].exists)
    }
    
    // Тест 5: Наличие корзины
    func testCartViewExists() {
        app.buttons["cartTab"].tap()
        XCTAssertTrue(app.staticTexts["Корзина"].exists)
    }
    
    // Тест 6: Кнопка оформления заказа
    func testCheckoutButtonExists() {
        app.buttons["cartTab"].tap()
        XCTAssertTrue(app.buttons["checkoutButton"].exists)
    }
    
    // Тест 7: Наличие меню блюд
    func testMenuViewExists() {
        XCTAssertTrue(app.collectionViews["menuList"].exists)
    }
    
    // Тест 8: Кнопка добавления блюда
    func testAddToCartButtonExists() {
        XCTAssertTrue(app.buttons["addToCartButton"].firstMatch.exists)
    }
    
    // Тест 9: Переход в корзину
    func testNavigateToCart() {
        app.buttons["cartTab"].tap()
        XCTAssertTrue(app.navigationBars["Корзина"].exists)
    }
    
    // Тест 10: Переход на главный экран
    func testNavigateToMain() {
        app.buttons["restaurantsTab"].tap()
        XCTAssertTrue(app.staticTexts["Рестораны"].exists)
    }
}
