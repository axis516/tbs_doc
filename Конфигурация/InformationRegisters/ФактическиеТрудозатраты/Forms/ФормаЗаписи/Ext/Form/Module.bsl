﻿
&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура;
	СохраняемыеЭлементы.Вставить("ВидРабот", Запись.ВидРабот);
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

&НаСервере
Процедура ЗаписатьВводимыеЗначения()
	
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоНовый = Параметры.Ключ.Пустой();
	
	Если ЭтоНовый Тогда 
		
		Запись.ДатаДобавления = ТекущаяДатаСеанса();
		Запись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		Запись.Подразделение = РаботаСПользователями.ПолучитьПодразделение(Запись.Пользователь);
		
		Если Параметры.Свойство("Источник") И ЗначениеЗаполнено(Параметры.Источник) Тогда 
			Запись.Источник = Параметры.Источник;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Запись.Источник) И ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
			
			Если ТипЗнч(Запись.Источник) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
				Запись.Проект = Запись.Источник.Проект;
				Запись.ПроектнаяЗадача = Запись.Источник.ПроектнаяЗадача;
				
			ИначеЕсли ТипЗнч(Запись.Источник) = Тип("СправочникСсылка.Проекты") Тогда
				Запись.Проект = Запись.Источник;
				Запись.ПроектнаяЗадача = Неопределено;
				
			ИначеЕсли ТипЗнч(Запись.Источник) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
				Запись.Проект = Запись.Источник.Владелец;
				Запись.ПроектнаяЗадача = Запись.Источник;
				
			ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(Запись.Источник) 
				Или ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Запись.Источник)
				Или ТипЗнч(Запись.Источник) = Тип("СправочникСсылка.Мероприятия")
				Или ТипЗнч(Запись.Источник) = Тип("СправочникСсылка.Файлы") Тогда 
				
				Запись.Проект = Запись.Источник.Проект;
				Запись.ПроектнаяЗадача = Неопределено;
				
			КонецЕсли; 
			
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Запись.Источник) Тогда 
			Если ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Запись.Источник) Тогда
				Запись.ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Составление письма ""%1""'"),
					Запись.Источник.Тема);
				
			ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(Запись.Источник) Тогда
				Запись.ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Чтение письма ""%1""'"),
					Запись.Источник.Тема);
					
			Иначе		
				Запись.ОписаниеРаботы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Работа над ""%1""'"),
					Запись.Источник);
				
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.ВидРабот) Тогда
			Запись.ВидРабот = УчетВремени.ПолучитьОсновнойВидРабот();
		КонецЕсли;
	КонецЕсли;	
	
	ДлительностьРаботы = УчетВремениКлиентСервер.ЧислоВСтроку(Запись.Длительность);
	ПроектЗадача = РаботаСПроектамиКлиентСервер.ПредставлениеПроектаЗадачи(Запись.Проект, Запись.ПроектнаяЗадача);
	
	СпособУказанияВремени = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "СпособУказанияВремени");
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
	КонецЕсли;	
	
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда 
		Элементы.ДлительностьРаботы.Видимость = Истина;
		Элементы.Начало.Видимость = Ложь;
		Элементы.Окончание.Видимость = Ложь;
	Иначе
		Элементы.ДлительностьРаботы.Видимость = Ложь;
		Элементы.Начало.Видимость = Истина;
		Элементы.Окончание.Видимость = Истина;
	КонецЕсли;
	
	Элементы.Пользователь.ТолькоПросмотр = Истина;
	Если РольДоступна("ПолныеПрава") Тогда 
		Элементы.Пользователь.ТолькоПросмотр = Ложь;
	ИначеЕсли ЗначениеЗаполнено(Запись.Проект) 
		И Запись.Проект.Руководитель = ПользователиКлиентСервер.ТекущийПользователь() Тогда 
		Элементы.Пользователь.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
	НачальнаяДатаДобавления = Запись.ДатаДобавления;
	
	Элементы.ДлительностьРаботы.СписокВыбора.ЗагрузитьЗначения(МассивВыбораВремени());
	
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ЗаполнитьСписокВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Запись.ВидРабот) Тогда
		ЗаписатьВводимыеЗначения();
	КонецЕсли;
	
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда 
		ТекущийОбъект.Длительность = УчетВремениКлиентСервер.ЧислоИзСтроки(ДлительностьРаботы);
	ИначеЕсли ЗначениеЗаполнено(ТекущийОбъект.Окончание) И ЗначениеЗаполнено(ТекущийОбъект.Начало) Тогда 
		ТекущийОбъект.Длительность = ТекущийОбъект.Окончание - ТекущийОбъект.Начало;
	КонецЕсли;	
	
	Если ЭтоНовый Или НачальнаяДатаДобавления <> ТекущийОбъект.ДатаДобавления Тогда 
		ТекущийОбъект.НомерДобавления = УчетВремени.МаксимальныйНомерДобавления(
			ТекущийОбъект.Подразделение, ТекущийОбъект.Пользователь, ТекущийОбъект.ДатаДобавления);
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	НачальнаяДатаДобавления = Запись.ДатаДобавления;
	
	Если ТипЗнч(Запись.Источник) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		Оповестить("Изменение_ФактическиеТрудозатратыЗадачи", Запись.Источник, ЭтаФорма);
	КонецЕсли;
	
	Оповестить("Изменение_ФактическиеТрудозатратыПроектнойЗадачи", Запись.ПроектнаяЗадача, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	СпособУказанияВремени = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "СпособУказанияВремени");
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
	КонецЕсли;
	
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда 
		Если Не ЗначениеЗаполнено(ДлительностьРаботы) Или ДлительностьРаботы = "00:00" Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""Длительность""'"),,
				"ДлительностьРаботы",, 
				Отказ);
		КонецЕсли;
	Иначе
		Если Не ЗначениеЗаполнено(Запись.Начало) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""Начало""'"),,
				"Запись.Начало",, 
				Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.Окончание) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено поле ""Окончание""'"),,
				"Запись.Окончание",, 
				Отказ);
		КонецЕсли;
			
		Если ЗначениеЗаполнено(Запись.Начало) И ЗначениеЗаполнено(Запись.Окончание) И Запись.Начало > Запись.Окончание Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Время окончания меньше, чем время начала'"),,
				"Запись.Окончание",, 
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
			
		ТекстСообщения = "";
		РезультатПроверки = РаботаСПроектами.ПроверитьЗаписьОФактическихТрудозатратах(
			Запись.Проект,
			Запись.ПроектнаяЗадача,
			Запись.Источник,
			Запись.Пользователь,
			ТекстСообщения);
		Если Не РезультатПроверки Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения,,
				"ПроектЗадача",, 
				Отказ);	
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПроектамиКлиент.ВыбратьПроектЗадачу(Элемент, Запись.Проект, Запись.ПроектнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда 	
		Запись.Проект = ВыбранноеЗначение.Проект;
		Запись.ПроектнаяЗадача = ВыбранноеЗначение.ПроектнаяЗадача;
		ПроектЗадача = РаботаСПроектамиКлиентСервер.ПредставлениеПроектаЗадачи(
			ВыбранноеЗначение.Проект, 
			ВыбранноеЗначение.ПроектнаяЗадача,
			ВыбранноеЗначение.ЕстьПроектныеЗадачи);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Запись.ПроектнаяЗадача) Тогда 
		ПоказатьЗначение(, Запись.ПроектнаяЗадача);
	ИначеЕсли ЗначениеЗаполнено(Запись.Проект) Тогда 
		ПоказатьЗначение(, Запись.Проект);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОчистка(Элемент, СтандартнаяОбработка)
	
	Запись.Проект = Неопределено;
	Запись.ПроектнаяЗадача = Неопределено;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивВыбораВремени()
	
	МассивВыбора = Новый Массив;
	
	МассивВыбора.Добавить("00:15");
	МассивВыбора.Добавить("00:30");
	МассивВыбора.Добавить("00:45");
	МассивВыбора.Добавить("01:00");
	МассивВыбора.Добавить("01:30");
	МассивВыбора.Добавить("02:00");
	МассивВыбора.Добавить("03:00");
	МассивВыбора.Добавить("04:00");
	МассивВыбора.Добавить("05:00");
	
	Возврат МассивВыбора;
	
КонецФункции

&НаКлиенте
Процедура ПроектЗадачаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = РаботаСПроектами.СформироватьДанныеВыбораПроектаЗадачи(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		ДанныеВыбораПроектаЗадачи = РаботаСПроектами.СформироватьДанныеВыбораПроектаЗадачи(Текст);
		
		Если ДанныеВыбораПроектаЗадачи.Количество() = 1 Тогда 
			ВыбранноеЗначение = ДанныеВыбораПроектаЗадачи[0].Значение;
			
			Запись.Проект = ВыбранноеЗначение.Проект;
			Запись.ПроектнаяЗадача = ВыбранноеЗначение.ПроектнаяЗадача;
			ПроектЗадача = РаботаСПроектамиКлиентСервер.ПредставлениеПроектаЗадачи(Запись.Проект, Запись.ПроектнаяЗадача);
		Иначе	
			СтандартнаяОбработка = Ложь;
			ДанныеВыбора = ДанныеВыбораПроектаЗадачи;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектЗадачаПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ПроектЗадача) Тогда 
		Запись.Проект = Неопределено;
		Запись.ПроектнаяЗадача = Неопределено;
	КонецЕсли;
	
КонецПроцедуры
