﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПоШаблону = Истина;
	
	Для Каждого ТипПроцесса Из Перечисления.ТипыПроцессовЭскалацииЗадач Цикл
		ДанныеШаблона = Перечисления.ТипыПроцессовЭскалацииЗадач.ДанныеШаблона(ТипПроцесса);
		ДанныеШаблонов.Добавить(ДанныеШаблона);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПоШаблонуПриИзменении(Элемент)
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьДоступностьКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Не ПоШаблону Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ДанныеШаблона Из ДанныеШаблонов Цикл
		
		Если ДанныеШаблона.Значение.ТипПроцесса <> Значение Тогда
			Продолжить;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		Закрыть(ДанныеШаблона.Значение.ИмяСправочника);
		
		Возврат;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	ТипПроцесса = ТипПроцесса();
	
	ДоступенВыбор =
		ТипПроцесса <> Неопределено
		И (ПоШаблону Или ТипПроцесса <>
			ПредопределенноеЗначение("Перечисление.ТипыПроцессовЭскалацииЗадач.КомплексныйПроцесс"));
	Элементы.ФормаВыбрать.Доступность = ДоступенВыбор;
	
КонецПроцедуры

&НаКлиенте
Функция ТипПроцесса()
	
	ТипПроцесса = Неопределено;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТипПроцесса = ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	Возврат ТипПроцесса;
	
КонецФункции

#КонецОбласти