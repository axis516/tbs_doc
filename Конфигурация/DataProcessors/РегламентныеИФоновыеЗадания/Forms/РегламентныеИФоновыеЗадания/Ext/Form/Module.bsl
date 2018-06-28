﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.
		                             |
		                             |Работа с регламентными и фоновыми заданиями
		                             |выполняется только администраторами.'");
	КонецЕсли;
	
	ПустойИдентификатор = Строка(Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ТекстНеОпределено = РегламентныеЗаданияСлужебный.ТекстНеОпределено();
	ЭтоПодчиненныйУзелРИБ = ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ();
	
	Если ОбщегоНазначенияКлиентСервер.РежимОтладки() Тогда
		Элементы.ТаблицаРегламентныеЗаданияКонтекстноеМенюВыполнитьНеВФоне.Видимость = Истина;
		Элементы.ТаблицаРегламентныеЗаданияВыполнитьНеВФоне.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = РегламентныеЗаданияСервер.РаботаСВнешнимиРесурсамиЗаблокирована();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ НастройкиЗагружены Тогда
		ЗаполнитьНастройкиФормы(Новый Соответствие);
	КонецЕсли;
	
	ЗагрузитьРегламентныеЗадания();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РегламентныеЗадания" Тогда
		
		Если ЗначениеЗаполнено(Параметр) Тогда
			ЗагрузитьРегламентныеЗадания(Параметр, Истина);
		Иначе
			ПодключитьОбработчикОжидания("ОтложенноеОбновлениеРегламентныхЗаданий", 0.1, Истина);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "РазрешенаРаботаСВнешнимиРесурсами" Тогда
		Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	ИначеЕсли ИмяСобытия = "Запись_НаборКонстант" Тогда
		ПодключитьОбработчикОжидания("ОтложенноеОбновлениеРегламентныхЗаданий", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьНастройкиФормы(Настройки);
	
	НастройкиЗагружены = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаданияПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ФоновыеЗадания И Не СтраницаФоновыеЗаданияОткрывалась Тогда
		СтраницаФоновыеЗаданияОткрывалась = Истина;
		ОбновитьТаблицуФоновыхЗаданийНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОтбораПоПериодуПриИзменении(Элемент)
	
	ТекущаяДатаСеанса = ТекущаяДатаСеансаНаСервере();
	
	Элементы.ОтборПериодС.ТолькоПросмотр  = НЕ (ВидОтбораПоПериоду = 4);
	Элементы.ОтборПериодПо.ТолькоПросмотр = НЕ (ВидОтбораПоПериоду = 4);
	
	Если ВидОтбораПоПериоду = 0 Тогда
		ОтборПериодС  = '00010101';
		ОтборПериодПо = '00010101';
		Элементы.УстановкаПроизвольногоПериода.Видимость = Ложь;
	ИначеЕсли ВидОтбораПоПериоду = 4 Тогда
		ОтборПериодС  = НачалоДня(ТекущаяДатаСеанса);
		ОтборПериодПо = ОтборПериодС;
		Элементы.УстановкаПроизвольногоПериода.Видимость = Истина;
	Иначе
		ОбновитьАвтоматическийПериод(ЭтотОбъект, ТекущаяДатаСеанса);
		Элементы.УстановкаПроизвольногоПериода.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтбиратьПоРегламентномуЗаданиюПриИзменении(Элемент)

	Элементы.РегламентноеЗаданиеДляОтбора.Доступность = ОтбиратьПоРегламентномуЗаданию;
	
КонецПроцедуры

&НаКлиенте
Процедура РегламентноеЗаданиеДляОтбораОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РегламентноеЗаданиеДляОтбораИдентификатор = ПустойИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеБлокировкаРаботыСВнешнимиРесурсамиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Элементы.ГруппаБлокировкаРаботыСВнешнимиРесурсами.Видимость = Ложь;
	ПояснениеБлокировкаРаботыСВнешнимиРесурсамиОбработкаНавигационнойСсылкиНаСервере();
	Оповестить("РазрешенаРаботаСВнешнимиРесурсами");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаФоновыеЗадания

&НаКлиенте
Процедура ТаблицаФоновыеЗаданияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьФоновоеЗадание();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаРегламентныеЗадания

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = "Предопределенное"
	 ИЛИ Поле = "Использование" Тогда
		
		ДобавитьСкопироватьИзменитьРегламентноеЗадание("Изменить");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ДобавитьСкопироватьИзменитьРегламентноеЗадание(?(Копирование, "Скопировать", "Добавить"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ДобавитьСкопироватьИзменитьРегламентноеЗадание("Изменить");
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Количество() > 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите одно регламентное задание.'"));
		
	ИначеЕсли Элемент.ТекущиеДанные.Предопределенное Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Невозможно удалить предопределенное регламентное задание.'") );
	Иначе
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ТаблицаРегламентныеЗаданияПередУдалениемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Удалить регламентное задание?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРегламентныеЗадания(Команда)
	
	Если Элементы.Задания.ТекущаяСтраница = Элементы.ФоновыеЗадания Тогда
		ОбновитьТаблицуФоновыхЗаданийНаКлиенте();
	Иначе
		ЗагрузитьРегламентныеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеВручную(Команда)

	Если Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите регламентное задание.'"));
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Новый Массив;
	Для каждого ВыделеннаяСтрока Из Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	Индекс = 0;
	
	КоличествоВыделенныхЗаданий = ВыделенныеСтроки.Количество();
	МассивСообщенийОбОшибках = Новый Массив;
	
	Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = ТаблицаРегламентныеЗадания.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		Если ТекущиеДанные.Параметризуемое И КоличествоВыделенныхЗаданий = 1 Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Выбранное регламентное задание нельзя выполнить вручную.'"));
			Возврат;
		ИначеЕсли ТекущиеДанные.Параметризуемое Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыВыполнения = ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(ТекущиеДанные.Идентификатор);
		Если ПараметрыВыполнения.ЗапускВыполнен Тогда
			
			ПоказатьОповещениеПользователя(
				НСтр("ru = 'Запущена процедура регламентного задания'"), ,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.
					|Процедура запущена в фоновом задании %2'"),
					ТекущиеДанные.Наименование,
					Строка(ПараметрыВыполнения.МоментЗапуска)),
				БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
			
			ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Добавить(
				ПараметрыВыполнения.ИдентификаторФоновогоЗадания,
				ТекущиеДанные.Наименование);
			
			ПодключитьОбработчикОжидания(
				"СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 0.1, Истина);
		ИначеЕсли ПараметрыВыполнения.ПроцедураУжеВыполняется Тогда
			МассивСообщенийОбОшибках.Добавить(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Процедура регламентного задания ""%1""
					|  уже выполняется в фоновом задании ""%2"", начатом %3.'"),
					ТекущиеДанные.Наименование,
					ПараметрыВыполнения.ПредставлениеФоновогоЗадания,
					Строка(ПараметрыВыполнения.МоментЗапуска)));
		Иначе
			Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Удалить(
				Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Найти(ВыделеннаяСтрока));
		КонецЕсли;
		
		Индекс = Индекс + 1;
	КонецЦикла;
	
	КоличествоОшибок = МассивСообщенийОбОшибках.Количество();
	Если КоличествоОшибок > 0 Тогда
		ЗаголовокТекстаПроОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Задания выполнены с ошибками (%1 из %2)'"),
			Формат(КоличествоОшибок, "ЧГ="),
			Формат(ВыделенныеСтроки.Количество(), "ЧГ="));
		
		ТекстВсехОшибок = Новый ТекстовыйДокумент;
		ТекстВсехОшибок.ДобавитьСтроку(ЗаголовокТекстаПроОшибки + ":");
		Для Каждого ТекстЭтойОшибки Из МассивСообщенийОбОшибках Цикл
			ТекстВсехОшибок.ДобавитьСтроку("");
			ТекстВсехОшибок.ДобавитьСтроку(ТекстЭтойОшибки);
		КонецЦикла;
		
		Если КоличествоОшибок > 5 Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить(1, НСтр("ru = 'Показать ошибки'"));
			Кнопки.Добавить(КодВозвратаДиалога.Отмена);
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения(
					"ВыполнитьРегламентноеЗаданиеВручнуюЗавершение", ЭтотОбъект, ТекстВсехОшибок),
				ЗаголовокТекстаПроОшибки, Кнопки);
		Иначе
			ПоказатьПредупреждение(, СокрЛП(ТекстВсехОшибок.ПолучитьТекст()));
		КонецЕсли;
	КонецЕсли;
	
	ЗагрузитьРегламентныеЗадания(, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите регламентное задание.'"));
	
	ИначеЕсли Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки.Количество() > 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите одно регламентное задание.'"));
	Иначе
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(
			ПолучитьРасписание(ТекущиеДанные.Идентификатор));
		
		Диалог.Показать(Новый ОписаниеОповещения(
			"ОткрытьРасписаниеЗавершение", ЭтотОбъект, ТекущиеДанные));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРегламентноеЗадание(Команда)
	
	УстановитьИспользованиеРегламентногоЗадания(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыключитьРегламентноеЗадание(Команда)
	
	УстановитьИспользованиеРегламентногоЗадания(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФоновоеЗаданиеНаКлиенте(Команда)
	
	ОткрытьФоновоеЗадание();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьФоновоеЗадание(Команда)
	
	Если Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите фоновое задание.'"));
	Иначе
		ОтменитьФоновоеЗаданиеНаСервере(Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные.Идентификатор);
		ЗагрузитьРегламентныеЗадания(, Истина);
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Задание отменено, но состояние отмены будет
			           |установлено сервером только через секунды,
			           |возможно потребуется обновить данные вручную.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсеЗадания(Команда)
	Значение = Элементы.ТаблицаРегламентныеЗаданияПоказатьВсеЗадания.Пометка;
	Элементы.ТаблицаРегламентныеЗаданияПоказатьВсеЗадания.Пометка = Не Значение;
	
	УстановитьВидимостьОтключенныхЗаданий(Не Значение);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНеВФоне(Команда)
	
	Если Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите регламентное задание.'"));
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Новый Массив;
	Для каждого ВыделеннаяСтрока Из Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	Индекс = 0;
	
	Для каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ТекущиеДанные = ТаблицаРегламентныеЗадания.НайтиПоИдентификатору(ВыделеннаяСтрока);
		ПараметрыВыполнения = ЗапуститьРегламентноеЗаданиеНеВФоне(ТекущиеДанные.Идентификатор);
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнена процедура регламентного задания'"), ,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1.
			|Процедура выполнена вручную без фонового задания'"),
			ТекущиеДанные.Наименование),
		БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьРегламентноеЗаданиеНеВФоне(ИдентификаторЗадания)
	
	РегламентныеЗаданияСлужебный.ВызватьИсключениеЕслиНетПраваАдминистрирования();
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(ИдентификаторЗадания);
	ИмяМетода = Задание.Метаданные.ИмяМетода;
	
	РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации(ИмяМетода);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Конец.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаФоновыеЗадания.Конец");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<>'"));
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеВыполнения.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРегламентныеЗадания.СостояниеВыполнения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = '<не определено>'");
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаОкончания.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРегламентныеЗадания.ДатаОкончания");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = НСтр("ru = '<не определено>'");
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Использование.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Наименование.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеВыполнения.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаОкончания.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИмяПользователя.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Предопределенное.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаРегламентныеЗадания.ИмяЗадания");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = ОтключенныеЗадания;
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОтключенныхЗаданий(Показывать)
	
	Элемент = УсловноеОформление.Элементы.Получить(3);
	ЭлементОформления = Элемент.Оформление.Элементы.Найти("Видимость");
	
	Если Не Показывать Тогда
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ТаблицаРегламентныеЗадания.ИмяЗадания");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
		ОтборЭлемента.ПравоеЗначение = ОтключенныеЗадания;
		
		ЭлементОформления.Использование = Истина;
	Иначе
		Элемент.Отбор.Элементы.Очистить();
		ЭлементОформления.Использование = Ложь;
	КонецЕсли;
	
	ПозицияСкобки = СтрНайти(Элементы.РегламентныеЗадания.Заголовок, " (");
	Если ПозицияСкобки > 0 Тогда
		Элементы.РегламентныеЗадания.Заголовок = Лев(Элементы.РегламентныеЗадания.Заголовок, ПозицияСкобки - 1);
	КонецЕсли;
	ЭлементовВСписке = ТаблицаРегламентныеЗадания.Количество();
	Если ЭлементовВСписке > 0 Тогда
		Если Не Показывать Тогда
			ЭлементовВСписке = ЭлементовВСписке - ОтключенныеЗадания.Количество();
		КонецЕсли;
		Элементы.РегламентныеЗадания.Заголовок = Элементы.РегламентныеЗадания.Заголовок + " (" + Формат(ЭлементовВСписке, "ЧГ=") + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаРегламентныеЗаданияПередУдалениемЗавершение(Ответ, Неопределен) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьРегламентноеЗаданиеВыполнитьНаСервере(
			Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРегламентноеЗаданиеВручнуюЗавершение(Ответ, ТекстВсехОшибок) Экспорт
	
	Если Ответ = 1 Тогда
		ТекстВсехОшибок.Показать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, ТекущиеДанные) Экспорт

	Если НовоеРасписание <> Неопределено Тогда
		УстановитьРасписание(ТекущиеДанные.Идентификатор, НовоеРасписание);
		ЗагрузитьРегламентныеЗадания(ТекущиеДанные.Идентификатор, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРасписание(Знач ИдентификаторРегламентногоЗадания)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат РегламентныеЗаданияСервер.РасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьРасписание(Знач ИдентификаторРегламентногоЗадания, Знач Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания,
		Расписание);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиФормы(Знач Настройки)
	
	НастройкиПоУмолчанию = Новый Структура;
	
	// Настройка отбора фоновых заданий.
	Если Настройки.Получить("ОтборПоСостояниюАктивно") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюАктивно", Истина);
	КонецЕсли;
	
	Если Настройки.Получить("ОтборПоСостояниюЗавершено") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюЗавершено", Истина);
	КонецЕсли;
	
	Если Настройки.Получить("ОтборПоСостояниюЗавершеноАварийно") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюЗавершеноАварийно", Истина);
	КонецЕсли;

	Если Настройки.Получить("ОтборПоСостояниюОтменено") = Неопределено Тогда
		Настройки.Вставить("ОтборПоСостояниюОтменено", Истина);
	КонецЕсли;
	
	Если Настройки.Получить("ОтбиратьПоРегламентномуЗаданию") = Неопределено
	 ИЛИ Настройки.Получить("РегламентноеЗаданиеДляОтбораИдентификатор")   = Неопределено Тогда
		Настройки.Вставить("ОтбиратьПоРегламентномуЗаданию", Ложь);
		Настройки.Вставить("РегламентноеЗаданиеДляОтбораИдентификатор", ПустойИдентификатор);
	КонецЕсли;
	
	// Настройка отбора по периоду "За все время".
	// См. также обработчик события ВидОтбораПоПериодуПриИзменении переключателя.
	Если Настройки.Получить("ВидОтбораПоПериоду") = Неопределено
	 ИЛИ Настройки.Получить("ОтборПериодС")       = Неопределено
	 ИЛИ Настройки.Получить("ОтборПериодПо")      = Неопределено Тогда
		
		Настройки.Вставить("ВидОтбораПоПериоду", 0);
		ТекущаяДатаСеанса = ТекущаяДатаСеанса();
		Настройки.Вставить("ОтборПериодС",  НачалоДня(ТекущаяДатаСеанса) - 3*3600);
		Настройки.Вставить("ОтборПериодПо", НачалоДня(ТекущаяДатаСеанса) + 9*3600);
	КонецЕсли;
	
	Для Каждого Настройка Из Настройки Цикл
		НастройкиПоУмолчанию.Вставить(Настройка.Ключ, Настройка.Значение);
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиПоУмолчанию);
	
	// Настройка видимости и доступности.
	Элементы.ОтборПериодС.ТолькоПросмотр  = НЕ (ВидОтбораПоПериоду = 4);
	Элементы.ОтборПериодПо.ТолькоПросмотр = НЕ (ВидОтбораПоПериоду = 4);
	Элементы.РегламентноеЗаданиеДляОтбора.Доступность = ОтбиратьПоРегламентномуЗаданию;
	
	ОбновитьАвтоматическийПериод(ЭтотОбъект, ТекущаяДатаСеанса());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФоновоеЗадание()
	
	Если Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите фоновое задание.'"));
		Возврат;
	КонецЕсли;
	
	СписокПередаваемыхСвойств =
	"Идентификатор,
	|Ключ,
	|Наименование,
	|ИмяМетода,
	|Состояние,
	|Начало,
	|Конец,
	|Расположение,
	|СообщенияПользователюИОписаниеИнформацииОбОшибке,
	|ИдентификаторРегламентногоЗадания,
	|НаименованиеРегламентногоЗадания";
	ЗначенияТекущихДанных = Новый Структура(СписокПередаваемыхСвойств);
	ЗаполнитьЗначенияСвойств(ЗначенияТекущихДанных, Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", Элементы.ТаблицаФоновыеЗадания.ТекущиеДанные.Идентификатор);
	ПараметрыФормы.Вставить("СвойстваФоновогоЗадания", ЗначенияТекущихДанных);
	
	ОткрытьФорму("Обработка.РегламентныеИФоновыеЗадания.Форма.ФоновоеЗадание", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекущаяДатаСеансаНаСервере()
	
	Возврат ТекущаяДатаСеанса();
	
КонецФункции

&НаСервере
Функция ОповещенияОбОкончанииВыполненияРегламентныхЗаданий()
	
	ОповещенияОбОкончанииВыполнения = Новый Массив;
	
	Если ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() > 0 Тогда
		Индекс = ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() - 1;
		
		УстановитьПривилегированныйРежим(Истина);
		Пока Индекс >= 0 Цикл
			
			НовыйУникальныйИдентификатор = Новый УникальныйИдентификатор(
				ИдентификаторыФоновыхЗаданийПриРучномВыполнении[Индекс].Значение);
			Отбор = Новый Структура;
			Отбор.Вставить("УникальныйИдентификатор", НовыйУникальныйИдентификатор);
			
			МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
			
			Если МассивФоновыхЗаданий.Количество() = 1 Тогда
				МоментОкончания = МассивФоновыхЗаданий[0].Конец;
				
				Если ЗначениеЗаполнено(МоментОкончания) Тогда
					
					ОповещенияОбОкончанииВыполнения.Добавить(
						Новый Структура(
							"ПредставлениеРегламентногоЗадания,
							|МоментОкончания",
							ИдентификаторыФоновыхЗаданийПриРучномВыполнении[Индекс].Представление,
							МоментОкончания));
					
					ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Удалить(Индекс);
				КонецЕсли;
			Иначе
				ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Удалить(Индекс);
			КонецЕсли;
			Индекс = Индекс - 1;
		КонецЦикла;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ОповещенияОбОкончанииВыполнения;
	
КонецФункции

&НаКлиенте
Процедура СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания()
	
	ОповещенияОбОкончанииВыполнения = ОповещенияОбОкончанииВыполненияРегламентныхЗаданий();
	
	Для каждого Оповещение Из ОповещенияОбОкончанииВыполнения Цикл
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Выполнена процедура регламентного задания'"),
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1.
				           |Процедура завершена в фоновом задании %2'"),
				Оповещение.ПредставлениеРегламентногоЗадания,
				Строка(Оповещение.МоментОкончания)),
			БиблиотекаКартинок.ВыполнитьРегламентноеЗаданиеВручную);
	КонецЦикла;
	
	Если ИдентификаторыФоновыхЗаданийПриРучномВыполнении.Количество() > 0 Тогда
		
		ПодключитьОбработчикОжидания(
			"СообщитьОбОкончанииРучногоВыполненияРегламентногоЗадания", 2, Истина);
	Иначе
		ЗагрузитьРегламентныеЗадания(, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВыбораРегламентногоЗадания()
	
	Таблица = ТаблицаРегламентныеЗадания;
	Список  = Элементы.РегламентноеЗаданиеДляОтбора.СписокВыбора;
	
	// Добавление предопределенного элемента.
	Если Список.Количество() = 0 Тогда
		Список.Добавить(ПустойИдентификатор, ТекстНеОпределено);
	КонецЕсли;
	
	Индекс = 1;
	Для каждого Задание Из Таблица Цикл
		Если Индекс >= Список.Количество()
		 ИЛИ Список[Индекс].Значение <> Задание.Идентификатор Тогда
			// Вставка нового задания.
			Список.Вставить(Индекс, Задание.Идентификатор, Задание.Наименование);
		Иначе
			Список[Индекс].Представление = Задание.Наименование;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	// Удаление лишних строк.
	Пока Индекс < Список.Количество() Цикл
		Список.Удалить(Индекс);
	КонецЦикла;
	
	ЭлементСписка = Список.НайтиПоЗначению(РегламентноеЗаданиеДляОтбораИдентификатор);
	Если ЭлементСписка = Неопределено Тогда
		РегламентноеЗаданиеДляОтбораИдентификатор = ПустойИдентификатор;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьРегламентноеЗаданиеВручнуюНаСервере(Знач ИдентификаторРегламентногоЗадания)
	
	Результат = РегламентныеЗаданияСлужебный.ВыполнитьРегламентноеЗаданиеВручную(ИдентификаторРегламентногоЗадания);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОтменитьФоновоеЗаданиеНаСервере(Знач Идентификатор)
	
	РегламентныеЗаданияСлужебный.ОтменитьФоновоеЗадание(Идентификатор);
	
	ОбновитьТаблицуФоновыхЗаданий();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРегламентноеЗаданиеВыполнитьНаСервере(Знач Идентификатор)
	
	Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(Идентификатор);
	Строка = ТаблицаРегламентныеЗадания.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор))[0];
	Задание.Удалить();
	ТаблицаРегламентныеЗадания.Удалить(ТаблицаРегламентныеЗадания.Индекс(Строка));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСкопироватьИзменитьРегламентноеЗадание(Знач Действие)
	
	Если Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите регламентное задание.'"));
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Идентификатор", Элементы.ТаблицаРегламентныеЗадания.ТекущиеДанные.Идентификатор);
		ПараметрыФормы.Вставить("Действие",      Действие);
		
		ОткрытьФорму("Обработка.РегламентныеИФоновыеЗадания.Форма.РегламентноеЗадание", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтложенноеОбновлениеРегламентныхЗаданий()
	
	ЗагрузитьРегламентныеЗадания(, Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьАвтоматическийПериод(Форма, ТекущаяДатаСеанса)
	
	Если Форма.ВидОтбораПоПериоду = 1 Тогда
		Форма.ОтборПериодС  = НачалоДня(ТекущаяДатаСеанса) - 3*3600;
		Форма.ОтборПериодПо = НачалоДня(ТекущаяДатаСеанса) + 9*3600;
		
	ИначеЕсли Форма.ВидОтбораПоПериоду = 2 Тогда
		Форма.ОтборПериодС  = НачалоДня(ТекущаяДатаСеанса) - 24*3600;
		Форма.ОтборПериодПо = КонецДня(Форма.ОтборПериодС);
		
	ИначеЕсли Форма.ВидОтбораПоПериоду = 3 Тогда
		Форма.ОтборПериодС  = НачалоДня(ТекущаяДатаСеанса);
		Форма.ОтборПериодПо = КонецДня(Форма.ОтборПериодС);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИспользованиеРегламентногоЗадания(Включено)
	
	Для каждого ВыделеннаяСтрока Из Элементы.ТаблицаРегламентныеЗадания.ВыделенныеСтроки Цикл
		ТекущиеДанные = ТаблицаРегламентныеЗадания.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Задание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(ТекущиеДанные.Идентификатор);
		Если Задание.Использование <> Включено Тогда
			Задание.Использование = Включено;
			Задание.Записать();
			ТекущиеДанные.Использование = Включено;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПояснениеБлокировкаРаботыСВнешнимиРесурсамиОбработкаНавигационнойСсылкиНаСервере()
	РегламентныеЗаданияСервер.РазблокироватьРаботуСВнешнимиРесурсами();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Фоновая загрузка регламентных заданий.

&НаКлиенте
Процедура ЗагрузитьРегламентныеЗадания(ИдентификаторЗадания = Неопределено, ОбновитьНезаметно = Ложь)
	
	Если Не ОбновитьНезаметно Тогда
		Элементы.СтраницыОтложеннаяЗагрузкаРегламентныхЗаданий.ТекущаяСтраница = Элементы.СтраницаЗагрузкаРегламентныхЗаданий;
	КонецЕсли;
	Результат = ЗагрузкаРегламентныхЗаданий(ИдентификаторЗадания);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗагрузитьРегламентныеЗаданияЗавершение", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРегламентныеЗаданияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ОбработатьРезультат(Результат);
		Элементы.СтраницыОтложеннаяЗагрузкаРегламентныхЗаданий.ТекущаяСтраница = Элементы.СтраницаРегламентныеЗадания;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		Элементы.СтраницыОтложеннаяЗагрузкаРегламентныхЗаданий.ТекущаяСтраница = Элементы.СтраницаРегламентныеЗадания;
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузкаРегламентныхЗаданий(ИдентификаторЗадания)
	
	Если РезультатВыполнения <> Неопределено
		И РезультатВыполнения.ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(РезультатВыполнения.ИдентификаторЗадания);
	КонецЕсли;
	
	ПараметрыДлительнойОперации = ПараметрыДлительнойОперации();
	ПараметрыДлительнойОперации.Вставить("ИдентификаторРегламентногоЗадания", ИдентификаторЗадания);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Формирование таблицы регламентных заданий'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("РегламентныеЗаданияСлужебный.ОбновленнаяТаблицаРегламентныхЗаданий",
		ПараметрыДлительнойОперации, ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПараметрыДлительнойОперации()
	
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("Таблица", РеквизитФормыВЗначение("ТаблицаРегламентныеЗадания"));
	ПараметрыОперации.Вставить("ОтключенныеЗадания", ОтключенныеЗадания);
	
	Возврат ПараметрыОперации;
	
КонецФункции

&НаСервере
Процедура ОбработатьРезультат(ПараметрыЗадания)
	
	Результат = ПолучитьИзВременногоХранилища(ПараметрыЗадания.АдресРезультата);
	ОтключенныеЗадания = Результат.ОтключенныеЗадания;
	ЗначениеВРеквизитФормы(Результат.Таблица, "ТаблицаРегламентныеЗадания");
	
	Элементы.ТаблицаРегламентныеЗадания.Обновить();
	
	ПозицияСкобки = СтрНайти(Элементы.РегламентныеЗадания.Заголовок, " (");
	Если ПозицияСкобки > 0 Тогда
		Элементы.РегламентныеЗадания.Заголовок = Лев(Элементы.РегламентныеЗадания.Заголовок, ПозицияСкобки - 1);
	КонецЕсли;
	ЭлементовВСписке = ТаблицаРегламентныеЗадания.Количество();
	Если ЭлементовВСписке > 0 Тогда
		Если Не Элементы.ТаблицаРегламентныеЗаданияПоказатьВсеЗадания.Пометка Тогда
			ЭлементовВСписке = ЭлементовВСписке - ОтключенныеЗадания.Количество();
		КонецЕсли;
		Элементы.РегламентныеЗадания.Заголовок = Элементы.РегламентныеЗадания.Заголовок + " (" + Формат(ЭлементовВСписке, "ЧГ=") + ")";
	КонецЕсли;
	
	ОбновитьСписокВыбораРегламентногоЗадания();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Фоновая загрузка фоновых заданий.

&НаКлиенте
Процедура ОбновитьТаблицуФоновыхЗаданийНаКлиенте()
	
	Результат = СформироватьТаблицуФоновыхЗаданийВФоне();
	Если Результат.Статус = "Выполнено" Или Результат.Статус = "Ошибка" Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаШапка.Доступность = Ложь;
	Элементы.СтраницыОтложеннаяЗагрузкаФоновыхЗаданий.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьТаблицуФоновыхЗаданийЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуФоновыхЗаданийВФоне()
	
	Отбор = ОтборФоновыхЗаданий();
	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("Отбор", Отбор);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Регламентные задания. Обновление списка фоновых заданий'");
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("РегламентныеЗаданияСлужебный.ТаблицаСвойствФоновыхЗаданийВФоне",
		ПередаваемыеПараметры, ПараметрыВыполнения);
		
	Если Результат.Статус = "Выполнено" Тогда
		ОбновитьТаблицуФоновыхЗаданий(Результат.АдресРезультата);
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	Возврат Результат;
		
КонецФункции

&НаСервере
Функция ОтборФоновыхЗаданий()
	
	// 1. Подготовка отбора.
	Отбор = Новый Структура;
	
	// 1.1. Добавление отбора по состояниям.
	МассивСостояний = Новый Массив;
	
	Если ОтборПоСостояниюАктивно Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.Активно);
	КонецЕсли;
	
	Если ОтборПоСостояниюЗавершено Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.Завершено);
	КонецЕсли;
	
	Если ОтборПоСостояниюЗавершеноАварийно Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.ЗавершеноАварийно);
	КонецЕсли;
	
	Если ОтборПоСостояниюОтменено Тогда 
		МассивСостояний.Добавить(СостояниеФоновогоЗадания.Отменено);
	КонецЕсли;
	
	Если МассивСостояний.Количество() <> 4 Тогда
		Если МассивСостояний.Количество() = 1 Тогда
			Отбор.Вставить("Состояние", МассивСостояний[0]);
		Иначе
			Отбор.Вставить("Состояние", МассивСостояний);
		КонецЕсли;
	КонецЕсли;
	
	// 1.2. Добавление отбора по регламентному заданию.
	Если ОтбиратьПоРегламентномуЗаданию Тогда
		Отбор.Вставить(
				"ИдентификаторРегламентногоЗадания",
				?(РегламентноеЗаданиеДляОтбораИдентификатор = ПустойИдентификатор,
				"",
				РегламентноеЗаданиеДляОтбораИдентификатор));
	КонецЕсли;
	
	// 1.3. Добавление отбора по периоду.
	Если ВидОтбораПоПериоду <> 0 Тогда
		ОбновитьАвтоматическийПериод(ЭтотОбъект, ТекущаяДатаСеанса());
		Отбор.Вставить("Начало", ОтборПериодС);
		Отбор.Вставить("Конец",  ОтборПериодПо);
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

&НаСервере
Процедура ОбновитьТаблицуФоновыхЗаданий(АдресРезультата = Неопределено)
	
	// Обновление списка фоновых заданий.
	
	Если АдресРезультата <> Неопределено Тогда
		ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресРезультата);
		ТекущаяТаблица = ДанныеИзХранилища.ТаблицаСвойств;
	Иначе
		Отбор = ОтборФоновыхЗаданий();
		ТекущаяТаблица = РегламентныеЗаданияСлужебный.СвойстваФоновыхЗаданий(Отбор);
	КонецЕсли;
	
	Таблица = ТаблицаФоновыеЗадания;
	
	Индекс = 0;
	Для каждого Задание Из ТекущаяТаблица Цикл
		
		Если Индекс >= Таблица.Количество()
		 ИЛИ Таблица[Индекс].Идентификатор <> Задание.Идентификатор Тогда
			// Вставка нового задания.
			Обновляемое = Таблица.Вставить(Индекс);
			// Установка уникального идентификатора.
			Обновляемое.Идентификатор = Задание.Идентификатор;
		Иначе
			Обновляемое = Таблица[Индекс];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Обновляемое, Задание);
		
		// Установка наименования регламентного задания из коллекции ТаблицаРегламентныеЗадания.
		Если ЗначениеЗаполнено(Обновляемое.ИдентификаторРегламентногоЗадания) Тогда
			
			Обновляемое.ИдентификаторРегламентногоЗадания
				= Обновляемое.ИдентификаторРегламентногоЗадания;
			
			Строки = ТаблицаРегламентныеЗадания.НайтиСтроки(
				Новый Структура("Идентификатор", Обновляемое.ИдентификаторРегламентногоЗадания));
			
			Обновляемое.НаименованиеРегламентногоЗадания
				= ?(Строки.Количество() = 0, НСтр("ru = '<не найдено>'"), Строки[0].Наименование);
		Иначе
			Обновляемое.НаименованиеРегламентногоЗадания  = ТекстНеОпределено;
			Обновляемое.ИдентификаторРегламентногоЗадания = ТекстНеОпределено;
		КонецЕсли;
		
		// Получение информации об ошибках.
		Обновляемое.СообщенияПользователюИОписаниеИнформацииОбОшибке 
			= РегламентныеЗаданияСлужебный.СообщенияИОписанияОшибокФоновогоЗадания(
				Обновляемое.Идентификатор, Задание);
		
		// Увеличение индекса
		Индекс = Индекс + 1;
	КонецЦикла;
	
	// Удаление лишних строк.
	Пока Индекс < Таблица.Количество() Цикл
		Таблица.Удалить(Таблица.Количество()-1);
	КонецЦикла;
	
	Элементы.ТаблицаФоновыеЗадания.Обновить();
	
	ПозицияСкобки = СтрНайти(Элементы.ФоновыеЗадания.Заголовок, " (");
	Если ПозицияСкобки > 0 Тогда
		Элементы.ФоновыеЗадания.Заголовок = Лев(Элементы.ФоновыеЗадания.Заголовок, ПозицияСкобки - 1);
	КонецЕсли;
	ЭлементовВСписке = ТаблицаФоновыеЗадания.Количество();
	Если ЭлементовВСписке > 0 Тогда
		Элементы.ФоновыеЗадания.Заголовок = Элементы.ФоновыеЗадания.Заголовок + " (" + Формат(ЭлементовВСписке, "ЧГ=") + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуФоновыхЗаданийЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ОбновитьТаблицуФоновыхЗаданий(Результат.АдресРезультата);
		Элементы.ГруппаШапка.Доступность = Истина;
		Элементы.СтраницыОтложеннаяЗагрузкаФоновыхЗаданий.ТекущаяСтраница = Элементы.СтраницаФоновыеЗадания;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		Элементы.ГруппаШапка.Доступность = Истина;
		Элементы.СтраницыОтложеннаяЗагрузкаФоновыхЗаданий.ТекущаяСтраница = Элементы.СтраницаФоновыеЗадания;
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
