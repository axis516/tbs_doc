﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЭкспортныеПроцедурыИФункции

// Определяет период устаревания письма для папки, полученной из настройки.
// 
// Параметры:
//  Папка - СправочникСсылка.ПапкиПисем
//
// Возвращаемое значение:
//  Если настройка не задана, тогда возвращает Неопределено.
//
Функция ПолучитьПериодУстареванияПисем(Папка) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.НастройкиАвтоочисткиПапокПисем.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Папка = Папка;
	МенеджерЗаписи.Прочитать();
	Если Не МенеджерЗаписи.Выбран() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат МенеджерЗаписи.ПериодУстаревания;
	
КонецФункции

// Управляет настройкой автоочистки папки писем.
//
// Параметры:
//  Папка - СправочникСсылка.ПапкиПисем
//  ПериодУстареванияПисьма - Число - количество дней, через которое письмо начинает считаться "старым".
//  АвтоОчистка - Булево - значение автивности флага настройки.
//
Процедура УстановитьАвтоОчисткуПапки(Папка, ПериодУстареванияПисем, АвтоОчистка) Экспорт
	
	Если Не ЗначениеЗаполнено(Папка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПериодУстареванияПисем) Или 
		ТипЗнч(ПериодУстареванияПисем) = Тип("Число") И ПериодУстареванияПисем < 1 Тогда
		
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(АвтоОчистка) Или ТипЗнч(АвтоОчистка) <> Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	Если АвтоОчистка Тогда
		
		МенеджерЗаписи = РегистрыСведений.НастройкиАвтоочисткиПапокПисем.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Папка = Папка;
		МенеджерЗаписи.ПериодУстаревания = ПериодУстареванияПисем;
		МенеджерЗаписи.Записать();
		
	Иначе
		
		МенеджерЗаписи = РегистрыСведений.НастройкиАвтоочисткиПапокПисем.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Папка = Папка;
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли