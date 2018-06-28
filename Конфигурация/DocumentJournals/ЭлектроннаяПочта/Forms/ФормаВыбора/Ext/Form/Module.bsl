﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Папка", Справочники.ПапкиПисем.ПустаяСсылка());
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователи.ТекущийПользователь());
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());
	
	Если Параметры.Свойство("ОтображатьУдаленные") Тогда
		ОтображатьУдаленные = Параметры.ОтображатьУдаленные;
	Иначе
		ОтображатьУдаленные =
			ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("ОтображатьУдаленныеПисьмаИПапки");
	КонецЕсли;
	
	Если Параметры.Свойство("КоличествоПисем") Тогда
		ПредставлениеКоличествоПисем = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' (%1 шт)'"),
			Параметры.КоличествоПисем);
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + ПредставлениеКоличествоПисем;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимМоиПапки") Тогда
		РежимМоиПапки = Параметры.РежимМоиПапки;
	Иначе
		РежимМоиПапки = ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("РежимМоиПапки");
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокКнопкиГотово") Тогда
		Элементы.Перенести.Заголовок = Параметры.ЗаголовокКнопкиГотово;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
		
	ЗаполнитьДеревоПапок();
	
	СостояниеДереваПапок = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ЭтаФорма.ИмяФормы, 
		"СостояниеДерева", 
		Неопределено);
	Если СостояниеДереваПапок = Неопределено И Параметры.Свойство("СостояниеДереваПапок") Тогда
		СостояниеДереваПапок = Параметры.СостояниеДереваПапок;
	КонецЕсли;
	
	// Предназначена для заполнения дерева переноса при первом открытии формы пользователем
	ДеревоПереносаИнициализировано =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ПереносПисем",
			"ДеревоПереносаИнициализировано",
			Ложь);
			
	Если Не ДеревоПереносаИнициализировано Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			ЭтаФорма.ИмяФормы, 
			"СостояниеДерева", 
			СостояниеДереваПапок);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ПереносПисем", 
			"ДеревоПереносаИнициализировано", 
			Истина);	
	КонецЕсли;
		
	Если СостояниеДереваПапок <> Неопределено Тогда
		ВыбраннаяПапка = СостояниеДереваПапок.ТекСсылка;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СостояниеДереваПапок <> Неопределено Тогда
		ВосстановитьСостояниеДереваПапок(СостояниеДереваПапок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПапкаПисемСохранена" Тогда
		СостояниеДерева = ЗапомнитьСостояниеДереваПапок();
		ЗаполнитьДеревоПапок();
		СостояниеДерева.ТекСсылка = Параметр;
		ВосстановитьСостояниеДереваПапок(СостояниеДерева);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПапкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПапкиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ - РАБОТА С ДЕРЕВОМ ПАПОК

&НаКлиенте
Процедура ОбойтиДерево(ДеревоЭлементы, Контекст, ИмяПроцедуры)
	
	Для каждого Элемент Из ДеревоЭлементы Цикл
		// Рекурсивный вызов
		ОбойтиДерево(Элемент.ПолучитьЭлементы(), Контекст, ИмяПроцедуры);
		Результат = Вычислить(ИмяПроцедуры + "(Элемент, Контекст)");
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ЗапомнитьСостояниеДереваПапок()
	
	Состояние = Новый Структура;
	Состояние.Вставить("ТекСсылка", Неопределено);
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		ТекущиеДанные = Элементы.Папки.ТекущиеДанные;
		Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
			Состояние.ТекСсылка = ТекущиеДанные.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", Папки);
	Контекст.Вставить("ФормаДерево", Элементы.Папки);
	Контекст.Вставить("Состояние", Новый Соответствие);
	ОбойтиДерево(Папки.ПолучитьЭлементы(), Контекст, "ЗапомнитьСостояниеРазвернут");
	Состояние.Вставить("Развернут", Контекст.Состояние);
	
	Возврат Состояние;
	
КонецФункции

&НаКлиенте
Функция ЗапомнитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Контекст.Состояние.Вставить(ТекДанные.Ссылка, Контекст.ФормаДерево.Развернут(ИдентификаторСтроки));
	
КонецФункции

&НаКлиенте
Процедура ВосстановитьСостояниеДереваПапок(Состояние)
	
	Контекст = Новый Структура;
	Контекст.Вставить("Дерево", Папки);
	Контекст.Вставить("ФормаДерево", Элементы.Папки);
	Контекст.Вставить("Состояние", Состояние.Развернут);
	Контекст.Вставить("ТекСсылка", Состояние.ТекСсылка);
	ОбойтиДерево(Папки.ПолучитьЭлементы(), Контекст, "УстановитьСостояниеРазвернут");
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьСостояниеРазвернут(Элемент, Контекст)
	
	ИдентификаторСтроки = Элемент.ПолучитьИдентификатор();
	ТекДанные = Контекст.Дерево.НайтиПоИдентификатору(ИдентификаторСтроки);
	Если Контекст.Состояние.Получить(ТекДанные.Ссылка) = Истина Тогда
		Контекст.ФормаДерево.Развернуть(ИдентификаторСтроки);
	Иначе
		Контекст.ФормаДерево.Свернуть(ИдентификаторСтроки);
	КонецЕсли;
	Если ТекДанные.Ссылка = Контекст.ТекСсылка Тогда
		Контекст.ФормаДерево.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьДеревоПапок()
	
	ДеревоПапок = РеквизитФормыВЗначение("Папки");

	ВстроеннаяПочтаСервер.ЗаполнитьДеревоПапок(ДеревоПапок, РежимМоиПапки, 
		ОтображатьУдаленныеПисьмаИПапки);
	
	ЗначениеВДанныеФормы(ДеревоПапок, Папки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.Папки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено 
		ИЛИ ТекущиеДанные.Ссылка = ПредопределенноеЗначение("Справочник.ПапкиПисем.ПустаяСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	ПапкаДляАктивации = Неопределено;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		ПапкаДляАктивации = ТекущиеДанные.Ссылка;
		
	КонецЕсли;
	
	Если ПапкаДляАктивации = ТекущаяПапка Тогда
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ОбработчикПапкиПриАктивизацииСтроки", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПапкиПриАктивизацииСтроки()
	
	ПапкаДляАктивации = Неопределено;
	
	ТекущиеДанные = Элементы.Папки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		
		ПапкаДляАктивации = ТекущиеДанные.Ссылка;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяПапка) Тогда
		ОтключитьОбработчикОжидания("ОбработчикСписокПриАктивизацииСтроки");
	КонецЕсли;	
	
	Если ПапкаДляАктивации = ТекущаяПапка Тогда
		Возврат;
	КонецЕсли;

	ПредыдущаяПапка = ТекущаяПапка;
	ТекущаяПапка = ПапкаДляАктивации;
	
	//УстановитьОтборПоПапкеКлиент(ТекущаяПапка, Элементы.Папки.ТекущаяСтрока);
	Список.Параметры.УстановитьЗначениеПараметра("Папка", ТекущаяПапка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеДерева = ЗапомнитьСостояниеДереваПапок();
	
	Настройки = Новый Структура;
	Настройки.Вставить("СостояниеДерева", СостояниеДерева);
	
	ПриЗакрытииСервер(ЭтаФорма.ИмяФормы, Настройки, УникальныйИдентификатор);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриЗакрытииСервер(ИмяЭтойФормыПараметр, Настройки, УникальныйИдентификатор)
	
	Для каждого Настройка Из Настройки Цикл
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяЭтойФормыПараметр, Настройка.Ключ, Настройка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьВыбранноеПисьмо(ВыводитьПредупреждение)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Если ВыводитьПредупреждение Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано письмо.'"));
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Если ВыводитьПредупреждение Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано письмо.'"));
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не Элементы.Список.ТекущиеДанные.Свойство("Ссылка") Тогда
		Если ВыводитьПредупреждение Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано письмо.'"));
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Письмо = Элементы.Список.ТекущиеДанные.Ссылка;
	Если Не ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Письмо) Тогда
		Если ВыводитьПредупреждение Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано письмо.'"));
		КонецЕсли;
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Письмо;
	
КонецФункции

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбранноеПисьмо = ПолучитьВыбранноеПисьмо(Ложь);
	Если Не ЗначениеЗаполнено(ВыбранноеПисьмо) Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ВыбранноеПисьмо);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранноеПисьмо = ПолучитьВыбранноеПисьмо(Ложь);
	Если Не ЗначениеЗаполнено(ВыбранноеПисьмо) Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть(ВыбранноеПисьмо);
	
КонецПроцедуры

