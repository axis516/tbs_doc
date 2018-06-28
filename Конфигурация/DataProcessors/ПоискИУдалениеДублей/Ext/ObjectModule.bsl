﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Определение менеджера объекта для вызова прикладных правил.
//
// Параметры:
//   ИмяОбластиПоискаДанных - Строка - Имя области (полное имя метаданных).
//
// Возвращаемое значение:
//   СправочникиМенеджер, ПланыВидовХарактеристикМенеджер,
//   ПланыСчетовМенеджер, ПланыВидовРасчетаМенеджер - Менеджер объекта.
//
Функция МенеджерОбластиПоискаДублей(Знач ИмяОбластиПоискаДанных) Экспорт
	Мета = Метаданные.НайтиПоПолномуИмени(ИмяОбластиПоискаДанных);
	
	Если Метаданные.Справочники.Содержит(Мета) Тогда
		Возврат Справочники[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(Мета) Тогда
		Возврат ПланыВидовХарактеристик[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыСчетов.Содержит(Мета) Тогда
		Возврат ПланыСчетов[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(Мета) Тогда
		Возврат ПланыВидовРасчета[Мета.Имя];
		
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ИмяОбластиПоискаДанных);
КонецФункции

// Обработчик фонового поиска дублей.
//
// Параметры:
//     Параметры       - Структура - Данные для анализа.
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата.
//
Процедура ФоновыйПоискДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	// Собираем компоновщик повторно через схему и настройки.
	КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	КомпоновщикПредварительногоОтбора.Инициализировать( Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.СхемаКомпоновки) );
	КомпоновщикПредварительногоОтбора.ЗагрузитьНастройки(Параметры.НастройкиКомпоновщикаПредварительногоОтбора);
	
	Параметры.Вставить("КомпоновщикПредварительногоОтбора", КомпоновщикПредварительногоОтбора);
	
	// Преобразуем правила поиска в таблицу значений с индексом.
	ПравилаПоиска = Новый ТаблицаЗначений;
	ПравилаПоиска.Колонки.Добавить("Реквизит", Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Колонки.Добавить("Правило",  Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Индексы.Добавить("Реквизит");
	
	Для Каждого Правило Из Параметры.ПравилаПоиска Цикл
		ЗаполнитьЗначенияСвойств(ПравилаПоиска.Добавить(), Правило);
	КонецЦикла;
	Параметры.Вставить("ПравилаПоиска", ПравилаПоиска);
	
	Параметры.Вставить("РассчитыватьМестаИспользования", Истина);
	
	// Запускаем поиск
	ПоместитьВоВременноеХранилище(ГруппыДублей(Параметры), АдресРезультата);
КонецПроцедуры

// Обработчик фонового удаления дублей.
//
// Параметры:
//     Параметры       - Структура - Данные для анализа.
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата.
//
Процедура ФоновоеУдалениеДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	ПараметрыЗамены = Новый Структура;
	ПараметрыЗамены.Вставить("СпособУдаления",       Параметры.СпособУдаления);
	ПараметрыЗамены.Вставить("ВключатьБизнесЛогику", Истина);
	ПараметрыЗамены.Вставить("УчитыватьПрикладныеПравила", Параметры.УчитыватьПрикладныеПравила);
	
	ЗаменитьСсылки(Параметры.ПарыЗамен, ПараметрыЗамены, АдресРезультата);
	
КонецПроцедуры

// Непосредственный поиск дублей.
//
// Параметры:
//     ПараметрыПоиска - Структура - Описывает параметры поиска.
//     ЭталонныйОбъект - Произвольный - Объект для сравнения при поиски похожих элементов.
//
// Возвращаемое значение:
//     ТаблицаЗначений - Реализация дерева значений через Ссылка и Родитель, 
//                       верхний уровень - группы, нижний - найденные дубли.
//
Функция ГруппыДублей(Знач ПараметрыПоиска, Знач ЭталонныйОбъект = Неопределено) Экспорт
	ПолноеИмяОМ = ПараметрыПоиска.ОбластьПоискаДублей;
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОМ);
	ЧитатьТаблицу1ИзСУБД = (ЭталонныйОбъект = Неопределено);
	
	// 1. Определяем параметры с учетом прикладного кода.
	РазмерВозвращаемойПорции = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоиска, "МаксимальноеЧислоДублей");
	Если Не ЗначениеЗаполнено(РазмерВозвращаемойПорции) Тогда
		РазмерВозвращаемойПорции = 0; // Без ограничения.
	КонецЕсли;
	
	РассчитыватьМестаИспользования = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоиска, "РассчитыватьМестаИспользования");
	Если ТипЗнч(РассчитыватьМестаИспользования) <> Тип("Булево") Тогда
		РассчитыватьМестаИспользования = Ложь;
	КонецЕсли;
	
	// Для передачи в прикладной код.
	ДополнительныеПараметры = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыПоиска, "ДополнительныеПараметры");
	
	// Вызываем прикладной код
	ИспользоватьПрикладныеПравила = ПараметрыПоиска.УчитыватьПрикладныеПравила
		И ЕстьПрикладныеПравилаОбластиПоискаДублей(ПолноеИмяОМ);
	
	ПоляСравненияНаРавенство = ""; // Имена реквизитов, по которым сравниваем по равенству.
	ПоляСравненияНаПодобие   = ""; // Имена реквизитов, по которым будем нечетко сравнивать.
	ПоляДополнительныхДанных = ""; // Имена реквизитов, дополнительно заказанные прикладными правилами.
	РазмерПрикладнойПорции   = 0;  // Сколько отдавать в прикладные правила для расчета.
	
	Если ИспользоватьПрикладныеПравила Тогда
		ПрикладныеПараметры = Новый Структура;
		ПрикладныеПараметры.Вставить("ПравилаПоиска",        ПараметрыПоиска.ПравилаПоиска);
		ПрикладныеПараметры.Вставить("ОграниченияСравнения", Новый Массив);
		ПрикладныеПараметры.Вставить("КомпоновщикОтбора",    ПараметрыПоиска.КомпоновщикПредварительногоОтбора);
		ПрикладныеПараметры.Вставить("КоличествоЭлементовДляСравнения", 1000);
		
		МенеджерОбластиПоиска = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОМ);
		МенеджерОбластиПоиска.ПараметрыПоискаДублей(ПрикладныеПараметры, ДополнительныеПараметры);
		
		ВсеДополнительныеПоля = Новый Соответствие;
		Для Каждого Ограничение Из ПрикладныеПараметры.ОграниченияСравнения Цикл
			Для Каждого КлючЗначение Из Новый Структура(Ограничение.ДополнительныеПоля) Цикл
				ИмяПоля = КлючЗначение.Ключ;
				Если ВсеДополнительныеПоля[ИмяПоля] = Неопределено Тогда
					ПоляДополнительныхДанных = ПоляДополнительныхДанных + ", " + ИмяПоля;
					ВсеДополнительныеПоля[ИмяПоля] = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		ПоляДополнительныхДанных = Сред(ПоляДополнительныхДанных, 2);
		
		// Сколько отдавать в прикладные правила для расчета.
		РазмерПрикладнойПорции = ПрикладныеПараметры.КоличествоЭлементовДляСравнения;
	КонецЕсли;
	
	// Списки полей, возможно измененные прикладным кодом.
	Для Каждого Строка Из ПараметрыПоиска.ПравилаПоиска Цикл
		Если Строка.Правило = "Равно" Тогда
			ПоляСравненияНаРавенство = ПоляСравненияНаРавенство + ", " + Строка.Реквизит;
		ИначеЕсли Строка.Правило = "Подобно" Тогда
			ПоляСравненияНаПодобие = ПоляСравненияНаПодобие + ", " + Строка.Реквизит;
		КонецЕсли
	КонецЦикла;
	ПоляСравненияНаРавенство = Сред(ПоляСравненияНаРавенство, 2);
	ПоляСравненияНаПодобие   = Сред(ПоляСравненияНаПодобие, 2);
	
	СтруктураПолейИдентичности   = Новый Структура(ПоляСравненияНаРавенство);
	СтруктураПолейПодобия        = Новый Структура(ПоляСравненияНаПодобие);
	СтруктураДополнительныхПолей = Новый Структура(ПоляДополнительныхДанных);
	
	// 2. Конструируем по возможно измененному компоновщику условия отбора.
	Характеристики = Новый Структура("ДлинаКода, ДлинаНаименования, Иерархический, ВидИерархии", 0, 0, Ложь);
	ЗаполнитьЗначенияСвойств(Характеристики, ОбъектМетаданных);
	
	ЕстьНаименование = Характеристики.ДлинаНаименования > 0;
	ЕстьКод          = Характеристики.ДлинаКода > 0;
	
	// Дополнительные поля могут пересекаться с остальными, им надо дать псевдонимы.
	ТаблицаКандидатов = Новый ТаблицаЗначений;
	КолонкиКандидатов = ТаблицаКандидатов.Колонки;
	КолонкиКандидатов.Добавить("Ссылка1");
	КолонкиКандидатов.Добавить("Поля1");
	КолонкиКандидатов.Добавить("Ссылка2");
	КолонкиКандидатов.Добавить("Поля2");
	КолонкиКандидатов.Добавить("ЭтоДубли", Новый ОписаниеТипов("Булево"));
	ТаблицаКандидатов.Индексы.Добавить("ЭтоДубли");
	
	ИменаПолейВЗапросе = ДоступныеРеквизитыОтбора(ОбъектМетаданных);
	Если Не ЕстьКод Тогда
		ИменаПолейВЗапросе = ИменаПолейВЗапросе + ", НЕОПРЕДЕЛЕНО КАК Код";
	КонецЕсли;
	Если Не ЕстьНаименование Тогда
		ИменаПолейВЗапросе = ИменаПолейВЗапросе + ", НЕОПРЕДЕЛЕНО КАК Наименование";
	КонецЕсли;
	ИменаПолейВВыборе  = СтрРазделить(ПоляСравненияНаРавенство + "," + ПоляСравненияНаПодобие, ",", Ложь);
	
	РасшифровкаДополнительныхПолей = Новый Соответствие;
	ПорядковыйНомер = 0;
	Для Каждого КлючЗначение Из СтруктураДополнительныхПолей Цикл
		ИмяПоля   = КлючЗначение.Ключ;
		Псевдоним = "Доп" + Формат(ПорядковыйНомер, "ЧН=; ЧГ=") + "_" + ИмяПоля;
		РасшифровкаДополнительныхПолей.Вставить(Псевдоним, ИмяПоля);
		
		ИменаПолейВЗапросе = ИменаПолейВЗапросе + "," + ИмяПоля + " КАК " + Псевдоним;
		ИменаПолейВВыборе.Добавить(Псевдоним);
		ПорядковыйНомер = ПорядковыйНомер + 1;
	КонецЦикла;
	
	// Наполнение схемы.
	СхемаКД = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанныхСхемыКД = СхемаКД.ИсточникиДанных.Добавить();
	ИсточникДанныхСхемыКД.Имя = "ИсточникДанных1";
	ИсточникДанныхСхемыКД.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = "ИсточникДанных1";
	НаборДанных.Запрос = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + ИменаПолейВЗапросе + " ИЗ " + ПолноеИмяОМ;
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	// Инициализация компоновщика.
	КомпоновщикНастроекКД = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКД));
	КомпоновщикНастроекКД.ЗагрузитьНастройки(ПараметрыПоиска.КомпоновщикПредварительногоОтбора.Настройки);
	НастройкиКД = КомпоновщикНастроекКД.Настройки;
	
	// Поля.
	НастройкиКД.Выбор.Элементы.Очистить();
	Для Каждого ИмяПоля Из ИменаПолейВВыборе Цикл
		ПолеКД = Новый ПолеКомпоновкиДанных(СокрЛП(ИмяПоля));
		ДоступноеПолеКД = НастройкиКД.ДоступныеПоляВыбора.НайтиПоле(ПолеКД);
		Если ДоступноеПолеКД = Неопределено Тогда
			ЗаписьЖурналаРегистрации(
				ПоискИУдалениеДублей.НаименованиеПодсистемы(Ложь),
				УровеньЖурналаРегистрации.Предупреждение,
				ОбъектМетаданных,
				ЭталонныйОбъект,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не найдено.'"), Строка(ПолеКД)));
			Продолжить;
		КонецЕсли;
		ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеКД.Поле = ПолеКД;
	КонецЦикла;
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("Код");
	ВыбранноеПолеКД = НастройкиКД.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПолеКД.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	
	// Сортировки.
	НастройкиКД.Порядок.Элементы.Очистить();
	ЭлементПорядкаКД = НастройкиКД.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядкаКД.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	// Отборы.
	Если Характеристики.Иерархический
		И Характеристики.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКД.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоГруппа");
		ЭлементОтбораКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбораКД.ПравоеЗначение = Ложь;
	КонецЕсли;
	
	// Структура.
	НастройкиКД.Структура.Очистить();
	ГруппировкаКД = НастройкиКД.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаКД.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	ГруппировкаКД.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	// Чтение данных оригиналов.
	Если ЧитатьТаблицу1ИзСУБД Тогда
		Выборка1 = ИнициализироватьВыборкуКД(СхемаКД, КомпоновщикНастроекКД.ПолучитьНастройки());
	Иначе
		ТаблицаЗначений = ОбъектВТаблицуЗначений(ЭталонныйОбъект, РасшифровкаДополнительныхПолей);
		Если Не ЕстьКод Тогда
			ТаблицаЗначений.Колонки.Добавить("Код", Новый ОписаниеТипов("Неопределено"));
		КонецЕсли;
		Если Не ЕстьНаименование Тогда
			ТаблицаЗначений.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Неопределено"));
		КонецЕсли;
		Выборка1 = ИнициализироватьВыборкуТЗ(ТаблицаЗначений);
	КонецЕсли;
	
	// Подготовка СКД к чтению данных дублей.
	ОтборыКандидатов = Новый Соответствие;
	ИменаПолей = СтрРазделить(ПоляСравненияНаРавенство, ",", Ложь);
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		ИмяПоля = СокрЛП(ИмяПоля);
		ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбораКД.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ЭлементОтбораКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборыКандидатов.Вставить(ИмяПоля, ЭлементОтбораКД);
	КонецЦикла;
	ЭлементОтбораКД = НастройкиКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораКД.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	Если ЧитатьТаблицу1ИзСУБД Тогда
		ЭлементОтбораКД.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	Иначе
		ЭлементОтбораКД.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	КонецЕсли;
	ОтборыКандидатов.Вставить("Ссылка", ЭлементОтбораКД);
	
	// Результат и цикл поиска
	ТаблицаДублей = Новый ТаблицаЗначений;
	КолонкиРезультата = ТаблицаДублей.Колонки;
	КолонкиРезультата.Добавить("Ссылка");
	Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
		Если КолонкиРезультата.Найти(КлючЗначение.Ключ) = Неопределено Тогда
			КолонкиРезультата.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого КлючЗначение Из СтруктураПолейПодобия Цикл
		Если КолонкиРезультата.Найти(КлючЗначение.Ключ) = Неопределено Тогда
			КолонкиРезультата.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Если КолонкиРезультата.Найти("Код") = Неопределено Тогда
		КолонкиРезультата.Добавить("Код");
	КонецЕсли;
	Если КолонкиРезультата.Найти("Наименование") = Неопределено Тогда
		КолонкиРезультата.Добавить("Наименование");
	КонецЕсли;
	Если КолонкиРезультата.Найти("Родитель") = Неопределено Тогда
		КолонкиРезультата.Добавить("Родитель");
	КонецЕсли;
	
	ТаблицаДублей.Индексы.Добавить("Ссылка");
	ТаблицаДублей.Индексы.Добавить("Родитель");
	ТаблицаДублей.Индексы.Добавить("Ссылка, Родитель");
	
	Результат = Новый Структура("ТаблицаДублей, ОписаниеОшибки, МестаИспользования", ТаблицаДублей);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("РасшифровкаДополнительныхПолей", РасшифровкаДополнительныхПолей);
	СтруктураПолей.Вставить("СтруктураПолейИдентичности",     СтруктураПолейИдентичности);
	СтруктураПолей.Вставить("СтруктураПолейПодобия",          СтруктураПолейПодобия);
	СтруктураПолей.Вставить("СписокПолейИдентичности",        ПоляСравненияНаРавенство);
	СтруктураПолей.Вставить("СписокПолейПодобия",             ПоляСравненияНаПодобие);
	
	Пока СледующийЭлементВыборки(Выборка1) Цикл
		СтрокаТаблицы1 = Выборка1.ТекущийЭлемент;
		
		// Установка отборов для выбора кандидатов.
		Для Каждого КлючИЗначение Из ОтборыКандидатов Цикл
			ЭлементОтбораКД = КлючИЗначение.Значение;
			ЭлементОтбораКД.ПравоеЗначение = СтрокаТаблицы1[КлючИЗначение.Ключ];
		КонецЦикла;
		
		// Выборка кандидатов данных из СУБД.
		Выборка2 = ИнициализироватьВыборкуКД(СхемаКД, НастройкиКД);
		Таблица2 = Выборка2.ПроцессорВыводаКД.Вывести(Выборка2.ПроцессорКД);
		Если СтруктураПолейПодобия.Количество() > 0 Тогда
			ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПоискаСтрок", "FuzzySearch", ТипВнешнейКомпоненты.Native);
			FuzzySearch = Новый("AddIn.FuzzySearch.FuzzyStringMatchExtension");
			Для Каждого КлючЗначение Из СтруктураПолейПодобия Цикл
				ИмяПоля = КлючЗначение.Ключ;
				МассивСтрок = Таблица2.ВыгрузитьКолонку(ИмяПоля);
				СтрокаМассивом = СтрСоединить(МассивСтрок,"~");
				СтрокаДляПоиска = СтрокаТаблицы1[ИмяПоля];
				МассивИндексовСтрокой = FuzzySearch.StringSearch(СтрокаДляПоиска, СтрокаМассивом, "~", 10, 80, 90);
				Если ПустаяСтрока(МассивИндексовСтрокой) Тогда
					Продолжить;
				КонецЕсли;
				МассивИндексов = СтрРазделить(МассивИндексовСтрокой, ",");
				Если МассивИндексов.Количество() > 0 Тогда
					Для Каждого ИндексСтроки Из МассивИндексов Цикл
						Если ПустаяСтрока(ИндексСтроки) Тогда
							Продолжить;
						КонецЕсли;
						СтрокаТаблицы2 = Таблица2.Получить(ИндексСтроки);
						Если ТаблицаДублей.Найти(СтрокаТаблицы2.Ссылка, "Ссылка") <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						Если ИспользоватьПрикладныеПравила Тогда
							// Наполняем таблицу для прикладных правил, вызываем их, если пора.
							ДобавитьСтрокуКандидатов(ТаблицаКандидатов, СтрокаТаблицы1, СтрокаТаблицы2, СтруктураПолей);
							Если ТаблицаКандидатов.Количество() = РазмерПрикладнойПорции Тогда
								ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, СтрокаТаблицы1, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
								ТаблицаКандидатов.Очистить();
							КонецЕсли;
						Иначе
							ДобавитьДубльВРезультат(ТаблицаДублей, СтрокаТаблицы1, СтрокаТаблицы2, СтруктураПолей);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого СтрокаТаблицы2 Из Таблица2 Цикл
				// Если мы его уже посчитали дублем в какой-то группе, то не трогаем.
				Если ТаблицаДублей.Найти(СтрокаТаблицы2.Ссылка, "Ссылка") <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				// Проигрываем правила подобия для строк.
				Если ИспользоватьПрикладныеПравила Тогда
					// Наполняем таблицу для прикладных правил, вызываем их, если пора.
					ДобавитьСтрокуКандидатов(ТаблицаКандидатов, СтрокаТаблицы1, СтрокаТаблицы2, СтруктураПолей);
					Если ТаблицаКандидатов.Количество() = РазмерПрикладнойПорции Тогда
						ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, СтрокаТаблицы1, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
						ТаблицаКандидатов.Очистить();
					КонецЕсли;
				Иначе
					ДобавитьДубльВРезультат(ТаблицаДублей, СтрокаТаблицы1, СтрокаТаблицы2, СтруктураПолей);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		// Обрабатываем остаток таблицы для прикладных правил.
		Если ИспользоватьПрикладныеПравила Тогда
			ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, СтрокаТаблицы1, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
			ТаблицаКандидатов.Очистить();
		КонецЕсли;
		
		// Завершен анализ группы, смотрим на количество. Много клиенту не отдаем.
		Если РазмерВозвращаемойПорции > 0 И (ТаблицаДублей.Количество() > РазмерВозвращаемойПорции) Тогда
			// Откатываем последнюю группу.
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Родитель ", СтрокаТаблицы1.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Ссылка", СтрокаТаблицы1.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			// Если это была последняя группа, то сообщаем об ошибке.
			Если ТаблицаДублей.Количество() = 0 Тогда
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много элементов, определены не все группы дублей.'");
			Иначе
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много элементов. Уточните критерии поиска дублей.'");
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат.ОписаниеОшибки <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Расчет мест использования
	Если РассчитыватьМестаИспользования Тогда
		НаборСсылок = Новый Массив;
		Для Каждого СтрокаДублей Из ТаблицаДублей Цикл
			Если ЗначениеЗаполнено(СтрокаДублей.Ссылка) Тогда
				НаборСсылок.Добавить(СтрокаДублей.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		МестаИспользования = МестаИспользованияСсылок(НаборСсылок);
		МестаИспользования = МестаИспользования.Скопировать(
			МестаИспользования.НайтиСтроки(Новый Структура("ВспомогательныеДанные", Ложь)));
		МестаИспользования.Индексы.Добавить("Ссылка");
		
		Результат.Вставить("МестаИспользования", МестаИспользования);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определение наличия прикладных правил у объекта.
//
// Параметры:
//     МенеджерОбласти - СправочникМенеджер - Менеджер проверяемого объекта.
//
// Возвращаемое значение:
//     Булево - Истина, если прикладные правила определены.
//
Функция ЕстьПрикладныеПравилаОбластиПоискаДублей(Знач ИмяОбъекта) Экспорт
	
	СписокОбъектов = Новый Соответствие;
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей(СписокОбъектов);
	
	СведенияОбОбъекте = СписокОбъектов[ИмяОбъекта];
	Возврат СведенияОбОбъекте <> Неопределено И (СведенияОбОбъекте = "" Или СтрНайти(СведенияОбОбъекте, "ПараметрыПоискаДублей") > 0);
	
КонецФункции

// Интерфейс для выполнения команд обработки.
Процедура ВыполнитьКоманду(ПараметрыВыполнения, АдресРезультата) Экспорт
	
	Если ПараметрыВыполнения.ИмяПроцедуры = "ФоновыйПоискДублей" Тогда
		
		ФоновыйПоискДублей(ПараметрыВыполнения, АдресРезультата);
		
	ИначеЕсли ПараметрыВыполнения.ИмяПроцедуры = "ФоновоеУдалениеДублей" Тогда
		
		ФоновоеУдалениеДублей(ПараметрыВыполнения, АдресРезультата);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Поиск и удаление дублей: Команда ""%1"" не поддерживается.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразуем объект в таблицу для помещения в запрос.
Функция ОбъектВТаблицуЗначений(Знач ОбъектДанных, Знач РасшифровкаДополнительныхПолей)
	Результат = Новый ТаблицаЗначений;
	СтрокаДанных = Результат.Добавить();
	
	МетаОбъект = ОбъектДанных.Метаданные();
	
	Для Каждого МетаРеквизит Из МетаОбъект.СтандартныеРеквизиты  Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Для Каждого МетаРеквизит Из МетаОбъект.Реквизиты Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из РасшифровкаДополнительныхПолей Цикл
		Имя1 = КлючИЗначение.Ключ;
		Имя2 = КлючИЗначение.Значение;
		Результат.Колонки.Добавить(Имя1, Результат.Колонки[Имя2].ТипЗначения);
		СтрокаДанных[Имя1] = СтрокаДанных[Имя2];
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Дополнительный анализ кандидатов в дубли прикладном методом.
//
Процедура ДобавитьДублиПоПрикладнымПравилам(СтрокиДереваРезультата, Знач МенеджерОбластиПоиска, Знач ОсновныеДанные, Знач ТаблицаКандидатов, Знач СтруктураПолей, Знач ДополнительныеПараметры)
	Если ТаблицаКандидатов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбластиПоиска.ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры);
	
	Данные1 = Новый Структура;
	Данные2 = Новый Структура;
	
	Для Каждого ПараКандидатов Из ТаблицаКандидатов.НайтиСтроки(Новый Структура("ЭтоДубли", Истина)) Цикл
		Данные1.Вставить("Ссылка",       ПараКандидатов.Ссылка1);
		Данные1.Вставить("Код",          ПараКандидатов.Поля1.Код);
		Данные1.Вставить("Наименование", ПараКандидатов.Поля1.Наименование);
		
		Данные2.Вставить("Ссылка",       ПараКандидатов.Ссылка2);
		Данные2.Вставить("Код",          ПараКандидатов.Поля2.Код);
		Данные2.Вставить("Наименование", ПараКандидатов.Поля2.Наименование);
		
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		
		ДобавитьДубльВРезультат(СтрокиДереваРезультата, Данные1, Данные2, СтруктураПолей);
	КонецЦикла;
КонецПроцедуры

// Добавляем строку в таблицу кандидатов для прикладного метода.
//
Функция ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	Строка = ТаблицаКандидатов.Добавить();
	Строка.ЭтоДубли = Ложь;
	Строка.Ссылка1  = ДанныеОсновногоЭлемента.Ссылка;
	Строка.Ссылка2  = ДанныеКандидата.Ссылка;
	
	Строка.Поля1 = Новый Структура("Код, Наименование", ДанныеОсновногоЭлемента.Код, ДанныеОсновногоЭлемента.Наименование);
	Строка.Поля2 = Новый Структура("Код, Наименование", ДанныеКандидата.Код, ДанныеКандидата.Наименование);
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.РасшифровкаДополнительныхПолей Цикл
		ИмяКолонки = КлючЗначение.Значение;
		ИмяПоля    = КлючЗначение.Ключ;
		
		Строка.Поля1.Вставить(ИмяКолонки, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяКолонки, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Возврат Строка;
КонецФункции

// Добавляем в дерево результатов найденный вариант.
//
Процедура ДобавитьДубльВРезультат(Результат, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	ФильтрГруппы = Новый Структура("Ссылка, Родитель", ДанныеОсновногоЭлемента.Ссылка);
	ГруппаДублей = Результат.НайтиСтроки(ФильтрГруппы);
	
	Если ГруппаДублей.Количество() = 0 Тогда
		ГруппаДублей = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ГруппаДублей, ФильтрГруппы);
		
		СтрокаДублей = Результат.Добавить();
		СписокСвойств = "Ссылка, Код, Наименование," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия;
		ЗаполнитьЗначенияСвойств(СтрокаДублей, ДанныеОсновногоЭлемента, СписокСвойств);
		
		СтрокаДублей.Родитель = ГруппаДублей.Ссылка;
	Иначе
		ГруппаДублей = ГруппаДублей[0];
	КонецЕсли;
	
	СтрокаДублей = Результат.Добавить();
	СписокСвойств = "Ссылка, Код, Наименование," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия;
	ЗаполнитьЗначенияСвойств(СтрокаДублей, ДанныеКандидата, СписокСвойств);
	
	СтрокаДублей.Родитель = ГруппаДублей.Ссылка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для автономной работы.

// [ОбщегоНазначения.МестаИспользования]
Функция МестаИспользованияСсылок(Знач НаборСсылок, Знач АдресРезультата = "")
	
	Возврат ОбщегоНазначения.МестаИспользования(НаборСсылок, АдресРезультата);
	
КонецФункции

// [ОбщегоНазначения.ЗаменитьСсылки]
Функция ЗаменитьСсылки(Знач ПарыЗамен, Знач Параметры = Неопределено, Знач АдресРезультата = "")
	
	Результат = ОбщегоНазначения.ЗаменитьСсылки(ПарыЗамен, Параметры);
	Если АдресРезультата <> "" Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие.

Функция ДоступныеРеквизитыОтбора(ОбъектМетаданных)
	МассивРеквизитов = Новый Массив;
	Для Каждого РеквизитМетаданные Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		Если РеквизитМетаданные.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			Продолжить;
		КонецЕсли;
		МассивРеквизитов.Добавить(РеквизитМетаданные.Имя);
	КонецЦикла;
	Для Каждого РеквизитМетаданные Из ОбъектМетаданных.Реквизиты Цикл
		Если РеквизитМетаданные.Тип.СодержитТип(Тип("ХранилищеЗначения")) Тогда
			Продолжить;
		КонецЕсли;
		МассивРеквизитов.Добавить(РеквизитМетаданные.Имя);
	КонецЦикла;
	Возврат СтрСоединить(МассивРеквизитов, ",");
КонецФункции

Функция ИнициализироватьВыборкуКД(СхемаКД, НастройкиКД)
	Выборка = Новый Структура("Таблица, ТекущийЭлемент, Индекс, ВГраница, ПроцессорКД, ПроцессорВыводаКД");
	КомпоновщикМакетаКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКД = КомпоновщикМакетаКД.Выполнить(СхемаКД, НастройкиКД, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	Выборка.ПроцессорКД = Новый ПроцессорКомпоновкиДанных;
	Выборка.ПроцессорКД.Инициализировать(МакетКД);
	
	Выборка.Таблица = Новый ТаблицаЗначений;
	Выборка.Индекс = -1;
	Выборка.ВГраница = -100;
	
	Выборка.ПроцессорВыводаКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Выборка.ПроцессорВыводаКД.УстановитьОбъект(Выборка.Таблица);
	
	Возврат Выборка;
КонецФункции

Функция ИнициализироватьВыборкуТЗ(ТаблицаЗначений)
	Выборка = Новый Структура("Таблица, ТекущийЭлемент, Индекс, ВГраница, ПроцессорКД, ПроцессорВыводаКД");
	Выборка.Таблица = ТаблицаЗначений;
	Выборка.Индекс = -1;
	Выборка.ВГраница = ТаблицаЗначений.Количество() - 1;
	Возврат Выборка;
КонецФункции

Функция СледующийЭлементВыборки(Выборка)
	Если Выборка.Индекс >= Выборка.ВГраница Тогда
		Если Выборка.ПроцессорКД = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		Если Выборка.ВГраница = -100 Тогда
			Выборка.ПроцессорВыводаКД.НачатьВывод();
		КонецЕсли;
		Выборка.Таблица.Очистить();
		Выборка.Индекс = -1;
		Выборка.ВГраница = -1;
		Пока Выборка.ВГраница = -1 Цикл
			ЭлементРезультатаКД = Выборка.ПроцессорКД.Следующий();
			Если ЭлементРезультатаКД = Неопределено Тогда
				Выборка.ПроцессорВыводаКД.ЗакончитьВывод();
				Возврат Ложь;
			КонецЕсли;
			Выборка.ПроцессорВыводаКД.ВывестиЭлемент(ЭлементРезультатаКД);
			Выборка.ВГраница = Выборка.Таблица.Количество() - 1;
		КонецЦикла;
	КонецЕсли;
	Выборка.Индекс = Выборка.Индекс + 1;
	Выборка.ТекущийЭлемент = Выборка.Таблица[Выборка.Индекс];
	Возврат Истина;
КонецФункции

#КонецОбласти

#КонецЕсли