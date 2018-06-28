﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ОбъектКТ") Тогда	
		ОбъектКТ = Параметры.ОбъектКТ;
	КонецЕсли;	
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборСписка(ИсторияОценок, Настройки);
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.УровеньКонтроля, УровеньКонтроля);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.Ответственный, Ответственный);		
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УровеньКонтроляПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("УровеньКонтроля", УровеньКонтроля);
	
	УстановитьОтборСписка(ИсторияОценок, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, УровеньКонтроля);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("Ответственный", Ответственный);
	
	УстановитьОтборСписка(ИсторияОценок, ПараметрыОтбора);		
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Ответственный);	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияОценокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(,Элементы.ИсторияОценок.ТекущиеДанные.КТ);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Оценить(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	СписокКТ = Новый Массив;
	
	Для каждого Эл Из Элементы.ИсторияОценок.ВыделенныеСтроки Цикл
		СписокКТ.Добавить(Эл);
	КонецЦикла;	
	
	ДополнительныеПараметры.Вставить("ВыбранныеКТ", СписокКТ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавлениеОценкиКТПродолжение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	
	Если Элементы.ИсторияОценок.ТекущийЭлемент = Элементы.ИсторияОценокОценка2 Тогда
		ПараметрыФормы.Вставить("Дата", СдвинутьДатуНаНеделю(ТекущаяДата(), -1));
	ИначеЕсли Элементы.ИсторияОценок.ТекущийЭлемент = Элементы.ИсторияОценокОценка3	Тогда
		ПараметрыФормы.Вставить("Дата", СдвинутьДатуНаНеделю(ТекущаяДата(), -2));
	Иначе 
		ПараметрыФормы.Вставить("Дата", ТекущаяДата());
	КонецЕсли;	

	ОткрытьФорму("Справочник.КонтрольныеТочки.Форма.ДобавлениеОценкиКТ", ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлениеОценкиКТПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "Отмена" ИЛИ Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ДополнительныеПараметры.ВыбранныеКТ.Количество() > 5 Тогда
		СтрокаСостояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Идет установка оценок контрольных точек (%1). Пожалуйста, подождите'"),
			Строка(ДополнительныеПараметры.ВыбранныеКТ.Количество()));
		Состояние(СтрокаСостояние);
	КонецЕсли;	
	
	УстановитьОценкуСервер(
		Результат.Оценка, 
		Результат.Дата, 
		Результат.Автор, 
		Результат.Комментарий,
		ДополнительныеПараметры.ВыбранныеКТ);
	
	Если ДополнительныеПараметры.ВыбранныеКТ.Количество() > 5 Тогда
		СтрокаСостояние = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Установка оценок контрольных точек завершена (%1).'"),
			Строка(ДополнительныеПараметры.ВыбранныеКТ.Количество()));
		Состояние(СтрокаСостояние);
	КонецЕсли;
	
	Элементы.ИсторияОценок.Обновить();
	Оповестить("Запись_ОценкаКТ", ОбъектКТ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНаСервере()
	      
	Дата1Начало = НачалоНедели(ТекущаяДата());
	Дата1Конец = КонецНедели(Дата1Начало);

	Дата2Начало = НачалоНедели(Дата1Начало - 1);
	Дата2Конец = КонецНедели(Дата2Начало);
	
	Дата3Начало = НачалоНедели(Дата2Начало - 1);
	Дата3Конец = КонецНедели(Дата3Начало);
	
	Элементы.ИсторияОценокОценка1.Заголовок = Формат(Дата1Начало, "ДФ='dd'") + "-" + Формат(Дата1Конец, "ДФ='dd.MM'");
	Элементы.ИсторияОценокОценка2.Заголовок = Формат(Дата2Начало, "ДФ='dd'") + "-" + Формат(Дата2Конец, "ДФ='dd.MM'");
	Элементы.ИсторияОценокОценка3.Заголовок = Формат(Дата3Начало, "ДФ='dd'") + "-" + Формат(Дата3Конец, "ДФ='dd.MM'");
	
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("Дата1Начало", Дата1Начало);
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("Дата1Конец", Дата1Конец);
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("Дата2Начало", Дата2Начало);
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("Дата2Конец", Дата2Конец);
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("Дата3Начало", Дата3Начало);
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("Дата3Конец", Дата3Конец);
	
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("ОбъектКТ", ОбъектКТ);
	
	ИсторияОценок.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИндексКартинкиОценки(Оценка)
	
	Если Оценка = Перечисления.ВероятностиКТ.ВСрок Тогда
		Возврат 3;
	ИначеЕсли Оценка = Перечисления.ВероятностиКТ.ЕстьНесущественныеРиски Тогда	
		Возврат 2;
	ИначеЕсли Оценка = Перечисления.ВероятностиКТ.ПодУгрозой Тогда			
		Возврат 1;
	ИначеЕсли Оценка = Перечисления.ВероятностиКТ.НеОпределено Тогда				
		Возврат 6;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция СдвинутьДатуНаНеделю(Дата, ЧислоНедель)
	
	Возврат Дата + ЧислоНедель *(60*60*24*7);
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьОценкуСервер(Оценка, Дата, Автор, Комментарий, СписокКТ)
	
	КонтрольныеТочки.УстановитьОценку(Оценка, Дата, Автор, Комментарий, СписокКТ);		
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	
	// уровень контрольной точки 
	УровеньКонтроля = ПараметрыОтбора.Получить("УровеньКонтроля");
	Если УровеньКонтроля <> Неопределено Тогда 
		Если ЗначениеЗаполнено(УровеньКонтроля) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"УровеньКТ",
				УровеньКонтроля,
				ВидСравненияКомпоновкиДанных.Равно);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "УровеньКТ");

		КонецЕсли;
	КонецЕсли;	
	
	// Ответственный 
	Ответственный = ПараметрыОтбора.Получить("Ответственный");
	Если Ответственный <> Неопределено Тогда 
		Если ЗначениеЗаполнено(Ответственный) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Ответственный",
				Ответственный,
				ВидСравненияКомпоновкиДанных.Равно);
		Иначе
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Ответственный");

		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти