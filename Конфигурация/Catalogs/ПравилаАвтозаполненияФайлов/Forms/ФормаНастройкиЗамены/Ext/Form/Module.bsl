﻿
&НаКлиенте
Процедура Выбрать(Команда)
	
	Если НРег(Команда.Имя) = "ок" Тогда
		
		ОчиститьСообщения();
		Если НЕ ПроверитьЗаполнение() Тогда
			Возврат;
		КонецЕсли;
		
		Модифицированность = Ложь;
		Если ТипЗаменяемыхДанных = "ИмяПоля"
			И Элементы.ИмяПоля.ТолькоПросмотр = Ложь
			И Элементы.ИмяПоля.Доступность Тогда
			СтрокаИмяПоля = ИмяПоля;
			СтрПодстрокаПоиска = "";
		КонецЕсли;
		
		Если ТипЗаменяемыхДанных = "ПодстрокаПоиска"
			И Элементы.ПодстрокаПоиска.ТолькоПросмотр = Ложь
			И Элементы.ПодстрокаПоиска.Доступность Тогда
			СтрокаИмяПоля = "";
			СтрПодстрокаПоиска = ПодстрокаПоиска;
		КонецЕсли;
		
		СтруктураВозврата = Новый Структура;

		СтруктураВозврата.Вставить("ИмяПоля", СтрокаИмяПоля );
		СтруктураВозврата.Вставить("ПодстрокаПоиска", СтрПодстрокаПоиска);
		СтруктураВозврата.Вставить("СписокПолейШаблона", СписокПолей);
		Если ВариантЗаполнения = "ЗначениеРеквизита" Тогда
			СтруктураВозврата.Вставить("ЗначениеЗамены", ЗначениеЗамены);
			СтруктураВозврата.Вставить("ФорматЗначенияЗамены", ФорматЗначенияЗамены);
			СтруктураВозврата.Вставить("ТипЗначенияЗамены", ТипЗначенияЗамены);
			СтруктураВозврата.Вставить("Выражение", "");
		Иначе
			СтруктураВозврата.Вставить("ЗначениеЗамены", "");
			СтруктураВозврата.Вставить("ФорматЗначенияЗамены", "");
			СтруктураВозврата.Вставить("ТипЗначенияЗамены", "");
			СтруктураВозврата.Вставить("Выражение", ТекстВыражения);
		КонецЕсли;
        				
		ОповеститьОЗаписиНового(СтруктураВозврата);
		Закрыть(СтруктураВозврата);
	Иначе
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.СписокПолей <> Неопределено
		И Параметры.СписокПолей.Количество() > 0 Тогда
		СписокПолей.Очистить();
		Для Каждого Поле Из Параметры.СписокПолей Цикл
			НоваяСтрока = СписокПолей.Добавить();
			НоваяСтрока.Наименование = Поле.Наименование;
		КонецЦикла;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Параметры.ИмяПоля) Тогда
		ИмяПоля = Параметры.ИмяПоля;
		ТипЗаменяемыхДанных = "ИмяПоля";
		Элементы.ПодстрокаПоиска.ТолькоПросмотр = Истина;
	ИначеЕсли НЕ ПустаяСтрока(Параметры.ПодстрокаПоиска) Тогда
		ПодстрокаПоиска = Параметры.ПодстрокаПоиска;
		ТипЗаменяемыхДанных = "ПодстрокаПоиска";
		Элементы.ИмяПоля.ТолькоПросмотр = Истина;
	Иначе
		ТипЗаменяемыхДанных = "ИмяПоля";
		Элементы.ПодстрокаПоиска.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ТипЗаменяемыхДанных = "ИмяПоля" Тогда
		Элементы.ИмяПоля.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ИмяПоля);
		Элементы.ПодстрокаПоиска.ОтметкаНезаполненного = Ложь;
	ИначеЕсли ТипЗаменяемыхДанных = "ПодстрокаПоиска" Тогда
		Элементы.ПодстрокаПоиска.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ПодстрокаПоиска);
		Элементы.ИмяПоля.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	Если НЕ Параметры.ДоступностьПоля Тогда
		Элементы.ИмяПоля.Видимость = Ложь;
		Элементы.ТипЗаменяемыхДанных.Видимость = Ложь;
		Элементы.ПодстрокаПоиска.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		Элементы.ПодстрокаПоиска.ТолькоПросмотр = Ложь;
		ТипЗаменяемыхДанных = "ПодстрокаПоиска";
	КонецЕсли;
	ЗначениеЗамены = Параметры.ЗначениеЗамены;
	ТипДокумента = Параметры.ТипДокумента;
	ШаблонФайла = Параметры.ШаблонФайла;
	ФорматЗначенияЗамены = "";
	Если Параметры.Свойство("ФорматЗначенияЗамены") Тогда
		ФорматЗначенияЗамены = Параметры.ФорматЗначенияЗамены;
	КонецЕсли;
	ТипЗначенияЗамены = "";
	Если Параметры.Свойство("ТипЗначенияЗамены") Тогда
		ТипЗначенияЗамены = Параметры.ТипЗначенияЗамены;
	КонецЕсли;
	
	Элементы.УстановитьФормат.Видимость = Ложь;
	Попытка
		Если ЗначениеЗаполнено(ТипЗначенияЗамены) 
			И (Тип(ТипЗначенияЗамены) = Тип("Дата")
			Или Тип(ТипЗначенияЗамены) = Тип("Булево")
			Или Тип(ТипЗначенияЗамены) = Тип("Число")) Тогда	
			Элементы.УстановитьФормат.Видимость = Истина;
			Если ЗначениеЗаполнено(ФорматЗначенияЗамены) Тогда
				Элементы.УстановитьФормат.Заголовок = НСтр("ru = 'Формат установлен'");
			КонецЕсли;	
		КонецЕсли;
	Исключение
		// тип значения замены - не примитивный
	КонецПопытки;
		
	ТипШаблонаФайла = НРег(Параметры.ШаблонФайла.ТекущаяВерсияРасширение);
	
	ВыполнятьЗаполнениеФайловНаСервере = Константы.ИзменениеФайловMSWordТолькоНаСервере.Получить();
	ВладелецФайла = Параметры.ВладелецФайла;
	ТекстВыражения = Параметры.Выражение;
	
	Если ЗначениеЗаполнено(ТекстВыражения) Тогда
		ВариантЗаполнения = "РезультатВыполненияВыражения";
		Элементы.ГруппаЗначениеЗамены.Доступность = Ложь;
		Элементы.ТекстВыражения.Доступность = Истина;
		Элементы.ТекстВыражения.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ТекстВыражения);
		Элементы.ЗначениеЗамены.ОтметкаНезаполненного = Ложь;		
	Иначе
		ВариантЗаполнения = "ЗначениеРеквизита";
		Элементы.ГруппаЗначениеЗамены.Доступность = Истина;
		Элементы.ТекстВыражения.Доступность = Ложь;
		Элементы.ЗначениеЗамены.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ЗначениеЗамены);
		Элементы.ТекстВыражения.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗаменяемыхДанныхПриИзменении(Элемент)
	
	Если ТипЗаменяемыхДанных = "ИмяПоля" Тогда
		Элементы.ПодстрокаПоиска.ТолькоПросмотр = Истина;
		Элементы.ИмяПоля.ТолькоПросмотр = Ложь;
		Элементы.ИмяПоля.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ИмяПоля);
		Элементы.ПодстрокаПоиска.ОтметкаНезаполненного = Ложь;
	ИначеЕсли ТипЗаменяемыхДанных = "ПодстрокаПоиска" Тогда
		Элементы.ИмяПоля.ТолькоПросмотр = Истина;
		Элементы.ПодстрокаПоиска.ТолькоПросмотр = Ложь;
		Элементы.ПодстрокаПоиска.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ПодстрокаПоиска);
		Элементы.ИмяПоля.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПоляПриИзменении(Элемент)
		
	Элементы.ИмяПоля.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ИмяПоля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодстрокаПоискаПриИзменении(Элемент)
	
	Элементы.ПодстрокаПоиска.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ПодстрокаПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеЗаменыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Родитель = ВыбранноеЗначение.ОбъектРодитель;
	Если Родитель = "Файл" Тогда
		ЗначениеЗамены = "{" + ВыбранноеЗначение.Наименование + "}";
	ИначеЕсли Лев(Родитель, 5) = "Файл|" Тогда
		ЗначениеЗамены = "{" + Прав(Родитель, СтрДлина(Родитель) - 5)
			+ "|" + ВыбранноеЗначение.Наименование + "}";
	Иначе
		ЗначениеЗамены = "{" + Родитель + "|" + ВыбранноеЗначение.Наименование + "}";
	КонецЕсли;
	
	ТипЗначенияЗамены = ВыбранноеЗначение.Тип;
	ФорматЗначенияЗамены = "";
	Элементы.УстановитьФормат.Видимость = Ложь;
	Попытка
		Если Тип(ТипЗначенияЗамены) = Тип("Дата")
			Или Тип(ТипЗначенияЗамены) = Тип("Булево")
			Или Тип(ТипЗначенияЗамены) = Тип("Число") Тогда	
			Элементы.УстановитьФормат.Видимость = Истина;
			Если ЗначениеЗаполнено(ФорматЗначенияЗамены) Тогда
				Элементы.УстановитьФормат.Заголовок = НСтр("ru = 'Формат установлен'");
			КонецЕсли;		
		КонецЕсли;
	Исключение
		// тип значения замены - не примитивный
	КонецПопытки;
	
	Модифицированность = Истина;
	СтандартнаяОбработка = Ложь;
	Элементы.ЗначениеЗамены.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ЗначениеЗамены);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПоляОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИмяПоля = ВыбранноеЗначение.НаименованиеПоля;
	
	Если ВыбранноеЗначение.СписокПолей.Количество() > 0 Тогда
		СписокПолей.Очистить();
		Для Каждого Поле Из ВыбранноеЗначение.СписокПолей Цикл
			НоваяСтрока = СписокПолей.Добавить();
			НоваяСтрока.Наименование = Поле.Наименование;
		КонецЦикла;
	КонецЕсли;
	Элементы.ИмяПоля.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ИмяПоля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
	Если НЕ ВыполнятьЗаполнениеФайловНаСервере 
		И СписокПолей.Количество() = 0 
		И ТипШаблонаФайла = "doc" Тогда
		Элементы.ИмяПоля.КнопкаВыбора = Ложь;
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПоляНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ФайлШаблон, СписокПолей", ШаблонФайла, СписокПолей);
	ОткрытьФорму(
		"Справочник.ПравилаАвтозаполненияФайлов.Форма.ФормаВыбораПоляВФайле", 
		ПараметрыФормы, 
		ЭтаФорма.Элементы.ИмяПоля,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеЗаменыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("ТипДокумента, ЗначениеРеквизита, ВладелецФайла");
	ПараметрыФормы.ТипДокумента = ТипДокумента;
	ПараметрыФормы.ЗначениеРеквизита = СтрЗаменить(СтрЗаменить(ЗначениеЗамены, "{", ""), "}", "");
	ПараметрыФормы.ВладелецФайла = ВладелецФайла;
	ОткрытьФорму(
		"Справочник.ПравилаАвтозаполненияФайлов.Форма.ФормаВыбораРеквизита", 
		ПараметрыФормы, 
		ЭтаФорма.Элементы.ЗначениеЗамены,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПередЗакрытиемПродолжение",
			ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные формы были изменены. При закрытии изменения не будут учтены.
			|Действительно закрыть форму?'");
		ПоказатьВопрос(
			ОписаниеОповещения,
			ТекстВопроса, 
			РежимДиалогаВопрос.ДаНет, 
			,
			КодВозвратаДиалога.Нет);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(Результат, Параметры) Экспорт
		
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФормат(Команда)
	
	Конструктор = Новый КонструкторФорматнойСтроки(ФорматЗначенияЗамены);
	Конструктор.ДоступныеТипы = Новый ОписаниеТипов(ТипЗначенияЗамены);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УстановитьФорматПродолжение",
		ЭтотОбъект);
	Конструктор.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФорматПродолжение(Текст, Параметры) Экспорт
	
	// Нажали "Отмену"
	Если Текст = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ФорматЗначенияЗамены = Текст;
	Если ЗначениеЗаполнено(ФорматЗначенияЗамены) Тогда
		Элементы.УстановитьФормат.Заголовок = НСтр("ru = 'Формат установлен'");
	Иначе
		Элементы.УстановитьФормат.Заголовок = НСтр("ru = 'Формат не установлен'");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеЗаменыПриИзменении(Элемент)
	
	ФорматЗначенияЗамены = "";
	ТипЗначенияЗамены = "";
	Элементы.УстановитьФормат.Видимость = Ложь;
	Элементы.ЗначениеЗамены.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ЗначениеЗамены);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияПриИзменении(Элемент)
	
	Если ВариантЗаполнения = "РезультатВыполненияВыражения" Тогда
		Элементы.ГруппаЗначениеЗамены.Доступность = Ложь;
		Элементы.ТекстВыражения.Доступность = Истина;
		Элементы.ТекстВыражения.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ТекстВыражения);
		Элементы.ЗначениеЗамены.ОтметкаНезаполненного = Ложь;
	Иначе 
		Элементы.ГруппаЗначениеЗамены.Доступность = Истина;
		Элементы.ТекстВыражения.Доступность = Ложь;
		Элементы.ЗначениеЗамены.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ЗначениеЗамены);
		Элементы.ТекстВыражения.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипЗаменяемыхДанных = "ИмяПоля" Тогда
		ПроверяемыеРеквизиты.Добавить("ИмяПоля");
	ИначеЕсли ТипЗаменяемыхДанных = "ПодстрокаПоиска" Тогда
		ПроверяемыеРеквизиты.Добавить("ПодстрокаПоиска");
	КонецЕсли;
	
	Если ВариантЗаполнения = "РезультатВыполненияВыражения" Тогда
		ПроверяемыеРеквизиты.Добавить("ТекстВыражения");
	Иначе 
		ПроверяемыеРеквизиты.Добавить("ЗначениеЗамены");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстВыраженияПриИзменении(Элемент)
	
	Элементы.ТекстВыражения.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(ТекстВыражения);
	
КонецПроцедуры

