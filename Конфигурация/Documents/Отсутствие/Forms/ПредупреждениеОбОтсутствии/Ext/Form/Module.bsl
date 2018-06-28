﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отсутствия.Количество() = 1 Тогда
		КлючСохраненияПоложенияОкна = "ОдноОтсутствие";
		ТекущееОтсутствие = Параметры.Отсутствия[0];
		ОбновитьДанныеОтсутствия(ТекущееОтсутствие, ПолноеОписаниеОтсутствия);
		Элементы.Список.Видимость = Ложь;
	Иначе
		КлючСохраненияПоложенияОкна = "СписокОтсутствий";
		Список.Параметры.УстановитьЗначениеПараметра("МассивСсылок", Параметры.Отсутствия);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстВопроса) Тогда
		Элементы.НадписьВопрос.Заголовок = Параметры.ТекстВопроса;
	Иначе
		Элементы.НадписьВопрос.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстПредупреждения) Тогда
		Элементы.НадписьПредупреждение.Заголовок = Параметры.ТекстПредупреждения;
	Иначе
		Элементы.НадписьПредупреждение.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстКоманды) Тогда
		Элементы.Да.Заголовок = Параметры.ТекстКоманды;
	Иначе
		Элементы.Да.Заголовок = НСтр("ru = 'Закрыть'");
		Элементы.Нет.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолноеОписаниеОтсутствияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВстроеннаяПочтаКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, , Элемент.Документ);
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ТекущееОтсутствие = Неопределено;
	ИначеЕсли Элемент.ТекущиеДанные.Ссылка <> ТекущееОтсутствие Тогда
		ТекущееОтсутствие = Элемент.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбновитьОтсутствие", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Да(Команда)
	
	Закрыть(КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)
	
	Закрыть(КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтсутствие()
	
	Если Не ЗначениеЗаполнено(ТекущееОтсутствие) Тогда
		ПолноеОписаниеОтсутствия = ОтсутствияКлиентСервер.ПолучитьПустоеHTMLПредставление();
		Возврат;
	КонецЕсли;
	
	ОбновитьДанныеОтсутствия(ТекущееОтсутствие, ПолноеОписаниеОтсутствия);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьДанныеОтсутствия(Отсутствие, ПолноеОписаниеОтсутствия)
	
	ПолноеОписаниеОтсутствия = Документы.Отсутствие.ПолучитьПредставлениеHTML(Отсутствие);
	
КонецПроцедуры

#КонецОбласти