﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Отбор показателей процессов.
//
// Возвращаемое значение:
//  Структура - Структура отбора показателей процессов.
//   * Автор - СправочникСсылка.Пользователи - Отбор по автору.
//   * ВключаяПомеченныеНаУдаление - Булево - Включать помеченные на удаление элементы в результат.
//
Функция ОтборПоказателейПроцессов() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Автор");
	Отбор.Вставить("ВключаяПомеченныеНаУдаление", Ложь);
	
	Возврат Отбор;
	
КонецФункции

// Формирует показатели процессов по заданному отбору.
//
// Параметры:
//  Отбор - Структура - Отбор показателей процессов. См. Справочники.ПоказателиПроцессов.ОтборПоказателейПроцессов().
//
// Возвращаемое значение:
//  ТаблицаЗначений - Показатели процессов по отбору.
//
Функция ПолучитьПоказателиПроцессов(Отбор) Экспорт
	
	Запрос = Новый Запрос;
	
	// Схема запроса
	ТекстЗапроса = Новый Массив;
	ТекстЗапроса.Добавить(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПоказателиПроцессов.Ссылка
		|ИЗ
		|	Справочник.ПоказателиПроцессов КАК ПоказателиПроцессов");
	
	ЕстьУсловия = Ложь;
	Если Отбор.Автор <> Неопределено Тогда
		Запрос.УстановитьПараметр("Автор", Отбор.Автор);
		ТекстЗапроса.Добавить(
			СтрШаблон(
				"%1ПоказателиПроцессов.Автор = &Автор",
				?(ЕстьУсловия,
					"	И",
					"ГДЕ
					| ")));
		ЕстьУсловия = Истина;
	КонецЕсли;
	
	Если Не Отбор.ВключаяПомеченныеНаУдаление Тогда
		ТекстЗапроса.Добавить(
			СтрШаблон(
				"%1ПоказателиПроцессов.ПометкаУдаления = ЛОЖЬ",
				?(ЕстьУсловия,
					"	И",
					"ГДЕ
					| ")));
		ЕстьУсловия = Истина;
	КонецЕсли;
	
	Запрос.Текст = СтрСоединить(ТекстЗапроса, Символы.ПС);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Формирует вариант отбора показателя.
// 
// Возвращаемое значение:
//  Структура - Вариант отбор для расчета показателя процессов.
//   * ТипПредмета - ПеречислениеСсылка.ТипыПредметовПоказателейПроцессов - Отбор по типу предмета.
//   * ВидПредмета - СправочникСсылка.ВидыМероприятий,
//                   СправочникСсылка.ВидыВнутреннихДокументов,
//                   СправочникСсылка.ВидыВходящихДокументов,
//                   СправочникСсылка.ВидыИсходящихДокументов - Отбор по виду предмета.
//   * ТипПроцесса - ПеречислениеСсылка.ТипыПроцессовПоказателейПроцессов - Отбор по типу процесса.
//   * Шаблон - СправочникСсылка.ШаблоныУтверждения, СправочникСсылка.ШаблоныОзнакомления,
//              СправочникСсылка.ШаблоныСоставныхБизнесПроцессов, СправочникСсылка.ШаблоныРассмотрения,
//              СправочникСсылка.ШаблоныСогласования, СправочникСсылка.ШаблоныПоручения,
//              СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов, СправочникСсылка.ШаблоныПриглашения,
//              СправочникСсылка.ШаблоныИсполнения, СправочникСсылка.ШаблоныРегистрации - Отбор по шаблону процесса.
//   * Проект - СправочникСсылка.Проекты - Отбор по проекту.
//   * Ответственный - СправочникСсылка.РолиИсполнителей, СправочникСсылка.РабочиеГруппы, Строка, СправочникСсылка.Пользователи - Отбор по ответсвенному.
//   * ЭтапОбработкиПредмета - ПеречислениеСсылка.ЭтапыОбработкиПредметовПоказателейПроцессов - Отбор по этапу обработки.
//
Функция ВариантОтбора() Экспорт
	
	ВариантОтбора = Новый Структура("ТипПредмета, ВидПредмета, ТипПроцесса, Шаблон, Проект,
		|Ответственный, ЭтапОбработкиПредмета");
	ВариантОтбора.ТипПредмета = Перечисления.ТипыПредметовПоказателейПроцессов.ПустаяСсылка();
	ВариантОтбора.ТипПроцесса = Перечисления.ТипыПроцессовПоказателейПроцессов.ПустаяСсылка();
	ВариантОтбора.Проект = Справочники.Проекты.ПустаяСсылка();
	ВариантОтбора.ЭтапОбработкиПредмета =
		Перечисления.ЭтапыОбработкиПредметовПоказателейПроцессов.ПустаяСсылка();
	
	Возврат ВариантОтбора;
	
КонецФункции

// Формирует структуру вариант расчета показателя.
// 
// Возвращаемое значение:
//  Структура - Вариант расчет показателя. 
//   * СпособРасчета - ПеречислениеСсылка.СпособыРасчетаАгрегатныхПоказателейПроцессов - Способ расчета показателя.
//   * ДанныеДляРасчета - ПеречислениеСсылка.ДанныеДляРасчетаПоказателейПроцессов - Данные для расчета показателя.
//
Функция ВариантРасчета() Экспорт
	
	ВариантРасчета = Новый Структура("СпособРасчета, ДанныеДляРасчета");
	ВариантРасчета.СпособРасчета =
		Перечисления.СпособыРасчетаПоказателейПроцессов.ПустаяСсылка();
	ВариантРасчета.ДанныеДляРасчета =
		Перечисления.ДанныеДляРасчетаПоказателейПроцессов.ПустаяСсылка();
	
	Возврат ВариантРасчета;
	
КонецФункции

// Формирует структуру настроек отбора показателя.
//
// Возвращаемое значение:
//  Структура - Настройки отбора показателя.
//   * ПериодРасчета - ПеречислениеСсылка.ПериодыРасчетаПоказателейПроцессов - Период расчета.
//   * ДниПериодаРасчета - Число - Количество дней в периоде расчета ПоДням.
//   * НачалоПериодаРасчета - Дата - Начало периода расчета Произвольный.
//   * ОкончаниеПериодаРасчета - Дата - Окончание периода расчета Произвольный.
//   * НаборВариантовОтбора - Массив - Настройки вариантов отбора.
//
Функция НастройкиОтбора() Экспорт
	
	НастройкиОтбора = Новый Структура("НаборВариантовОтбора, ПериодРасчета,
		|НачалоПериодаРасчета, ОкончаниеПериодаРасчета, ДниПериодаРасчета");
	НастройкиОтбора.ПериодРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПустаяСсылка();
	НастройкиОтбора.ДниПериодаРасчета = 0;
	НастройкиОтбора.НачалоПериодаРасчета = Дата(1, 1, 1);
	НастройкиОтбора.ОкончаниеПериодаРасчета = Дата(1, 1, 1);
	НастройкиОтбора.НаборВариантовОтбора = Новый Массив;
	
	Возврат НастройкиОтбора;
	
КонецФункции

// Рассчитывает хеши показателя.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//  НастройкиОтбора - Структура - Настройки отбора показателя. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//
// Возвращаемое значение:
//  Структура - Хеши показателя.
//   * ХешНастроекОтбора - Хеш настроек отбора показателя.
//   * ХешПоказателя - Хеш показателя.
//
Функция ХешиПоказателя(ВариантРасчета, НастройкиОтбора) Экспорт
	
	ХешиПоказателя = Новый Структура("ХешНастроекОтбора, ХешПоказателя");
	
	ХешВариантаРасчета = ХешВариантаРасчета(ВариантРасчета);
	ХешиПоказателя.ХешНастроекОтбора = ХешНастроекОтбора(НастройкиОтбора);
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ХешВариантаРасчета + ХешиПоказателя.ХешНастроекОтбора);
	ХешиПоказателя.ХешПоказателя = СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
	Возврат ХешиПоказателя;
	
КонецФункции

// Создает автоматический показатель.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//  НастройкиОтбора - Структура - Настройки отбора показателя. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//
// Возвращаемое значение:
//  СправочникСсылка.ПоказателиПроцессов - Ссылка на созданный показатель.
//
Функция ДобавитьАвтоматическийПоказатель(ВариантРасчета, НастройкиОтбора) Экспорт
	
	ДанныеЗаполнения = Новый Структура("ВариантРасчета, НастройкиОтбора, СозданАвтоматически");
	ДанныеЗаполнения.ВариантРасчета = ВариантРасчета;
	ДанныеЗаполнения.НастройкиОтбора = НастройкиОтбора;
	ДанныеЗаполнения.СозданАвтоматически = Истина;
	
	ПоказательПроцесса = Справочники.ПоказателиПроцессов.СоздатьЭлемент();
	ПоказательПроцесса.Заполнить(ДанныеЗаполнения);
	ПоказательПроцесса.Записать();
	
	Возврат ПоказательПроцесса.Ссылка;
	
КонецФункции

// Создает библиотечный показатель.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//  НаборВариантовОтбора - Массив - Набор вариант отбора показателя.
//
// Возвращаемое значение:
//  СправочникСсылка.ПоказателиПроцессов - Ссылка на созданный показатель.
//
Функция ДобавитьБиблиотечныйПоказатель(ВариантРасчета, НаборВариантовОтбора) Экспорт
	
	ДанныеЗаполнения = Новый Структура("ВариантРасчета, НаборВариантовОтбора");
	ДанныеЗаполнения.ВариантРасчета = ВариантРасчета;
	ДанныеЗаполнения.НаборВариантовОтбора = НаборВариантовОтбора;
	
	ПоказательПроцесса = Справочники.ПоказателиПроцессов.СоздатьЭлемент();
	ПоказательПроцесса.Заполнить(ДанныеЗаполнения);
	ПоказательПроцесса.Записать();
	
	Возврат ПоказательПроцесса.Ссылка;
	
КонецФункции

// Формирует список способов расчета библиотечных показателей.
//
// Возвращаемое значение:
//  Массив - Способы расчета библиотечных показателей.
//
Функция ВариантыРасчетаБиблиотечныхПоказателей() Экспорт
	
	ВариантыРасчета = Новый Массив;
	
	Для Каждого БиблиотечныйПоказатель Из ДанныеБиблиотечныхПоказателей() Цикл
		ВариантРасчета = ВариантРасчета();
		ЗаполнитьЗначенияСвойств(ВариантРасчета, БиблиотечныйПоказатель);
		ВариантыРасчета.Добавить(ВариантРасчета);
	КонецЦикла;
	
	Возврат ВариантыРасчета;
	
КонецФункции

// Формирует список библиотечных показателей.
//
// Возвращаемое значение:
//  Массив - Библиотечные показатели.
//
Функция БиблиотечныеПоказатели() Экспорт
	
	БиблиотечныеПоказатели = Новый Массив;
	
	ДанныеБиблиотечныхПоказателей = ДанныеБиблиотечныхПоказателей();
	
	ПараметрыОтбора = Новый Структура("АвтоматическийПоказатель", Истина);
	НайденныеСтроки = ДанныеБиблиотечныхПоказателей.НайтиСтроки(ПараметрыОтбора);
	Для Каждого СтрокаБиблиотечногоПоказателя Из НайденныеСтроки Цикл
		
		Для Каждого Период Из СтрокаБиблиотечногоПоказателя.ПериодыАвтоматическогоПоказателя Цикл
			
			БиблиотечныйПоказатель =
				Новый Структура("ВариантРасчета, ПериодРасчета, ТипыПроцессовИсключения");
			
			БиблиотечныйПоказатель.ВариантРасчета = ВариантРасчета();
			ЗаполнитьЗначенияСвойств(БиблиотечныйПоказатель.ВариантРасчета, СтрокаБиблиотечногоПоказателя);
			ЗаполнитьЗначенияСвойств(БиблиотечныйПоказатель, СтрокаБиблиотечногоПоказателя);
			БиблиотечныйПоказатель.ПериодРасчета = Период;
			
			БиблиотечныеПоказатели.Добавить(БиблиотечныйПоказатель);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат БиблиотечныеПоказатели;
	
КонецФункции

// Возвращает доступные настройки отбора процессов библиотечных показателей по основанию.
//
// Параметры:
//  Основание - СправочникСсылка.* - Основание показателя.
//
// Возвращаемое значение:
//  Массив - Типы библиотечных процессов по основанию.
//
Функция ВариантыОтбораБиблиотечныхПоказателей(Основание) Экспорт
	
	ВариантыОтбора = Новый Массив;
	ТабличныйДокумент = ПолучитьМакет("ВариантыОтбораБиблиотечныхПоказателей");
	НомерСтроки = 2;
	ТипОснования = ТипЗнч(Основание);
	ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
	Пока ЗначениеЗаполнено(ИмяТипаОснования) Цикл
		
		ЯвляетсяШаблоном = Булево(ТабличныйДокумент.Область(НомерСтроки, 2).Текст);
		ИмяТипШаблона = ТабличныйДокумент.Область(НомерСтроки, 3).Текст;
		ИмяТипПроцесса = ТабличныйДокумент.Область(НомерСтроки, 4).Текст;
		ИмяЭтапОбработкиПредмета = ТабличныйДокумент.Область(НомерСтроки, 5).Текст;
		ИмяФункциональнойОпции = ТабличныйДокумент.Область(НомерСтроки, 6).Текст;
		
		Если ЗначениеЗаполнено(ИмяФункциональнойОпции) Тогда
			Если Не ПолучитьФункциональнуюОпцию(ИмяФункциональнойОпции) Тогда
				НомерСтроки = НомерСтроки + 1;
				ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипОснования <> Тип(ИмяТипаОснования) Тогда
			НомерСтроки = НомерСтроки + 1;
			ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИмяТипШаблона) Тогда
			ТипШаблона = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ТипШаблона");
			Если ТипШаблона <> ИмяТипШаблона Тогда
				НомерСтроки = НомерСтроки + 1;
				ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ВариантОтбора = ВариантОтбора();
		ВариантОтбора.ТипПроцесса = Перечисления.ТипыПроцессовПоказателейПроцессов[ИмяТипПроцесса];
		Если ЯвляетсяШаблоном Тогда
			ВариантОтбора.Шаблон = Основание;
		КонецЕсли;
		Если ЗначениеЗаполнено(ИмяЭтапОбработкиПредмета) Тогда
			ВариантОтбора.ЭтапОбработкиПредмета =
				Перечисления.ЭтапыОбработкиПредметовПоказателейПроцессов[ИмяЭтапОбработкиПредмета];
		КонецЕсли;
		ВариантыОтбора.Добавить(ВариантОтбора);
		
		НомерСтроки = НомерСтроки + 1;
		ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
		
	КонецЦикла;
	
	Возврат ВариантыОтбора;
	
КонецФункции

// Возвращает массив типов оснований библиотечных показателей.
//
// Возвращаемое значение:
//  Массив - Типы оснований библиотечных показателей.
//
Функция ТипыОснованияБиблиотечныхПоказателей() Экспорт
	
	ТипыОснования = Новый Массив;
	ТабличныйДокумент = ПолучитьМакет("ВариантыОтбораБиблиотечныхПоказателей");
	НомерСтроки = 2;
	ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
	Пока ЗначениеЗаполнено(ИмяТипаОснования) Цикл
		
		ИмяФункциональнойОпции = ТабличныйДокумент.Область(НомерСтроки, 6).Текст;
		Если ЗначениеЗаполнено(ИмяФункциональнойОпции) Тогда
			Если Не ПолучитьФункциональнуюОпцию(ИмяФункциональнойОпции) Тогда
				НомерСтроки = НомерСтроки + 1;
				ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ТипОснования = Тип(ИмяТипаОснования);
		Если ТипыОснования.Найти(ТипОснования) = Неопределено Тогда
			ТипыОснования.Добавить(ТипОснования);
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		ИмяТипаОснования = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
		
	КонецЦикла;
	
	Возврат ТипыОснования;
	
КонецФункции

// Возвращает представление варианта расчета.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//
// Возвращаемое значение:
//  Строка - Представление варианта расчета.
//
Функция ПредставлениеВариантаРасчета(ВариантРасчета) Экспорт
	
	ПредставлениеВариантаРасчета = "";
	
	ДанныеБиблиотечногоПоказателя = ДанныеБиблиотечногоПоказателя(ВариантРасчета);
	Если ДанныеБиблиотечногоПоказателя <> Неопределено Тогда
		ПредставлениеВариантаРасчета = ДанныеБиблиотечногоПоказателя.Представление;
	КонецЕсли;
	
	Возврат ПредставлениеВариантаРасчета;
	
КонецФункции

// Возвращает тип значения варианта расчета.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыЗначенийВариантовРасчета - Тип значения варианта расчета.
//
Функция ТипЗначенияВариантаРасчета(ВариантРасчета) Экспорт
	
	ТипЗначенияВариантаРасчета = Перечисления.ТипыЗначенийПоказателейПроцессов.ПустаяСсылка();
	
	ДанныеБиблиотечногоПоказателя = ДанныеБиблиотечногоПоказателя(ВариантРасчета);
	Если ДанныеБиблиотечногоПоказателя <> Неопределено Тогда
		ТипЗначенияВариантаРасчета = ДанныеБиблиотечногоПоказателя.ТипЗначения;
	КонецЕсли;
	
	Возврат ТипЗначенияВариантаРасчета;
	
КонецФункции

// Возвращает период по умолчанию варианта расчета.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ПериодыРасчетаПоказателейПроцессов - Период расчета по умолчанию.
//
Функция ПериодПоУмолчаниюВариантаРасчета(ВариантРасчета) Экспорт
	
	ТипЗначенияВариантаРасчета = Перечисления.ПериодыРасчетаПоказателейПроцессов.ПустаяСсылка();
	
	ДанныеБиблиотечногоПоказателя = ДанныеБиблиотечногоПоказателя(ВариантРасчета);
	Если ДанныеБиблиотечногоПоказателя <> Неопределено Тогда
		ТипЗначенияВариантаРасчета = ДанныеБиблиотечногоПоказателя.ПериодПоУмолчанию;
	КонецЕсли;
	
	Возврат ТипЗначенияВариантаРасчета;
	
КонецФункции

// Возвращает Типы процессов исключения варианта расчета.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//
// Возвращаемое значение:
//  Массив - Типы процессов исключения.
//
Функция ТипыПроцессовИсключенияВариантаРасчета(ВариантРасчета) Экспорт
	
	ТипыПроцессовИсключения = Новый Массив;
	
	ДанныеБиблиотечногоПоказателя = ДанныеБиблиотечногоПоказателя(ВариантРасчета);
	Если ДанныеБиблиотечногоПоказателя <> Неопределено Тогда
		ТипыПроцессовИсключения = ДанныеБиблиотечногоПоказателя.ТипыПроцессовИсключения;
	КонецЕсли;
	
	Возврат ТипыПроцессовИсключения;
	
КонецФункции

// Возвращает представление периода расчета.
//
// Параметры:
//  НастройкиОтбора - Структура - Настройки отбора показателя. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//
// Возвращаемое значение:
//  Строка - Представление варианта расчета.
//
Функция ПредставлениеПериодаРасчета(НастройкиОтбора) Экспорт
	
	ПредставлениеПериодаРасчета = "";
	
	Если НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.День Тогда
		ПредставлениеПериодаРасчета = НСтр("ru = 'за день'");
		
	ИначеЕсли НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Неделя Тогда
		ПредставлениеПериодаРасчета = НСтр("ru = 'за неделю'");
		
	ИначеЕсли НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Месяц Тогда
		ПредставлениеПериодаРасчета = НСтр("ru = 'за месяц'");
		
	ИначеЕсли НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Квартал Тогда
		ПредставлениеПериодаРасчета = НСтр("ru = 'за квартал'");
		
	ИначеЕсли НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Год Тогда
		ПредставлениеПериодаРасчета = НСтр("ru = 'за год'");
		
	ИначеЕсли НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		ПодписьДней = ДелопроизводствоКлиентСервер.ПолучитьПодписьДней(НастройкиОтбора.ДниПериодаРасчета);
		ПредставлениеПериодаРасчета = СтрШаблон(НСтр("ru = 'за %1 %2'"),
			НастройкиОтбора.ДниПериодаРасчета,
			ПодписьДней);
		
	ИначеЕсли НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ПредставлениеПериодаРасчета = СтрШаблон(НСтр("ru = 'за период с %1 по %2'"),
			Формат(НастройкиОтбора.НачалоПериодаРасчета, "ДЛФ=D"),
			Формат(НастройкиОтбора.ОкончаниеПериодаРасчета, "ДЛФ=D"));
		
	КонецЕсли;
	
	Возврат ПредставлениеПериодаРасчета;
	
КонецФункции

// Формирует представление набора вариантов отбора показателя.
//
// Параметры:
//  НаборВариантовОтбора - Массив - Набор вариантов отбора показателя.
//
// Возвращаемое значение:
//  Строка - Представление набора вариантов отбоар показателя.
//
Функция ПредставлениеНабораВариантовОтбора(НаборВариантовОтбора) Экспорт
	
	ПредставлениеНабораВариантовОтбора = "";
	
	Если НаборВариантовОтбора.Количество() <> 1 Тогда
		Возврат ПредставлениеНабораВариантовОтбора;
	КонецЕсли;
	
	ИтоговоеПредставление = Новый Массив;
	
	// По отбору процессов варианта отбора.
	ВариантОтбора = НаборВариантовОтбора[0];
	ПредставлениеВариантаОтбораПроцесса = "";
	Если ЗначениеЗаполнено(ВариантОтбора.Шаблон) Тогда
		ПредставлениеВариантаОтбораПроцесса =
			СтрШаблон(НСтр("ru = 'По шаблону ""%1""'"), ВариантОтбора.Шаблон);
	ИначеЕсли ЗначениеЗаполнено(ВариантОтбора.ЭтапОбработкиПредмета) Тогда
		ПредставлениеВариантаОтбораПроцесса =
			СтрШаблон(НСтр("ru = 'По этапу ""%1""'"), ВариантОтбора.ЭтапОбработкиПредмета);
	ИначеЕсли ЗначениеЗаполнено(ВариантОтбора.ТипПроцесса) Тогда
		ПредставлениеВариантаОтбораПроцесса =
			СтрШаблон(НСтр("ru = 'По процессу ""%1""'"), ВариантОтбора.ТипПроцесса);
	КонецЕсли;
	ИтоговоеПредставление.Добавить(ПредставлениеВариантаОтбораПроцесса);
	
	// По основному отбора варианта отбора.
	ПредставлениеОсновногоВариантаОтбора = "";
	Если ЗначениеЗаполнено(ВариантОтбора.ВидПредмета) Тогда
		ТипВидаПредмета = ТипЗнч(ВариантОтбора.ВидПредмета);
		Если ТипВидаПредмета = Тип("СправочникСсылка.ВидыВходящихДокументов")
			Или ТипВидаПредмета = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
			Или ТипВидаПредмета = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
			ПредставлениеОсновногоВариантаОтбора = СтрШаблон(НСтр("ru = 'по виду документа ""%1""'"),
				ВариантОтбора.ВидПредмета);
		ИначеЕсли ТипВидаПредмета = Тип("СправочникСсылка.ВидыМероприятий") Тогда
			ПредставлениеОсновногоВариантаОтбора = СтрШаблон(НСтр("ru = 'по виду мероприятия ""%1""'"),
				ВариантОтбора.ВидПредмета);
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ВариантОтбора.Проект) Тогда
		ПредставлениеОсновногоВариантаОтбора = СтрШаблон(НСтр("ru = 'по проекту ""%1""'"),
			ВариантОтбора.Проект);
	ИначеЕсли ЗначениеЗаполнено(ВариантОтбора.Ответственный) Тогда
		ПредставлениеОсновногоВариантаОтбора = СтрШаблон(НСтр("ru = 'по ответственному ""%1""'"),
			ВариантОтбора.Ответственный);
	КонецЕсли;
	ИтоговоеПредставление.Добавить(ПредставлениеОсновногоВариантаОтбора);
	
	ПредставлениеНабораВариантовОтбора = СтрСоединить(ИтоговоеПредставление, " ");
	
	Возврат ПредставлениеНабораВариантовОтбора;
	
КонецФункции

// Формирует представление показателя по варианту расчета и набору вариантов отбора.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//  НастройкиОтбора - Структура - Настройки отбора показателя. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//
// Возвращаемое значение:
//  Строка - Текстовое описание содержания возвращаемого значения функции.
//
Функция ПредставлениеПоказателя(ВариантРасчета, НастройкиОтбора) Экспорт
	
	ПредставлениеПоказателя = "";
	
	Если Не ЗначениеЗаполнено(ВариантРасчета.СпособРасчета)
		Или Не ЗначениеЗаполнено(ВариантРасчета.ДанныеДляРасчета)
		Или НастройкиОтбора.НаборВариантовОтбора.Количество() <> 1 Тогда
		Возврат ПредставлениеПоказателя;
	КонецЕсли;
	
	ИтоговоеПредставление = Новый Массив;
	
	// По варианту расчета.
	ПредставлениеВариантаРасчета = ПредставлениеВариантаРасчета(ВариантРасчета);
	Если Не ЗначениеЗаполнено(ПредставлениеВариантаРасчета) Тогда
		Возврат ПредставлениеПоказателя;
	КонецЕсли;
	ИтоговоеПредставление.Добавить(ПредставлениеВариантаРасчета);
	
	// По периоду
	ПредставлениеПериодаРасчета = ПредставлениеПериодаРасчета(НастройкиОтбора);
	Если ЗначениеЗаполнено(ПредставлениеПериодаРасчета) Тогда
		ИтоговоеПредставление.Добавить(ПредставлениеПериодаРасчета);
	КонецЕсли;
	
	// По варианту отбора.
	ПредставлениеНабораВариантовОтбора =
		ПредставлениеНабораВариантовОтбора(НастройкиОтбора.НаборВариантовОтбора);
	Если Не ЗначениеЗаполнено(ПредставлениеНабораВариантовОтбора) Тогда
		Возврат ПредставлениеПоказателя;
	КонецЕсли;
	ПервыйСимвол = Сред(ПредставлениеНабораВариантовОтбора, 1, 1);
	Если ПервыйСимвол <> НРег(ПервыйСимвол) Тогда
		ПредставлениеНабораВариантовОтбора =
			НРег(ПервыйСимвол) + Сред(ПредставлениеНабораВариантовОтбора, 2);
	КонецЕсли;
	ИтоговоеПредставление.Добавить(ПредставлениеНабораВариантовОтбора);
	
	ПредставлениеПоказателя = СтрСоединить(ИтоговоеПредставление, " ");
	
	Возврат ПредставлениеПоказателя;
	
КонецФункции

// Формирует наборы вариантов отбора для библиотеных показателей по основанию.
//
// Параметры:
//  Основание - СправочникСсылка.* - Основание библиотечного показателя.
//
// Возвращаемое значение:
//  Массив - Варианты отбора показателя по основанию.
//
Функция НаборыВариантовОтбораБиблиотечныхПоказателей(Основание) Экспорт
	
	НаборыВариантовОтбора = Новый Массив;
	
	ОсновнойОтбор = ВариантОтбора();
	Если ЭтоВидПредмета(Основание) Тогда
		ОсновнойОтбор.ВидПредмета = Основание;
		ОсновнойОтбор.ТипПредмета = ТипПредметаПоВидуПредмета(Основание);
	ИначеЕсли ТипЗнч(Основание) = Тип("СправочникСсылка.Проекты") Тогда
		ОсновнойОтбор.Проект = Основание;
	ИначеЕсли ТипЗнч(Основание) = Тип("СправочникСсылка.СтруктураПредприятия") Тогда
		ОсновнойОтбор.Ответственный = Основание;
	КонецЕсли;
	
	ОтборыПроцессов = ВариантыОтбораБиблиотечныхПоказателей(Основание);
	Для Каждого ОтборПроцесса Из ОтборыПроцессов Цикл
		НаборВариантовОтбора = Новый Массив;
		ВариантОтбора = ВариантОтбора();
		ЗаполнитьЗначенияСвойств(
			ВариантОтбора,
			ОсновнойОтбор,
			"ВидПредмета, ТипПредмета, Проект, Ответственный");
		ЗаполнитьЗначенияСвойств(
			ВариантОтбора,
			ОтборПроцесса,
			"Шаблон, ТипПроцесса, ЭтапОбработкиПредмета");
		НаборВариантовОтбора.Добавить(ВариантОтбора);
		НаборыВариантовОтбора.Добавить(НаборВариантовОтбора);
	КонецЦикла;
	
	Возврат НаборыВариантовОтбора;
	
КонецФункции

// Определяет состав библиотечных показателей.
//
// Параметры:
//  Основания - Массив - Основания для подготовки состав показателей.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Состав библиотечных показателей.
//   * ВариантРасчета - Структура - Вариант расчета показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//   * НаборВариантовОтбора - Массив - Набор вариантов отбора показателя.
//   * ХешПоказателя - Строка - Хеш показателя.
//
Функция СоставБиблиотечныхПоказателей(Основания) Экспорт
	
	СоставПоказателей = Новый ТаблицаЗначений;
	СоставПоказателей.Колонки.Добавить("ВариантРасчета");
	СоставПоказателей.Колонки.Добавить("НастройкиОтбора");
	СоставПоказателей.Колонки.Добавить("ХешПоказателя");
	
	БиблиотечныеПоказатели = БиблиотечныеПоказатели();
	
	Для Каждого Основание Из Основания Цикл
		
		НаборыВариантовОтбора = НаборыВариантовОтбораБиблиотечныхПоказателей(Основание);
		Для Каждого БиблиотечныйПоказатель Из БиблиотечныеПоказатели Цикл
			
			Для Каждого НаборВариантовОтбора Из НаборыВариантовОтбора Цикл
				
				ЕстьНеподходящийТипПроцесса = Ложь;
				Для Каждого ВариантОтбора Из НаборВариантовОтбора Цикл
					Если БиблиотечныйПоказатель.ТипыПроцессовИсключения.Найти(ВариантОтбора.ТипПроцесса) <> Неопределено Тогда
						ЕстьНеподходящийТипПроцесса = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если ЕстьНеподходящийТипПроцесса Тогда
					Продолжить;
				КонецЕсли;
				
				НастройкиОтбора = НастройкиОтбора();
				НастройкиОтбора.ПериодРасчета = БиблиотечныйПоказатель.ПериодРасчета;
				НастройкиОтбора.ДниПериодаРасчета = 
					Метаданные.Справочники.ПоказателиПроцессов.Реквизиты.ДниПериодаРасчета.ЗначениеЗаполнения;
				НастройкиОтбора.НачалоПериодаРасчета =
					Метаданные.Справочники.ПоказателиПроцессов.Реквизиты.НачалоПериодаРасчета.ЗначениеЗаполнения;
				НастройкиОтбора.ОкончаниеПериодаРасчета = 
					Метаданные.Справочники.ПоказателиПроцессов.Реквизиты.ОкончаниеПериодаРасчета.ЗначениеЗаполнения;
				
				НастройкиОтбора.НаборВариантовОтбора = НаборВариантовОтбора;
				ХешиПоказателя = ХешиПоказателя(БиблиотечныйПоказатель.ВариантРасчета, НастройкиОтбора);
				
				НовыйПоказатель = СоставПоказателей.Добавить();
				НовыйПоказатель.ВариантРасчета = БиблиотечныйПоказатель.ВариантРасчета;
				НовыйПоказатель.НастройкиОтбора = НастройкиОтбора;
				НовыйПоказатель.ХешПоказателя = ХешиПоказателя.ХешПоказателя;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СоставПоказателей;
	
КонецФункции

// Возвращает основание варианта отбора.
//
// Параметры:
//  ВариантОтбора - Структура - Вариант отбора. См. Справочники.ПоказателиПроцессов.ВариантОтбора().
//
// Возвращаемое значение:
//  СправочникСсылка.* - Основание варианта отбора.
//
Функция ОснованиеВариантОтбора(ВариантОтбора) Экспорт
	
	ЗаполненоПолей = 0;
	
	Основание = Неопределено;
	Если ЗначениеЗаполнено(ВариантОтбора.Шаблон) Тогда
		Основание = ВариантОтбора.Шаблон;
		ЗаполненоПолей = ЗаполненоПолей + 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантОтбора.ВидПредмета) Тогда
		Основание = ВариантОтбора.ВидПредмета;
		ЗаполненоПолей = ЗаполненоПолей + 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантОтбора.Проект) Тогда
		Основание = ВариантОтбора.Проект;
		ЗаполненоПолей = ЗаполненоПолей + 1;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантОтбора.Ответственный) Тогда
		Основание = ВариантОтбора.Ответственный;
		ЗаполненоПолей = ЗаполненоПолей + 1;
	КонецЕсли;
	
	Если ЗаполненоПолей <> 1 Тогда
		Основание = Неопределено;
	КонецЕсли;
	
	Возврат Основание;
	
КонецФункции

// Рассчитывает хеш варианта расчета.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//
// Возвращаемое значение:
//  Строка - Хеш варианта расчета.
//
Функция ХешВариантаРасчета(ВариантРасчета) Экспорт
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешСтрока = Новый Массив;
	ХешСтрока.Добавить("1");
	ХешСтрока.Добавить(ВариантРасчета.СпособРасчета);
	ХешСтрока.Добавить("2");
	ХешСтрока.Добавить(ВариантРасчета.ДанныеДляРасчета);
	ХешированиеДанных.Добавить(СтрСоединить(ХешСтрока));
	
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Рассчитывает хеш варианта отбора.
//
// Параметры:
//  ВариантОтбора - Структура - Вариант отбора показателя. См. МониторингПроцессов.ВариантОтбора().
//
// Возвращаемое значение:
//  Строка - Хеш варианта отбора.
//
Функция ХешВариантаОтбора(ВариантОтбора)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешСтрока = Новый Массив;
	
	// Тип предмета
	ХешСтрока.Добавить("1");
	ХешСтрока.Добавить(ВариантОтбора.ТипПредмета);
	
	// Вид предмета
	ХешСтрока.Добавить("2");
	Если ЗначениеЗаполнено(ВариантОтбора.ВидПредмета) Тогда
		ВидПредмета = ВариантОтбора.ВидПредмета.УникальныйИдентификатор();
	Иначе
		ВидПредмета = "";
	КонецЕсли;
	ХешСтрока.Добавить(ВидПредмета);
	
	// Тип процесса
	ХешСтрока.Добавить("3");
	ХешСтрока.Добавить(ВариантОтбора.ТипПроцесса);
	
	// Шаблон
	ХешСтрока.Добавить("4");
	Если ЗначениеЗаполнено(ВариантОтбора.Шаблон) Тогда
		Шаблон = ВариантОтбора.Шаблон.УникальныйИдентификатор();
	Иначе
		Шаблон = "";
	КонецЕсли;
	ХешСтрока.Добавить(Шаблон);
	
	// Проект
	ХешСтрока.Добавить("5");
	Проект = ВариантОтбора.Проект.УникальныйИдентификатор();
	ХешСтрока.Добавить(ВариантОтбора.Проект);
	
	// Ответственный
	ХешСтрока.Добавить("6");
	Если ЗначениеЗаполнено(ВариантОтбора.Ответственный) Тогда
		Если ТипЗнч(ВариантОтбора.Ответственный) = Тип("Строка") Тогда
			Ответственный = ВариантОтбора.Ответственный;
		Иначе
			Ответственный = ВариантОтбора.Ответственный.УникальныйИдентификатор();
		КонецЕсли;
	Иначе
		Ответственный = "";
	КонецЕсли;
	ХешСтрока.Добавить(ВариантОтбора.Ответственный);
	
	// Этап обработки предмета
	ХешСтрока.Добавить("7");
	ХешСтрока.Добавить(ВариантОтбора.ЭтапОбработкиПредмета);
	
	ХешированиеДанных.Добавить(СтрСоединить(ХешСтрока));
	
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

// Рассчитывает хеш настроек отбора.
//
// Параметры:
//  НастройкиОтбора - Структура - Настройки отбора показателя. См. Справочники.ПоказателиПроцессов.НастройкиОтбора().
//
// Возвращаемое значение:
//  Строка - Хеш настро отбора.
//
Функция ХешНастроекОтбора(НастройкиОтбора)
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешСтрока = Новый Массив;
	
	// Период расчета
	ХешСтрока.Добавить("1");
	ХешСтрока.Добавить(НастройкиОтбора.ПериодРасчета);
	
	// Дни периода расчета
	ХешСтрока.Добавить("2");
	Если НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.ПоДням Тогда
		ХешСтрока.Добавить(НастройкиОтбора.ДниПериодаРасчета);
	КонецЕсли;
	
	// Начало периода расчета
	ХешСтрока.Добавить("3");
	Если НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ХешСтрока.Добавить(НастройкиОтбора.НачалоПериодаРасчета);
	КонецЕсли;
	
	// Окончание периода расчета
	ХешСтрока.Добавить("4");
	Если НастройкиОтбора.ПериодРасчета =
			Перечисления.ПериодыРасчетаПоказателейПроцессов.Произвольный Тогда
		ХешСтрока.Добавить(НастройкиОтбора.ОкончаниеПериодаРасчета);
	КонецЕсли;
	
	// Набор вариантов отбора
	ХешСтрока.Добавить("5");
	ХешНабораВариантовОтбора = ХешНабораВариантовОтбора(НастройкиОтбора.НаборВариантовОтбора);
	ХешСтрока.Добавить(ХешНабораВариантовОтбора);
	
	ХешированиеДанных.Добавить(СтрСоединить(ХешСтрока));
	
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

// Рассчитывает хеш набора вариантов отбора.
//
// Параметры:
//  НаборВариантовОтбора - Массив - Набор вариантов отбора показателя.
//
// Возвращаемое значение:
//  Строка - Хеш набора вариантов отбора.
//
Функция ХешНабораВариантовОтбора(НаборВариантовОтбора)
	
	СписокХешей = Новый СписокЗначений;
	
	Для Каждого ВариантОтбора Из НаборВариантовОтбора Цикл
		СписокХешей.Добавить(ХешВариантаОтбора(ВариантОтбора));
	КонецЦикла;
	СписокХешей.СортироватьПоЗначению();
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(СтрСоединить(СписокХешей.ВыгрузитьЗначения()));
	
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	
КонецФункции

// Возвращает тип предмета по ссылке на вид предмета.
//
// Параметры:
//  Шаблон - СправочникСсылка - Ссылка на шаблон.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТипыПредметовПоказателейПроцессов - Тип предмета.
//
Функция ТипПредметаПоВидуПредмета(ВидПредмета)
	
	ТипПредмета = Перечисления.ТипыПредметовПоказателейПроцессов.ПустаяСсылка();
	
	ТипВидаПредмета = ТипЗнч(ВидПредмета);
	Если ТипВидаПредмета = Тип("СправочникСсылка.ВидыВнутреннихДокументов") Тогда
		ТипПредмета = Перечисления.ТипыПредметовПоказателейПроцессов.ВнутренниеДокументы;
	ИначеЕсли ТипВидаПредмета = Тип("СправочникСсылка.ВидыВходящихДокументов") Тогда
		ТипПредмета = Перечисления.ТипыПредметовПоказателейПроцессов.ВходящиеДокументы;
	ИначеЕсли ТипВидаПредмета = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		ТипПредмета = Перечисления.ТипыПредметовПоказателейПроцессов.ИсходящиеДокументы;
	ИначеЕсли ТипВидаПредмета = Тип("СправочникСсылка.ВидыМероприятий") Тогда
		ТипПредмета = Перечисления.ТипыПредметовПоказателейПроцессов.Мероприятия;
	КонецЕсли;
	
	Возврат ТипПредмета;
	
КонецФункции

// Проверяет, является ли переданное занчение ссылкой на вид предмета.
//
// Параметры:
//  Значение - СправочникСсылка.* - Проверяемое значение.
//
// Возвращаемое значение:
//  Булево - Значение является ссылкой на вид предмета.
//
Функция ЭтоВидПредмета(Значение)
	
	ТипЗначения = ТипЗнч(Значение);
	Возврат ТипЗначения = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗначения = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗначения = Тип("СправочникСсылка.ВидыИсходящихДокументов")
		Или ТипЗначения = Тип("СправочникСсылка.ВидыМероприятий");
	
КонецФункции

// Формирует данные библиотечных показателей из макета ДанныеБиблиотечныхПоказателей.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Данные библиотечных показателей.
//
Функция ДанныеБиблиотечныхПоказателей()
	
	ДанныеБиблиотечныхПоказателей = Новый ТаблицаЗначений;
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("СпособРасчета",
		Новый ОписаниеТипов("ПеречислениеСсылка.СпособыРасчетаПоказателейПроцессов"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("ДанныеДляРасчета",
		Новый ОписаниеТипов("ПеречислениеСсылка.ДанныеДляРасчетаПоказателейПроцессов"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("Представление",
		Новый ОписаниеТипов("Строка"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("ТипЗначения",
		Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЗначенийПоказателейПроцессов"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("АвтоматическийПоказатель",
		Новый ОписаниеТипов("Булево"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("ПериодыАвтоматическогоПоказателя",
		Новый ОписаниеТипов("Массив"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("ПериодПоУмолчанию",
		Новый ОписаниеТипов("ПеречислениеСсылка.ПериодыРасчетаПоказателейПроцессов"));
	ДанныеБиблиотечныхПоказателей.Колонки.Добавить("ТипыПроцессовИсключения",
		Новый ОписаниеТипов("Массив"));
		
	ТабличныйДокумент = ПолучитьМакет("ДанныеБиблиотечныхПоказателей");
	НомерСтроки = 2;
	ИмяСпособРасчета = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
	Пока ЗначениеЗаполнено(ИмяСпособРасчета) Цикл
		
		ИмяДанныеДляРасчета = ТабличныйДокумент.Область(НомерСтроки, 2).Текст;
		Представление = ТабличныйДокумент.Область(НомерСтроки, 3).Текст;
		ИмяТипЗначения = ТабличныйДокумент.Область(НомерСтроки, 4).Текст;
		ИмяАвтоматическийПоказатель = ТабличныйДокумент.Область(НомерСтроки, 5).Текст;
		ИмяПериодыАвтоматическогоПоказателя = ТабличныйДокумент.Область(НомерСтроки, 6).Текст;
		ИмяПериодаПоУмолчанию = ТабличныйДокумент.Область(НомерСтроки, 7).Текст;
		ИмяТипыПроцессовИсключения = ТабличныйДокумент.Область(НомерСтроки, 8).Текст;
		ИмяФункциональнойОпции = ТабличныйДокумент.Область(НомерСтроки, 9).Текст;
		
		Если ЗначениеЗаполнено(ИмяФункциональнойОпции) Тогда
			Если Не ПолучитьФункциональнуюОпцию(ИмяФункциональнойОпции) Тогда
				НомерСтроки = НомерСтроки + 1;
				ИмяСпособРасчета = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НоваяСтрока = ДанныеБиблиотечныхПоказателей.Добавить();
		НоваяСтрока.СпособРасчета =
			Перечисления.СпособыРасчетаПоказателейПроцессов[ИмяСпособРасчета];
		НоваяСтрока.ДанныеДляРасчета =
			Перечисления.ДанныеДляРасчетаПоказателейПроцессов[ИмяДанныеДляРасчета];
		НоваяСтрока.Представление = Представление;
		НоваяСтрока.ТипЗначения =
			Перечисления.ТипыЗначенийПоказателейПроцессов[ИмяТипЗначения];
		НоваяСтрока.АвтоматическийПоказатель = Булево(ИмяАвтоматическийПоказатель);
		Для Каждого ИмяПериодАвтоматическогоПоказателя Из СтрРазделить(ИмяПериодыАвтоматическогоПоказателя, ",", Ложь) Цикл
			ПериодАвтоматическогоПоказателя =
				Перечисления.ПериодыРасчетаПоказателейПроцессов[ИмяПериодАвтоматическогоПоказателя];
			НоваяСтрока.ПериодыАвтоматическогоПоказателя.Добавить(ПериодАвтоматическогоПоказателя);
		КонецЦикла;
		НоваяСтрока.ПериодПоУмолчанию =
			Перечисления.ПериодыРасчетаПоказателейПроцессов[ИмяПериодаПоУмолчанию];
		Для Каждого ИмяТипПроцессаИсключение Из СтрРазделить(ИмяТипыПроцессовИсключения, ",", Ложь) Цикл
			ТипПроцессаИсключение =
				Перечисления.ТипыПроцессовПоказателейПроцессов[ИмяТипПроцессаИсключение];
			НоваяСтрока.ТипыПроцессовИсключения.Добавить(ТипПроцессаИсключение);
		КонецЦикла;
		
		НомерСтроки = НомерСтроки + 1;
		ИмяСпособРасчета = ТабличныйДокумент.Область(НомерСтроки, 1).Текст;
		
	КонецЦикла;
	
	Возврат ДанныеБиблиотечныхПоказателей;
	
КонецФункции

// Формирует данные библиотечного показателя из макета ДанныеБиблиотечныхПоказателей для вариант расчета.
//
// Параметры:
//  ВариантРасчета - Структура - Вариант расчет показателя. См. Справочники.ПоказателиПроцессов.ВариантРасчета().
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений - Данные библиотечного показателя. 
//
Функция ДанныеБиблиотечногоПоказателя(ВариантРасчета)
	
	ДанныеБиблиотечногоПоказателя = Неопределено;
	
	НайденныеСтроки = ДанныеБиблиотечныхПоказателей().НайтиСтроки(ВариантРасчета);
	Если НайденныеСтроки.Количество() <> 0 Тогда
		ДанныеБиблиотечногоПоказателя = НайденныеСтроки[0];
	КонецЕсли;
	
	Возврат ДанныеБиблиотечногоПоказателя;
	
КонецФункции

#КонецОбласти

#КонецЕсли