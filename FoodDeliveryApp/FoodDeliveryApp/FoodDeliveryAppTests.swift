import XCTest
@testable import FoodDeliveryApp

final class FoodDeliveryAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Подготовка перед каждым тестом
    }
    
    override func tearDownWithError() throws {
        // Очистка после каждого теста
    }
    
    // Тест 1: Проверка создания ресторана
    func testRestaurantCreation() {
        let restaurant = Ресторан(название: "Тест", эмодзи: "🍕", кухня: "Итальянская", блюда: [])
        XCTAssertEqual(restaurant.название, "Тест")
        XCTAssertEqual(restaurant.эмодзи, "🍕")
    }
    
    // Тест 2: Проверка создания блюда
    func testDishCreation() {
        let dish = Блюдо(название: "Пицца", цена: 24.50, описание: "Вкусно", категория: .основное, эмодзи: "🍕")
        XCTAssertEqual(dish.название, "Пицца")
        XCTAssertEqual(dish.цена, 24.50)
    }
    
    // Тест 3: Проверка добавления в корзину
    func testAddToCart() {
        var cart: [ТоварВКорзине] = []
        let dish = Блюдо(название: "Бургер", цена: 22.00, описание: "Сочный", категория: .основное, эмодзи: "🍔")
        cart.append(ТоварВКорзине(блюдо: dish, количество: 1))
        XCTAssertEqual(cart.count, 1)
    }
    
    // Тест 4: Проверка расчета суммы
    func testTotalPrice() {
        let dish1 = Блюдо(название: "Пицца", цена: 24.50, описание: "", категория: .основное, эмодзи: "🍕")
        let dish2 = Блюдо(название: "Кола", цена: 4.50, описание: "", категория: .напитки, эмодзи: "🥤")
        let cart = [
            ТоварВКорзине(блюдо: dish1, количество: 2),
            ТоварВКорзине(блюдо: dish2, количество: 1)
        ]
        let total = cart.reduce(0) { $0 + ($1.блюдо.цена * Double($1.количество)) }
        XCTAssertEqual(total, 53.50)
    }
    
    // Тест 5: Проверка что корзина пуста
    func testEmptyCart() {
        let cart: [ТоварВКорзине] = []
        XCTAssertTrue(cart.isEmpty)
    }
    
    // Тест 6: Проверка увеличения количества
    func testIncreaseQuantity() {
        let dish = Блюдо(название: "Суши", цена: 38.00, описание: "", категория: .основное, эмодзи: "🍣")
        var item = ТоварВКорзине(блюдо: dish, количество: 1)
        item.количество = 3
        XCTAssertEqual(item.количество, 3)
    }
    
    // Тест 7: Проверка что есть популярные блюда
    func testPopularDishFlag() {
        let dish = Блюдо(название: "Популярное", цена: 100, описание: "", категория: .основное, эмодзи: "⭐", популярное: true)
        XCTAssertTrue(dish.популярное)
    }
    
    // Тест 8: Проверка что блюдо не популярное
    func testNotPopularDish() {
        let dish = Блюдо(название: "Обычное", цена: 100, описание: "", категория: .основное, эмодзи: "🍽️", популярное: false)
        XCTAssertFalse(dish.популярное)
    }
    
    // Тест 9: Проверка удаления из корзины
    func testRemoveFromCart() {
        let dish = Блюдо(название: "Салат", цена: 18.00, описание: "", категория: .закуски, эмодзи: "🥗")
        var cart = [ТоварВКорзине(блюдо: dish, количество: 1)]
        cart.removeAll()
        XCTAssertTrue(cart.isEmpty)
    }
    
    // Тест 10: Проверка статуса заказа
    func testOrderStatus() {
        let status = СтатусЗаказа.готовится
        XCTAssertEqual(status.rawValue, "👨‍🍳 Готовится")
    }
}
