﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой ГрупповоеИзменениеОбъектов.

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой ПоискИУдалениеДублей.

// Анализирует пары ссылок справочника на возможность замены одной на другую 
// во всех местах использования с прикладной точки зрения.
// 
// Параметры:
//     ПарыЗамен - Соответствие - Ключ - что будет заменено, значение - на что будет заменено.
//     Параметры - Структура    - Необязательный набор флагов, описывающих действие с заменяемыми 
//                                элементами. Содержит необязательные реквизиты:
//                     * СпособУдаления - Строка, может принимать значения:
//                         "Непосредственно" - Если после замены ссылка нигде не используется,
//                                             то она будет удалена непосредственно
//                         "Пометка"         - Если после замены ссылка не используется, то 
//                                             она будет помечена на удаление.
//                         Любые другие значения говорят о том, что заменяемая ссылка не будет изменена.
//
// Возвращаемое значение:
//     Соответствие - Ключ - исходная ссылка, значение - строка - описание, почему замена недопустима.
//                    Если все замены допустимы, то возвращается пустое соответствие;
//
// Проверки на запрет замены групп и ссылок разных типов производятся автоматически при начале замены.
//
Функция ВозможностьЗаменыЭлементов(Знач ПарыЗамен, Знач Параметры = Неопределено) Экспорт
	
КонецФункции

// Вызывается для определения прикладных параметров поиска дублей.
//
// Параметры:
//
//     ПараметрыПоиска - Структура - Предлагаемые параметры поиска. Содержит поля:
//
//         *  ПравилаПоиска - ТаблицаЗначений - Предлагаемые правила сравнения для объектов.
//                            Может быть изменена для установки новых вариантов. Содержит колонки.
//               ** Реквизит - Строка - Имя реквизита для сравнения.
//               ** Правило  - Строка - Правило сравнения: "Равно" - сравнение по равенству, "Подобно" -подобие строк,
//                                     "" - пустая строка - не сравнивать.
//
//         * КомпоновщикОтбора - КомпоновщикНастроекКомпоновкиДанных - Инициализированный компоновщик для 
//                               предварительного отбора. Может быть изменен, например, для 
//                               усиления отборов.
// 
//         * ОграниченияСравнения - Массив - Предназначен для заполнения описания прикладных правил-ограничений.
//                                  Должен быть дополнен структурами с полями:
//               ** Представление      - Строка - Описание правила-ограничения для пользователя.
//               ** ДополнительныеПоля - Строка - Список дополнительных реквизитов запятую, необходимых для
//                                                дополнительного анализа.
// 
//         * КоличествоЭлементовДляСравнения - Число - Количество кандидатов в дубли, передаваемых одним вызовом
//                                                     обработчику.
//
//     ДополнительныеПараметры - Произвольный - Значение, переданное при вызове программного интерфейса
//                                              ОбщегоНазначения.НайтиДублиЭлементов.
//                               При вызове пользователем из обработки "ПоискИЗаменаДублей" равно Неопределено.
// 
Процедура ПараметрыПоискаДублей(ПараметрыПоиска, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОграниченияСравнения = ПараметрыПоиска.ОграниченияСравнения;
	ПравилаПоиска        = ПараметрыПоиска.ПравилаПоиска;
	КомпоновщикОтбора    = ПараметрыПоиска.КомпоновщикОтбора;
	
	// Размер таблицы для передачи в обработчик.
	ПараметрыПоиска.КоличествоЭлементовДляСравнения = 100;
	
	// Анализ режима работы - варианта вызова.
	Если ДополнительныеПараметры = Неопределено Тогда
		// Внешний вызов из обработки, больше ничего делать не надо, но можно отредактировать параметры пользователя.
		Возврат;
	КонецЕсли;
	
	// Вызов из программного интерфейса.
	ЭлементыОтбора = КомпоновщикОтбора.Настройки.Отбор.Элементы;
	ЭлементыОтбора.Очистить();
	ПравилаПоиска.Очистить();
	
	Если ДополнительныеПараметры.Режим = "КонтрольПоНаименованию" Тогда
		// Ищем среди неудаленных таких же по равенству Наименования и ВидаНоменклатуры.
		
		// Фиксируем условия отбора
		Отбор = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.Использование  = Истина;
		Отбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
		Отбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		Отбор.ПравоеЗначение = Ложь;
		
		СтрокаПравила = ПравилаПоиска.Добавить();
		СтрокаПравила.Реквизит = "Наименование";
		СтрокаПравила.Правило  = "Равно";
		
	ИначеЕсли ДополнительныеПараметры.Режим = "ПоискПохожихПоНаименованию" Тогда
		// Ищем все похожие по наименованию.
		
		СтрокаПравила = ПравилаПоиска.Добавить();
		СтрокаПравила.Реквизит = "Наименование";
		СтрокаПравила.Правило  = "Подобно";
	КонецЕсли;
	
КонецПроцедуры

// Вызывается для определения дублей по прикладным правилам.
//
// Параметры:
//
//     ТаблицаКандидатов - ТаблицаЗначений - Описывает кандидатов в дубли. Содержит колонки:
//         - Ссылка1  - ЛюбаяСсылка - Ссылка на элемент первого кандидата.
//         - Ссылка2  - ЛюбаяСсылка - Ссылка на элемент второго кандидата.
//         - ЭтоДубли - Булево      - Флаг того, что кандидаты действительно являются дублями. По умолчанию содержит 
//                                    значение Ложь, может быть изменено на Истина, если кандидаты - действительно
//                                    дубли.
//         - Поля1    - Структура   - Содержит поля Код, Наименование и дополнительные поля первого кандидата,
//         указанные в ПараметрыПоискаДублей.
//         - Поля2    - Структура   - Содержит поля Код, Наименование и дополнительные поля второго кандидата,
//         указанные в ПараметрыПоискаДублей.
//
//     ДополнительныеПараметры - Произвольный - Значение, переданное при вызове программного интерфейса
//                                              ОбщегоНазначения.НайтиДублиЭлементов.
//                               При вызове пользователем из обработки "ПоискИЗаменаДублей" равно Неопределено.
//
Процедура ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = Неопределено Тогда
		
	ИначеЕсли ДополнительныеПараметры.Режим = "КонтрольПоНаименованию" Тогда
		
		// Исключим себя самого
		Для Каждого Вариант Из ТаблицаКандидатов Цикл
			Если Вариант.Ссылка1 <> ДополнительныеПараметры.Ссылка
				Или Вариант.Ссылка2 <> ДополнительныеПараметры.Ссылка Тогда
				Вариант.ЭтоДубли = Истина;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ДополнительныеПараметры.Режим = "ПоискПохожихПоНаименованию" Тогда
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли