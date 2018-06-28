﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокиЗаголовка = Новый Массив;
	СтрокиЗаголовка.Добавить(НСтр("ru = 'У адресата ""'"));
	СтрокиЗаголовка.Добавить(
		Новый ФорматированнаяСтрока(
			Строка(Параметры.Контакт.Контакт),,,,
			ПолучитьНавигационнуюСсылку(Параметры.Контакт.Контакт)));
	СтрокиЗаголовка.Добавить(НСтр("ru = '"" имеется несколько электронных адресов.'"));
	СтрокиЗаголовка.Добавить(Символы.ПС + НСтр("ru = 'Отметьте нужные и нажмите ОК.'"));
	
	Элементы.Декорация_Инфо.Заголовок = Новый ФорматированнаяСтрока(СтрокиЗаголовка);
	
	Для Каждого СтрАдрес ИЗ Параметры.Контакт.Адреса Цикл
		
		Стр = АдресаКонтакта.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, СтрАдрес); 
		Стр.Контакт = Параметры.Контакт.Контакт;
		Стр.НомерКартинки = Параметры.Контакт.НомерКартинки;
				
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_АдресаКонтакта

&НаКлиенте
Процедура АдресаКонтактаПередНачаломИзменения(Элемент, Отказ)
	
	Если НЕ Параметры.ВыборНесколькихАдресов Тогда
		Отказ = Истина;
		УстановитьЗначениеОтметкиУВсехЭлАдресов(Ложь);
		ТекущиеДанные = Элементы.АдресаКонтакта.ТекущиеДанные;
		ТекущиеДанные.Отметка = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбранныеАдресаКонтактов = Новый Массив;
	
	Для Каждого Стр ИЗ АдресаКонтакта Цикл
		Если Стр.Отметка Тогда
			СтруктураКонтакта = СтруктураКонтакта();
			СтруктураКонтакта.Контакт = Стр.Контакт;
			СтруктураКонтакта.НомерКартинки = Стр.НомерКартинки;
			СтруктураАдресаКонтакта = СтруктураАдресаКонтакта();
			ЗаполнитьЗначенияСвойств(СтруктураАдресаКонтакта, Стр);
			СтруктураКонтакта.Адреса.Добавить(СтруктураАдресаКонтакта);
			ВыбранныеАдресаКонтактов.Добавить(СтруктураКонтакта);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(ВыбранныеАдресаКонтактов);
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьЗначениеОтметкиУВсехЭлАдресов(Отметка)
	
	Для Каждого Элемент ИЗ АдресаКонтакта Цикл
		Элемент.Отметка = Отметка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураКонтакта()
	
	СтруктураКонтакта = Новый Структура;
	СтруктураКонтакта.Вставить("Контакт");
	СтруктураКонтакта.Вставить("НомерКартинки");
	СтруктураКонтакта.Вставить("Адреса", Новый Массив);
	
	Возврат СтруктураКонтакта;
	
КонецФункции

&НаКлиенте
Функция СтруктураАдресаКонтакта()
	
	Возврат Новый Структура("Адрес, Представление, ПолноеПредставление");
	
КонецФункции

#КонецОбласти
