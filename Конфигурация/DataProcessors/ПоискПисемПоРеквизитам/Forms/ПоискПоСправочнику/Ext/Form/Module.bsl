﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТипСправочника = Параметры.ТипСправочника;
	АвтоЗаголовок = Ложь;
	Заголовок = Параметры.ЗаголовокФормы;
	Если Метаданные.Справочники.Найти(ТипСправочника) <> Неопределено Тогда
		СтрокаДляДобавления = ПредопределенноеЗначение("Справочник." + ТипСправочника + ".ПустаяСсылка");
		ЭтоСправочник = Истина;
	Иначе
		СтрокаДляДобавления = ПредопределенноеЗначение("Перечисление." + ТипСправочника + ".ПустаяСсылка");
		ЭтоСправочник = Ложь;
	КонецЕсли;	
	Для Каждого Элемент Из Параметры.СписокЗначений Цикл
		НоваяСтрока = ТаблицаСтрок.Добавить();
		НоваяСтрока.Строка = Элемент.Значение;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	
	ВозвращаемыйСписок = Новый СписокЗначений();
	Для Каждого СтрокаТаблицы Из ТаблицаСтрок Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Строка) Тогда
			ВозвращаемыйСписок.Добавить(СтрокаТаблицы.Строка);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Список", ВозвращаемыйСписок);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Копирование Тогда
		Отказ = Истина;
		НоваяСтрока = ТаблицаСтрок.Добавить();
		НоваяСтрока.Строка = СтрокаДляДобавления; 
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтрокСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	Если ЭтоСправочник Тогда
		ОткрытьФорму("Справочник." + ТипСправочника + ".ФормаВыбора", ПараметрыФормы, Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ОткрытьФорму("Перечисление." + ТипСправочника + ".ФормаВыбора", ПараметрыФормы, Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры
