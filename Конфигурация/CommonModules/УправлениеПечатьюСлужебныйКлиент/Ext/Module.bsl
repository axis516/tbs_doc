﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик подключенной команды.
//
// Параметры
//   МассивСсылок - Массив - Массив ссылок выбранных объектов, для которых выполняется команда.
//   ПараметрыВыполнения - Структура - Контекст команды.
//       * ОписаниеКоманды - Структура - Сведения о выполняемой команде.
//          ** Идентификатор - Строка - Идентификатор команды.
//          ** Представление - Строка - Представление команды в форме.
//          ** Имя - Строка - Имя команды в форме.
//       * Форма - УправляемаяФорма - Форма, из которой была вызвана команда.
//       * Источник - ДанныеФормыСтруктура, ТаблицаФормы - Объект или список формы с полем "Ссылка".
//
Процедура Подключаемый_ОбработчикКоманды(Знач МассивСсылок, Знач ПараметрыВыполнения) Экспорт
	ПараметрыВыполнения.Вставить("ОбъектыПечати", МассивСсылок);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыВыполнения.ОписаниеКоманды, ПараметрыВыполнения.ОписаниеКоманды.ДополнительныеПараметры, Истина);
	ВыполнитьПодключаемуюКомандуПечатиЗавершение(Истина, ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати.
Процедура ВыполнитьПодключаемуюКомандуПечатиПодтверждениеЗаписи(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	Источник = ДополнительныеПараметры.Источник;
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		Форма.Записать();
		Если Источник.Ссылка.Пустая() Или Форма.Модифицированность Тогда
			Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьПодключаемуюКомандуПечатиПодготовкаОбъектовПечати(ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати.
Процедура ВыполнитьПодключаемуюКомандуПечатиПодготовкаОбъектовПечати(ДополнительныеПараметры)
	
	ОбъектыПечати = ДополнительныеПараметры.Источник;
	Если ТипЗнч(ОбъектыПечати) <> Тип("Массив") Тогда
		ОбъектыПечати = ОбъектыПечати(ОбъектыПечати);
	КонецЕсли;
	
	Если ОбъектыПечати.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'")
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОписаниеКоманды.ТипыОбъектовПечати.Количество() <> 0 Тогда // требуется проверка типа
		ЕстьПечатаемыеОбъекты = Ложь;
		Для Каждого ОбъектПечати Из ОбъектыПечати Цикл
			Если ДополнительныеПараметры.ОписаниеКоманды.ТипыОбъектовПечати.Найти(ТипЗнч(ОбъектПечати)) <> Неопределено Тогда
				ЕстьПечатаемыеОбъекты = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЕстьПечатаемыеОбъекты Тогда
			ТекстСообщения = УправлениеПечатьюВызовСервера.СообщениеОПредназначенииКомандыПечати(ДополнительныеПараметры.ОписаниеКоманды.ТипыОбъектовПечати);
			ПоказатьПредупреждение(, ТекстСообщения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОписаниеКоманды.ПроверкаПроведенияПередПечатью Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПечатиПодключениеРасширенияРаботыСФайлами", ЭтотОбъект, ДополнительныеПараметры);
		УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов(ОписаниеОповещения, ОбъектыПечати, ДополнительныеПараметры.Форма);
		Возврат;
	КонецЕсли;
	
	ВыполнитьПодключаемуюКомандуПечатиПодключениеРасширенияРаботыСФайлами(ОбъектыПечати, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати.
Процедура ВыполнитьПодключаемуюКомандуПечатиПодключениеРасширенияРаботыСФайлами(ОбъектыПечати, ДополнительныеПараметры) Экспорт
	
	Если ОбъектыПечати.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	Если ДополнительныеПараметры.ОписаниеКоманды.ТребуетсяРасширениеРаботыСФайлами Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПечатиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения);
		Возврат;
	КонецЕсли;
	
	ВыполнитьПодключаемуюКомандуПечатиЗавершение(Истина, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати.
Процедура ВыполнитьПодключаемуюКомандуПечатиЗавершение(РасширениеРаботыСФайламиПодключено, ДополнительныеПараметры) Экспорт
	
	Если Не РасширениеРаботыСФайламиПодключено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКоманды = ДополнительныеПараметры.ОписаниеКоманды;
	Форма = ДополнительныеПараметры.Форма;
	ОбъектыПечати = ДополнительныеПараметры.ОбъектыПечати;
	
	ОписаниеКоманды = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ОписаниеКоманды);
	ОписаниеКоманды.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиентСервер");
		
		ИмяПоказателя = НСтр("ru = 'Печать'") + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("/%1/%2/%3/%4/%5/%6/%7",
			ОписаниеКоманды.Идентификатор,
			ОписаниеКоманды.МенеджерПечати,
			ОписаниеКоманды.Обработчик,
			Формат(ОписаниеКоманды.ОбъектыПечати.Количество(), "ЧГ=0"),
			?(ОписаниеКоманды.СразуНаПринтер, "Принтер", ""),
			ОписаниеКоманды.ФорматСохранения,
			?(ОписаниеКоманды.ФиксированныйКомплект, "Фиксированный", ""));
		
		МодульОценкаПроизводительностиКлиентСервер.НачатьЗамерВремениТехнологический(НРег(ИмяПоказателя));
	КонецЕсли;
	
	Если ОписаниеКоманды.МенеджерПечати = "СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки" 
		И ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
			МодульДополнительныеОтчетыИОбработкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДополнительныеОтчетыИОбработкиКлиент");
			МодульДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуПечати(ОписаниеКоманды, Форма);
			Возврат;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ОписаниеКоманды.Обработчик) Тогда
		ОписаниеКоманды.Вставить("Форма", Форма);
		ИмяОбработчика = ОписаниеКоманды.Обработчик;
		Если СтрЧислоВхождений(ИмяОбработчика, ".") = 0 И ЭтоОтчетИлиОбработка(ОписаниеКоманды.МенеджерПечати) Тогда
			ОсновнаяФорма = ПолучитьФорму(ОписаниеКоманды.МенеджерПечати + ".Форма", , Форма, Истина);
			ИмяОбработчика = "ОсновнаяФорма." + ИмяОбработчика;
		КонецЕсли;
		Обработчик = ИмяОбработчика + "(ОписаниеКоманды)";
		Результат = Вычислить(Обработчик);
		Возврат;
	КонецЕсли;
	
	Если ОписаниеКоманды.СразуНаПринтер Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
			ОбъектыПечати, ОписаниеКоманды.ДополнительныеПараметры);
	Иначе
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(ОписаниеКоманды.МенеджерПечати, ОписаниеКоманды.Идентификатор,
			ОбъектыПечати, Форма, ОписаниеКоманды);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов.
Процедура ПроверитьПроведенностьДокументовДиалогПроведения(Параметры) Экспорт
	
	Если УправлениеПечатьюВызовСервера.ДоступноПравоПроведения(Параметры.НепроведенныеДокументы) Тогда
		Если Параметры.НепроведенныеДокументы.Количество() = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документ, его необходимо предварительно провести. Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документы, их необходимо предварительно провести. Выполнить проведение документов и продолжить?'");
		КонецЕсли;
	Иначе
		Если Параметры.НепроведенныеДокументы.Количество() = 1 Тогда
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать документ, его необходимо предварительно провести. Недостаточно прав для проведения документа, печать невозможна.'");
		Иначе
			ТекстПредупреждения = НСтр("ru = 'Для того чтобы распечатать документы, их необходимо предварительно провести. Недостаточно прав для проведения документов, печать невозможна.'");
		КонецЕсли;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПроведенностьДокументовПроведениеДокументов", ЭтотОбъект, Параметры);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// Продолжение процедуры УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов.
Процедура ПроверитьПроведенностьДокументовПроведениеДокументов(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	РезультатПроведения = УправлениеПечатьюВызовСервера.ПровестиДокументы(ДополнительныеПараметры.НепроведенныеДокументы);
	ДанныеОНепроведенныхДокументах = РезультатПроведения.Непроведенные;
	ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2'");
	НепроведенныеДокументы = Новый Массив;
	Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(ИнформацияОДокументе.Ссылка), ИнформацияОДокументе.ОписаниеОшибки),
			ИнформацияОДокументе.Ссылка);
		НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
	КонецЦикла;
	ДополнительныеПараметры.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
	
	ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДополнительныеПараметры.СписокДокументов, НепроведенныеДокументы);
	ДополнительныеПараметры.Вставить("ПроведенныеДокументы", ПроведенныеДокументы);
	
	// Оповещаем открытые формы о том, что были проведены документы.
	СтандартныеПодсистемыКлиент.ОповеститьФормыОбИзменении(РезультатПроведения.ДанныеДляОповещения);
	
	// Если команда была вызвана из формы, то зачитываем в форму актуальную (проведенную) копию из базы.
	Если ТипЗнч(ДополнительныеПараметры.Форма) = Тип("УправляемаяФорма") Тогда
		Попытка
			ДополнительныеПараметры.Форма.Прочитать();
		Исключение
			// Если метода Прочитать нет, значит печать выполнена не из формы объекта.
		КонецПопытки;
	КонецЕсли;
		
	Если НепроведенныеДокументы.Количество() > 0 Тогда
		// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов.
		ТекстДиалога = НСтр("ru = 'Не удалось провести один или несколько документов.'");
		
		КнопкиДиалога = Новый СписокЗначений;
		Если ПроведенныеДокументы.Количество() > 0 Тогда
			ТекстДиалога = ТекстДиалога + " " + НСтр("ru = 'Продолжить?'");
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
		Иначе
			КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПроведенностьДокументовЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстДиалога, КнопкиДиалога);
		Возврат;
	КонецЕсли;
	
	ПроверитьПроведенностьДокументовЗавершение(Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

// Продолжение процедуры УправлениеПечатьюКлиент.ПроверитьПроведенностьДокументов.
Процедура ПроверитьПроведенностьДокументовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> Неопределено И РезультатВопроса <> КодВозвратаДиалога.Пропустить Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеПроцедурыЗавершения, ДополнительныеПараметры.ПроведенныеДокументы);
	
КонецПроцедуры

// Возвращает ссылки на объекты, выбранные в данный момент на форме.
Функция ОбъектыПечати(Источник)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ВыделенныеСтроки = Источник.ВыделенныеСтроки;
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущаяСтрока <> Неопределено Тогда
				Результат.Добавить(ТекущаяСтрока.Ссылка);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Результат.Добавить(Источник.Ссылка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет что менеджер печати является отчетом или обработкой.
Функция ЭтоОтчетИлиОбработка(МенеджерПечати)
	Если Не ЗначениеЗаполнено(МенеджерПечати) Тогда
		Возврат Ложь;
	КонецЕсли;
	МассивПодстрок = СтрРазделить(МенеджерПечати, ".");
	Если МассивПодстрок.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	Вид = ВРег(СокрЛП(МассивПодстрок[0]));
	Возврат Вид = "ОТЧЕТ" Или Вид = "ОБРАБОТКА";
КонецФункции

// Проверяет наличие установленного расширения работы с файлами в веб-клиенте и предлагает установку в случае
// отсутствия.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - описание процедуры, вызов которой будет произведен после проверки.
//                                            Процедура должна содержать следующие параметры:
//                                             Результат - (не используется);
//                                             ДополнительныеПараметры - (не используется).
//
Процедура ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения)
	#Если ВебКлиент Тогда
		ТекстСообщения = НСтр("ru = 'Для продолжения печати необходимо установить расширение для веб-клиента 1С:Предприятие.'");
		ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОписаниеОповещения, ТекстСообщения, Ложь);
		Возврат;
	#КонецЕсли
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
КонецПроцедуры

#КонецОбласти
