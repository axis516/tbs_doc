﻿
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДокументыПоВопросу.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора",
		Справочники.ВопросыДеятельности.ПустаяСсылка());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОжидания()
	
	Если Элементы.Список.ТекущаяСтрока <> ДокументыПоВопросу.Параметры.Элементы.Найти("ЗначениеОтбора").Значение Тогда
		ДокументыПоВопросу.Параметры.УстановитьЗначениеПараметра("ЗначениеОтбора", Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры
