﻿#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
// 
// Параметры:
//	Настройки - Структура - Сеодержит настройки по умолчанию
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.ПутьКФайлуКомплектаПравилНаПользовательскомСайте = "";
	Настройки.ПутьКФайлуКомплектаПравилВКаталогеШаблонов = "";
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат "Настройки_обмена_ДОКОРП_УХ";
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для
//									разного состава настроек на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки узла. Возможно, например, использование
//						различных форм для разных версий корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	СтруктураНастроек.Вставить("ОграничиватьВыгрузкуОрганизациями", Ложь);
	СтруктураНастроек.Вставить("Организации", СтруктураТабличнойЧастиОрганизации);
	
	СтруктураТабличнойЧастиДоговоры = Новый Структура;
	СтруктураТабличнойЧастиДоговоры.Вставить("ВидДокумента", Новый Массив);
	СтруктураНастроек.Вставить("ВыгружатьДоговоры", Ложь);
	СтруктураНастроек.Вставить("Договоры", СтруктураТабличнойЧастиДоговоры);
	
	СтруктураТабличнойЧастиЗаявкиНаОперации = Новый Структура;
	СтруктураТабличнойЧастиЗаявкиНаОперации.Вставить("ВидДокумента", Новый Массив);
	СтруктураТабличнойЧастиЗаявкиНаОперации.Вставить("ТипОперации", Новый Массив);
	
	СтруктураНастроек.Вставить("ВыгружатьЗаявкиНаОперации", Ложь);
	СтруктураНастроек.Вставить("ЗаявкиНаОперации", СтруктураТабличнойЧастиЗаявкиНаОперации);
	
	СтруктураНастроек.Вставить("ВыгружатьПроектыИПроектныеЗадачи", Ложь);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для
//									разного состава настроек на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки узла. Возможно, например, использование
//						различных форм для разных версий корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	
	Если ПолучитьФункциональнуюОпцию("ДокументооборотИспользоватьОграничениеПравДоступа") Тогда
		СтруктураНастроек.Вставить("ГруппаДоступаКонтрагентов", 
			Справочники.ГруппыДоступаКонтрагентов.ПустаяСсылка());
	КонецЕсли;
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	// Общие сведения.
	ТекстОписания = НСтр("ru = 'Синхронизация нормативно-справочной информации:'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Корреспонденты'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Контактные лица'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Банковские счета'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Организации'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Валюты'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Статьи движения денежных средств'");
	
	// Отбор по организациям.
	Если НастройкаОтборовНаУзле.ОграничиватьВыгрузкуОрганизациями Тогда
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Выгружаются только данные по организациям:'");
		ВыгружаемыеОрганизации = НастройкаОтборовНаУзле.Организации.Организация;
		Для каждого ВыгружаемаяОрганизация из ВыгружаемыеОрганизации Цикл
			ТекстОписания = ТекстОписания + Символы.ПС + Символы.Таб + ВыгружаемаяОрганизация;
		КонецЦикла;
		ТекстОписания = ТекстОписания + ".";
	Иначе
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Данные выгружаются без отбора по организациям.'");
	КонецЕсли;
	
	// Договоры.
	Если НастройкаОтборовНаУзле.ВыгружатьДоговоры Тогда
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Договоры выгружаются'");
		ВыгружаемыеВидыДокументов = НастройкаОтборовНаУзле.Договоры.ВидДокумента;
		Если ВыгружаемыеВидыДокументов.Количество() > 0 Тогда
			ТекстОписания = ТекстОписания + " " + НСтр("ru = 'по видам'") + ": ";
			Разделитель = "";
			Для каждого ВидДокумента из ВыгружаемыеВидыДокументов Цикл
				ТекстОписания = ТекстОписания + Разделитель + ВидДокумента;
				Разделитель = ", ";
			КонецЦикла;
		КонецЕсли;
		ТекстОписания = ТекстОписания + ".";
	Иначе
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Договоры не выгружаются.'");
	КонецЕсли;
	
	// Заявки на операции.
	Если НастройкаОтборовНаУзле.ВыгружатьЗаявкиНаОперации Тогда
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Заявки на операции выгружаются'");
		ВыгружаемыеВидыДокументов = НастройкаОтборовНаУзле.ЗаявкиНаОперации.ВидДокумента;
		Если ВыгружаемыеВидыДокументов.Количество() > 0 Тогда
			ТекстОписания = ТекстОписания + " " + НСтр("ru = 'по видам'") + ": ";
			Разделитель = "";
			Для каждого ВидДокумента из ВыгружаемыеВидыДокументов Цикл
				ТекстОписания = ТекстОписания + Разделитель + ВидДокумента;
				Разделитель = ", ";
			КонецЦикла;
		КонецЕсли;
		ТекстОписания = ТекстОписания + ".";
	Иначе
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Заявки на операции не выгружаются.'");
	КонецЕсли;
	
	Если НастройкаОтборовНаУзле.ВыгружатьПроектыИПроектныеЗадачи Тогда
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Выгружаются проекты и проектные задачи.'");
	Иначе
		ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = 'Проекты и проектные задачи не выгружаются.'");
	КонецЕсли;
	
	Возврат ТекстОписания;
	
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ТекстОписания = "";
	
	Если ПолучитьФункциональнуюОпцию("ОграничиватьДоступНаУровнеЗаписей") Тогда
		ТекстОписания = ТекстОписания + НСтр("ru = 'Группа доступа контрагентов'") + ": ";
		Если ЗначениеЗаполнено(ЗначенияПоУмолчаниюНаУзле.ГруппаДоступаКонтрагентов) Тогда
			ТекстОписания = ТекстОписания + ЗначенияПоУмолчаниюНаУзле.ГруппаДоступаКонтрагентов;
		Иначе
			ТекстОписания = ТекстОписания + НСтр("ru = 'не назначается.'");
		КонецЕсли;
		ТекстОписания = ТекстОписания + Символы.ПС;
	КонецЕсли;
	
	Возврат ТекстОписания;
	
КонецФункции

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = '1С:Управление холдингом, ред. 1'");
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
// Например:
//	Возврат "ПланОбмена._ДемоРаспределеннаяИнформационнаяБаза.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
КонецФункции

// Возвращает признак использования плана обмена для организации обмена в модели сервиса.
//  Если признак установлен, то в сервисе можно включить обмен данными
//  с использованием этого плана обмена.
//  Если признак не установлен, то план обмена будет использоваться только 
//  для обмена в локальном режиме работы конфигурации.
// 
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает имя обработки выгрузки в составе конфигурации
//
Функция ИмяОбработкиВыгрузки() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает имя обработки загрузки в составе конфигурации
//
Функция ИмяОбработкиЗагрузки() Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
// Параметры:
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные между конфигурациями ""1С:Управление холдингом"" и ""1С:Документооборот"".
	|Синхронизация данных выполняется в двустороннем режиме на уровне нормативно-справочной информации, проектов, договоров и заявок на операции.'");

	Возврат ПоясняющийТекст;

КонецФункции

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме
//
// Параметры:
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
//
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
	
		Возврат "";
	
	Иначе
		
		Возврат "ПланОбмена.ОбменУправлениеХолдингомДокументооборот20.Форма.ПодробнаяИнформация";
		
	КонецЕсли;

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для работы через внешнее соединение

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для
//									разного состава настроек на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки узла. Возможно, например, использование
//						различных форм для разных версий корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для
//									разного состава настроек на узле для разных версий корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки узла. Возможно, например, использование
//						различных форм для разных версий корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураНастроек = Новый Структура;
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ТекстОписания = НСтр("ru = 'Синхронизация нормативно-справочной информации:'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Контрагенты'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Контактные лица'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Банковские счета'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Организации'");
	ТекстОписания = ТекстОписания + Символы.ПС + НСтр("ru = '    Валюты'");
	
	Возврат ТекстОписания;
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
//  ИдентификаторНастройки - Строка - содержит идентификатор варианта настройки.
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	ТекстОписания = "";
	
	Возврат ТекстОписания;
	
КонецФункции

// Процедура предназначена для получения дополнительных данных, используемых при настройке обмена в базе-корреспонденте.
//
//  Параметры:
// ДополнительныеДанные – Структура. Дополнительные данные, которые будут использованы
// в базе-корреспонденте при настройке обмена.
// В качестве значений структуры применимы только значения, поддерживающие XDTO-сериализацию.
//
Процедура ПолучитьДополнительныеДанныеДляКорреспондента(ДополнительныеДанные) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
//  Параметры:
// ВерсияКорреспондента (только чтение) – Строка – версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать – Булево – признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Константы и проверка параметров учета

Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	
	Возврат "";
	
КонецФункции

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Переопределяемая настройка дополнения выгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Используется для контроля режимов работы помощника интерактивного обмена данными.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Строка            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Строка            - Заголовок для отрисовки на форме команды открытия формы настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно  использовать специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки, предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле "Ссылка.Организация"
//
//
//     Если для всех вариантов флаги разрешения использования установлены в Ложь, то страница дополнения выгрузки в помощнике
//     интерактивного обмена данными будет пропущена и дополнительная регистрация объектов производится не будет. Например, инициализация вида:
//
//          Параметры.ВариантВсеДокументы.Использование      = Ложь;
//          Параметры.ВариантБезДополнения.Использование     = Ложь;
//          Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
//          Параметры.ВариантДополнительно.Использование     = Ложь;
//
//     Приведет к тому, что шаг дополнения выгрузки будет полностью пропущен.
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	Параметры.ВариантВсеДокументы.Использование      = Ложь;
	Параметры.ВариантБезДополнения.Использование     = Ложь;
	Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
	Параметры.ВариантДополнительно.Использование     = Ложь;
	
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку"
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут быть использованы специальные 
//                                                               значения "ВсеДокументы" и "ВсеСправочники" для отбора соответственно всех 
//                                                               документов и всех справочников, регистрирующихся на узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с общим правилами
//                                                               формирования полей компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", будет использовано поле "Ссылка.Организация"
//
// Возвращаемое значение: 
//     Строка - описание отбора
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает список поддерживаемых типов операций для заявок.
//
Функция ПоддерживаемыеТипыОпераций() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("РасчетыСКонтрагентами", НСтр("ru = 'Расчеты с контрагентами'"));
	Результат.Вставить("РасчетыСПодотчетнымиЛицами", НСтр("ru = 'Расчеты с подотчетными лицами'"));
	Результат.Вставить("РасчетыПоКредитамИЗаймамСКонтрагентами", НСтр("ru = 'Расчеты по кредитам и займам с контрагентами'"));
	Результат.Вставить("РасчетыПоКредитамИЗаймамСРаботниками", НСтр("ru = 'Расчеты кредитам и займам с работниками'"));
	Результат.Вставить("ПрочиеОперации", НСтр("ru = 'Прочие операции'"));
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли

#КонецОбласти