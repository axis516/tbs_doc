﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не РольДоступна("ПолныеПрава") Тогда
		Элементы.ФормаНастроитьПравилаРазмещенияФайловВТомах.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПереместитьПорядокТома(Элементы.Список.ТекущиеДанные.Ссылка, Истина);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПереместитьПорядокТома(Элементы.Список.ТекущиеДанные.Ссылка, Ложь);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПереместитьПорядокТома(ТомСсылка, Вверх)
	
	Если ТомСсылка.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;	
	
	ТомСледующий = НайтиСледующийТомВГруппе(ТомСсылка, Вверх);
	Если ТомСледующий <> Неопределено Тогда
		
		ТомТекущийОбъект = ТомСсылка.ПолучитьОбъект();
		ТомСледующийОбъект = ТомСледующий.ПолучитьОбъект();
		
		ПорядокСледующий = ТомСледующийОбъект.ПорядокЗаполнения;
		ТомСледующийОбъект.ПорядокЗаполнения = ТомТекущийОбъект.ПорядокЗаполнения;
		ТомТекущийОбъект.ПорядокЗаполнения = ПорядокСледующий;
		
		ТомТекущийОбъект.Записать();
		ТомСледующийОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция НайтиСледующийТомВГруппе(ТомСсылка, Вверх)
	
	ТаблицаТомов = ФайловыеФункции.ПолучитьСписокТомовВГруппе(ТомСсылка.Родитель);
	
	Строка = ТаблицаТомов.Найти(ТомСсылка, "Ссылка");
	Если Строка <> Неопределено Тогда
		
		ИндексСледующий = -1;
		ИндексТекущий = ТаблицаТомов.Индекс(Строка);
		
		Если Вверх И ИндексТекущий > 0 Тогда
			ИндексСледующий = ИндексТекущий - 1;
		ИначеЕсли Не Вверх И ИндексТекущий < ТаблицаТомов.Количество() - 1 Тогда
			ИндексСледующий = ИндексТекущий + 1;
		КонецЕсли;	
		
		Если ИндексСледующий <> -1 Тогда
			
			СтрокаСледующая = ТаблицаТомов[ИндексСледующий];
			Возврат СтрокаСледующая.Ссылка;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если УстановитьВладельцаТома(ПараметрыПеретаскивания.Значение, Строка) Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УстановитьВладельцаТома(МассивСсылокНаТома, НовыйВладелец)
	
	Если МассивСсылокНаТома.Количество() = 0 Или Не ЗначениеЗаполнено(НовыйВладелец) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Этот тип объекта при перетаскивании мы не обрабатываем
	Если МассивСсылокНаТома.Количество() > 0 И ТипЗнч(МассивСсылокНаТома[0]) <> Тип("СправочникСсылка.ТомаХраненияФайлов") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Родитель не изменился
	Если МассивСсылокНаТома.Количество() > 0 И (МассивСсылокНаТома[0].Родитель = НовыйВладелец) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Группы нельзя перетаскивать
	Если МассивСсылокНаТома.Количество() > 0 И МассивСсылокНаТома[0].ЭтоГруппа Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Корень групп нельзя перетаскивать
	Если МассивСсылокНаТома.Количество() > 0 И Не ЗначениеЗаполнено(МассивСсылокНаТома[0]) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		Для Каждого ТомПринятый Из МассивСсылокНаТома Цикл
			ТомОбъект = ТомПринятый.ПолучитьОбъект();
			ТомОбъект.Заблокировать();
			ТомОбъект.Родитель = НовыйВладелец;
			ТомОбъект.ПорядокЗаполнения = Справочники.ТомаХраненияФайлов.НайтиМаксимальныйПорядок(ТомОбъект.Родитель) + 1;
			ТомОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		РаботаСФайламиВызовСервера.ПрименитьПравилаДляФормированияОчереди();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура НастроитьПравилаРазмещенияФайловВТомах(Команда)
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму("Справочник.ПравилаРазмещенияФайловВТомах.Форма.НастройкаПравилРазмещенияФайловВТомах", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ПереносФайловВТома(Команда)
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму("Обработка.ПереносФайловВТома.Форма", ПараметрыФормы);
КонецПроцедуры
