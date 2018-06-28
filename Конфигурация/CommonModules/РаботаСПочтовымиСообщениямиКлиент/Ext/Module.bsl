﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Интерфейсная клиентская функция, поддерживающая упрощенный вызов формы редактирования
// нового письма.
// Параметры
// Отправитель*  - СписокЗначений, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - 
//                 учетная запись ,с которой может быть отправлено
//                 почтовое сообщение. Если тип список значений, тогда
//                   представление - наименование учетной записи,
//                   значение - ссылка на учетную запись
//
// Получатель      - СписокЗначений, Строка:
//                   если список значений, то представление - имя получателя
//                                            значение      - почтовый адрес
//                   если строка то список почтовых адресов,
//                   в формате правильного e-mail адреса*
//
// Тема            - Строка - тема письма
// Текст           - Строка - тело письма
//
// СписокФайлов    - СписокЗначений, где
//                   представление - строка - наименование вложения
//                   значение      - ДвоичныеДанные - двоичные данные вложения
//                                 - Строка - адрес файла во временном хранилище
//                                 - Строка - путь к файлу на клиенте
//
// УдалятьФайлыПослеОтправки - булево - удалять временные файлы после отправки сообщения
// ПисьмоДолжноСохраняться   - булево - должно ли письмо сохраняться (используется только
//                                      если встроена подсистема Взаимодействия)
//
Процедура ОткрытьФормуОтправкиПочтовогоСообщения(знач Отправитель = Неопределено,
												знач Получатель = Неопределено,
												знач Тема = "",
												знач Текст = "",
												знач СписокФайлов = Неопределено,
												знач УдалятьФайлыПослеОтправки = Ложь,
												знач ПисьмоДолжноСохраняться = Истина,
												знач Основание = Неопределено) Экспорт
												
	ИспользованиеЛегкойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеЛегкойПочты");
	ИспользованиеВстроеннойПочты = ПолучитьФункциональнуюОпциюИнтерфейса("ИспользованиеВстроеннойПочты");
												
	Если Не ИспользованиеЛегкойПочты И Не ИспользованиеВстроеннойПочты Тогда
		ТекстСообщения = НСтр("ru = 'Для отправки письма требуется включить использование встроенной или легкой почты.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ИспользованиеВстроеннойПочты Тогда		
				
		ПараметрыОткрытия = Новый Структура;
		
		Если ЗначениеЗаполнено(Получатель) Тогда 
			СписокПочтовыхАдресов = Новый СписокЗначений;
			АдресИнфо = Новый Структура("Контакт, Адрес, ОтображаемоеИмя",
				"", Получатель, "");
			СписокПочтовыхАдресов.Добавить(АдресИнфо);
			ПараметрыОткрытия.Вставить("СписокПочтовыхАдресов", СписокПочтовыхАдресов);
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Основание) Тогда 
			ПараметрыОткрытия.Вставить("Основание", Основание);
		КонецЕсли;
		
		Если СписокФайлов <> Неопределено Тогда 
			
			Если ТипЗнч(СписокФайлов) = Тип("Массив") Тогда
				
				ПараметрыОткрытия.Вставить("СписокФайлов", СписокФайлов);
				
			ИначеЕсли ТипЗнч(СписокФайлов) = Тип("СписокЗначений") Тогда
				
				МассивФайлов = Новый Массив;
				Для Каждого Строка Из СписокФайлов Цикл
					МассивФайлов.Добавить(
						Новый Структура("Представление, АдресВоВременномХранилище", 
						Строка.Представление, Строка.Значение));
				КонецЦикла;	
				ПараметрыОткрытия.Вставить("СписокФайлов", МассивФайлов);
				
			КонецЕсли;			
			
		КонецЕсли;	
		
		ОткрытьФорму("Документ.ИсходящееПисьмо.ФормаОбъекта", ПараметрыОткрытия);
			
	ИначеЕсли ИспользованиеЛегкойПочты Тогда
		ПараметрКоманды = Новый Массив;
		
		Если ЗначениеЗаполнено(Основание) Тогда 
			ПараметрКоманды.Добавить(Основание);
		КонецЕсли;	

		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Объекты", ПараметрКоманды);
		ПараметрыОткрытия.Вставить("Кому",    Получатель);
		
		Если СписокФайлов <> Неопределено Тогда 
			
			Если ТипЗнч(СписокФайлов) = Тип("Массив") Тогда
				
				ПараметрыОткрытия.Вставить("СписокФайлов", СписокФайлов);
				
			ИначеЕсли ТипЗнч(СписокФайлов) = Тип("СписокЗначений") Тогда
				
				МассивФайлов = Новый Массив;
				Для Каждого Строка Из СписокФайлов Цикл
					МассивФайлов.Добавить(
						Новый Структура("Представление, АдресВоВременномХранилище", 
						Строка.Представление, Строка.Значение));
				КонецЦикла;	
				ПараметрыОткрытия.Вставить("СписокФайлов", МассивФайлов);
				
			КонецЕсли;			
			
		КонецЕсли;	
		
		ОткрытьФорму(
			"Обработка.ПочтовоеСообщение.Форма.Форма",
			ПараметрыОткрытия,,
			Новый УникальныйИдентификатор);
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет проверку учетной записи.
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//					которую нужно проверить.
//
Процедура ПроверитьУчетнуюЗапись(знач УчетнаяЗапись) Экспорт
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Проверка учетной записи'"),,НСтр("ru = 'Выполняется проверка учетной записи. Подождите...'"));
	ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(Неопределено, УчетнаяЗапись);
	
КонецПроцедуры

// Проверка учетной записи электронной почты.
//
// См. описание процедуры РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(ОбработчикРезультата, УчетнаяЗапись)
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	РаботаСПочтовымиСообщениямиВызовСервера.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, СообщениеОбОшибке, ДополнительноеСообщение);
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		ПоказатьПредупреждение(ОбработчикРезультата, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками:
					   |%1'"), СообщениеОбОшибке ),,
			НСтр("ru = 'Проверка учетной записи'"));
	Иначе
		ПоказатьПредупреждение(ОбработчикРезультата, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась успешно. %1'"),
			ДополнительноеСообщение),,
			НСтр("ru = 'Проверка учетной записи'"));
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму создания нового письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - параметры для заполнения в форме отправки нового письма (все необязательные):
//    * Отправитель - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись, с которой может
//                    быть отправлено почтовое сообщение;
//                  - СписокЗначений - список учетных записей, доступных для выбора в форме:
//                      ** Представление - Строка- наименование учетной записи;
//                      ** Значение - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись.
//    
//    * Получатель - список почтовых адресов.
//        - Строка - список адресов в формате:
//            [ПредставлениеПолучателя1] <Адрес1>; [[ПредставлениеПолучателя2] <Адрес2>;...]
//        - СписокЗначений - Список адресов.
//            ** Представление - Строка - представление получателя,
//            ** Значение      - Строка - почтовый адрес.
//    
//    * Тема - Строка - тема письма.
//    
//    * Текст - Строка - тело письма.
//    
//    * Вложения - Массив - файлы, которые необходимо приложить к письму (описания в виде структур):
//        ** Структура - описание вложения:
//             *** Представление - Строка - имя файла вложения;
//             *** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//             *** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//             *** Идентификатор - Строка - (необязательный) используется для отметки картинок, отображаемых в теле письма.
//
//    * УдалятьФайлыПослеОтправки - Булево - удалять временные файлы после отправки сообщения.
//  
//  ОповещениеОЗакрытииФормы - ОписаниеОповещения - процедура, в которую необходимо передать управление после закрытия
//                           формы отправки письма.
//
Процедура СоздатьНовоеПисьмо(ПараметрыОтправки = Неопределено, ОповещениеОЗакрытииФормы = Неопределено) Экспорт
	
	Если ПараметрыОтправки = Неопределено Тогда
		ПараметрыОтправки = Новый Структура;
	КонецЕсли;
	ПараметрыОтправки.Вставить("ОповещениеОЗакрытииФормы", ОповещениеОЗакрытииФормы);
	
	Получатель = "";
	Если ПараметрыОтправки.Свойство("Получатель") Тогда
		Получатель = ПараметрыОтправки.Получатель;
	КонецЕсли;	
	
	Вложения = Неопределено;
	Если ПараметрыОтправки.Свойство("Вложения") Тогда
		Вложения = ПараметрыОтправки.Вложения;
	КонецЕсли;	
	
	ОткрытьФормуОтправкиПочтовогоСообщения(, Получатель,,, Вложения);
	
КонецПроцедуры

// Если у пользователя нет настроенной учетной записи для отправки писем, то в зависимости от прав либо показывает
// помощник настройки новой учетной записи, либо выводит сообщение о невозможности отправки.
// Предназначена для сценариев, в которых требуется выполнить настройку учетной записи перед запросом дополнительных
// параметров отправки.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещение - процедура, в которую необходимо передать выполнение кода после проверки.
//                                              В качестве результата возвращается Истина, если есть доступная учетная
//                                              запись для отправки почты. Иначе возвращается Ложь.
Процедура ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОбработчикРезультата) Экспорт
	Если РаботаСПочтовымиСообщениямиВызовСервера.ЕстьДоступныеУчетныеЗаписиДляОтправки() Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	Иначе
		Если РаботаСПочтовымиСообщениямиВызовСервера.ДоступноПравоДобавленияУчетныхЗаписей() Тогда
			ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.Форма.ФормаЭлемента", 
				Новый Структура("КонтекстныйРежим", Истина), , , , , ОбработчикРезультата);
		Иначе	
			ТекстСообщения = НСтр("ru = 'Для отправки письма требуется настройка учетной записи электронной почты.
				|Обратитесь к администратору.'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочтыЗавершение", ЭтотОбъект, ОбработчикРезультата);
			ПоказатьПредупреждение(ОписаниеОповещения, ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// УСТАРЕВШИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочтыЗавершение(ОбработчикРезультата) Экспорт
	ВыполнитьОбработкуОповещения(ОбработчикРезультата, Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Отправляет табличные документы по электронной почте.
//
// Параметры:
//   ТабличныеДокументы - СписокЗначений - Табличные документы для отправки.
//       * Значение - ТабличныйДокумент - Отправляемый документ.
//       * Представление - Строка - Наименование документа.
//           Используется при сохранении в файл и для вложений.
//   Заголовок - Строка - Необязательный. Заголовок диалога сохранения табличных документов в файл.
//   ПараметрыОтправки - Структура - Необязательный. Параметры письма.
//       * Тема  - Строка - Тема письма.
//       * Текст - Строка - Текст письма.
//
// Порядок работы:
//   1. Проверяется наличие учетной записи, настроенной для отправки.
//      Если учетной записи нет, то открывается помощник настройки.
//   2. Открывается диалог сохранения табличных документов в файлы.
//      Табличные документы сохраняются в файлы.
//   3. Открывается диалог отправки письма.
//
Процедура ОтправитьТабличныеДокументы(ТабличныеДокументы, ЗаголовокСохранения = Неопределено, ПараметрыОтправки = Неопределено) Экспорт
	Контекст = Новый Структура;
	Контекст.Вставить("ТабличныеДокументы", ТабличныеДокументы);
	Контекст.Вставить("Заголовок",          ЗаголовокСохранения);
	Контекст.Вставить("ПараметрыОтправки",  ПараметрыОтправки);
	Обработчик = Новый ОписаниеОповещения("ОтправитьТабличныеДокументыПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, Контекст);
	ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(Обработчик);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры ОтправитьТабличныеДокументы.
Процедура ОтправитьТабличныеДокументыПроверкаУчетнойЗаписиВыполнена(УчетнаяЗаписьНастроена, Контекст) Экспорт
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ТабличныеДокументы, Заголовок");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Контекст);
	
	Обработчик = Новый ОписаниеОповещения("ОтправитьТабличныеДокументыСохранениеВыполнено", ЭтотОбъект, Контекст);
	
	ОткрытьФорму("ОбщаяФорма.ОтправкаТабличныхДокументовПоПочте", ПараметрыФормы, , , , , Обработчик);
КонецПроцедуры

// Продолжение процедуры ОтправитьТабличныеДокументыПроверкаУчетнойЗаписиВыполнена.
Процедура ОтправитьТабличныеДокументыСохранениеВыполнено(СохраненныеДокументы, Контекст) Экспорт
	Если СохраненныеДокументы = Неопределено Или СохраненныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = Контекст.ПараметрыОтправки;
	Если ТипЗнч(ПараметрыОтправки) <> Тип("Структура") Тогда
		ПараметрыОтправки = Новый Структура;
	КонецЕсли;
	
	Вложения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОтправки, "Вложения");
	Если ТипЗнч(Вложения) = Тип("СписокЗначений") И Вложения.Количество() > 0 Тогда
		Для Каждого ДокументВложение Из СохраненныеДокументы Цикл
			ЗаполнитьЗначенияСвойств(Вложения.Добавить(), ДокументВложение);
		КонецЦикла;
	Иначе
		ПараметрыОтправки.Вставить("Вложения", СохраненныеДокументы);
	КонецЕсли;
	
	УдалятьФайлыПослеОтправки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОтправки, "УдалятьФайлыПослеОтправки");
	Если ТипЗнч(УдалятьФайлыПослеОтправки) <> Тип("Булево") Тогда
		ПараметрыОтправки.Вставить("УдалятьФайлыПослеОтправки", Истина);
	КонецЕсли;
	
	СоздатьНовоеПисьмо(ПараметрыОтправки);
КонецПроцедуры

#КонецОбласти
