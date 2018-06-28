﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПересекающиесяОтсутствия = Отсутствия.ПолучитьПересекающиесяОтсутствия(
		Параметры.Отсутствие, Параметры.Сотрудник, Параметры.ДатаНачала, Параметры.ДатаОкончания);
	МассивСсылок = ПересекающиесяОтсутствия.ВыгрузитьКолонку("Ссылка");
	Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", МассивСсылок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Повторить(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти