﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор,
		"Автор",
		ПользователиКлиентСервер.ТекущийПользователь());
			
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		Закрыть(Значение);
	КонецЕсли;	
	
КонецПроцедуры
