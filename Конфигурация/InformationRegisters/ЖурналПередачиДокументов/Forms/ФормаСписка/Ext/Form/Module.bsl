﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПользователиПустаяСсылка = Справочники.Пользователи.ПустаяСсылка();
	Показывать = "Невозвращенные";
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.Показывать, 
		Показывать, "Все");
	УстановитьОтбор();
	
	ПоказатьУдаленные();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Показывать = Настройки["Показывать"];
	ПоДокументу = Настройки["ПоДокументу"];
	ПоПользователю = Настройки["ПоПользователю"];
	
	УстановитьОтборСписка(Список, Настройки);
	
	ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
	ПоказатьУдаленные();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.Показывать, 
		Показывать, "Все");
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоДокументу, ПоДокументу);
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.ПоПользователю, ПоПользователю);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоПользователюПриИзменении(Элемент)
	
	Если ПоПользователю = Неопределено Тогда
		ПоПользователю = ПользователиПустаяСсылка;	
	КонецЕсли;
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ПоПользователю);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПользователюНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ВыборПользователяКонтактноеЛицо", Новый Структура("ТекущаяСтрока", ПоПользователю), Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПользователюОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛица")
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") 
		Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		ПоПользователю = ВыбранноеЗначение;
	КонецЕсли;
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ПоПользователю);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПользователюАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателяДляЖурналаПередачи(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоПользователюОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Делопроизводство.СформироватьДанныеВыбораПолучателяДляЖурналаПередачи(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДокументуПриИзменении(Элемент)
	
	УстановитьОтбор();
	
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, ПоДокументу);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоДокументуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить("ВнутренниеДокументы", НСтр("ru = 'Внутренний документ'"));
	СписокТипов.Добавить("ВходящиеДокументы",   НСтр("ru = 'Входящий документ'"));
	СписокТипов.Добавить("ИсходящиеДокументы",  НСтр("ru = 'Исходящий документ'"));	
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПоДокументуНачалоВыбораПродолжение",
		ЭтотОбъект,
		Новый Структура("Элемент", Элемент));

	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокТипов, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ПоДокументуНачалоВыбораПродолжение(ВыбранныйТип, Параметры) Экспорт 

	Если ВыбранныйТип <> Неопределено Тогда 
		ОткрытьФорму("Справочник." + ВыбранныйТип.Значение + ".ФормаВыбора", , Параметры.Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПриИзменении(Элемент)
	
	УстановитьОтбор();
	ОбщегоНазначенияДокументооборотКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, 
		Показывать, "Все");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтметитьВозврат(Команда)
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда 
		Если ТипЗнч(ВыделенныеСтроки[0]) <> Тип("РегистрСведенийКлючЗаписи.ЖурналПередачиДокументов") Тогда 
			ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'"));
			Возврат;
		КонецЕсли;
		Если Элементы.Список.ТекущиеДанные.Возвращен Тогда 
			ПоказатьПредупреждение(, НСтр("ru = 'Документ уже возвращен!'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) <> Тип("РегистрСведенийКлючЗаписи.ЖурналПередачиДокументов") Тогда 
			Продолжить;
		КонецЕсли;
		
		УстановитьВозвращен(ВыделеннаяСтрока);
	КонецЦикла;	
	
	Если ВыделенныеСтроки.Количество() = 1 Тогда 
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			Оповестить("ИзмененЖурналПередачи", ТекущиеДанные.Документ);
		КонецЕсли;	
	КонецЕсли;	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
		
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.ЖурналПередачиСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по журналу передачи'");
	
	РазделГипперСсылка = НастройкиВариантовОтчетовДокументооборот.ПолучитьРазделОтчетаПоИмени("ДокументыИФайлы");

	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, РазделГипперСсылка", 
		Раздел, ЗаголовокФормы, Истина, РазделГипперСсылка);
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"ЖурналПередачиСписок");

КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	
	ПоказатьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	Если ПоПользователю = Неопределено Тогда 
		ПоПользователю = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	ПараметрыОтбора = Новый Соответствие();
	ПараметрыОтбора.Вставить("ПоПользователю", 	ПоПользователю);
	ПараметрыОтбора.Вставить("ПоДокументу",  	ПоДокументу);
	ПараметрыОтбора.Вставить("Показывать", 		Показывать);
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)

	Если ЗначениеЗаполнено(ПараметрыОтбора["ПоПользователю"]) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Пользователь", ПараметрыОтбора["ПоПользователю"]);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Пользователь");
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ПараметрыОтбора["ПоДокументу"]) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Документ", ПараметрыОтбора["ПоДокументу"]);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Документ");
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Возвращен"); 
	Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПросроченные", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());
	
	Если ПараметрыОтбора["Показывать"] = "Возвращенные" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Возвращен", Истина);
	ИначеЕсли ПараметрыОтбора["Показывать"] = "Невозвращенные" Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Возвращен", Ложь);
	ИначеЕсли ПараметрыОтбора["Показывать"] = "Просроченные" Тогда 
		Список.Параметры.УстановитьЗначениеПараметра("ПоказыватьПросроченные", Истина);
	КонецЕсли;		
		
КонецПроцедуры	

&НаСервереБезКонтекста
Процедура УстановитьВозвращен(КлючЗаписи)
	
	МенеджерЗаписи = РегистрыСведений.ЖурналПередачиДокументов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период = КлючЗаписи.Период;
	МенеджерЗаписи.Документ = КлючЗаписи.Документ;
	МенеджерЗаписи.ТипЭкземпляра = КлючЗаписи.ТипЭкземпляра;
	МенеджерЗаписи.НомерЭкземпляра = КлючЗаписи.НомерЭкземпляра;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Возвращен Тогда 
		Возврат;
	КонецЕсли;	
	
	МенеджерЗаписи.Возвращен = Истина;
	МенеджерЗаписи.ДатаВозврата = ТекущаяДата();
	МенеджерЗаписи.Записать();
	
КонецПроцедуры	

&НаСервере
Процедура ПоказатьУдаленные()
	
	Если ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Документ.ПометкаУдаления");
	Иначе	
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Документ.ПометкаУдаления", Ложь);
	КонецЕсли;	
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
КонецПроцедуры

#КонецОбласти
