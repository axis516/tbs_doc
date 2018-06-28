﻿//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();

	Если Параметры.Свойство("СписокОповещений") И ЗначениеЗаполнено(Параметры.СписокОповещений) Тогда 
		
		Оповещения = Параметры.СписокОповещений;
		ДанныеПисем = ПолучитьДанныеПисем(Оповещения); 
		
		Для Каждого Письмо Из ДанныеПисем Цикл
			Если Письмо.Прочтен Тогда 
				Продолжить;
			КонецЕсли;
			
			НовоеПисьмо = Письма.Добавить();
			НовоеПисьмо.От = Письмо.ОтправительАдресат;
			НовоеПисьмо.Тема = Письмо.Тема;
			НовоеПисьмо.Получено = Письмо.ДатаПолучения;
			
			Если Письмо.Важность = Перечисления.ВажностьПисем.Высокая Тогда 
				НовоеПисьмо.Важность = 2;
			ИначеЕсли Письмо.Важность = Перечисления.ВажностьПисем.Низкая Тогда 
				НовоеПисьмо.Важность = 0;
			Иначе	
				НовоеПисьмо.Важность = 1;
			КонецЕсли;
			
			НовоеПисьмо.Ссылка = Письмо.Ссылка;
			
			Оповещения.Удалить(Оповещения.Найти(Письмо.Ссылка));
		КонецЦикла; 	
		
		// Если на письмо у пользователя нет прав, то удаляем его из регистра оповещений для данного пользователя
		Для Каждого Письмо Из Оповещения Цикл 
			УдалитьПисьмоИзОповещений(Письмо, ТекущийПользователь);	
		КонецЦикла;	
	КонецЕсли;	
	
	Если Письма.Количество() = 0 Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Новые письма (%1)'"), Письма.Количество());		
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытьФормуОповещения"
		И Источник <> ЭтаФорма Тогда
		ЗакрытиеОповещением = Истина;
		
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
 
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗакрытиеОповещением Тогда
		ОчиститьСписокОповещений();				
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПисьмаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Письма.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьПисьмо(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПисьмаПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Письма.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	УдалитьПисьмоИзОповещений(ТекущиеДанные.Ссылка, ТекущийПользователь);				

КонецПроцедуры

&НаКлиенте
Процедура ПисьмаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Письма.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьПисьмо(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПисьмаПослеУдаления(Элемент)
	
	Если Письма.Количество() = 0 Тогда 
		Закрыть();
	КонецЕсли;

	Элементы.Письма.Обновить();
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Новые письма (%1)'"), Письма.Количество());

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОткрытьПисьмо(ТекущиеДанные)
	
	Письмо = ТекущиеДанные.Ссылка;
	ВстроеннаяПочтаКлиент.ОткрытьПисьмо(Письмо);
	Письма.Удалить(ТекущиеДанные);
	УдалитьПисьмоИзОповещений(Письмо, ТекущийПользователь);
	
	Если Письма.Количество() = 0 Тогда 
		Закрыть();
	КонецЕсли;
	
	Элементы.Письма.Обновить();
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Новые письма (%1)'"), Письма.Количество());
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьПисьмоИзОповещений(ПисьмоСсылка, ТекущийПользователь)
	
	УстановитьПривилегированныйРежим(Истина);
	НаборЗаписей = РегистрыСведений.ОповещенияОПисьмах.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Письмо.Установить(ПисьмоСсылка);
	НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
	НаборЗаписей.Записать();	
	
КонецПроцедуры 

&НаСервере
Функция ПолучитьДанныеПисем(СписокПисем)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВходящееПисьмо.Ссылка,
		|	ВходящееПисьмо.ОтправительАдресат,
		|	ВходящееПисьмо.Тема,
		|	ВходящееПисьмо.ДатаПолучения КАК ДатаПолучения,
		|	ВходящееПисьмо.Важность,
		|	ЕСТЬNULL(СведенияОПрочтении.Прочтен, ЛОЖЬ) КАК Прочтен
		|ИЗ
		|	Документ.ВходящееПисьмо КАК ВходящееПисьмо
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПрочтении КАК СведенияОПрочтении
		|		ПО ВходящееПисьмо.Ссылка = СведенияОПрочтении.Объект
		|			И (СведенияОПрочтении.Пользователь = &Пользователь)
		|ГДЕ
		|	ВходящееПисьмо.Ссылка В(&СписокПисем)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПолучения УБЫВ";
		
	Запрос.Параметры.Вставить("СписокПисем", СписокПисем);
	Запрос.Параметры.Вставить("Пользователь", ТекущийПользователь);
	Выборка = Запрос.Выполнить().Выгрузить();
	
	Возврат Выборка;
	
КонецФункции

&НаСервере
Процедура ОчиститьСписокОповещений()

	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Письмо Из Письма Цикл
		НаборЗаписей = РегистрыСведений.ОповещенияОПисьмах.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Письмо.Установить(Письмо.Ссылка);
		НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
		НаборЗаписей.Записать();
	КонецЦикла;	
	
КонецПроцедуры 
