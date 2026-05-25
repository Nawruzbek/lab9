import SwiftUI
import Combine

// MARK: - МОДЕЛИ ДАННЫХ

struct Ресторан: Identifiable {
    let id = UUID()
    let название: String
    let эмодзи: String
    let кухня: String
    let блюда: [Блюдо]
}

struct Блюдо: Identifiable {
    let id = UUID()
    let название: String
    let цена: Double
    let описание: String
    let категория: КатегорияБлюда
    let эмодзи: String
    var популярное: Bool = false
}

enum КатегорияБлюда: String, CaseIterable {
    case основное = "🍽 Основные блюда"
    case десерты = "🍰 Десерты"
    case напитки = "🥤 Напитки"
    case закуски = "🍿 Закуски"
}

struct ТоварВКорзине: Identifiable {
    let id = UUID()
    let блюдо: Блюдо
    var количество: Int
}

struct Заказ: Identifiable {
    let id = UUID()
    let дата: Date
    let товары: [ТоварВКорзине]
    let общаяСумма: Double
    let статус: СтатусЗаказа
    let ресторан: String
    let времяДоставки: Date
}

enum СтатусЗаказа: String {
    case готовится = "👨‍🍳 Готовится"
    case вПути = "🚚 В пути"
    case доставлен = "✅ Доставлен"
    
    var цвет: Color {
        switch self {
        case .готовится: return .orange
        case .вПути: return .blue
        case .доставлен: return .green
        }
    }
}

// MARK: - ГЛАВНОЕ ПРЕДСТАВЛЕНИЕ

struct ГлавныйЭкран: View {
    @State private var корзина: [ТоварВКорзине] = []
    @State private var выбранныйРесторан: Ресторан?
    @State private var показатьКорзину = false
    @State private var историяЗаказов: [Заказ] = []
    
    let рестораны = [
        Ресторан(название: "Бона Пицца", эмодзи: "🍕", кухня: "Итальянская", блюда: [
            Блюдо(название: "Маргарита", цена: 24.50, описание: "Томатный соус, моцарелла, базилик", категория: .основное, эмодзи: "🍕", популярное: true),
            Блюдо(название: "Пепперони", цена: 29.90, описание: "Острая пепперони, моцарелла", категория: .основное, эмодзи: "🍕", популярное: true),
            Блюдо(название: "Карбонара", цена: 32.00, описание: "Бекон, пармезан, яйцо", категория: .основное, эмодзи: "🍝"),
            Блюдо(название: "Тирамису", цена: 12.50, описание: "Кофейный десерт с маскарпоне", категория: .десерты, эмодзи: "🍰", популярное: true),
            Блюдо(название: "Кока-Кола", цена: 4.50, описание: "0.5 литра", категория: .напитки, эмодзи: "🥤"),
            Блюдо(название: "Морс клюквенный", цена: 6.00, описание: "Домашний морс", категория: .напитки, эмодзи: "🧃", популярное: true),
            Блюдо(название: "Картошка фри", цена: 8.00, описание: "С соусом барбекю", категория: .закуски, эмодзи: "🍟"),
            Блюдо(название: "Чесночные палочки", цена: 10.00, описание: "С сырным соусом", категория: .закуски, эмодзи: "🥖", популярное: true)
        ]),
        Ресторан(название: "Суши Вок", эмодзи: "🍣", кухня: "Японская", блюда: [
            Блюдо(название: "Филадельфия", цена: 38.00, описание: "Лосось, сливочный сыр", категория: .основное, эмодзи: "🍣", популярное: true),
            Блюдо(название: "Калифорния", цена: 32.00, описание: "Краб, авокадо, огурец", категория: .основное, эмодзи: "🍣", популярное: true),
            Блюдо(название: "Темпура креветка", цена: 42.00, описание: "Креветка в кляре", категория: .основное, эмодзи: "🍤"),
            Блюдо(название: "Моти мороженое", цена: 9.00, описание: "2 штуки", категория: .десерты, эмодзи: "🍨", популярное: true),
            Блюдо(название: "Зеленый чай", цена: 5.00, описание: "С жасмином", категория: .напитки, эмодзи: "🍵"),
            Блюдо(название: "Лимонад Сакура", цена: 7.00, описание: "Домашний лимонад", категория: .напитки, эмодзи: "🌸", популярное: true),
            Блюдо(название: "Мисо суп", цена: 6.50, описание: "С тофу", категория: .закуски, эмодзи: "🥣"),
            Блюдо(название: "Эдамаме", цена: 8.00, описание: "Стручковая соя", категория: .закуски, эмодзи: "🥜")
        ]),
        Ресторан(название: "Гриль Хаус", эмодзи: "🥩", кухня: "Европейская", блюда: [
            Блюдо(название: "Стейк Рибай", цена: 65.00, описание: "Мраморная говядина", категория: .основное, эмодзи: "🥩", популярное: true),
            Блюдо(название: "Бургер Классик", цена: 22.00, описание: "Говяжья котлета", категория: .основное, эмодзи: "🍔", популярное: true),
            Блюдо(название: "Цезарь с курицей", цена: 18.00, описание: "Куриное филе, пармезан", категория: .основное, эмодзи: "🥗"),
            Блюдо(название: "Чизкейк", цена: 10.00, описание: "Классический чизкейк", категория: .десерты, эмодзи: "🍰", популярное: true),
            Блюдо(название: "Чай черный", цена: 4.00, описание: "Ассам 0.5л", категория: .напитки, эмодзи: "🫖"),
            Блюдо(название: "Лимонад Малина", цена: 8.00, описание: "Домашний лимонад", категория: .напитки, эмодзи: "🍹", популярное: true),
            Блюдо(название: "Картошка по-деревенски", цена: 9.00, описание: "С розмарином", категория: .закуски, эмодзи: "🥔"),
            Блюдо(название: "Куриные крылья", цена: 16.00, описание: "500г, соус BBQ", категория: .закуски, эмодзи: "🍗", популярное: true)
        ])
    ]
    
    var общаяСумма: Double {
        корзина.reduce(0) { $0 + ($1.блюдо.цена * Double($1.количество)) }
    }
    
    var общееКоличество: Int {
        корзина.reduce(0) { $0 + $1.количество }
    }
    
    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(рестораны) { ресторан in
                            КарточкаРесторана(ресторан: ресторан) {
                                выбранныйРесторан = ресторан
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Рестораны Минска")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        КнопкаКорзины(количество: общееКоличество) {
                            показатьКорзину = true
                        }
                    }
                }
            }
            .tabItem {
                Label("Главная", systemImage: "house.fill")
            }
            
            NavigationView {
                СписокЗаказов(заказы: историяЗаказов)
            }
            .tabItem {
                Label("Заказы", systemImage: "list.bullet.clipboard")
            }
        }
        .sheet(item: $выбранныйРесторан) { ресторан in
            ДеталиРесторана(ресторан: ресторан, корзина: $корзина)
        }
        .sheet(isPresented: $показатьКорзину) {
            ЭкранКорзины(корзина: $корзина, общаяСумма: общаяСумма, историяЗаказов: $историяЗаказов, ресторан: выбранныйРесторан?.название ?? "")
        }
    }
}

struct КарточкаРесторана: View {
    let ресторан: Ресторан
    let действие: () -> Void
    
    var body: some View {
        Button(action: действие) {
            HStack(spacing: 16) {
                Text(ресторан.эмодзи)
                    .font(.system(size: 50))
                VStack(alignment: .leading, spacing: 4) {
                    Text(ресторан.название)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(ресторан.кухня)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
        .buttonStyle(.plain)
    }
}

struct КнопкаКорзины: View {
    let количество: Int
    let действие: () -> Void
    
    var body: some View {
        Button(action: действие) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart.fill")
                    .font(.title2)
                if количество > 0 {
                    Text("\(количество)")
                        .font(.caption2)
                        .padding(4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .offset(x: 10, y: -8)
                }
            }
        }
    }
}

struct ДеталиРесторана: View {
    let ресторан: Ресторан
    @Binding var корзина: [ТоварВКорзине]
    @Environment(\.dismiss) var закрыть
    @State private var выбраннаяКатегория: КатегорияБлюда = .основное
    
    var отфильтрованныеБлюда: [Блюдо] {
        ресторан.блюда.filter { $0.категория == выбраннаяКатегория }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(КатегорияБлюда.allCases, id: \.self) { категория in
                            КнопкаКатегории(
                                название: категория.rawValue,
                                выбрана: выбраннаяКатегория == категория
                            ) {
                                выбраннаяКатегория = категория
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(отфильтрованныеБлюда) { блюдо in
                            КарточкаБлюда(блюдо: блюдо, корзина: $корзина)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(ресторан.название)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") { закрыть() }
                }
            }
        }
    }
}

struct КнопкаКатегории: View {
    let название: String
    let выбрана: Bool
    let действие: () -> Void
    
    var body: some View {
        Button(action: действие) {
            Text(название)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(выбрана ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(выбрана ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct КарточкаБлюда: View {
    let блюдо: Блюдо
    @Binding var корзина: [ТоварВКорзине]
    
    var текущееКоличество: Int {
        корзина.first(where: { $0.блюдо.id == блюдо.id })?.количество ?? 0
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(блюдо.эмодзи)
                .font(.system(size: 45))
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(блюдо.название)
                        .font(.headline)
                    if блюдо.популярное {
                        Text("🔥")
                            .font(.caption)
                    }
                }
                Text(блюдо.описание)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Text(String(format: "%.2f Br", блюдо.цена))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            if текущееКоличество > 0 {
                HStack(spacing: 12) {
                    Button(action: {
                        if let index = корзина.firstIndex(where: { $0.блюдо.id == блюдо.id }) {
                            if корзина[index].количество > 1 {
                                корзина[index].количество -= 1
                            } else {
                                корзина.remove(at: index)
                            }
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.red)
                    }
                    
                    Text("\(текущееКоличество)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Button(action: {
                        if let index = корзина.firstIndex(where: { $0.блюдо.id == блюдо.id }) {
                            корзина[index].количество += 1
                        } else {
                            корзина.append(ТоварВКорзине(блюдо: блюдо, количество: 1))
                        }
                    }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
            } else {
                Button(action: {
                    корзина.append(ТоварВКорзине(блюдо: блюдо, количество: 1))
                }) {
                    Text("В корзину")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 3)
    }
}

struct ЭкранКорзины: View {
    @Binding var корзина: [ТоварВКорзине]
    let общаяСумма: Double
    @Binding var историяЗаказов: [Заказ]
    let ресторан: String
    @Environment(\.dismiss) var закрыть
    @State private var показатьПодтверждение = false
    @State private var времяДоставки = Date().addingTimeInterval(2700)
    
    var body: some View {
        NavigationView {
            VStack {
                if корзина.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 70))
                            .foregroundColor(.gray)
                        Text("Корзина пуста")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Добавьте блюда из меню")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(корзина) { товар in
                            HStack {
                                Text(товар.блюдо.эмодзи)
                                    .font(.system(size: 35))
                                VStack(alignment: .leading) {
                                    Text(товар.блюдо.название)
                                        .font(.headline)
                                    Text("\(String(format: "%.2f", товар.блюдо.цена)) Br × \(товар.количество)")
                                        .font(.caption)
                                }
                                Spacer()
                                Text("\(String(format: "%.2f", товар.блюдо.цена * Double(товар.количество))) Br")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    корзина.removeAll { $0.id == товар.id }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    
                    VStack(spacing: 16) {
                        Divider()
                        HStack {
                            Text("Итого:")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(String(format: "%.2f", общаяСумма)) Br")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            let новыйЗаказ = Заказ(
                                дата: Date(),
                                товары: корзина,
                                общаяСумма: общаяСумма,
                                статус: .готовится,
                                ресторан: ресторан.isEmpty ? "Ресторан" : ресторан,
                                времяДоставки: времяДоставки
                            )
                            историяЗаказов.insert(новыйЗаказ, at: 0)
                            показатьПодтверждение = true
                        }) {
                            Text("Оформить заказ")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Корзина")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Назад") { закрыть() }
                }
            }
            .alert("Заказ оформлен! 🎉", isPresented: $показатьПодтверждение) {
                Button("Отлично!") {
                    корзина.removeAll()
                    закрыть()
                }
            } message: {
                Text("Ваш заказ доставят \(времяДоставки, format: .dateTime.hour().minute())\nПримерное время ожидания 45 минут.")
            }
        }
    }
}

struct СписокЗаказов: View {
    let заказы: [Заказ]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if заказы.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "clock")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("У вас пока нет заказов")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("Сделайте первый заказ в ресторане!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else {
                    ForEach(заказы) { заказ in
                        КарточкаЗаказа(заказ: заказ)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Мои заказы")
        .background(Color(.systemGroupedBackground))
    }
}

struct КарточкаЗаказа: View {
    let заказ: Заказ
    @State private var текущийСтатус = СтатусЗаказа.готовится
    @State private var оставшеесяВремя: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(заказ.ресторан)
                    .font(.headline)
                Spacer()
                Text(текущийСтатус.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(текущийСтатус.цвет.opacity(0.2))
                    .foregroundColor(текущийСтатус.цвет)
                    .cornerRadius(10)
            }
            
            Divider()
            
            ForEach(заказ.товары) { товар in
                HStack {
                    Text("\(товар.количество)×")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(товар.блюдо.название)
                        .font(.subheadline)
                    Spacer()
                    Text("\(String(format: "%.2f", товар.блюдо.цена * Double(товар.количество))) Br")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    if текущийСтатус == .готовится {
                        Text("⏳ Доставка через: \(оставшеесяВремя)")
                            .font(.caption)
                            .foregroundColor(.orange)
                    } else if текущийСтатус == .вПути {
                        Text("🚚 Курьер уже в пути!")
                            .font(.caption)
                            .foregroundColor(.blue)
                    } else {
                        Text("✅ Заказ доставлен")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                Spacer()
                Text("Итого: \(String(format: "%.2f", заказ.общаяСумма)) Br")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .onAppear {
            обновитьСтатус()
        }
        .onReceive(timer) { _ in
            обновитьСтатус()
        }
    }
    
    func обновитьСтатус() {
        let секундСМоментаЗаказа = Date().timeIntervalSince(заказ.дата)
        
        if секундСМоментаЗаказа < 10 {
            текущийСтатус = .готовится
            let осталось = max(0, 25 - Int(секундСМоментаЗаказа))
            оставшеесяВремя = "\(осталось) сек"
        } else if секундСМоментаЗаказа < 20 {
            текущийСтатус = .вПути
            let осталось = max(0, 30 - Int(секундСМоментаЗаказа))
            оставшеесяВремя = "\(осталось) сек"
        } else {
            текущийСтатус = .доставлен
            оставшеесяВремя = "Доставлен"
        }
    }
}

struct ContentView: View {
    var body: some View {
        ГлавныйЭкран()
    }
}

#Preview {
    ContentView()
}
