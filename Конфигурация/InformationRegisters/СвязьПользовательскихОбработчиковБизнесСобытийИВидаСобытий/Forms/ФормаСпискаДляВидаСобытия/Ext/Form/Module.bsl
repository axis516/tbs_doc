﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"ВидСобытия",
		Параметры.ВидСобытия);
		
	ВидСобытия	= Параметры.ВидСобытия;
	
	Если Не Параметры.Свойство("ВызовИзФормыПодписок") Тогда
		Элементы.ВидСобытия.Видимость = Ложь;
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Обработчик);
	
КонецПроцедуры
