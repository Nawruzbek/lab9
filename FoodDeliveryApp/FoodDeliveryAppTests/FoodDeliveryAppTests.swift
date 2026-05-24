import XCTest
@testable import FoodDeliveryApp

// Модель для тестов
struct Dish {
    let name: String
    let price: Double
    var quantity: Int
}

struct Cart {
    var items: [Dish] = []
    
    mutating func addDish(_ dish: Dish) {
        if let index = items.firstIndex(where: { $0.name == dish.name }) {
            items[index].quantity += dish.quantity
        } else {
            items.append(dish)
        }
    }
    
    func totalPrice() -> Double {
        return items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    mutating func removeDish(named name: String) {
        items.removeAll { $0.name == name }
    }
    
    var itemCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
}

final class FoodDeliveryAppTests: XCTestCase {
    
    // Тест 1: Добавление блюда в корзину
    func testAddDishToCart() {
        var cart = Cart()
        let dish = Dish(name: "Пицца", price: 500, quantity: 1)
        cart.addDish(dish)
        XCTAssertEqual(cart.items.count, 1)
    }
    
    // Тест 2: Добавление двух одинаковых блюд увеличивает количество
    func testAddSameDishTwice() {
        var cart = Cart()
        let dish = Dish(name: "Бургер", price: 300, quantity: 2)
        cart.addDish(dish)
        cart.addDish(dish)
        XCTAssertEqual(cart.items.first?.quantity, 4)
    }
    
    // Тест 3: Подсчёт общей стоимости
    func testTotalPriceCalculation() {
        var cart = Cart()
        cart.addDish(Dish(name: "Пицца", price: 500, quantity: 2))
        cart.addDish(Dish(name: "Кола", price: 150, quantity: 1))
        XCTAssertEqual(cart.totalPrice(), 1150)
    }
    
    // Тест 4: Удаление блюда из корзины
    func testRemoveDishFromCart() {
        var cart = Cart()
        cart.addDish(Dish(name: "Салат", price: 200, quantity: 1))
        cart.removeDish(named: "Салат")
        XCTAssertTrue(cart.items.isEmpty)
    }
    
    // Тест 5: Пустая корзина имеет стоимость 0
    func testEmptyCartTotalPrice() {
        let cart = Cart()
        XCTAssertEqual(cart.totalPrice(), 0)
    }
    
    // Тест 6: Подсчёт количества позиций
    func testItemCount() {
        var cart = Cart()
        cart.addDish(Dish(name: "Пицца", price: 500, quantity: 3))
        cart.addDish(Dish(name: "Кола", price: 150, quantity: 2))
        XCTAssertEqual(cart.itemCount, 5)
    }
    
    // Тест 7: Проверка цены блюда
    func testDishPrice() {
        let dish = Dish(name: "Суши", price: 800, quantity: 1)
        XCTAssertEqual(dish.price, 800)
    }
    
    // Тест 8: Проверка количества блюда
    func testDishQuantity() {
        let dish = Dish(name: "Роллы", price: 600, quantity: 3)
        XCTAssertEqual(dish.quantity, 3)
    }
    
    // Тест 9: Добавление нескольких разных блюд
    func testMultipleDifferentDishes() {
        var cart = Cart()
        cart.addDish(Dish(name: "Пицца", price: 500, quantity: 1))
        cart.addDish(Dish(name: "Бургер", price: 300, quantity: 2))
        cart.addDish(Dish(name: "Кола", price: 150, quantity: 1))
        XCTAssertEqual(cart.items.count, 3)
    }
    
    // Тест 10: Очистка корзины
    func testClearCart() {
        var cart = Cart()
        cart.addDish(Dish(name: "Пицца", price: 500, quantity: 1))
        cart.items.removeAll()
        XCTAssertEqual(cart.totalPrice(), 0)
    }
}
