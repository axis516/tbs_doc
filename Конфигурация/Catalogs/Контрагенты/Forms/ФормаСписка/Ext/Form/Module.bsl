﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Список.Параметры.УстановитьЗначениеПараметра("ЮрЛицо", НСтр("ru = 'Юр. лицо'"));
	Список.Параметры.УстановитьЗначениеПараметра("ФизЛицо", НСтр("ru = 'Физ. лицо'"));
	Список.Параметры.УстановитьЗначениеПараметра("ИП", НСтр("ru = 'ИП'"));
	Список.Параметры.УстановитьЗначениеПараметра("НеРезидент", НСтр("ru = 'Нерезидент'"));
	
	// Отображение состояния контрагентов БЭД
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД") Тогда
		Элементы.ЭДО.Видимость = Ложь;
	КонецЕсли;
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда 
		Элементы.СостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// Кэшируемые значения
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ЕстьДоступныеУчетныеЗаписиДляОтправки = 
		РаботаСПочтовымиСообщениямиВызовСервера.ЕстьДоступныеУчетныеЗаписиДляОтправки();
	
	Делопроизводство.СписокДокументовУсловноеОформлениеПомеченныхНаУдаление(Список);
	НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяФормы + "/ТекущиеДанные", "");
	Если НастройкиФормы = Неопределено Или НастройкиФормы.Получить("ПоказыватьУдаленные") = Неопределено Тогда
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
		УстановитьОтбор();
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
    ПроверкаКонтрагентов.ПриСозданииНаСервереСписокКонтрагентов(Список);
    // Конец СтандартныеПодсистемы.РаботаСКонтрагентами 
	
	// Учет трудозатрат
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Неопределено,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьКонтроля" Тогда
		Если ЗначениеЗаполнено(Параметр.Предмет)
			И ТипЗнч(Параметр.Предмет) = Тип("СправочникСсылка.Контрагенты") Тогда 
			ОповеститьОбИзменении(Параметр.Предмет);
		КонецЕсли;	
	КонецЕсли;
	
	Если (ИмяСобытия = "СозданоНовоеКонтактноеЛицо" Или ИмяСобытия = "ИзменилосьКонтактноеЛицо"
		Или ИмяСобытия = "ИзменилсяКонтрагент") 
		И Параметр.Владелец = ТекущийКонтрагент Тогда
		ОбновитьОбзорКонтрагента();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если Настройки["ПоказыватьУдаленные"] <> Неопределено Тогда
		ПоказыватьУдаленные = Настройки["ПоказыватьУдаленные"];
		Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
		УстановитьОтбор();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) <> "v8doc:" Тогда 
		Возврат;
	КонецЕсли;	
	НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
	
	ПараметрыНажатия = Новый Структура;
	ПараметрыНажатия.Вставить("ТекущийПользователь", ТекущийПользователь);
	ПараметрыНажатия.Вставить("Элемент", Элемент);
	ПараметрыНажатия.Вставить("ЭтаФорма", ЭтаФорма);
	ПараметрыНажатия.Вставить("Объект", ТекущийКонтрагент);
	ПараметрыНажатия.Вставить("ЭтоСписок", Истина);
	
	ДелопроизводствоКлиент.ОбработатьНажатиеНаПолеОбзор(ТекущийКонтрагент,
		НавигационнаяСсылкаПоля, ПараметрыНажатия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("АктивизацияСтрокиСписка", 0.2, Истина);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	УстановитьОтбор();
	
КонецПроцедуры

// Учет времени

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	ПараметрыОповещения = Неопределено;
	НуженДиалог = УчетВремениКлиент.НуженДиалогДляХронометража(ВключенХронометраж, 
		ДатаНачалаХронометража, ВидыРабот);
	
	Если НуженДиалог = Ложь Тогда
		
		ПереключитьХронометражСервер(ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, ТекущиеДанные.Ссылка);
	
	Иначе
		ДлительностьРаботы = УчетВремениКлиент.ПолучитьДлительностьРаботы(ДатаНачалаХронометража);
		
		ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Работа с контрагентом ""%1""'"),
			ТекущиеДанные.Наименование);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ДатаОтчета", ТекущаяДата());
		ПараметрыФормы.Вставить("ВидыРабот", ВидыРабот);
		ПараметрыФормы.Вставить("ОписаниеРаботы", ОписаниеРаботы);
		ПараметрыФормы.Вставить("ДлительностьРаботы", ДлительностьРаботы);
		ПараметрыФормы.Вставить("НачалоРаботы", ДатаНачалаХронометража);
		ПараметрыФормы.Вставить("Объект", ТекущиеДанные.Ссылка);
		ПараметрыФормы.Вставить("СпособУказанияВремени", СпособУказанияВремени);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПереключитьХронометражПродолжение",
			ЭтотОбъект,
			Новый Структура("Объект", ТекущиеДанные.Ссылка));
		
		ОткрытьФорму("РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаДобавленияРаботы", ПараметрыФормы,,,,,
			ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометражПродолжение(Результат, Параметры) Экспорт 
	
	Если Результат <> Неопределено Тогда
		ДобавитьВОтчетИОбновитьФорму(Результат, ПараметрыОповещения);
		УчетВремениКлиент.ПоказатьОповещение(ПараметрыОповещения, ВключенХронометраж, Параметры.Объект);
	Иначе
		ОтключитьХронометражСервер();
	КонецЕсли;  

КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДатаОтчета = ТекущаяДата();
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		ТекущиеДанные.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Ложь,
		ЭтаФорма); // Выполнена
	
КонецПроцедуры

&НаКлиенте
Процедура Трудозатраты(Команда)
	
	ПараметрыФормы = Новый Структура("Источник", ТекущийКонтрагент);
	ОткрытьФорму("РегистрСведений.ФактическиеТрудозатраты.Форма.ФормаСпискаИсточника", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Отправить

&НаКлиенте
Процедура ПроцессСогласование(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Согласование");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессУтверждение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Утверждение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессРассмотрение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Рассмотрение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессИсполнение(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Исполнение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОзнакомление(Команда)
	
	ОткрытьПомощникСозданияОсновныхПроцессов("Ознакомление");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцессОбработка(Команда)
	
	ТипыОпераций = Новый Массив;
	ТипыОпераций.Добавить("КомплексныйПроцесс");
	
	ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникСозданияОсновныхПроцессов(ТипыОпераций)
	
	ВыделенныеСтроки = Новый Массив;
	
	Для Каждого СтрСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(СтрСписка).Ссылка);
	КонецЦикла;
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьПомощникСозданияОсновныхПроцессов(
		ТипыОпераций, ВыделенныеСтроки, ЭтаФорма, "ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
		
	Раздел = ПредопределенноеЗначение("Перечисление.РазделыОтчетов.КонтрагентыСписок");
	
	ЗаголовокФормы = НСтр("ru = 'Отчеты по контрагентам'");
	
	ПараметрыФормы = Новый Структура("Раздел, ЗаголовокФормы, НеОтображатьИерархию, ", 
										Раздел, ЗаголовокФормы, Истина, );
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма.ФормаПоКатегориям",
		ПараметрыФормы,
		ЭтаФорма, 
		"КонтрагентыСписок");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	Если Не ПоказыватьУдаленные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь,
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "ПометкаУдаления");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущийКонтрагент) Тогда 
		ОбновитьОбзорКонтрагента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизацияСтрокиСписка()
	
	Если ТекущийКонтрагент <> Элементы.Список.ТекущаяСтрока Тогда
		ТекущийКонтрагент = Элементы.Список.ТекущаяСтрока;
		ОбновитьПараметрыУчетаВремениВФорме();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОбзорКонтрагента()
	
	ПредставлениеHTML = ОбзорКонтрагента.ПолучитьОбзорКонтрагента(
		ТекущийКонтрагент, ПоказыватьУдаленные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Хронометраж

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	Если ТекущийКонтрагент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УчетВремени.ПереключитьХронометражСервер(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущийКонтрагент,
		ВидыРабот,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
	    ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	Если ТекущийКонтрагент = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УчетВремени.ОтключитьХронометражСервер(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ТекущийКонтрагент,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыУчетаВремениВФорме()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено 
		Или ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Элементы.ПереключитьХронометраж.Доступность = Ложь;
		Элементы.УказатьТрудозатраты.Доступность = Ложь;
		ПредставлениеHTML = "";
		Возврат;
	КонецЕсли;
	
	ТекущийКонтрагент = ТекущиеДанные.Ссылка;
	
	ПараметрыУчетаВремени = ПолучитьПараметрыУчетаВремени(ТекущиеДанные.Ссылка);
	
	ДатаНачалаХронометража = ПараметрыУчетаВремени.ДатаНачалаХронометража;
	ДатаКонцаХронометража = ПараметрыУчетаВремени.ДатаКонцаХронометража;
	ВключенХронометраж = ПараметрыУчетаВремени.ВключенХронометраж;
	ОпцияИспользоватьУчетВремени = ПараметрыУчетаВремени.ОпцияИспользоватьУчетВремени;
	ВидыРабот = ПараметрыУчетаВремени.ВидыРабот;
	СпособУказанияВремени = ПараметрыУчетаВремени.СпособУказанияВремени;
	
	Для Каждого СвойствоЭлемента Из ПараметрыУчетаВремени.ПереключитьХронометраж Цикл
		Элементы.ПереключитьХронометраж[СвойствоЭлемента.Ключ] = СвойствоЭлемента.Значение;
	КонецЦикла;
	
	Для Каждого СвойствоЭлемента Из ПараметрыУчетаВремени.УказатьТрудозатраты Цикл
		Элементы.УказатьТрудозатраты[СвойствоЭлемента.Ключ] = СвойствоЭлемента.Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыУчетаВремени(Документ)
	
	Результат = Новый Структура;
	
	ДатаНачалаХронометража = Неопределено;
	ДатаКонцаХронометража = Неопределено;
	ВключенХронометраж = Неопределено;
	ОпцияИспользоватьУчетВремени = Неопределено;
	ВидыРабот = Неопределено;
	СпособУказанияВремени = Неопределено;
	
	ПереключитьХронометражНеМеняяПодсказку = Новый Структура("Имя, Подсказка");
	
	ПереключитьХронометраж = Новый Структура("Доступность, Пометка, Видимость");
	ПереключитьХронометраж.Доступность = Истина;
	
	УказатьТрудозатраты = Новый Структура("Доступность");
	УказатьТрудозатраты.Доступность = Истина;
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Документ,
		ВидыРабот,
		СпособУказанияВремени,
		ПереключитьХронометражНеМеняяПодсказку,
		ПереключитьХронометраж,
		УказатьТрудозатраты);
		
	Результат.Вставить("ПереключитьХронометраж", Новый Соответствие);
	Результат.Вставить("УказатьТрудозатраты", Новый Соответствие);
	
	Результат.ПереключитьХронометраж.Вставить(
		"Доступность",
		ПереключитьХронометраж.Доступность);
	Результат.ПереключитьХронометраж.Вставить(
		"Пометка",
		ПереключитьХронометраж.Пометка);
	Результат.УказатьТрудозатраты.Вставить(
		"Доступность",
		УказатьТрудозатраты.Доступность);
	
	Результат.Вставить("ДатаНачалаХронометража", ДатаНачалаХронометража);
	Результат.Вставить("ДатаКонцаХронометража", ДатаКонцаХронометража);
	Результат.Вставить("ВключенХронометраж", ВключенХронометраж);
	Результат.Вставить("ОпцияИспользоватьУчетВремени", ОпцияИспользоватьУчетВремени);
	Результат.Вставить("ВидыРабот", ВидыРабот);
	Результат.Вставить("СпособУказанияВремени", СпособУказанияВремени);
	
	ОбновитьОбзорКонтрагента();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
