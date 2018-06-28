﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Копирование = ЗначениеЗаполнено(Параметры.ЗначениеКопирования);
	
	ПользователиПустаяСсылка = Справочники.Пользователи.ПустаяСсылка();
	Если Объект.Ссылка.Пустая() И Объект.Контролер = Неопределено Тогда 
		Объект.Контролер = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
		
	ПредыдущийВариантИсполнения = Объект.ВариантИсполнения;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	УстановитьДоступностьПоШаблону();
	УстановитьДоступность();
	
	Мультипредметность.ПроцессПриСозданииНаСервере(ЭтаФорма, Объект);
	
	РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьШаг(Объект.Исполнители);
	
	// Учет переносов сроков выполнения
	ПереносСроковВыполненияЗадач.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Сроки выполнения
	УстановитьУсловноеОформлениеИстекшихСроков();
	СрокиИсполненияПроцессов.КарточкаПроцессаПриСозданииНаСервере(
		ЭтаФорма, БизнесПроцессы.Исполнение.ТочкиМаршрута.Проверить, Истина);
	
	ПроверятьОтсутствие = Отсутствия.ПредупреждатьОбОтсутствии();
	
	// Заполнение комментария проверяющего и вычисление новых сроков.
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РезультатыПроверки.ЗадачаИсполнителя,
		|	РезультатыПроверки.КомментарийПроверяющего
		|ИЗ
		|	БизнесПроцесс.Исполнение.РезультатыПроверки КАК РезультатыПроверки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Задача.ЗадачаИсполнителя КАК ЗадачиИсполнителей
		|		ПО РезультатыПроверки.ЗадачаИсполнителя = ЗадачиИсполнителей.Ссылка
		|ГДЕ
		|	РезультатыПроверки.Ссылка = &Процесс
		|	И РезультатыПроверки.НомерИтерации = &НомерИтерации";
	Запрос.УстановитьПараметр("Процесс", Объект.Ссылка);
	Запрос.УстановитьПараметр("НомерИтерации", Объект.НомерИтерации);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ПараметрыОтбораЗадачи = Новый Структура;
		ПараметрыОтбораЗадачи.Вставить("ЗадачаИсполнителя", Выборка.ЗадачаИсполнителя);
		Исполнители = Объект.Исполнители.НайтиСтроки(ПараметрыОтбораЗадачи);
		Если Исполнители.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаИсполнитель = Исполнители[0];
		
		СтрокаИсполнитель.КомментарийПроверяющего = Выборка.КомментарийПроверяющего;
		СтрокаИсполнитель.КартинкаСтроки = 1;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьШаг(Объект.Исполнители);
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	РаботаСБизнесПроцессамиКлиент.ОбработкаОповещенияФормаБизнесПроцесса(
		ИмяСобытия, Параметр, Источник, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	Мультипредметность.ОбработатьОписаниеПредметовПроцесса(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(Объект.Исполнители, "Исполнитель");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Мультипредметность.ОчиститьНезаполненныеПредметыПроцесса(Объект);
	
	// Учет переноса сроков
	ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// проверка заполнения полей
	Для Каждого Строка Из Объект.Исполнители Цикл
		Если Объект.ВариантИсполнения = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно И Не ЗначениеЗаполнено(Строка.ПорядокИсполнения) Тогда 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнено поле ""Порядок исполнения"" в строке %1 списка исполнителей!'"), Строка.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,
				"Объект.Исполнители[" + Формат(Строка.НомерСтроки-1, "ЧГ=0") + "].ПорядокСогласования",, Отказ);

		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Мультипредметность.ПроцессПослеЗаписиНаСервере(ЭтаФорма, Объект);
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковВТаблицеИсполнителей(
		Объект.Исполнители, ИспользоватьДатуИВремяВСрокахЗадач);
	ОбновитьПризнакиИстекшихСроков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("БизнесПроцессИзменен", Объект.Ссылка, ЭтаФорма);
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Изменение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантИсполненияПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ВариантИсполненияПриИзмененииПроцессаИсполнения(
		ЭтаФорма, Элементы.Исполнители,
		Объект.ВариантИсполнения, ПредыдущийВариантИсполнения, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоИтерацийПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.КоличествоИтерацийПриИзменении(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокОбработкиРезультатовПредставление

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокОбработкиРезультатовПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокОбработкиРезультатов";
	ДопПараметры.Исполнитель = Объект.Проверяющий;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокОбработкиРезультатовДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокОбработкиРезультатовЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокОбработкиРезультатовМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокОбработкиРезультатовПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.Исполнители;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.Участник = Объект.Проверяющий;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		Направление,
		"СрокОбработкиРезультатов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Исполнители

&НаКлиенте
Процедура ИсполнителиПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиИсполненияПриАктивизацииСтроки(
		ЭтаФорма, Элементы.Исполнители,
		Элементы.ИсполнителиСрокИсполненияПредставление, Объект.Исполнители,
		ДоступностьПоШаблону);
	
	ТекущиеДанные = Элементы.Исполнители.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ИсполнителиКомментарийПроверяющего.Доступность =
		ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриНачалеРедактирования(
		ЭтаФорма, НоваяСтрока,
		Элементы.Исполнители,
		Объект.Исполнители,
		Объект.ВариантИсполнения,
		"ПорядокИсполнения");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиПриОкончанииРедактирования(
		ЭтаФорма, НоваяСтрока, ОтменаРедактирования, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПослеУдаления(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнителиИсполненияПослеУдаления(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантИсполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Поле Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительПриИзменении(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
		
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительИсполненияНачалоВыбора(
		ЭтаФорма, СтандартнаяОбработка, Элементы.Исполнители,
		Объект.Исполнители, Объект.ВариантИсполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОчистка(
		СтандартнаяОбработка, Элементы.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОбработкаВыбора(
		ЭтаФорма, ВыбранноеЗначение, Элементы.Исполнители);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительАвтоПодбор(
		ЭтаФорма, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ИсполнительОкончаниеВводаТекста(
		ЭтаФорма, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Поле ПорядокИсполнения

&НаКлиенте
Процедура ПорядокИсполненияПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.ПорядокИсполненияПриИзмененииТаблицыИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители);
	
КонецПроцедуры

// Поле ИсполнителиСрокИсполненияПредставление

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеПриИзменении(Элемент)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияПоПредставлениюВТаблицеИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантИсполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокИсполненияДляСтрокиТаблицыИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантИсполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиСрокИсполненияПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияВТаблицеИсполнители(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Направление, Объект.ВариантИсполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВводОписанияЗадачи(Команда)
	
	ПараметрыФормы = Новый Структура("ОписаниеЗадачи", Элементы.Исполнители.ТекущиеДанные.Описание);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеПослеВводаОписанияЗадачиИсполнителя",
		ЭтотОбъект);
		
	ОткрытьФорму("БизнесПроцесс.Исполнение.Форма.ВводОписанияЗадачиИсполнителя", ПараметрыФормы,
		Элементы.Исполнители,,,,ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеПослеВводаОписанияЗадачиИсполнителя(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Элементы.Исполнители.ТекущиеДанные.Описание = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	// Проверка заполнения таблицы Исполнители
	Если Объект.Исполнители.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Список",,,, "Исполнители"),
			Объект.Ссылка,
			"Объект.Исполнители");
		Возврат;
	КонецЕсли;
	
	// Заполним таблицу РезультатыПроверки.
	Для Каждого СтрИсполнитель Из Объект.Исполнители Цикл
		
		Если Не ЗначениеЗаполнено(СтрИсполнитель.ЗадачаИсполнителя) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СтрИсполнитель.КомментарийПроверяющего) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен комментарий проверяющего'");
			
			Элементы.Исполнители.ТекущаяСтрока = СтрИсполнитель.ПолучитьИдентификатор();
			ТекущийЭлемент = Элементы.ИсполнителиКомментарийПроверяющего;
			ПоказатьПредупреждение(, ТекстСообщения);
			
			Возврат;
		КонецЕсли;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ЗадачаИсполнителя", СтрИсполнитель.ЗадачаИсполнителя);
		РезультатыПроверки = Объект.РезультатыПроверки.НайтиСтроки(ПараметрыОтбора);
		РезультатыПроверки[0].КомментарийПроверяющего = СтрИсполнитель.КомментарийПроверяющего;
		РезультатыПроверки[0].ОтправленоНаДоработку = Истина;
		
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПодтвержденияПереносаСрока", ЭтотОбъект);
	
	СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку(
		ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПодтвержденияПереносаСрока(Результат, Параметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОК_ПослеПроверкиОтсутствия", ЭтотОбъект);
	Если Не ОтсутствияКлиент.ПроверитьОтсутствиеПоПроцессу(ЭтаФорма, ОписаниеОповещения) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК_ПослеПроверкиОтсутствия(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры <> Неопределено 
		И ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство(
			"УникальныйИдентификаторФормыИзмененияПараметров") Тогда
		
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.
			УникальныйИдентификаторФормыИзмененияПараметров = УникальныйИдентификатор;
	КонецЕсли;
	
	ОбщегоНазначенияДокументооборотКлиент.УдалитьПустыеСтрокиТаблицы(
		Объект.Исполнители, "Исполнитель");
	ОчиститьСообщения();
	
	РезультатЗакрытияФормы = СтруктураРезультата();
	РезультатЗаписи = ЗаписатьНаСервере();
	
	Если Не РезультатЗаписи.Отказ Тогда
		
		// Сроки выполнения
		СрокиИсполненияПроцессовКлиент.ОповеститьОПереносеСроков(ЭтаФорма);
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Изменение:'"),
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
			
		РезультатЗакрытияФормы.КодВозврата = КодВозвратаДиалога.ОК;
		РезультатЗакрытияФормы.Исполнители = РезультатЗаписи.Исполнители;
		РезультатЗакрытияФормы.РезультатыПроверки = РезультатЗаписи.РезультатыПроверки;
		РезультатЗакрытияФормы.СрокИсполненияПроцесса = Объект.СрокИсполненияПроцесса;
		РезультатЗакрытияФормы.СрокОбработкиРезультатов = Объект.СрокОбработкиРезультатов;
		РезультатЗакрытияФормы.СрокОбработкиРезультатовДни = Объект.СрокОбработкиРезультатовДни;
		РезультатЗакрытияФормы.СрокОбработкиРезультатовЧасы = Объект.СрокОбработкиРезультатовЧасы;
		РезультатЗакрытияФормы.СрокОбработкиРезультатовМинуты = Объект.СрокОбработкиРезультатовМинуты;
		РезультатЗакрытияФормы.ВариантУстановкиСрокаОбработкиРезультатов = Объект.ВариантУстановкиСрокаОбработкиРезультатов;
		РезультатЗакрытияФормы.КоличествоИтераций = Объект.КоличествоИтераций;
		РезультатЗакрытияФормы.ПричинаПереносаСрока = ПричинаПереносаСрока;
		
		Закрыть(РезультатЗакрытияФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть(СтруктураРезультата());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Исполнители

&НаКлиенте
Процедура Подобрать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПодобратьИсполнителейИсполнения(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантИсполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПереместитьИсполнителяПроцессаИсполнения(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантИсполнения, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ПереместитьИсполнителяПроцессаИсполнения(
		ЭтаФорма, Элементы.Исполнители, Объект.Исполнители, Объект.ВариантИсполнения, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НазначитьОтветственным(Команда)
	
	РаботаСБизнесПроцессамиКлиент.НазначитьОтветственным(
		ЭтаФорма,
		Элементы.Исполнители,
		Объект.Исполнители,
		Объект.ВариантИсполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьДоступность() Экспорт
			
	Если Объект.ВариантИсполнения = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда 
		Элементы.ПорядокИсполнения.Видимость = Истина;
		Элементы.Шаг.Видимость = Истина;
	ИначеЕсли Объект.ВариантИсполнения = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно Тогда
		Элементы.ПорядокИсполнения.Видимость = Ложь;
		Элементы.Шаг.Видимость = Ложь;
	Иначе
		Элементы.ПорядокИсполнения.Видимость = Ложь;
		Элементы.Шаг.Видимость = Ложь;
	КонецЕсли;
		
	Если Объект.Исполнители.Количество() > 1 Тогда 
		Элементы.НазначитьОтветственным.Доступность = Не Элементы.Исполнители.ТолькоПросмотр;
	Иначе
		Элементы.НазначитьОтветственным.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПоШаблону()
	
	ДоступностьПоШаблону = Истина;
	
	Если Не ЗначениеЗаполнено(Объект.Шаблон) И Не ЗначениеЗаполнено(Объект.ВедущаяЗадача) Тогда 
		Возврат;
	КонецЕсли;
	
	ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(Объект);
	
	Если Объект.Исполнители.Количество() > 0 Тогда
		
		Элементы.Исполнители.ИзменятьСоставСтрок = ДоступностьПоШаблону;
		Элементы.Исполнители.ИзменятьПорядокСтрок = ДоступностьПоШаблону;
		Для Каждого ЭлементТаблицыИсполнители Из Элементы.Исполнители.ПодчиненныеЭлементы Цикл
			ЭлементТаблицыИсполнители.ТолькоПросмотр = Не ДоступностьПоШаблону;
		КонецЦикла;
		
		Элементы.Подобрать.Доступность = ДоступностьПоШаблону;
		Элементы.ПереместитьВверх.Доступность = ДоступностьПоШаблону;
		Элементы.ПереместитьВниз.Доступность = ДоступностьПоШаблону;
		Элементы.НазначитьОтветственным.Доступность = ДоступностьПоШаблону;
		Элементы.ИсполнителиКонтекстноеМенюВводОписанияЗадачи.Доступность = ДоступностьПоШаблону;
	Иначе
		Элементы.Исполнители.ИзменятьСоставСтрок = Истина;
		Элементы.Исполнители.ИзменятьПорядокСтрок = Истина;
		Для Каждого ЭлементТаблицыИсполнители Из Элементы.Исполнители.ПодчиненныеЭлементы Цикл
			ЭлементТаблицыИсполнители.ТолькоПросмотр = Ложь;
		КонецЦикла;
		
		Элементы.Подобрать.Доступность = Истина;
		Элементы.ПереместитьВверх.Доступность = Истина;
		Элементы.ПереместитьВниз.Доступность = Истина;
		Элементы.НазначитьОтветственным.Доступность = Истина;
		Элементы.ИсполнителиКонтекстноеМенюВводОписанияЗадачи.Доступность = Истина;
	КонецЕсли;
	
	ПараметрыДоступности = 
		СрокиИсполненияПроцессовКлиентСервер.ПараметрыДоступностиЭлементаУправления();
	ПараметрыДоступности.ДоступностьПоШаблону = ДоступностьПоШаблону;
	
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.СрокОбработкиРезультатовПредставление,
		СрокОбработкиРезультатовПредставление,
		ПараметрыДоступности);
	
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.КоличествоИтераций,
		Объект.КоличествоИтераций,
		ПараметрыДоступности);
		
	СрокиИсполненияПроцессовКлиентСервер.НастроитьЭлементУправленияСроком(
		ЭтаФорма,
		Элементы.ВариантИсполнения,
		Объект.ВариантИсполнения,
		ПараметрыДоступности);
	
КонецПроцедуры

// Возвращает структуру результата для процедур закрытия формы.
//
&НаКлиенте
Функция СтруктураРезультата()
	
	ВариантыУстановкиСрока = СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("КодВозврата", КодВозвратаДиалога.Отмена);
	СтруктураРезультата.Вставить("Исполнители", Новый Массив);
	СтруктураРезультата.Вставить("РезультатыПроверки", Новый Массив);
	СтруктураРезультата.Вставить("СрокИсполненияПроцесса", Дата(1,1,1));
	СтруктураРезультата.Вставить("СрокОбработкиРезультатов", Дата(1,1,1));
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовДни", 0);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовЧасы", 0);
	СтруктураРезультата.Вставить("СрокОбработкиРезультатовМинуты", 0);
	СтруктураРезультата.Вставить("ВариантУстановкиСрокаОбработкиРезультатов",
		ВариантыУстановкиСрока.ОтносительныйСрок);
	СтруктураРезультата.Вставить("КоличествоИтераций", 0);
	СтруктураРезультата.Вставить("ПричинаПереносаСрока", "");
	
	Возврат СтруктураРезультата;
	
КонецФункции

&НаСервере
Функция ЗаписатьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура;
	Результат.Вставить("Отказ", Ложь);
	Результат.Вставить("Исполнители", Новый Массив);
	Результат.Вставить("РезультатыПроверки", Новый Массив);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("ПричинаПереносаСрока", ПричинаПереносаСрока);
	
	Если Не Записать(ПараметрыЗаписи) Тогда
		Результат.Отказ = Истина;
	КонецЕсли;
	
	Прочитать();
	
	Если Не Результат.Отказ Тогда
		
		ПоляСтр = ПоляТаблицыПроцесса("Исполнители");
		Для Каждого СтрИсполнитель Из Объект.Исполнители Цикл
			СтруктураСтр = Новый Структура(ПоляСтр);
			ЗаполнитьЗначенияСвойств(СтруктураСтр, СтрИсполнитель);
			Результат.Исполнители.Добавить(СтруктураСтр);
		КонецЦикла;
		
		ПоляСтр = ПоляТаблицыПроцесса("РезультатыПроверки");
		Для Каждого СтрРезультат Из Объект.РезультатыПроверки Цикл
			СтруктураСтр = Новый Структура(ПоляСтр);
			ЗаполнитьЗначенияСвойств(СтруктураСтр, СтрРезультат);
			Результат.РезультатыПроверки.Добавить(СтруктураСтр);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПоляТаблицыПроцесса(ИмяТаблицы)
	
	ПоляСтр = "";
	
	РеквизитыТабЧасти = Объект.Ссылка.Метаданные().ТабличныеЧасти[ИмяТаблицы].Реквизиты;
	
	Разделитель = "";
	
	Для Каждого СтрРеквизит Из РеквизитыТабЧасти Цикл
		ПоляСтр = ПоляСтр + Разделитель + СтрРеквизит.Имя;
		Разделитель = ",";
	КонецЦикла;
	
	Возврат ПоляСтр;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ТестЦентр

&НаКлиенте
Процедура ТЦВыполнитьКомандуОК() Экспорт
	
	ОК(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_СрокиИсполненияПроцессов

// Заполняет представление сроков в карточке процесса
//
&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере() Экспорт
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
	ПараметрыДляРасчетаСроков.РеквизитТаблицаСИзмененнымСроком = РеквизитТаблицаСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ИндексСтроки = ИндексСтрокиСИзмененнымСроком;
	ПараметрыДляРасчетаСроков.ТекущаяИтерация = Объект.НомерИтерации + 1;
	ПараметрыДляРасчетаСроков.ЗаполнятьСрокПроцессаТолькоПриПревышении = Истина;
	
	СрокиИсполненияПроцессов.РассчитатьСрокиПроцессаИсполнения(Объект, ПараметрыДляРасчетаСроков);
	
	СрокиИсполненияПроцессов.ПроверитьИзменениеСроковВФормеПроцесса(ЭтаФорма);
	
	РеквизитТаблицаСИзмененнымСроком = "";
	ИндексСтрокиСИзмененнымСроком = 0;
	
	ОбновитьПризнакиИстекшихСроков();
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(РеквизитТаблица = "", ИндексСтроки = 0) Экспорт
	
	РеквизитТаблицаСИзмененнымСроком = РеквизитТаблица;
	ИндексСтрокиСИзмененнымСроком = ИндексСтроки;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// Устанавливает условное оформление истекших сроков.
//
&НаСервере
Процедура УстановитьУсловноеОформлениеИстекшихСроков()
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения истек (Исполнители)'"),
		"Объект.Исполнители.СрокИсполненияИстек",
		"ИсполнителиСрокИсполненияПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок обработки результатов истек'"),
		"СрокОбработкиРезультатовИстек",
		"СрокОбработкиРезультатовПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения процесса истек'"),
		"СрокИсполненияПроцессаИстек",
		"СрокИсполненияПроцессаПредставление");
	
КонецПроцедуры

// Обновляет признаки истекших сроков в карточке.
//
&НаСервере
Процедура ОбновитьПризнакиИстекшихСроков()
	
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшихСроковВТаблицеИсполнителей(
		Объект.Исполнители, ТекущаяДатаСеанса());
	
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
		Объект.СрокОбработкиРезультатов, СрокОбработкиРезультатовИстек, ТекущаяДатаСеанса());
		
	СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаПроцесса(
		Объект.СрокИсполненияПроцесса, Объект.ДатаЗавершения, СрокИсполненияПроцессаИстек);
	
КонецПроцедуры

#КонецОбласти
