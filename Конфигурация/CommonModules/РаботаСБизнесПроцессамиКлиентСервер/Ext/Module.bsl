﻿////////////////////////////////////////////////////////////////////////////////
// Работа с бизнес процессами клиент сервер
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает вариант маршрутизации задач процесса
//
// Парметры:
//   Объект - ДанныеФормыСтруктура - основной реквизит в карточке процесса, шаблона процесса
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВариантыМаршрутизацииЗадач
//
Функция ВариантМаршрутизацииЗадач(Объект) Экспорт
	
	ВариантИсполнения = ПредопределенноеЗначение(
		"Перечисление.ВариантыМаршрутизацииЗадач.Параллельно");
	
	Если Объект.Свойство("ВариантИсполнения") Тогда
		ВариантИсполнения = Объект.ВариантИсполнения;
	ИначеЕсли Объект.Свойство("ВариантСогласования") Тогда
		ВариантИсполнения = Объект.ВариантСогласования;
	КонецЕсли;
	
	Возврат ВариантИсполнения;
	
КонецФункции

// Возвращает значения перечисления ВариантыМаршрутизацииЗадач в виде структуры
//
// Возвращаемое значение:
//   Структура
//     Параллельно
//     Последовательно
//     Смешанно
//
Функция ВариантыМаршуртизацииЗадач() Экспорт
	
	Варианты = Новый Структура;
	Варианты.Вставить("Параллельно", ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Параллельно"));
	Варианты.Вставить("Последовательно", ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Последовательно"));
	Варианты.Вставить("Смешанно", ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Смешанно"));
	
	Возврат Варианты;
	
КонецФункции

Функция ВариантыПорядкаВыполненияЗадач() Экспорт
	
	Варианты = Новый Структура;
	Варианты.Вставить("ВместеСПредыдущим", ПредопределенноеЗначение("Перечисление.ПорядокВыполненияЗадач.ВместеСПредыдущим"));
	Варианты.Вставить("ПослеПредыдущего", ПредопределенноеЗначение("Перечисление.ПорядокВыполненияЗадач.ПослеПредыдущего"));
	
	Возврат Варианты;
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_ТрудозатратыУчастниковПроцесса

Процедура ЗаполнитьОписаниеТрудозатрат(Форма, ПараметрыОписания,
	ИмяРеквизитаОписанияТрудозатрат = "ОписаниеТрудозатрат") Экспорт
	
	ОписаниеТрудозатрат = "";
	
	СтрокаИсполнитель = "";
	СтрокаИсполнители = "";
	СтрокаПроверяющий = "";
	СтрокаКонтролер = "";
	СтрокаАвтор = "";
	
	Разделитель = "";
	
	ИмяРеквизитаОбъекта = "Объект";
	Если ПараметрыОписания.Свойство("ИмяРеквизитаОбъекта") Тогда
		ИмяРеквизитаОбъекта = ПараметрыОписания.ИмяРеквизитаОбъекта;
	КонецЕсли;
	
	ИмяТаблицыИсполнители = "Исполнители";
	Если ПараметрыОписания.Свойство("ИмяТаблицыИсполнители") Тогда
		ИмяТаблицыИсполнители = ПараметрыОписания.ИмяТаблицыИсполнители;
	КонецЕсли;
	
	ИмяРеквизитаТрудозатратыПланИсполнителя = "ТрудозатратыПланИсполнителя";
	Если ПараметрыОписания.Свойство("ИмяРеквизитаТрудозатратыПланИсполнителя") Тогда
		ИмяРеквизитаТрудозатратыПланИсполнителя = 
			ПараметрыОписания.ИмяРеквизитаТрудозатратыПланИсполнителя;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяРеквизитаОбъекта) Тогда
		Объект = Форма[ИмяРеквизитаОбъекта];
	Иначе
		Объект = Форма;
	КонецЕсли;
	
	ОбщееКоличествоТрудозатрат = 0;
	
	Если ПараметрыОписания.Свойство("Исполнитель") Тогда
		
		ПредставлениеИсполнителя = НСтр("ru = 'Исполнитель'");
		ПараметрыОписания.Свойство("ПредставлениеИсполнителя", ПредставлениеИсполнителя);
		
		СтрокаИсполнитель = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' %1 - не указано'"),
			ПредставлениеИсполнителя);
		
		Если ЗначениеЗаполнено(Объект[ИмяРеквизитаТрудозатратыПланИсполнителя]) Тогда
			СтрокаИсполнитель = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 - %2 %3'"),
				ПредставлениеИсполнителя,
				Формат(Объект[ИмяРеквизитаТрудозатратыПланИсполнителя], "ЧДЦ=1; ЧРД=; ЧГ="),
				Форма.ЕдиницаТрудозатрат);
		КонецЕсли;
		
		ОписаниеТрудозатрат = ОписаниеТрудозатрат + СтрокаИсполнитель;
		
		Разделитель = ", ";
		
		ОбщееКоличествоТрудозатрат = ОбщееКоличествоТрудозатрат + Объект[ИмяРеквизитаТрудозатратыПланИсполнителя];
		
	КонецЕсли;
	
	Если ПараметрыОписания.Свойство("Исполнители") Тогда
		
		ПредставлениеИсполнителей = "";
		
		ПараметрыОписания.Свойство("ПредставлениеИсполнителей", ПредставлениеИсполнителей);
		
		СтрокаИсполнители = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = ' %1 - не указано'"),
			ПредставлениеИсполнителей);
			
		ОбщиеТрудозатратыИсполнителей = 
			Объект[ИмяТаблицыИсполнители].Итог("ТрудозатратыПланИсполнителя");
			
		Если ЗначениеЗаполнено(ОбщиеТрудозатратыИсполнителей) Тогда
			СтрокаИсполнители = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 - %2 %3'"),
				ПредставлениеИсполнителей,
				Формат(ОбщиеТрудозатратыИсполнителей, "ЧДЦ=1; ЧРД=; ЧГ="),
				Форма.ЕдиницаТрудозатрат);
		КонецЕсли;
		
		ОписаниеТрудозатрат = ОписаниеТрудозатрат
			+ Разделитель
			+ СтрокаИсполнители;
			
		Разделитель = ", ";
		
		ОбщееКоличествоТрудозатрат = ОбщееКоличествоТрудозатрат + ОбщиеТрудозатратыИсполнителей;
			
	КонецЕсли;
	
	Если ПараметрыОписания.Свойство("Проверяющий") Тогда
		
		СтрокаПроверяющий = НСтр("ru = 'Проверяющий - не указано'");
		
		Если ЗначениеЗаполнено(Объект.ТрудозатратыПланПроверяющего) Тогда
			СтрокаПроверяющий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Проверяющий - %1 %2'"),
				Формат(Объект.ТрудозатратыПланПроверяющего, "ЧДЦ=1; ЧРД=; ЧГ="),
				Форма.ЕдиницаТрудозатрат);
		КонецЕсли;
		
		ОписаниеТрудозатрат = ОписаниеТрудозатрат
			+ Разделитель
			+ СтрокаПроверяющий;
			
		Разделитель = ", ";
		
		ОбщееКоличествоТрудозатрат = ОбщееКоличествоТрудозатрат + Объект.ТрудозатратыПланПроверяющего;
			
	КонецЕсли;
	
	Если ПараметрыОписания.Свойство("Контролер") Тогда
		
		СтрокаКонтролер = НСтр("ru = 'Контролер - не указано'");
		
		Если ЗначениеЗаполнено(Объект.ТрудозатратыПланКонтролера) Тогда
			СтрокаКонтролер = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Контролер - %1 %2'"),
				Формат(Объект.ТрудозатратыПланКонтролера, "ЧДЦ=1; ЧРД=; ЧГ="),
				Форма.ЕдиницаТрудозатрат);
		КонецЕсли;
		
		ОписаниеТрудозатрат = ОписаниеТрудозатрат
			+ Разделитель
			+ СтрокаКонтролер;
			
		Разделитель = ", ";
		
		ОбщееКоличествоТрудозатрат = ОбщееКоличествоТрудозатрат + Объект.ТрудозатратыПланКонтролера;
			
	КонецЕсли;
	
	Если ПараметрыОписания.Свойство("Автор") Тогда
		
		СтрокаАвтор = НСтр("ru = 'Автор - не указано'");
		
		Если ЗначениеЗаполнено(Объект.ТрудозатратыПланАвтора) Тогда
			СтрокаАвтор = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Автор - %1 %2'"),
				Формат(Объект.ТрудозатратыПланАвтора, "ЧДЦ=1; ЧРД=; ЧГ="),
				Форма.ЕдиницаТрудозатрат);
		КонецЕсли;
		
		ОписаниеТрудозатрат = ОписаниеТрудозатрат
			+ Разделитель
			+ СтрокаАвтор;
			
		ОбщееКоличествоТрудозатрат = ОбщееКоличествоТрудозатрат + Объект.ТрудозатратыПланАвтора;
		
	КонецЕсли;
	
	Если ОбщееКоличествоТрудозатрат = 0 Тогда
		Форма[ИмяРеквизитаОписанияТрудозатрат] = НСтр("ru = 'Не указаны'");
	Иначе
		ОписаниеОбщегоКоличестваТрудозатрат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего - %1 %2: '"),
			Формат(ОбщееКоличествоТрудозатрат, "ЧДЦ=1; ЧРД=; ЧГ="),
			Форма.ЕдиницаТрудозатрат);
		Форма[ИмяРеквизитаОписанияТрудозатрат] = ОписаниеОбщегоКоличестваТрудозатрат + ОписаниеТрудозатрат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_РаботаСДеревомПроцессовИЗадач

// Рекурсивная процедура.
// Устанавливает текущую строку в дереве процессов и задач по реквизиту
// формы ТекущаяСтрокаВДереве.
//
// Параметры:
//   ЭлементыДерева - ДанныеФормыКоллекцияЭлементовДерева - корневые элементы дерева.
//   Форма - УправляемаяФорма - форма с деревом процессов и задач.
//
Процедура УстановитьТекущуюСтроку(ЭлементыДерева, Форма) Экспорт
	
	Если Форма.Элементы.Количество() > 0 Тогда
		Для Каждого Эл Из ЭлементыДерева Цикл
			Если Эл.Ссылка = Форма.ТекущаяСтрокаВДереве Тогда
				Форма.Элементы.ДеревоЗадач.ТекущаяСтрока = Эл.ПолучитьИдентификатор();
				Возврат;
			Иначе	
				УстановитьТекущуюСтроку(Эл.ПолучитьЭлементы(), Форма);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает текущую строку в списке активных задач по реквизиту
// формы ТекущаяСтрокаВСпискеАктивныхЗадач.
//
// Параметры:
//   Форма - УправляемаяФорма - форма с списком активных задач.
//
Процедура УстановитьТекущуюСтрокуВСпискеАктивныхЗадач(Форма) Экспорт
	
	Для Каждого ЗадачаСтрока Из Форма.СписокАктивныхЗадач Цикл
		
		Если ЗадачаСтрока.Ссылка = Форма.ТекущаяСтрокаВСпискеАктивныхЗадач Тогда
			Форма.Элементы.СписокАктивныхЗадач.ТекущаяСтрока = ЗадачаСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_РаботаСТаблицейИсполнители

// Заполняет номера шагов в таблице исполнителей
//
// Параметры:
//   ТаблицаИсполнители - ДанныеФормыКоллекция - таблица исполнителей процесса
//
Процедура ЗаполнитьШаг(ТаблицаИсполнители) Экспорт
	
	КоличествоСтрок = ТаблицаИсполнители.Количество();
	
	Если КоличествоСтрок = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Определяем имя реквизита порядка выполнения задач и признак наличия реквизита Ответственного
	ЭтаТаблицаЗначений = Ложь;
	#Если Сервер Тогда
		ЭтаТаблицаЗначений = (ТипЗнч(ТаблицаИсполнители) = Тип("ТаблицаЗначений"));
	#КонецЕсли
	
	Если ЭтаТаблицаЗначений Тогда
		Если ТаблицаИсполнители.Колонки.Найти("ПорядокИсполнения") <> Неопределено Тогда
			ИмяРеквизитаПорядок = "ПорядокИсполнения";
		ИначеЕсли ТаблицаИсполнители.Колонки.Найти("ПорядокСогласования") <> Неопределено Тогда
			ИмяРеквизитаПорядок = "ПорядокСогласования";
		КонецЕсли;
		ЕстьРеквизитОтветственный = ТаблицаИсполнители.Колонки.Найти("Ответственный") <> Неопределено;;
	Иначе
		Если ТаблицаИсполнители[0].Свойство("ПорядокИсполнения") Тогда
			ИмяРеквизитаПорядок = "ПорядокИсполнения";
		ИначеЕсли ТаблицаИсполнители[0].Свойство("ПорядокСогласования") Тогда
			ИмяРеквизитаПорядок = "ПорядокСогласования";
		КонецЕсли;
		ЕстьРеквизитОтветственный = ТаблицаИсполнители[0].Свойство("Ответственный");
	КонецЕсли;
	
	// Определяем первую строку исполнителя 
	// Строка ответственного исполнителя всегда идет первой с номером шага 0.
	ИндексПервойСтрокиИсполнителя = 0;
	Если ЕстьРеквизитОтветственный И ТаблицаИсполнители[0].Ответственный Тогда
		ТаблицаИсполнители[0].Шаг = 0;
		ИндексПервойСтрокиИсполнителя = 1;
	КонецЕсли;
	
	Для ИндексТекущейСтроки = ИндексПервойСтрокиИсполнителя По КоличествоСтрок - 1 Цикл
		
		Строка = ТаблицаИсполнители[ИндексТекущейСтроки];
		
		// Устанавливаем номер шага первой строке исполнителя
		Если ИндексТекущейСтроки = ИндексПервойСтрокиИсполнителя Тогда
			Строка.Шаг = 1;
			Продолжить;
		КонецЕсли;
		
		ПредыдущаяСтрока = ТаблицаИсполнители[ИндексТекущейСтроки-1];
		
		Если Строка[ИмяРеквизитаПорядок] = 
			ПредопределенноеЗначение("Перечисление.ПорядокВыполненияЗадач.ВместеСПредыдущим") Тогда
			
			Строка.Шаг = ПредыдущаяСтрока.Шаг; 
		ИначеЕсли Строка[ИмяРеквизитаПорядок] = 
			ПредопределенноеЗначение("Перечисление.ПорядокВыполненияЗадач.ПослеПредыдущего") Тогда
			
			Строка.Шаг = ПредыдущаяСтрока.Шаг + 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру параметров участника процесса.
//
Функция ПолучитьСтруктуруПараметровУчастника(Участник, УчастникСтрокой,
	ОсновнойОбъектАдресации = Неопределено, ДополнительныйОбъектАдресации = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Участник", Участник);
	Результат.Вставить("УчастникСтрокой", УчастникСтрокой);
	Результат.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Результат.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	
	Возврат Результат;
	
КонецФункции

// Возвращает представление участника процесса. Если участником является роль, то
// в представление добавляются объекты адресации.
//
// Параметры:
//   Участник - СправочникСсылка.Пользователи
//            - СправочникСсылка.РолиИсполнителей
//   ОсновнойОбъектАдресации - ссылка на основной объект адресации исполнителя
//   ДополнительныйОбъектАдресации - ссылка на дополнительный объект адресации исполнителя
//
Функция ПредставлениеУчастникаПроцесса(
	Участник, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации) Экспорт
	
	Результат = Строка(Участник);
	
	Если ТипЗнч(Участник) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		Если ЗначениеЗаполнено(ОсновнойОбъектАдресации) Тогда
			Результат = Результат + ", " + ОсновнойОбъектАдресации;
		КонецЕсли;
		Если ЗначениеЗаполнено(ДополнительныйОбъектАдресации) Тогда
			Результат = Результат + ", " + ДополнительныйОбъектАдресации;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет таблицу исполнителей на дубли
// Если в таблице присутствуют дубли, то пользователю выводится сообщение
// и переменной Отказ присваивается значение Истина.
//
// Параметры:
//   Исполнители - таблица исполнителей в форме.
//   ПутьКТаблицеВФорме - Строка - путь в форме к таблице исполнителей.
//   Отказ - Булево - принимает Истина, если найдены дубли исполнителей.
//
Процедура ПроверитьНаДублиТаблицуИсполнителей(
	Исполнители, ПутьКТаблицеВФорме, Отказ, УчитыватьШаги = Истина) Экспорт
	
	КоличествоИсполнителей = Исполнители.Количество();
	
	Для Инд1 = 0 По КоличествоИсполнителей-2 Цикл
		Строка1 = Исполнители[Инд1];
		
		Если Не ЗначениеЗаполнено(Строка1.Исполнитель) Тогда 
			Продолжить;
		КонецЕсли;
		
		Для Инд2 = Инд1+1 По КоличествоИсполнителей-1 Цикл
			Строка2 = Исполнители[Инд2];
			
			Если УчитыватьШаги Тогда
				Шаг1 = Строка1.Шаг;
				Шаг2 = Строка2.Шаг;
			Иначе
				Шаг1 = Неопределено;
				Шаг2 = Неопределено;
			КонецЕсли;
			
			Если Строка1.Исполнитель = Строка2.Исполнитель
				И Шаг1 = Шаг2 Тогда 
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке исполнителей!'"), 
					Строка(Строка2.Исполнитель));
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,,
					ПутьКТаблицеВФорме + "[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьНомерСтрокиВТаблицеИсполнителей(Таблица) Экспорт
	
	НомерСтроки = 1;
	
	Для Каждого Строка Из Таблица Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
КонецФункции	

#КонецОбласти


