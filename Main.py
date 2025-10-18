purchases = [
    {"item": "apple", "category": "fruit", "price": 1.2, "quantity": 10},
    {"item": "banana", "category": "fruit", "price": 0.5, "quantity": 5},
    {"item": "milk", "category": "dairy", "price": 1.5, "quantity": 2},
    {"item": "bread", "category": "bakery", "price": 2.0, "quantity": 3},
]


# Рассчитайте и верните общую выручку (цена * количество для всех записей).
def total_revenue(purchases: list) -> float:
    count = 0
    for purchase in purchases:
        count += purchase['price'] * purchase['quantity']
    return count


# Верните словарь, где ключ — категория, а значение — список уникальных товаров в этой категории.
def items_by_category(purchases: list) -> dict:
    items_by_category_dict = {}
    for purchase in purchases:
        key = purchase['category']
        if key not in items_by_category_dict:
            items_by_category_dict[key] = []
        items_by_category_dict.get(key).append(purchase['item'])
    return items_by_category_dict


# Выведите все покупки, где цена товара больше или равна min_price.
def expensive_purchases(purchases: list, min_price: float) -> list:
    return sorted(purchases, key=lambda x: x['price'] >= min_price)


# Рассчитайте среднюю цену товаров по каждой категории.
def average_price_by_category(purchases: list) -> dict:
    average_price_by_category_dict = {}
    for purchase in purchases:
        key = purchase['category']
        if key not in average_price_by_category_dict:
            average_price_by_category_dict[key] = purchase['price']
        else:
            average_price_by_category_dict[key] = (average_price_by_category_dict.get(key) + purchase['price']) / 2
    return average_price_by_category_dict


# Найдите и верните категорию, в которой куплено больше всего единиц товаров (учитывайте поле quantity).
def most_frequent_category(purchases: list) -> str:
    return max(purchases, key=lambda x: x['quantity'])['category']


min_price = 1.0
print(f'Общая выручка: {total_revenue(purchases)}')
print(f'Товары по категориям: {items_by_category(purchases)}')
print(f'Покупки дороже {min_price}: {expensive_purchases(purchases, min_price)}')
print(f'Средняя цена по категориям: {average_price_by_category(purchases)}')
print(f'Категория с наибольшим количеством проданных товаров: {most_frequent_category(purchases)}')
