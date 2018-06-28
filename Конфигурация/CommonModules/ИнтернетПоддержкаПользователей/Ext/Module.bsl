﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей".
// ОбщийМодуль.ИнтернетПоддержкаПользователей.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает логин и пароль пользователя Интернет-поддержки,
// сохраненные в информационной базе.
//
// Возвращаемое значение:
//	Структура - структура, содержащая логин и пароль пользователя
//		Интернет-поддержки:
//		* Логин - Строка - логин пользователя Интернет-поддержки;
//		* Пароль - Строка - пароль пользователя Интернет-поддержки.
//	Неопределено - при отсутствии сохраненных данных аутентификации.
//
Функция ДанныеАутентификацииПользователяИнтернетПоддержки() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеВБезопасномХранилище = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		ИдентификаторПодсистемы(),
		"login,password");
	
	Если ДанныеВБезопасномХранилище.login <> Неопределено
		И ДанныеВБезопасномХранилище.password <> Неопределено Тогда
		Возврат Новый Структура(
			"Логин, Пароль",
			ДанныеВБезопасномХранилище.login,
			ДанныеВБезопасномХранилище.password);
	КонецЕсли;
	
КонецФункции

// Возвращает тикет аутентификации пользователя на портале поддержки.
// Возвращенный тикет может быть проверен вызовом операции checkTicket()
// сервиса https://login.1c.ru/api/public/ticket?wsdl или
// https://login.1c.eu/api/public/ticket?wsdl.
//
// Важно. Получение тикета выполняется в соответствии с настройками
// библиотеки:
//	- доменная зона серверов (1c.ru или 1c.eu);
//	- таймаут подключения к серверам.
//
// Параметры:
//	ВладелецТикета - Строка - произвольное имя сервиса, для которого
//		выполняется аутентификация пользователя. Это же имя должно
//		использоваться при вызове операции checkTicket();
//		Не допускается незаполненное значение параметра.
//
// Возвращаемое значение:
//	Структура - результат получения тикета. Поля структуры:
//		* Тикет - Строка - полученный тикет аутентификации. Если при получении
//			тикета произошла ошибка (неверный логин или пароль или другая ошибка),
//			значение поля - пустая строка.
//		* КодОшибки - Строка - строковый код возникшей ошибки, который
//			может быть обработан вызывающим функционалом:
//				- <Пустая строка> - получение тикета выполнено успешно;
//				- "НеверныйЛогинИлиПароль" - неверный логин или пароль;
//				- "ПревышеноКоличествоПопыток" - превышено количество попыток
//					получения тикета с некорректным логином и паролем;
//				- "ОшибкаПодключения" - ошибка при подключении к сервису;
//				- "ОшибкаСервиса" - внутренняя ошибка сервиса;
//				- "НеизвестнаяОшибка" - при получении тикета возникла
//					неизвестная (необрабатываемая) ошибка;
//		* СообщениеОбОшибке - Строка - краткое описание ошибки, которое
//			может быть отображено пользователю;
//
Функция ТикетАутентификацииНаПорталеПоддержки(ВладелецТикета) Экспорт
	
	Если Не ЗначениеЗаполнено(ВладелецТикета) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнено значение параметра ""ВладелецТикета""'");
	КонецЕсли;
	
	НастройкиСоединения = ИнтернетПоддержкаПользователейКлиентСервер.НастройкиСоединенияССерверами();
	ДанныеАутентификации = ДанныеАутентификацииПользователяИнтернетПоддержки();
	Если ДанныеАутентификации = Неопределено Тогда
		
		РезультатПолученияТикета = Новый Структура("КодОшибки, СообщениеОбОшибке, Тикет",
			"НеверныйЛогинИлиПароль",
			НСтр("ru = 'Неверный логин или пароль.'"),
			"");
		
	Иначе
		
		РезультатПолученияТикета = ИнтернетПоддержкаПользователейКлиентСервер.СлужебнаяТикетАутентификации(
			ДанныеАутентификации.Логин,
			ДанныеАутентификации.Пароль,
			ВладелецТикета,
			ИнтернетПоддержкаПользователейКлиентСервер.НастройкиСоединенияССерверами());
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(РезультатПолученияТикета.КодОшибки)
		И РезультатПолученияТикета.КодОшибки <> "НеверныйЛогинИлиПароль"
		И РезультатПолученияТикета.КодОшибки <> "ПревышеноКоличествоПопыток"
		И РезультатПолученияТикета.КодОшибки <> "ОшибкаСервиса"
		И РезультатПолученияТикета.КодОшибки <> "НеизвестнаяОшибка" Тогда
		
		Если РезультатПолученияТикета.КодОшибки = "ClientError" Или РезультатПолученияТикета.КодОшибки = "ConnectError" Тогда
			РезультатПолученияТикета.КодОшибки = "ОшибкаПодключения";
		ИначеЕсли РезультатПолученияТикета.КодОшибки = "ServerError" Или РезультатПолученияТикета.КодОшибки = "InternalError" Тогда
			РезультатПолученияТикета.КодОшибки = "ОшибкаСервиса";
		Иначе
			РезультатПолученияТикета.КодОшибки = "НеизвестнаяОшибка";
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат РезультатПолученияТикета;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интеграция с Библиотекой стандартных подсистем (БСП).
// Подсистема "Базовая функциональность".

// См. описание этой же процедуры в общем модуле
// ОбщегоНазначенияПереопределяемый.
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПараметрыИПП = Новый Структура;
	
	ОписаниеОбработчиков = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ОбработчикиСобытий();
	
	Для каждого ИмяМодуля Из ОписаниеОбработчиков.Сервер.ПараметрыРаботыКлиентаПриЗапуске Цикл
		МодульОбработчика = ОбщегоНазначения.ОбщийМодуль(ИмяМодуля);
		Если МодульОбработчика <> Неопределено Тогда
			МодульОбработчика.ПараметрыРаботыКлиентаПриЗапуске(ПараметрыИПП);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыИПП.Вставить("ПриНачалеРаботыСистемы", ОписаниеОбработчиков.Клиент.ПриНачалеРаботыСистемы);
	
	Параметры.Вставить("ИнтернетПоддержкаПользователей", ПараметрыИПП);
	
КонецПроцедуры

// См. описание этой же процедуры в общем модуле
// ОбщегоНазначенияПереопределяемый.
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		ПараметрыИПП = Новый Структура;
		
		Если Метаданные.Имя = "ДокументооборотБиблиотека" Тогда
			ПараметрыИПП.Вставить("ИмяКонфигурации"          , "ДокументооборотПРОФ");
		Иначе
			ПараметрыИПП.Вставить("ИмяКонфигурации"          , Метаданные.Имя);
		КонецЕсли;
		ПараметрыИПП.Вставить("ИмяПрограммы"             , ИмяПрограммы());
		ПараметрыИПП.Вставить("ВерсияКонфигурации"       , Метаданные.Версия);
		ПараметрыИПП.Вставить("КодЛокализации"           , ТекущийКодЛокализации());
		ПараметрыИПП.Вставить("ВерсияОбработкиОбновления", ВерсияОбработкиОбновления());
		
		НастройкиСоединения = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
		ПараметрыИПП.Вставить("УстанавливатьПодключениеНаСервере", НастройкиСоединения.УстанавливатьПодключениеНаСервере);
		ПараметрыИПП.Вставить("ТаймаутПодключения"               , НастройкиСоединения.ТаймаутПодключения);
		ПараметрыИПП.Вставить("ДоменРасположенияСерверовИПП"     , НастройкиСоединения.ДоменРасположенияСерверовИПП);
		
		ПараметрыИПП.Вставить(
			"ДоступноПодключениеИнтернетПоддержки",
			ДоступноПодключениеИнтернетПоддержки());
		
		// Обработчики бизнес-процессов
		ПараметрыИПП.Вставить("КлиентскиеОбработчикиБизнесПроцессов",
			ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ОбработчикиСобытий().Клиент.БизнесПроцессы);
		
		Параметры.Вставить("ИнтернетПоддержкаПользователей", ПараметрыИПП);
		
	КонецЕсли;
	
КонецПроцедуры

// См. описание этой же процедуры в общем модуле
// ОбщегоНазначенияПереопределяемый.
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт

	// Базовая функциональность БИП
	// 2.1.2.1
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"2.1.2.1",
		"Роль.ИспользованиеИПП",
		"Роль.ПодключениеКСервисуИнтернетПоддержки",
		"ИнтернетПоддержкаПользователей");
	
	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	КонецЕсли;
	// Конец Новости

КонецПроцедуры

// См. описание этой же процедуры в общем модуле
// ОбщегоНазначенияПереопределяемый.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт

	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	КонецЕсли;
	// Конец Новости

	// ОблачныйАрхив
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		МодульОблачныйАрхив.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	КонецЕсли;
	// Конец ОблачныйАрхив

КонецПроцедуры

// См. описание этой же процедуры в общем модуле
// РаботаВБезопасномРежимеПереопределяемый.
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		
		НовыеРазрешения = Новый Массив;
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"webits.1c.ru",
			443,
			НСтр("ru = 'Интернет-поддержка пользователей (зона ru)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"login.1c.ru",
			443,
			НСтр("ru = 'Сервисы аутентификации (зона ru)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"login.1c.eu",
			443,
			НСтр("ru = 'Сервисы аутентификации (зона eu)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"portal-support.1c.ru",
			443,
			НСтр("ru = 'Сервисы службы технической поддержки (зона ru)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		Разрешение = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
			"HTTPS",
			"portal-support.1c.eu",
			443,
			НСтр("ru = 'Сервисы службы технической поддержки (зона eu)'"));
		НовыеРазрешения.Добавить(Разрешение);
		
		ЗапросыРазрешений.Добавить(РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(НовыеРазрешения));
		
		// ПолучениеОбновленийПрограммы
		Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
			МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
			МодульПолучениеОбновленийПрограммы.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений);
		КонецЕсли;
		// Конец ПолучениеОбновленийПрограммы
		
	КонецЕсли;
	
	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений);
	КонецЕсли;
	// Конец Новости
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с Библиотекой стандартных подсистем (БСП).
// Подсистема "Пользователи".

// См. описание этой же процедуры в общем модуле
// ПользователиПереопределяемый.
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт

	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриОпределенииНазначенияРолей(НазначениеРолей);
	КонецЕсли;
	// Конец Новости

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интеграция с Библиотекой стандартных подсистем (БСП).
// Подсистема "Текущие дела".

// См. описание этой же процедуры в общем модуле
// ТекущиеДелаПереопределяемый.
//
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт

	// ПолучениеОбновленийПрограммы
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		Обработчики.Добавить(МодульПолучениеОбновленийПрограммы);
	КонецЕсли;
	// Конец ПолучениеОбновленийПрограммы

	// ОблачныйАрхив
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		Обработчики.Добавить(МодульОблачныйАрхив);
	КонецЕсли;
	// Конец ОблачныйАрхив

КонецПроцедуры

// См. описание этой же процедуры в общем модуле
// ТекущиеДелаПереопределяемый.
//
Процедура ПриОпределенииПорядкаРазделовКомандногоИнтерфейса(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.ИнтернетПоддержкаПользователей);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Интеграция с библиотекой "Технология сервиса" (БТС).
// Подсистема "Выгрузка загрузка данных".

// См. описание этой же процедуры в общем модуле
// ВыгрузкаЗагрузкаДанныхПереопределяемый.
//
Процедура ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы) Экспорт

	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	КонецЕсли;
	// Конец Новости

КонецПроцедуры

// См. описание этой же процедуры в общем модуле
// ВыгрузкаЗагрузкаДанныхПереопределяемый.
//
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт

	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	// Конец Новости

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Устаревший программный интерфейс

// Устарела. Будет удалена в следующей редакции библиотеки.
// Необходимо использовать функции:
//		ИнтернетПоддержкаПользователейВызовСервера.ДоступноПодключениеИнтернетПоддержки();
//		МониторИнтернетПоддержки.ДоступноИспользованиеМонитораИнтернетПоддержки();
//		Подключение1СТакскомВызовСервера.ДоступноИспользованиеСервиса1СТакском();
// если в конфигурацию внедрены соответствующие подсистемы.
//
// Определяет, разрешено ли использование Интернет-поддержки в текущем режиме
// работы информационной базы.
// Определяет на основании значений: 1) Это локальный режим работы;
// 2) реализации процедуры
// ИнтернетПоддержкаПользователейПереопределяемый.ИспользоватьИнтернетПоддержку().
//
// Возвращаемое значение:
//	Булево - Истина - использование разрешено, Ложь - в противном случае.
//
Функция ИспользованиеИнтернетПоддержкиРазрешеноВТекущемРежимеРаботы() Экспорт
	
	// Запрет работы в модели сервиса
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	ИнтернетПоддержкаПользователейПереопределяемый.ИспользоватьИнтернетПоддержку(Отказ);
	
	Возврат (Отказ <> Истина);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Интеграция подсистем библиотеки.

// В вызывающем коде перед записью данных необходимо проверить права
// и установить привилегированный режим.
// Сохраняет логин и пароль пользователя в подсистеме Интернет-поддержки.
//
Функция СохранитьДанныеАутентификации(ДанныеАутентификации) Экспорт
	
	Если ДанныеАутентификации = Неопределено Тогда
		
		// Удалить все данные для логина из безопасного хранилища
		ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ИдентификаторПодсистемы());
		ПриУдаленииЛогинаИПароляИзИБ();
		
	Иначе
		
		// Запись данных в безопасное хранилище
		ИДПодсистемы = ИдентификаторПодсистемы();
		НачатьТранзакцию();
		Попытка
			ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ИДПодсистемы);
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
				ИДПодсистемы,
				ДанныеАутентификации.Логин,
				"login");
			
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
				ИДПодсистемы,
				ДанныеАутентификации.Пароль,
				"password");
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;
		ПриСохраненииЛогинаИПароляВИБ(ДанныеАутентификации.Логин, ДанныеАутентификации.Пароль);
		
	КонецЕсли;
	
КонецФункции

// Возвращается код текущего языка интерфейса конфигурации
// в формате ISO-639-1.
//
Функция КодЯзыкаИнтерфейсаКонфигурации() Экспорт
	
	Язык = ТекущийЯзык();
	Если Язык = Неопределено Тогда
		// Для пользователя информационной базы не указан язык.
		Возврат КодОсновногоЯзыкаИнтерфейсаКонфигурации();
	КонецЕсли;
	
	КодЯзыкаВМетаданных = ?(ТипЗнч(Язык) = Тип("Строка"), Язык, Язык.КодЯзыка);
	КодЯзыкаВФорматеISO639_1 = Неопределено;
	ИнтернетПоддержкаПользователейПереопределяемый.ПриОпределенииКодаЯзыкаИнтерфейсаКонфигурации(
		КодЯзыкаВМетаданных,
		КодЯзыкаВФорматеISO639_1);
	
	Возврат ?(КодЯзыкаВФорматеISO639_1 = Неопределено, КодЯзыкаВМетаданных, КодЯзыкаВФорматеISO639_1);
	
КонецФункции

// Возвращается код основного языка интерфейса конфигурации
// в формате ISO-639-1.
//
Функция КодОсновногоЯзыкаИнтерфейсаКонфигурации() Экспорт
	
	КодЯзыкаВМетаданных = Метаданные.ОсновнойЯзык.КодЯзыка;
	КодЯзыкаВФорматеISO639_1 = Неопределено;
	ИнтернетПоддержкаПользователейПереопределяемый.ПриОпределенииКодаЯзыкаИнтерфейсаКонфигурации(
		КодЯзыкаВМетаданных,
		КодЯзыкаВФорматеISO639_1);
	
	Возврат ?(КодЯзыкаВФорматеISO639_1 = Неопределено, КодЯзыкаВМетаданных, КодЯзыкаВФорматеISO639_1);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает версию обработки обновления конфигурации.
Функция ВерсияОбработкиОбновления() Экспорт
	
	Возврат СтандартныеПодсистемыСервер.ВерсияБиблиотеки();
	
КонецФункции

// Возвращает имена модулей подсистем, реализующих обработку событий библиотеки.
//
// Возвращаемое значение:
//	Массив - массив элементов типа Строка - имена модулей подсистем,
//		реализующих заполнение описаний обработчиков событий.
//
// Описание модулей подсистем:
//
// Каждый модуль, имя которого возвращается функцией, должен реализовывать
// экспортную процедуру служебного программного интерфейса, реализующую
// заполнение описания обработчиков событий.
//
// Процедура ДобавитьОбработчикиСобытий(СерверныеОбработчики, КлиентскиеОбработчики) Экспорт
//
// КонецПроцедуры
//
// Подробную информацию по реализации процедур см. в описании функции
// ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ОбработчикиСобытий().
//
Функция МодулиПодсистем() Экспорт
	
	Результат = Новый Массив;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки") Тогда
		Результат.Добавить("МониторИнтернетПоддержки");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Подключение1СТакском") Тогда
		Результат.Добавить("Подключение1СТакском");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		Результат.Добавить("ПолучениеОбновленийПрограммы");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИмяПрограммы() Экспорт
	
	Результат = "";
	ИнтернетПоддержкаПользователейПереопределяемый.ПриОпределенииИмениПрограммы(Результат);
	Если ПустаяСтрока(Результат) Тогда
		Результат = "Unknown";
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Функция СинонимКонфигурации() Экспорт
	
	Возврат Метаданные.Синоним;
	
КонецФункции

// Возвращает серверный обработчик бизнес-процесса.
// Параметры:
//	МестоЗапуска - Строка - точка входа в бизнес-процесс;
//	ИмяСобытия - Строка - имя обрабатываемого события.
//
// Возвращаемое значение:
//	ОбщийМодуль - модуль, содержащий заданный обработчик бизнес-процесса;
//	Неопределено - если обработчик бизнес-процесса неопределен.
//
Функция СерверныйОбработчикБизнесПроцесса(МестоЗапуска, ИмяСобытия) Экспорт
	
	Если ИнтернетПоддержкаПользователейКлиентСервер.ЭтоБазовыйБизнесПроцесс(МестоЗапуска) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбработчикиСобытий = ИнтернетПоддержкаПользователейСлужебныйПовтИсп.ОбработчикиСобытий();
	МодулиОбработчиковБизнесПроцессов = ОбработчикиСобытий.Сервер.БизнесПроцессы;
	ИмяМодуля = МодулиОбработчиковБизнесПроцессов[МестоЗапуска + "\" + ИмяСобытия];
	
	Если ИмяМодуля = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ОбщийМодуль(ИмяМодуля);
	
КонецФункции

// Возвращает сохраненный регистрационный номер программного продукта.
//
Функция РегистрационныйНомерПрограммногоПродукта() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИдентификаторПодсистемы(), "regnumber");
	
КонецФункции

// Определяет, доступно ли текущему пользователю выполнение интерактивной
// авторизации в на портале 1С:ИТС в соответствии с текущим режимом работы
// и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - интерактивная авторизация доступна,
//		Ложь - в противном случае.
//
Функция ДоступноПодключениеИнтернетПоддержки() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Пользователи.РолиДоступны("ПодключениеКСервисуИнтернетПоддержки", , Ложь) Тогда
		Возврат Истина;
	КонецЕсли;
	
	// Проверка функциональности, дающей возможность подключения ИПП
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки") Тогда
		МодульМониторИнтернетПоддержки = ОбщегоНазначения.ОбщийМодуль("МониторИнтернетПоддержки");
		Если МодульМониторИнтернетПоддержки.ДоступноИспользованиеМонитораИнтернетПоддержки() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Подключение1СТакском") Тогда
		МодульПодключение1СТакскомВызовСервера = ОбщегоНазначения.ОбщийМодуль("Подключение1СТакскомВызовСервера");
		Если МодульПодключение1СТакскомВызовСервера.ДоступноИспользованиеСервиса1СТакском() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает Истина, если у текущего пользователя есть право записи параметров ИПП.
// Ложь - в противном случае.
//
Функция ПравоЗаписиПараметровИПП() Экспорт
	
	Возврат Пользователи.ЭтоПолноправныйПользователь(, , Ложь)
		Или Пользователи.РолиДоступны("ПодключениеКСервисуИнтернетПоддержки", , Ложь)
		Или ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.МониторИнтернетПоддержки")
		И Пользователи.РолиДоступны("ИспользованиеМонитораИПП", , Ложь)
		Или ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Подключение1СТакском")
		И Пользователи.РолиДоступны("ИспользованиеСервиса1СТакском", , Ложь);
	
КонецФункции

// Возвращает идентификатор подсистемы в в справочнике объектов
// метаданных.
//
Функция ИдентификаторПодсистемы() Экспорт
	
	Возврат ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		"Подсистема.ИнтернетПоддержкаПользователей.Подсистема.БазоваяФункциональностьБИП");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработка событий библиотеки

// Вызывается при сохранении логина и пароля пользователя ИПП в
// информационной базе из всех контекстов использования библиотеки.
//
Процедура ПриСохраненииЛогинаИПароляВИБ(Логин, Пароль)
	
	Если ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		УстановитьПривилегированныйРежим(Истина);
		КлиентЛицензирования.ПриИзмененииДанныхАутентификации(Логин, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

	// ОблачныйАрхив
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		МодульОблачныйАрхив.ПриСохраненииЛогинаИПароляВИБ(Логин, Пароль);
	КонецЕсли;
	// Конец ОблачныйАрхив

	// Переопределяемая обработка события.
	ИнтернетПоддержкаПользователейПереопределяемый.ПриСохраненииДанныхАутентификацииПользователяИнтернетПоддержки(
		Новый Структура("Логин, Пароль", Логин, Пароль));
	
	// Вызов устаревшего метода для поддержки обратной совместимости в текущей редакции.
	ИнтернетПоддержкаПользователейПереопределяемый.ПриАвторизацииПользователяВИнтернетПоддержке(
		Новый Структура("Логин, Пароль", Логин, Пароль));
	
КонецПроцедуры

// Вызывается при удалении логина и пароля пользователя ИПП из
// информационной базы из всех контекстов использования библиотеки.
//
Процедура ПриУдаленииЛогинаИПароляИзИБ()
	
	Если ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		УстановитьПривилегированныйРежим(Истина);
		КлиентЛицензирования.ПриИзмененииДанныхАутентификации("", "");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	// ОблачныйАрхив
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
		МодульОблачныйАрхив.ПриУдаленииЛогинаИПароляИзИБ();
	КонецЕсли;
	// Конец ОблачныйАрхив
	
	// Переопределяемая обработка события
	ИнтернетПоддержкаПользователейПереопределяемый.ПриУдаленииДанныхАутентификацииПользователяИнтернетПоддержки();
	
	// Вызов устаревшего метода для поддержки обратной совместимости в текущей редакции.
	ИнтернетПоддержкаПользователейПереопределяемый.ПриВыходеПользователяИзИнтернетПоддержки();
	
КонецПроцедуры

// Вызывается при изменении настройки "Доменная зона расположения серверов ИПП".
//
Процедура ПриИзмененииДоменнойЗоныСерверовИПП(ДоменнаяЗона) Экспорт
	
	Если ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Тогда
		УстановитьПривилегированныйРежим(Истина);
		КлиентЛицензирования.ПриИзмененииДоменнойЗоныСерверовИПП(ДоменнаяЗона);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики бизнес-процессов

// В вызывающем коде должны быть проверены права пользователя и установлен
// привилегированный режим.
// Выполняет запись общих стартовых параметров.
//
Процедура ЗаписатьОбщиеПараметрыИПП(Знач ОбщиеПараметры) Экспорт
	
	Логин  = Неопределено;
	Пароль = Неопределено;
	
	ИдентификаторПодсистемы = ИдентификаторПодсистемы();
	
	// Запись выполняется в транзакции, т.к. данные (например, пара Логин-Пароль)
	// должны зачитываться неделимо другими механизмами.
	НачатьТранзакцию();
	Попытка
		Для каждого КлючЗначение Из ОбщиеПараметры Цикл
			
			ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
				ИдентификаторПодсистемы,
				КлючЗначение.Значение,
				КлючЗначение.Ключ);
			
			Если КлючЗначение.Ключ = "login" Тогда
				Логин = КлючЗначение.Значение;
			ИначеЕсли КлючЗначение.Ключ = "password" Тогда
				Пароль = КлючЗначение.Значение;
			КонецЕсли;
			
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Если Логин <> Неопределено И Пароль <> Неопределено Тогда
		ПриСохраненииЛогинаИПароляВИБ(Логин, Пароль);
	КонецЕсли;
	
КонецПроцедуры

// В вызывающем коде должны быть проверены права пользователя и установлен
// привилегированный режим.
// Удаление общих стартовых параметров.
//
// Параметры:
//	УдаляемыеИзРС - Массив - массив строк - имена удаляемых параметров.
//
Процедура УдалитьОбщиеПараметрыИПП(Знач УдаляемыеИзРС) Экспорт
	
	УдаленыДанныеАутентификации = Ложь;
	ИДПодсистемы = ИдентификаторПодсистемы();
	НачатьТранзакцию();
	Попытка
		Для каждого КлючЗначение Из УдаляемыеИзРС Цикл
			
			ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища(ИДПодсистемы, КлючЗначение.Ключ);
			
			Если КлючЗначение.Ключ = "login" Или КлючЗначение.Ключ = "password" Тогда
				УдаленыДанныеАутентификации = Истина;
			КонецЕсли;
			
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	Если УдаленыДанныеАутентификации Тогда
		ПриУдаленииЛогинаИПароляИзИБ();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки клиента лицензирования

// Возвращает признак возможности работы с настройками клиента лицензирования
// в БИП.
//
// Версия платформы 1С:Предприятие 8.3.7 или выше и не работа в модели сервиса.
//
Функция ДоступнаРаботаСНастройкамиКлиентаЛицензирования() Экспорт
	
	Возврат Не ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Заполняет список обработчиков обновления информационной базы.
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия    = "2.1.7.1";
	Обработчик.Процедура =
		"ИнтернетПоддержкаПользователей.ОбновлениеИнформационнойБазы_ПереместитьПараметрыИнтернетПоддержкиВБезопасноеХранилищеДанных_2_1_7_1";
	Обработчик.ОбщиеДанные         = Ложь;
	Обработчик.НачальноеЗаполнение = Ложь;
	
	// ПолучениеОбновленийПрограммы
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		МодульПолучениеОбновленийПрограммы.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ПолучениеОбновленийПрограммы
	
КонецПроцедуры

Процедура ОбновлениеИнформационнойБазы_ПереместитьПараметрыИнтернетПоддержкиВБезопасноеХранилищеДанных_2_1_7_1() Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		// Не используется при работе в модели сервиса
		Возврат;
	КонецЕсли;
	
	ЗапросПараметровИПП = Новый Запрос;
	ЗапросПараметровИПП.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Имя КАК ИмяПараметра,
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Значение КАК ЗначениеПараметра
	|ИЗ
	|	РегистрСведений.УдалитьПараметрыИнтернетПоддержкиПользователей КАК УдалитьПараметрыИнтернетПоддержкиПользователей
	|ГДЕ
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Имя = ""login""
	|	И УдалитьПараметрыИнтернетПоддержкиПользователей.Пользователь = &ПустойИдентификатор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Имя,
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Значение
	|ИЗ
	|	РегистрСведений.УдалитьПараметрыИнтернетПоддержкиПользователей КАК УдалитьПараметрыИнтернетПоддержкиПользователей
	|ГДЕ
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Имя = ""password""
	|	И УдалитьПараметрыИнтернетПоддержкиПользователей.Пользователь = &ПустойИдентификатор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Имя,
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Значение
	|ИЗ
	|	РегистрСведений.УдалитьПараметрыИнтернетПоддержкиПользователей КАК УдалитьПараметрыИнтернетПоддержкиПользователей
	|ГДЕ
	|	УдалитьПараметрыИнтернетПоддержкиПользователей.Имя = ""regnumber""
	|	И УдалитьПараметрыИнтернетПоддержкиПользователей.Пользователь = &ПустойИдентификатор";
	
	ЗапросПараметровИПП.УстановитьПараметр(
		"ПустойИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	УстановитьПривилегированныйРежим(Истина);
	ВыборкаПараметров = ЗапросПараметровИПП.Выполнить().Выбрать();
	
	// Запись данных в безопасное хранилище
	ИдентификаторПодсистемыБИП = ИдентификаторПодсистемы();
	Пока ВыборкаПараметров.Следующий() Цикл
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
			ИдентификаторПодсистемыБИП,
			ВыборкаПараметров.ЗначениеПараметра,
			ВыборкаПараметров.ИмяПараметра);
	КонецЦикла;
	
	// Очистка неиспользуемого регистра параметров ИПП
	НаборЗаписей = РегистрыСведений.УдалитьПараметрыИнтернетПоддержкиПользователей.СоздатьНаборЗаписей();
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти
