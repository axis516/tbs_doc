﻿///////////////////////////////////////////////////////////////////////////////
// В Н И М А Н И Е!
// ПЕРЕМЕННЫЕ, ПРОЦЕДУРЫ И ФУНКЦИИ, НАЧИНАЮЩИЕСЯ С "ТЦ", НЕЛЬЗЯ УДАЛЯТЬ, Т.К.
// ОНИ НЕОБХОДИМЫ ДЛЯ ПРАВИЛЬНОЙ РАБОТЫ ТЕСТ-ЦЕНТРА
//

&НаКлиенте
Перем ТЦКонтекстВыполнения; // Служебная переменная Тест-центра
&НаКлиенте
Перем ТЦИмяОбработчика;     // Служебная переменная Тест-центра

///////////////////////////////////////////////////////////////////////////////
// ИНТЕРФЕЙС РАЗРАБОТЧИКА СЦЕНАРИЯ

&НаКлиенте
// Единовременная подготовка данных перед выполнением действия.
// Эта подготовка выполняется только при необходимости и не является
// обязательной.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.
//   Успешно - если при инициализации ошибок не возникло
//   Предупреждение - если возникшие ошибки позволяют продолжить выполнение
//   Ошибка - если возникли ошибки, которые не позволяют продолжить выполнение
//
Функция ТЦИнициализировать() Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Код обычного приложения
	#Иначе
		// Код управляемого приложения
	#КонецЕсли
	
	Возврат ТЦРезультатВыполненияУспешно();
	
КонецФункции // ТЦИнициализировать()

&НаКлиенте
// Выполнение действия.
// В этой функции содержится основной код действия, необходимый для выполнения
// сценария.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.
//   Успешно - если при инициализации ошибок не возникло
//   Предупреждение - если возникшие ошибки позволяют продолжить выполнение
//   Ошибка - если возникли ошибки, которые не позволяют продолжить выполнение
//
Функция ТЦВыполнить() Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Код обычного приложения
	#Иначе
		// Код управляемого приложения
		Возврат ТЦРезультатВыполненияПродолжить("ЗапуститьВыполнениеСценария", 0.1, Истина);
	#КонецЕсли
	
КонецФункции // ТЦВыполнить()

&НаКлиенте
Функция ЗапуститьВыполнениеСценария() Экспорт
	
	НагрузочноеТестированиеКлиент.ЗапуститьВыполнениеСценария(ПолучитьСценарий());
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ПолучитьСценарий()
	
	Сценарий = НагрузочноеТестированиеСценарии.СозданиеИсходящегоДокумента();
	Возврат Сценарий;
	
КонецФункции

&НаКлиенте
// Единовременное удаление созданных при инициализации данных, после выполнения
// действия. Это удаление выполняется только при необходимости и не является
// обязательным.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.
//   Успешно - если при инициализации ошибок не возникло
//   Предупреждение - если возникшие ошибки позволяют продолжить выполнение
//   Ошибка - если возникли ошибки, которые не позволяют продолжить выполнение
//
Функция ТЦУдалитьДанные() Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Код обычного приложения
	#Иначе
		// Код управляемого приложения
	#КонецЕсли
	
	Возврат ТЦРезультатВыполненияУспешно();
	
КонецФункции // ТЦУдалитьДанные()


///////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАЗРАБОТЧИКА СЦЕНАРИЯ

&НаКлиенте
// Записать значение показателя производительности
//
// Параметры:
//  ИмяПоказателя - Строка, произвольное имя показателя производительности
//  ЗначениеПоказателя - Число, значение показателя
//
Процедура ТЦЗаписатьПоказатель(ИмяПоказателя, ЗначениеПоказателя)
	
	ТЦКлиент.ДобавитьРезультат(ТЦКонтекст(), ИмяПоказателя, ЗначениеПоказателя);
	
КонецПроцедуры // ТЦЗаписатьПоказатель()

&НаКлиенте
// Завершить выполнение действия
//
// Параметры:
//  Результат - ПеречислениеСсылка.ТЦРезультатВыполнения
//  ВозниклоИсключение - Булево, при выполнении обработчика ожидания
//                 возникла и обработана исключительная ситуация
//                 указывать этот параметр явно не следует
//
Процедура ТЦЗавершитьВыполнение(Результат, ВозниклоИсключение = Ложь, ТекстОшибкиОбработки = "")
	
	ОтключитьОбработчикОжидания("ТЦОбработчикВыполнения");
	ФормаВРМ = ТЦКонтекст().ФормаВРМ;
	
	Если ФормаВРМ <> Неопределено Тогда
		ФормаВРМ.РезультатВыполнения = Результат;
		ФормаВРМ.ВозниклоИсключение = ВозниклоИсключение;
		ФормаВРМ.ТекстОшибкиОбработки = ТекстОшибкиОбработки;
	КонецЕсли;
	
	ТЦКонтекстВыполнения.ТекущийРезультатВыполнения = Результат;
	ТЦКонтекстВыполнения.ВозниклоИсключение = ВозниклоИсключение;
	ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = ТекстОшибкиОбработки;
	
КонецПроцедуры // ТЦЗавершитьВыполнение()

&НаКлиенте
// Номер ВРМ, уникальный в рамках сценария
//
// Возвращаемое значение:
//  Число - номер текущего ВРМ
//
Функция ТЦНомерВРМ()
	
	Возврат ТЦКонтекст().ВРМ.Номер;
	
КонецФункции // ТЦНомерВРМ()

&НаКлиенте
// Ссылка на сценарий
//
// Возвращаемое значение:
//  СправочникСсылка.ТЦСценарии
//
Функция ТЦСценарий()
	
	Возврат ТЦКонтекст().ВРМ.Сценарий;
	
КонецФункции // ТЦСценарий()

&НаКлиенте
// Получить имя текущей роли
//
// Возвращаемое значение:
//  Строка - имя текущей роли
//
Функция ТЦИмяРоли()
	
	Возврат ТЦКонтекст().ВРМ.ИмяРоли;
	
КонецФункции // ТЦИмяРоли()

&НаКлиенте
// Получить имя текущей роли
//
// Возвращаемое значение:
//  Строка - имя текущей роли
//
Функция ТЦРоль()
	
	Возврат ТЦКонтекст().ВРМ.Роль;
	
КонецФункции // ТЦРоль()

&НаКлиенте
// Получить имя текущего пользователя
//
// Возвращаемое значение:
//  Строка - имя текущего пользователя
//
Функция ТЦИмяПользователя()
	
	Возврат ТЦКонтекст().ВРМ.Пользователь;
	
КонецФункции // ТЦИмяПользователя()

&НаКлиенте
// Получить имя текущего компьютера
//
// Возвращаемое значение:
//  Строка - имя текущего компьютера
//
Функция ТЦИмяКомпьютера()
	
	Возврат ТЦКонтекст().ВРМ.Компьютер;
	
КонецФункции // ТЦИмяКомпьютера()

&НаКлиенте
// Получить результат выполнения "Успешно"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Успешно
//
Функция ТЦРезультатВыполненияУспешно()
	
	Возврат ТЦКонтекст().РезультатВыполнения.Успешно;
	
КонецФункции // ТЦРезультатВыполненияУспешно()

&НаКлиенте
// Получить результат выполнения "Предупреждение"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Предупреждение
//
Функция ТЦРезультатВыполненияПредупреждение()
	
	Возврат ТЦКонтекст().РезультатВыполнения.Предупреждение;
	
КонецФункции // ТЦРезультатВыполненияПредупреждение()

&НаКлиенте
// Получить результат выполнения "Ошибка"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Ошибка
//
Функция ТЦРезультатВыполненияОшибка()
	
	Возврат ТЦКонтекст().РезультатВыполнения.Ошибка;
	
КонецФункции // ТЦРезультатВыполненияОшибка()

&НаКлиенте
// Получить результат выполнения "Продолжить" и подключить обработчик
// ТЦОбработчикВыполнения с указанным интервалом, который в свою очередь,
// Периодически выполняет функцию указанную в параметре Обработчик.
//
// Параметры:
//  Интервал - Число, через которое будет вызываться обработчик
//  Однократно - Булево, Признак однократного выполнения обработчика ожидания
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Продолжить
//
Функция ТЦРезультатВыполненияПродолжить(Обработчик, Интервал, Однократно = Ложь)
	
	ТЦИмяОбработчика = Обработчик;
	ПодключитьОбработчикОжидания("ТЦОбработчикВыполнения", Интервал, Однократно);
	Возврат ТЦКонтекст().РезультатВыполнения.Продолжить;
	
КонецФункции // ТЦРезультатВыполненияОшибка()

&НаКлиенте
// Получить статус сообщения "Информация"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦСтатусСообщения.Информация
//
Функция ТЦСтатусСообщенияИнформация()
	
	Возврат ТЦКонтекст().СтатусСообщения.Информация;
	
КонецФункции // ТЦСтатусСообщенияИнформация()

&НаКлиенте
// Получить статус сообщения "Предупреждение"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦСтатусСообщения.Предупреждение
//
Функция ТЦСтатусСообщенияПредупреждение()
	
	Возврат ТЦКонтекст().СтатусСообщения.Предупреждение;
	
КонецФункции // ТЦСтатусСообщенияПредупреждение()

&НаКлиенте
// Получить статус сообщения "Ошибка"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦСтатусСообщения.Ошибка
//
Функция ТЦСтатусСообщенияОшибка()
	
	Возврат ТЦКонтекст().СтатусСообщения.Ошибка;
	
КонецФункции // ТЦСтатусСообщенияОшибка()


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ТЕСТ-ЦЕНТРА

&НаКлиенте
// Обработчик команды "Выполнить".
// Выполняет инициализацию, действие и удаление созданных данных.
//
Процедура ВыполнитьДействие(Команда)
	
	ТЦВыполнитьТестирование(Ложь, Истина);
	
КонецПроцедуры // ВыполнитьДействие()

&НаКлиенте
// Обработчик выполнения действия в случае возврата из ТЦВыполнить результата
// ПеречислениеСсылка.ТЦРезультатВыполнения.ТЦПродолжить
//
Процедура ТЦОбработчикВыполнения()
	
	Попытка
		Результат = Вычислить(ТЦИмяОбработчика + "()");
	Исключение
		ТЦОбщий.ЗаписатьВЖурнал(ИнформацияОбОшибке(), "ВП");
		ТЦЗавершитьВыполнение(
			ТЦКонтекст().РезультатВыполнения.Неопределено,
			Истина,
			ТЦОбщий.ИнформациюОбОшибкеВСтроку(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры // ТЦОбработчикВыполнения()

&НаКлиенте
// Получить контекст выполнения обработки
//
// Возвращаемое значение:
//  Структура - см. ТЦСервер.СоздатьКонтекстВыполненияОбработки()
//
Функция ТЦКонтекст() Экспорт
	
	Если ТЦКонтекстВыполнения = Неопределено Тогда
		ТЦКонтекстВыполнения = ТЦСервер.СоздатьКонтекстВыполненияОбработки();
	КонецЕсли;
	
	Возврат ТЦКонтекстВыполнения;
	
КонецФункции // ТЦКонтекст()

&НаКлиенте
// Загрузить параметры обработки и формы
//
// Параметры:
//  ПараметрыЗагрузки - ХранилищеЗначения
//
Процедура ТЦЗагрузить(ПараметрыЗагрузки) Экспорт
	
	ТЦЗагрузитьНаСервере(ПараметрыЗагрузки);
	ТЦКонтекст();
	
КонецПроцедуры // ТЦЗагрузить()

&НаСервере
// Загрузить параметры обработки.
// Во время загрузки устанавливаются ранее сохраненные значения реквизитов
//
// Параметры:
//  АрхивЗначений - ХранилищеЗначения, загружаемые данные
//
Процедура ТЦЗагрузитьНаСервере(АрхивЗначений)
	
	ТекущийОбъект = РеквизитФормыВЗначение("ТЦОбъект");
	ТЦСервер.ЗагрузитьРеквизитыОбработки(ТекущийОбъект, АрхивЗначений);
	ЗначениеВРеквизитФормы(ТекущийОбъект, "ТЦОбъект");
	
КонецПроцедуры // ТЦЗагрузитьНаСервере()

&НаКлиенте
// Сохранить значения реквизитов для возможности последующей загрузки
//
// Возвращаемое значение:
//  ХранилищеЗначения - запакованые значения реквизитов
//
Функция ТЦСохранить() Экспорт
	
	Возврат ТЦСохранитьНаСервере();
	
КонецФункции // ТЦСохранить()

&НаСервере
// Сохранить значения реквизитов для возможности последующей загрузки
//
// Возвращаемое значение:
//  ХранилищеЗначения - запакованые значения реквизитов
//
Функция ТЦСохранитьНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("ТЦОбъект");
	Возврат ТЦСервер.СохранитьРеквизитыОбработки(ТекущийОбъект);
	
КонецФункции // ТЦСохранитьНаСервере()

&НаКлиенте
// Получить результат выполнения тестирования
//
// Возвращаемое значение:
//  Соответствие - показатели и их значения
//
Функция ТЦПолучитьРезультат() Экспорт
	
	Возврат ТЦКонтекст().Результаты;
	
КонецФункции // ТЦПолучитьРезультат()

&НаКлиенте
// Выполняет инициализацию, действие и удаление созданных данных
Процедура ТЦВыполнитьТестирование(ЗавершатьРаботу = Истина, ПоказыватьОшибки = Ложь)
	
	ТЦКонтекст().ПоказыватьОшибки = ПоказыватьОшибки;
	ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения = ЗавершатьРаботу;
	
	ТЦКонтекстВыполнения.МассивДействий = Новый Массив;
	ТЦКонтекстВыполнения.МассивДействий.Добавить("ТЦИнициализировать()");
	ТЦКонтекстВыполнения.МассивДействий.Добавить("ТЦВыполнить()");
	ТЦКонтекстВыполнения.МассивДействий.Добавить("ТЦУдалитьДанные()");
	
	Для Каждого ТекущееДействие Из ТЦКонтекстВыполнения.МассивДействий Цикл
		
		РезультатВыполнения = ТЦВыполнитьДействиеТеста(ТекущееДействие);

		Если РезультатВыполнения = ТЦКонтекстВыполнения.РезультатВыполнения.Продолжить
			ИЛИ РезультатВыполнения = ТЦРезультатВыполненияОшибка()
			ИЛИ ТЦКонтекстВыполнения.ВозниклоИсключение Тогда

			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения Тогда
		ЗавершитьРаботуСистемы(Ложь, Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Обработчик заверщения выполнения
Процедура ТЦОжиданиеЗавершенияВыполнения()
	
	ЗавершитьВыполнение = Ложь;
	ТекущийРезультатВыполнения = ТЦКонтекст().ТекущийРезультатВыполнения;
	ТекущаяОперация = ТЦКонтекстВыполнения.ТекущаяОперация;
	
	// Возникло исключение
	// или выполнение действия вернуло ошибку
	Если ТЦКонтекстВыполнения.ВозниклоИсключение ИЛИ ТекущийРезультатВыполнения = ТЦРезультатВыполненияОшибка() Тогда
		
		ЗавершитьВыполнение = Истина;
		Пояснение = ?(ТекущийРезультатВыполнения = ТЦРезультатВыполненияОшибка(), "Функция вернула ошибку. ", "");
		
		ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Возникла ошибка при выполнении " + ТекущаяОперация +
														Символы.ПС + Пояснение + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
			
		Если ТЦКонтекстВыполнения.ПоказыватьОшибки Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
			Сообщение.Сообщить();
		КонецЕсли;
	
		ТЦОбщий.ЗаписатьВЖурнал(ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки, "Тест-центр", ТЦСтатусСообщенияОшибка());
	
	// Завершилась часть теста
	ИначеЕсли ТекущийРезультатВыполнения <> Неопределено
		И ТекущийРезультатВыполнения <> ТЦКонтекстВыполнения.РезультатВыполнения.Неопределено
		И ТекущийРезультатВыполнения <> ТЦКонтекстВыполнения.РезультатВыполнения.Продолжить Тогда

		Индекс = ТЦКонтекстВыполнения.МассивДействий.Найти(ТекущаяОперация);
		// Произошла ошибка
		Если Индекс = Неопределено Тогда
			ЗавершитьВыполнение = Истина;
			
		// Все операции выполнены	
		ИначеЕсли Индекс = ТЦКонтекстВыполнения.МассивДействий.ВГраница() Тогда
			ЗавершитьВыполнение = Истина;
			
		// Продолжаем выполнение операций
		Иначе
			ОтключитьОбработчикОжидания("ТЦОжиданиеЗавершенияВыполнения");
			
			МассивДействий = ТЦКонтекстВыполнения.МассивДействий;
			Для Сч = Индекс + 1 По МассивДействий.ВГраница() Цикл
				
				ТекущаяОперация = МассивДействий[Сч];
				РезультатВыполнения = ТЦВыполнитьДействиеТеста(ТекущаяОперация);
				
				Если РезультатВыполнения = ТЦКонтекстВыполнения.РезультатВыполнения.Продолжить
					ИЛИ РезультатВыполнения = ТЦРезультатВыполненияОшибка()
					ИЛИ ТЦКонтекстВыполнения.ВозниклоИсключение Тогда
					Возврат;
				КонецЕсли;
			КонецЦикла;
			
			ЗавершитьВыполнение = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗавершитьВыполнение Тогда
		ОтключитьОбработчикОжидания("ТЦОжиданиеЗавершенияВыполнения");
		Если ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения Тогда
			ЗавершитьРаботуСистемы(Ложь, Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Служебная функция, предназначенная для выполнения указанной процедуры и записи результатов в текстовый файл.
//   Параметры:
//      ИмяПроцедуры - имя тестовой процедуры, которую нужно выполнить.
//						
Функция ТЦВыполнитьДействиеТеста(Знач ИмяФункции)
	
	ТЦКонтекст().ТекущийРезультатВыполнения = Неопределено;
	ТЦКонтекстВыполнения.ВозниклоИсключение = Ложь;
	ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "";
	ТЦКонтекстВыполнения.ТекущаяОперация = ИмяФункции;
	
	Попытка
		РезультатВыполнения = Вычислить(ИмяФункции);

		Если РезультатВыполнения = ТЦРезультатВыполненияОшибка() Тогда
			ТЦВозниклоИсключение = Ложь;
			ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Возникла ошибка при выполнении " + ИмяФункции + Символы.ПС +
															"Функция вернула ошибку. " + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
		КонецЕсли;
		
	Исключение

		РезультатВыполнения = ТЦКонтекст().РезультатВыполнения.Неопределено;
		ТЦКонтекстВыполнения.ВозниклоИсключение = Истина;		
		ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Возникла ошибка при выполнении " + ИмяФункции + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
	КонецПопытки;
				
	Если ТЦКонтекстВыполнения.ВозниклоИсключение ИЛИ РезультатВыполнения = ТЦРезультатВыполненияОшибка() Тогда
		
		Если ТЦКонтекстВыполнения.ПоказыватьОшибки Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
			Сообщение.Сообщить();
		КонецЕсли;
		
		ТЦОбщий.ЗаписатьВЖурнал(ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки, "Тест-центр", ТЦСтатусСообщенияОшибка());
		Если ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения Тогда
			ЗавершитьРаботуСистемы(Ложь, Ложь);
		КонецЕсли;
		
	ИначеЕсли РезультатВыполнения = ТЦКонтекст().РезультатВыполнения.Продолжить Тогда
		ПодключитьОбработчикОжидания("ТЦОжиданиеЗавершенияВыполнения", 1);
	КонецЕсли;
	
	ТЦКонтекстВыполнения.ТекущийРезультатВыполнения = РезультатВыполнения;
	Возврат РезультатВыполнения;
		
КонецФункции	// ВыполнитьДействиеТеста

&НаКлиенте
// Закрыть форму и вернуть значение Истина, для модального вызова
//
Процедура ТЦОК(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры // ТЦОК()
