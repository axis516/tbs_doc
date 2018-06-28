﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ПрограммныйИнтерфейс

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПечататьКарточкуЭД = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КарточкаЭД");
	Если ПечататьКарточкуЭД Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"КарточкаЭД",
			НСтр("ru = 'Карточка электронного документа'"),
			ПечатьКарточкиЭД(МассивОбъектов, ОбъектыПечати, "КарточкаЭД"),
			,
			"ОбщийМакет.ПФ_MXL_КарточкаЭД");
	КонецЕсли;
	
	ПечататьЭД = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ЭД");
	Если ПечататьЭД Тогда
		ТабДок = ПечатьЭД(МассивОбъектов, ОбъектыПечати);
		СинонимМакета = НСтр("ru = 'Электронный документ'");
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ЭД", СинонимМакета, ТабДок);
		Если ТипЗнч(ТабДок) = Тип("Строка") Тогда
			ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ТабДок);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Обработчик обновления БЭД 1.1.13.4
// Заполняет дату окончания действия сертификата.
//
Процедура ЗаполнитьНаименованиеФайла() Экспорт
	
	ЭлементСсылка = Справочники.ЭДПрисоединенныеФайлы.Выбрать();
	
	Пока ЭлементСсылка.Следующий() Цикл
		
		Попытка
			ЭлементОбъект = ЭлементСсылка.ПолучитьОбъект();
			Если ЭлементОбъект.ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ЭСФ
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементОбъект.ВладелецФайла,"ВидЭД") 
					= Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
				СтрокаУИД = ЭлементОбъект.УникальныйИД;
				Наименование = ЭлементОбъект.Наименование;
				ПозицияУИД = СтрНайти(Наименование, "_" + Лев(СтрокаУИД, 35));
				Если ПозицияУИД > 0 Тогда
					ЭлементОбъект.НаименованиеФайла = Лев(Наименование, ПозицияУИД) + СтрокаУИД;
				КонецЕсли;
			Иначе
				ЭлементОбъект.НаименованиеФайла = ЭлементОбъект.Наименование;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЭлементОбъект);
		Исключение
			Операция = НСтр("ru = 'Запись присоединенного файла'");
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				Операция, ТекстОшибки, ТекстСообщения, 2);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.2.4.4
// Меняет текущий статус Произвольного ЭД с НеОтправлен на Сформирован.
//
Процедура ИзменитьСтатусыПроизвольныхЭДСНеОтправленНаСформирован() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЭДПрисоединенныеФайлы.Ссылка
		|ИЗ
		|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
		|ГДЕ
		|	ЭДПрисоединенныеФайлы.СтатусЭД = &СтатусНеОтправлен
		|	И ЭДПрисоединенныеФайлы.УдалитьВидЭД = &ВидПроизвольныйЭД";
	
	Запрос.УстановитьПараметр("ВидПроизвольныйЭД", Перечисления.ВидыЭД.ПроизвольныйЭД);
	Запрос.УстановитьПараметр("СтатусНеОтправлен", Перечисления.СтатусыЭД.УдалитьНеОтправлен);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Если МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.СтатусЭД = Перечисления.СтатусыЭД.Сформирован;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			СообщитьОбОшибке(ИнформацияОбОшибке());
		КонецПопытки;
	КонецЦикла;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#Область Документооборот
// УправлениеДоступом

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
КонецПроцедуры

// Конец УправлениеДоступом
#КонецОбласти


#КонецОбласти
#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Перем ВидЭД;
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		СтандартнаяОбработка = Ложь;
		ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьРеквизитыЭД(Параметры.Ключ.ВладелецФайла).Свойство("ВидЭД", ВидЭД);
		Если ТипЗнч(Параметры.Ключ.ВладелецФайла) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий") Тогда
			Если ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
				ВыбраннаяФорма = "Документ.ЭлектронныйДокументВходящий.Форма.ФормаПроизвольногоДокумента";
				Параметры.Вставить("Объект", Параметры.Ключ.ВладелецФайла);
				
			Иначе
				ВыбраннаяФорма = "Документ.ЭлектронныйДокументВходящий.Форма.ФормаПросмотраЭД";
			КонецЕсли;
		Иначе
			Если ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
				ВыбраннаяФорма = "Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПроизвольногоДокумента";
				Параметры.Вставить("Объект",Параметры.Ключ.ВладелецФайла);
				
			Иначе
				ВыбраннаяФорма = "Документ.ЭлектронныйДокументИсходящий.Форма.ФормаПросмотраЭД";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура из универсальной обработки ПоискИЗаменаЗначений
// Изменения:
// - заменен метод Сообщить(...) на ЗаписьЖурналаРегистрации(...).
//
Процедура СообщитьОбОшибке(Знач Описание)
	
	Если ТипЗнч(Описание) = Тип("ИнформацияОбОшибке") Тогда
		Описание = ?(Описание.Причина = Неопределено, Описание, Описание.Причина).Описание;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Сертификаты электронной подписи.Перенос настроек в новый объект метаданных'",
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		,
		,
		Описание,
		РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
	
КонецПроцедуры

Функция ПечатьЭД(СсылкаНаЭД, ОбъектыПечати)
	
	ТабДок = ПечатнаяФормаЭД(СсылкаНаЭД);
	
	Возврат ТабДок;
	
КонецФункции

Функция ПечатьКарточкиЭД(МассивОбъектов, ОбъектыПечати, ИмяМакета ="КарточкаЭД")
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЭДПрисоединенныеФайлы.Ссылка,
	|	ЭДПрисоединенныеФайлы.НаименованиеФайла КАК НаименованиеФайла,
	|	ЭДПрисоединенныеФайлы.ОтправительЭД КАК Отправитель,
	|	ЭДПрисоединенныеФайлы.ПолучательЭД КАК Получатель,
	|	ЭДПрисоединенныеФайлы.УникальныйИД КАК Идентификатор,
	|	ЭДПрисоединенныеФайлы.ДополнительнаяИнформация КАК СопроводительнаяЗаписка,
	|	ЭДПрисоединенныеФайлы.Расширение,
	|	ЭДПрисоединенныеФайлы.НаправлениеЭД КАК НаправлениеЭД,
	|	ЭДПрисоединенныеФайлы.ВладелецФайла КАК ВладелецФайла
	|ПОМЕСТИТЬ втЭД
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
	|ГДЕ
	|	ЭДПрисоединенныеФайлы.Ссылка В(&МассивОбъектов)
	|	И НЕ ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД В (&СлужебныеЭД)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭлектронныйДокументВходящий.Ссылка,
	|	ЭлектронныйДокументВходящий.ВидЭД,
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныйДокументВходящий.ВидЭД),
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныйДокументВходящий.ТипДокумента),
	|	ЭлектронныйДокументВходящий.Организация,
	|	ЭлектронныйДокументВходящий.Контрагент,
	|	ЭлектронныйДокументВходящий.ПрофильНастроекЭДО,
	|	ЭлектронныйДокументВходящий.Дата КАК Дата,
	|	ЭлектронныйДокументВходящий.Номер
	|ПОМЕСТИТЬ втДокументы
	|ИЗ
	|	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныйДокументВходящий
	|ГДЕ
	|	ЭлектронныйДокументВходящий.Ссылка В
	|			(ВЫБРАТЬ
	|				втЭД.ВладелецФайла
	|			ИЗ
	|				втЭД КАК втЭД)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭлектронныйДокументИсходящий.Ссылка,
	|	ЭлектронныйДокументИсходящий.ВидЭД,
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныйДокументИсходящий.ВидЭД),
	|	ПРЕДСТАВЛЕНИЕ(ЭлектронныйДокументИсходящий.ТипДокумента),
	|	ЭлектронныйДокументИсходящий.Организация,
	|	ЭлектронныйДокументИсходящий.Контрагент,
	|	ЭлектронныйДокументИсходящий.ПрофильНастроекЭДО,
	|	ЭлектронныйДокументИсходящий.Дата,
	|	ЭлектронныйДокументИсходящий.Номер
	|ИЗ
	|	Документ.ЭлектронныйДокументИсходящий КАК ЭлектронныйДокументИсходящий
	|ГДЕ
	|	ЭлектронныйДокументИсходящий.Ссылка В
	|			(ВЫБРАТЬ
	|				втЭД.ВладелецФайла
	|			ИЗ
	|				втЭД КАК втЭД)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДокументы.ВидЭД КАК ВидЭДСсылка,
	|	втДокументы.ВидЭДПредставление КАК ВидДокумента,
	|	втДокументы.ТипДокументаПредставление КАК ТипДокумента,
	|	втДокументы.Контрагент,
	|	втДокументы.Организация,
	|	втДокументы.ПрофильНастроекЭДО,
	|	втЭД.Ссылка,
	|	втЭД.НаименованиеФайла,
	|	втЭД.Отправитель,
	|	втЭД.Получатель,
	|	втДокументы.Дата КАК ДатаЭД,
	|	втДокументы.Номер КАК НомерЭД,
	|	втЭД.СопроводительнаяЗаписка,
	|	втЭД.Расширение,
	|	втЭД.НаправлениеЭД,
	|	втЭД.ВладелецФайла,
	|	втЭД.Идентификатор
	|ПОМЕСТИТЬ втЭДО
	|ИЗ
	|	втЭД КАК втЭД,
	|	втДокументы КАК втДокументы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Отпечаток,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.ПодписьВерна КАК ПодписьВерна,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.ДатаПроверкиПодписи,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.КомуВыданСертификат,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Ссылка,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Сертификат
	|ПОМЕСТИТЬ ВтОтпечатки
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы.ЭлектронныеПодписи КАК ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи
	|ГДЕ
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Ссылка В
	|			(ВЫБРАТЬ
	|				втЭД.Ссылка
	|			ИЗ
	|				втЭД)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Отпечаток,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.ПодписьВерна,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.ДатаПроверкиПодписи,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.КомуВыданСертификат,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Ссылка,
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Сертификат
	|ИЗ
	|	Справочник.ЭДПрисоединенныеФайлы.ЭлектронныеПодписи КАК ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи
	|ГДЕ
	|	ЭДПрисоединенныеФайлыЭлектронныеЦифровыеПодписи.Ссылка.ЭлектронныйДокументВладелец В
	|			(ВЫБРАТЬ
	|				втЭД.Ссылка
	|			ИЗ
	|				втЭД)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИспользоватьЭП КАК ТребуетсяПодпись,
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Организация КАК ПодписьОрганизации,
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Контрагент КАК ПодписьКонтрагента,
	|	втЭДО.Ссылка КАК Ссылка,
	|	втЭДО.ВидЭДСсылка,
	|	втЭДО.НаправлениеЭД КАК НаправлениеЭД,
	|	ЛОЖЬ КАК ПроизвольныйЭД
	|ИЗ
	|	втЭДО КАК втЭДО
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|		ПО втЭДО.ПрофильНастроекЭДО = СоглашенияОбИспользованииЭДИсходящиеДокументы.ПрофильНастроекЭДО
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент В
	|			(ВЫБРАТЬ
	|				втЭДО.ВидЭДСсылка
	|			ИЗ
	|				втЭДО)
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Организация В
	|			(ВЫБРАТЬ
	|				втЭДО.Организация
	|			ИЗ
	|				втЭДО)
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка.Контрагент В
	|			(ВЫБРАТЬ
	|				втЭДО.Контрагент
	|			ИЗ
	|				втЭДО)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втЭДО.НаименованиеФайла,
	|	втЭДО.Отправитель,
	|	втЭДО.Получатель,
	|	втЭДО.ВидДокумента,
	|	втЭДО.ВидЭДСсылка,
	|	втЭДО.ТипДокумента,
	|	втЭДО.Идентификатор,
	|	втЭДО.НомерЭД,
	|	втЭДО.ДатаЭД,
	|	втЭДО.СопроводительнаяЗаписка,
	|	втЭДО.Расширение,
	|	втЭДО.Контрагент,
	|	втЭДО.Организация,
	|	втЭДО.НаправлениеЭД,
	|	втЭДО.Ссылка
	|ИЗ
	|	втЭДО КАК втЭДО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВтОтпечатки.ПодписьВерна,
	|	ВтОтпечатки.ДатаПроверкиПодписи,
	|	ВтОтпечатки.КомуВыданСертификат,
	|	ВтОтпечатки.Ссылка
	|ИЗ
	|	ВтОтпечатки КАК ВтОтпечатки";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	СлужебныеЭД = Новый Массив;
	СлужебныеЭД.Добавить(Перечисления.ВидыЭД.ИзвещениеОПолучении);
	СлужебныеЭД.Добавить(Перечисления.ВидыЭД.УведомлениеОбУточнении);
	Запрос.УстановитьПараметр("СлужебныеЭД", СлужебныеЭД);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	МассивДанныхПечати = Новый Массив;
	
	ЗаполнитьДанныеПечатнойФормы(МассивРезультатов, МассивДанныхПечати);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_КарточкаЭД");
	ТабДок = Новый ТабличныйДокумент;
	
	Для каждого ДанныеПечатнойФормы Из МассивДанныхПечати Цикл
		
		Если ТабДок.ВысотаТаблицы > 0 Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		НомерСтрокиНачало = ТабДок.ВысотаТаблицы + 1;
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
		ОбластьШапка.Параметры.Заполнить(ДанныеПечатнойФормы);
		ТабДок.Вывести(ОбластьШапка);
		
		Если ДанныеПечатнойФормы.Свойство("НомерЭД") Тогда
			ОбластьПроизвольныйЭД = Макет.ПолучитьОбласть("ПроизвольныйЭД");
			ОбластьПроизвольныйЭД.Параметры.Заполнить(ДанныеПечатнойФормы);
			ТабДок.Вывести(ОбластьПроизвольныйЭД);
		КонецЕсли;
		
		Если ДанныеПечатнойФормы.Свойство("СопроводительнаяЗаписка") Тогда
			ОбластьСопроводительнаяЗаписка = Макет.ПолучитьОбласть("СопроводительнаяЗаписка");
			ОбластьСопроводительнаяЗаписка.Параметры.Заполнить(ДанныеПечатнойФормы);
			ТабДок.Вывести(ОбластьСопроводительнаяЗаписка);
		КонецЕсли;
		
		Если ДанныеПечатнойФормы.Свойство("Подписи") Тогда
			
			ОбластьСопроводительнаяЗаписка = Макет.ПолучитьОбласть("ТребуемыеПодписи");
			ОбластьСопроводительнаяЗаписка.Параметры.Заполнить(ДанныеПечатнойФормы.Подписи);
			ТабДок.Вывести(ОбластьСопроводительнаяЗаписка);
			
		КонецЕсли;
		
		Если ДанныеПечатнойФормы.Свойство("Сертификаты") Тогда
			
			ОбластьСертификаты = Макет.ПолучитьОбласть("Сертификаты");
			ТабДок.Вывести(ОбластьСертификаты);
			
			ОбластьСертификатыСтрока = Макет.ПолучитьОбласть("СертификатыСтрока");
			Для Каждого ТекСтрока Из ДанныеПечатнойФормы.Сертификаты Цикл
				ОбластьСертификатыСтрока.Параметры.Заполнить(ТекСтрока);
				ТабДок.Вывести(ОбластьСертификатыСтрока);
			КонецЦикла;
			
		КонецЕсли;
		
		ОбластьПодпись = Макет.ПолучитьОбласть("Подпись");
		ОбластьПодпись.Параметры.Заполнить(ДанныеПечатнойФормы);
		ТабДок.Вывести(ОбластьПодпись);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечатнойФормы.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

Процедура ЗаполнитьДанныеПечатнойФормы(МассивРезультатовЗапроса, МассивДанныхПечати)
	
	НеобходимыеПодписи = МассивРезультатовЗапроса[4].Выгрузить();
	ДанныеЭД = МассивРезультатовЗапроса[5].Выгрузить();
	СертификатыЭД = МассивРезультатовЗапроса[6].Выгрузить();
	
	МассивЭД = Новый Массив;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивЭД, ДанныеЭД.ВыгрузитьКолонку("Ссылка"), Истина);
	
	Для Каждого ЭлементМассива Из МассивЭД Цикл
		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", ЭлементМассива);
		
		МассивСтрокЭД = ДанныеЭД.НайтиСтроки(Отбор);
		СтрокаДанныхЭД = МассивСтрокЭД[0];
		
		ДанныеПечатнойФормы = Новый Структура;
		ДанныеПечатнойФормы.Вставить("Ссылка", ЭлементМассива);
		
		ИмяФайла = СтрокаДанныхЭД.НаименованиеФайла +"." + СтрокаДанныхЭД.Расширение;
		ДанныеПечатнойФормы.Вставить("ИмяФайла", ИмяФайла);
		
		Если СтрокаДанныхЭД.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий Тогда
			Отправитель = ПредставлениеЮрФизЛицо(СтрокаДанныхЭД.Организация);
			Получатель = ПредставлениеЮрФизЛицо(СтрокаДанныхЭД.Контрагент);
			
		Иначе
			Отправитель = ПредставлениеЮрФизЛицо(СтрокаДанныхЭД.Контрагент);
			Получатель = ПредставлениеЮрФизЛицо(СтрокаДанныхЭД.Организация);
			
		КонецЕсли;
		
		ДанныеПечатнойФормы.Вставить("Отправитель", Отправитель);
		ДанныеПечатнойФормы.Вставить("Получатель", Получатель);
		
		ТипДокумента = СтрокаДанныхЭД.ВидДокумента + " "+ СтрокаДанныхЭД.ТипДокумента;
		ДанныеПечатнойФормы.Вставить("ТипДокумента", ТипДокумента);
		
		Если ОбменСКонтрагентамиСлужебный.ЭтоФНС(СтрокаДанныхЭД.ВидЭДСсылка)Тогда
			Идентификатор = СтрокаДанныхЭД.НаименованиеФайла;
		Иначе
			Идентификатор = СтрокаДанныхЭД.Идентификатор;
		КонецЕсли;
		ДанныеПечатнойФормы.Вставить("Идентификатор", Идентификатор );
		
		Если ЗначениеЗаполнено(СтрокаДанныхЭД.НомерЭД) Тогда
			
			ДанныеПечатнойФормы.Вставить("НомерЭД", СтрокаДанныхЭД.НомерЭД);
			ДанныеПечатнойФормы.Вставить("ДатаЭД", СтрокаДанныхЭД.ДатаЭД);
			
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаДанныхЭД.СопроводительнаяЗаписка) Тогда
			ДанныеПечатнойФормы.Вставить("СопроводительнаяЗаписка", СтрокаДанныхЭД.СопроводительнаяЗаписка);
		КонецЕсли;
		
		ДанныеПечатнойФормы.Вставить("ТекущаяДата", Формат(ТекущаяДатаСеанса(), "ДЛФ=D"));
		
		// заполняем требуемые подписи
		МассивНеобходимыеПодписи = НеобходимыеПодписи.НайтиСтроки(Отбор);
		ТребуемыеПодписи = Неопределено;
		
		ЗаполнитьТребуемыеПодписи(ТребуемыеПодписи, МассивНеобходимыеПодписи);
		Если ЗначениеЗаполнено(ТребуемыеПодписи) Тогда
			ДанныеПечатнойФормы.Вставить("Подписи", ТребуемыеПодписи);
		КонецЕсли;
		
		// заполняем таблицу сертификатов ЭД
		
		МассивСертификатовЭД = СертификатыЭД.НайтиСтроки(Отбор);
		
		ТаблицаСертификатов = Новый ТаблицаЗначений;
		ИнициализацияТаблицыСертификатов(ТаблицаСертификатов);

		Для Каждого СтрокаМассива Из МассивСертификатовЭД Цикл
			
			НоваяСтрока = ТаблицаСертификатов.Добавить();
			НоваяСтрока.КомуВыдан = СтрокаМассива.КомуВыданСертификат;
			НоваяСтрока.Сертификат = СтрокаМассива.КомуВыданСертификат;
			НоваяСтрока.Статус = СтатусПодписи(СтрокаМассива);
		КонецЦикла;

		ДанныеПечатнойФормы.Вставить("Сертификаты", ТаблицаСертификатов);
		
		МассивДанныхПечати.Добавить(ДанныеПечатнойФормы);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТребуемыеПодписи(ТребуемыеПодписи, МассивНеобходимыеПодписи)
	
	Если МассивНеобходимыеПодписи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТребуемыеПодписи = Новый Структура;
	ТребуемыеПодписи.Вставить("ПредставлениеОтправителя");
	ТребуемыеПодписи.Вставить("ПредставлениеПолучателя");
	
	Для Каждого СтрокаМассива Из МассивНеобходимыеПодписи Цикл
		
		ЗаполнитьПредставлениеПодписантов(СтрокаМассива, ТребуемыеПодписи);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПредставлениеПодписантов(СтрокаМассива, ТребуемыеПодписи)
	
	Если СтрокаМассива.ПроизвольныйЭД Тогда
				
		Если СтрокаМассива.ТребуетсяПодпись Тогда
			
			Если СтрокаМассива.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий Тогда
				ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьОрганизации);
				ТребуемыеПодписи.ПредставлениеПолучателя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьКонтрагента);
				
			Иначе
				ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьКонтрагента);
				ТребуемыеПодписи.ПредставлениеПолучателя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьОрганизации);
				
			КонецЕсли;
		Иначе
			
			Если СтрокаМассива.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий Тогда
				
				ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьОрганизации);
				ТребуемыеПодписи.ПредставлениеПолучателя = НСтр("ru = 'Не требуется'");
				
			Иначе
				ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьКонтрагента);
				ТребуемыеПодписи.ПредставлениеПолучателя = НСтр("ru = 'Не требуется'");
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		Если СтрокаМассива.ТребуетсяПодпись Тогда
			
			Если ОбменСКонтрагентамиСлужебный.ЭтоФНС(СтрокаМассива.ВидЭДСсылка) Тогда
						
				Если СтрокаМассива.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий Тогда
					ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьОрганизации);
					ТребуемыеПодписи.ПредставлениеПолучателя = НСтр("ru = 'Не требуется'");
					
				Иначе
					ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьКонтрагента);
					ТребуемыеПодписи.ПредставлениеПолучателя = НСтр("ru = 'Не требуется'");
				
				КонецЕсли;
			
			Иначе
				
				Если СтрокаМассива.НаправлениеЭД = Перечисления.НаправленияЭД.Исходящий Тогда
					ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьОрганизации);
					ТребуемыеПодписи.ПредставлениеПолучателя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьКонтрагента);
					
				Иначе
					ТребуемыеПодписи.ПредставлениеОтправителя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьКонтрагента);
					ТребуемыеПодписи.ПредставлениеПолучателя = ПредставлениеЮрФизЛицо(СтрокаМассива.ПодписьОрганизации);
					
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			ТребуемыеПодписи.ПредставлениеОтправителя = НСтр("ru = 'Не требуется'");
			ТребуемыеПодписи.ПредставлениеПолучателя = НСтр("ru = 'Не требуется'");

		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеЮрФизЛицо(ЮрФизЛицо)
	
	ДанныеЮрФизЛицо = ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьДанныеЮрФизЛица(ЮрФизЛицо);
	ПредставлениеЮрФизЛицо = ЭлектронноеВзаимодействиеПереопределяемый.ОписаниеОрганизации(ДанныеЮрФизЛицо,"ПолноеНаименование,ИНН,КПП");
	
	Возврат ПредставлениеЮрФизЛицо;
	
КонецФункции

Функция СтатусПодписи(ВыборкаЭД)
	
	Если ВыборкаЭД.ПодписьВерна Тогда
		СтатусПодписи = "Верна ("+Формат(ВыборкаЭД.ДатаПроверкиПодписи,"ДЛФ=DT") + ")";
	Иначе
		СтатусПодписи = "Неверна ( "+Формат(ВыборкаЭД.ДатаПроверкиПодписи,"ДЛФ=DT") + ")";
	КонецЕсли;
	
	Возврат СтатусПодписи;
	
КонецФункции

Процедура ИнициализацияТаблицыСертификатов(ТаблицаСертификатов)
	
	ТаблицаСертификатов.Колонки.Добавить("КомуВыдан");
	ТаблицаСертификатов.Колонки.Добавить("Сертификат");
	ТаблицаСертификатов.Колонки.Добавить("Статус");
	
КонецПроцедуры

Функция ПечатнаяФормаЭД(СсылкаНаЭД, Идентификатор = Неопределено)
	
	ПараметрыПросмотра = Новый Структура;
	ПараметрыПросмотра.Вставить("ПечатьЭД", Истина);
	
	ТабДок = ОбменСКонтрагентамиВнутренний.ФайлДанныхЭД(СсылкаНаЭД, ПараметрыПросмотра);
	
	ОбъектыПечати = Новый СписокЗначений;
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДок, 1, ОбъектыПечати, СсылкаНаЭД);
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти

#КонецЕсли