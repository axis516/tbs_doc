﻿
// Возвращает HTML представление письма
//
Функция Прочитать(Письмо) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Возврат Запись.ТекстHTMLХранилище.Получить();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Устанавливает HTML представление письма
//
Процедура Записать(Письмо, ТекстHTML) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	
	Запись.Письмо = Письмо;
	Запись.ТекстHTMLХранилище = Новый ХранилищеЗначения(ТекстHTML, Новый СжатиеДанных);
	Запись.ДатаЗаписи = ТекущаяДатаСеанса();
	
	Запись.Записать(Истина);
	
КонецПроцедуры

// Очищает HTML представление письма
//
Процедура Удалить(Письмо) Экспорт
	
	Запись = СоздатьМенеджерЗаписи();
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	
	Если Запись.Выбран() Тогда
		Запись.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Удаляет порцию устаревших данных.
// 
// Возвращаемое значение - Булево - Истина, если были найдены устаревшие данные, в противном случае Ложь.
// 
Функция УдалитьПорциюУстаревшихДанных() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПериодХраненияHTMLПредставленияСодержанияПисем =
		ВстроеннаяПочтаСервер.ПолучитьНастройкуПрограммы("ПериодХраненияHTMLПредставленияСодержанияПисем");
	
	Если ПериодХраненияHTMLПредставленияСодержанияПисем <= 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ГраницаОчисткиЗаписей = НачалоДня(ТекущаяДатаСеанса())
		- ПериодХраненияHTMLПредставленияСодержанияПисем * 24 * 3600;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 500000
		|	HTMLПредставленияСодержанияПисем.Письмо
		|ИЗ
		|	РегистрСведений.HTMLПредставленияСодержанияПисем КАК HTMLПредставленияСодержанияПисем
		|ГДЕ
		|	HTMLПредставленияСодержанияПисем.ДатаЗаписи < &Дата");
	
	Запрос.УстановитьПараметр("Дата", ГраницаОчисткиЗаписей);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		Удалить(Выборка.Письмо);
	КонецЦикла;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru='Удаление устаревших данных'"), 
		УровеньЖурналаРегистрации.Информация,
		Метаданные.РегистрыСведений.HTMLПредставленияСодержанияПисем,, 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура завершена успешно, обработано %1 записей'"), Выборка.Количество()));
	
	Возврат Выборка.Количество() > 0;
	
КонецФункции
