﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Отображение удаленных
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Отображение удаленных
	Если ОтображатьУдаленные Тогда
		ПереключитьОтображатьУдаленные();
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтображатьУдаленные(Команда)
	
	ОтображатьУдаленные = Не ОтображатьУдаленные;
	ПереключитьОтображатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПереключитьОтображатьУдаленные()
	
	Элементы.ФормаОтображатьУдаленные.Пометка = ОтображатьУдаленные;
	Список.Параметры.УстановитьЗначениеПараметра("ОтображатьУдаленные", ОтображатьУдаленные);
	
КонецПроцедуры

#КонецОбласти
