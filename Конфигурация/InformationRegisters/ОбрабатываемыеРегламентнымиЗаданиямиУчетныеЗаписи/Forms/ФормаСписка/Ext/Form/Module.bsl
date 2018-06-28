﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
		ПодключитьОбработчикОжидания("Автообновление", 300);
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвтоматически(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗаполнитьАвтоматическиПродолжение",
		ЭтотОбъект);

	ОткрытьФорму("РегистрСведений.ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.Форма.ФормаВводаЧислаЗаданий",,,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвтоматическиПродолжение(Результат, Параметры) Экспорт 

	Если ТипЗнч(Результат) <> Тип("Число") Тогда
		Возврат;
	КонецЕсли;	
	
	ЧислоЗаданий = Результат;
	
	ВстроеннаяПочтаСервер.ПерезаполнитьРегистрОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи(ЧислоЗаданий);
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ПоменятьПоток(Команда)
	
	МассивУчетныхЗаписей = Новый Массив;
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		МассивУчетныхЗаписей.Добавить(ТекущиеДанные.УчетнаяЗапись);
	Иначе
		Для Каждого ВыбраннаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
			ДанныеСтроки = Элементы.Список.ДанныеСтроки(ВыбраннаяСтрока);
			МассивУчетныхЗаписей.Добавить(ДанныеСтроки.УчетнаяЗапись);
		КонецЦикла;
	КонецЕсли;
	
	Если МассивУчетныхЗаписей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("МассивУчетныхЗаписей", МассивУчетныхЗаписей);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоменятьПотокЗавершение", ЭтотОбъект, ПараметрыФормы);
	
	ОткрытьФорму("РегистрСведений.ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.Форма.ФормаВводаНомераПотока",
		ПараметрыФормы, ЭтаФорма,,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьПотокЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоменятьПотокСервер(Параметры.МассивУчетныхЗаписей, Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Автообновление()
	
	ОбновитьДанные();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанные()
	
	ТекДата = ТекущаяДатаСеанса();
	Дата30Минут = ТекущаяДатаСеанса() - 30 * 60;
	Таблица.Очистить();
	
	Для НомерЗадания = 1 По 10 Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.УчетнаяЗапись) КАК Количество
			|ИЗ
			|	РегистрСведений.ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи КАК ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи
			|ГДЕ
			|	ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.НомерЗадания = &НомерЗадания";
			
		Запрос.УстановитьПараметр("НомерЗадания", НомерЗадания);
		
		ТаблицаПотоков = Запрос.Выполнить().Выгрузить();
		Если ТаблицаПотоков.Количество() <> 0 Тогда
			
			Количество = ТаблицаПотоков[0].Количество;
			
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ЕСТЬNULL(МАКСИМУМ(ОбработанныеУчетныеЗаписи.ДатаПоследнейОбработки), 0) КАК МаксВремя
				|ИЗ
				|	РегистрСведений.ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи КАК ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи
				|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбработанныеУчетныеЗаписи КАК ОбработанныеУчетныеЗаписи
				|		ПО ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.УчетнаяЗапись = ОбработанныеУчетныеЗаписи.УчетнаяЗапись
				|ГДЕ
				|	ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.НомерЗадания = &НомерЗадания";
				
			Запрос.УстановитьПараметр("НомерЗадания", НомерЗадания);
			ТаблицаПотоков = Запрос.Выполнить().Выгрузить();
			
			Если ТаблицаПотоков.Количество() <> 0 Тогда
				
				МаксВремя = ТаблицаПотоков[0].МаксВремя;
				
				Если ТипЗнч(МаксВремя) = Тип("Дата") Тогда
				
					Строка = Таблица.Добавить();
					Строка.Поток = НомерЗадания;
					Строка.ЧислоУчетныхЗаписей = Количество;
					Строка.ДатаПоследнейОбработки = МаксВремя;
					Строка.СрокПревышен = (МаксВремя < Дата30Минут);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПоменятьПотокСервер(МассивУчетныхЗаписей, НомерПотока)
	
	УстановитьПривилегированныйРежим(Истина);
	ЕстьИзменения = Ложь;
	
	Для Каждого УчетнаяЗапись Из МассивУчетныхЗаписей Цикл
		
		МенеджерЗаписи = РегистрыСведений.ОбрабатываемыеРегламентнымиЗаданиямиУчетныеЗаписи.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.НомерЗадания <> НомерПотока Тогда 
			МенеджерЗаписи.УчетнаяЗапись = УчетнаяЗапись;
			МенеджерЗаписи.НомерЗадания = НомерПотока;
			МенеджерЗаписи.Записать();
			ЕстьИзменения = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьИзменения Тогда 
		ОбновитьДанные();
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
