﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеФункции = РаботаСАдреснойКнигой.ПолучитьСписокДоступныхФункций();
	Для Каждого ЭлементСписка Из ДоступныеФункции Цикл
		СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбораВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Строка = СписокВыбора.НайтиПоИдентификатору(Элементы.СписокВыбора.ТекущаяСтрока);
	Закрыть(Строка);
	
КонецПроцедуры

#КонецОбласти
