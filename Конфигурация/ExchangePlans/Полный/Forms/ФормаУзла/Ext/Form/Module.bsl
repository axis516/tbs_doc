﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ЗакрытаФормаУзлаПланаОбмена");
	
КонецПроцедуры

#КонецОбласти