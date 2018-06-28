﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// По номеру возвращает нужное число ****
Функция ПолучитьСтрокуРанга(Ранг) Экспорт
	
	СтрокаРанга = "";
	
	Если ТипЗнч(Ранг) = Тип("Число") И Ранг <> 0 Тогда
		
		Для Пер = 0 По Ранг-1 Цикл
			СтрокаРанга = СтрокаРанга + "*";
		КонецЦикла;	
		
	КонецЕсли;	
	
	Возврат СтрокаРанга;
	
КонецФункции

// Получает состав контейнера пользователей.
// 
// Параметры:
//   Контейнер - ОпределяемыйТип.КонтейнерыПользователей.
//
// Возвращаемое значение:
//   Массив элементов СправочникСсылка.Пользователи.
//
Функция СоставКонтейнера(Контейнер) Экспорт
	
	Если Не Метаданные.ОпределяемыеТипы.КонтейнерПользователей.Тип.СодержитТип(ТипЗнч(Контейнер)) Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Недопустимый тип %1 контейнера %2'"),
			ТипЗнч(Контейнер),
			Контейнер);
	КонецЕсли;
	
	Менеджер = Справочники[Контейнер.Метаданные().Имя];
	Возврат Менеджер.СоставКонтейнераПользователей(Контейнер);
	
КонецФункции

// Проверяет, является ли переданная ссылка контейнером пользователей.
// 
// Параметры:
//   Ссылка - Произвольный - проверяемая ссылка.
//
// Возвращаемое значение:
//   Булево - Истина, если переданная ссылка является контейнером.
//
Функция ЭтоКонтейнер(Ссылка) Экспорт
	
	Возврат Метаданные.ОпределяемыеТипы.КонтейнерПользователей.Тип.СодержитТип(ТипЗнч(Ссылка));
	
КонецФункции

// Получает контейнеры указанного пользователя, ограничивая их, если необходимо.
//
// Параметры:
//   Пользователь - СправочникСсылка.Пользователи - пользователь, чьи контейнеры получаем.
//   ОграничениеТипа - ОписаниеТипов - типы, которыми следует ограничиться.
//
Функция КонтейнерыПользователя(Пользователь, ОграничениеТипа = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Состав.Контейнер КАК Контейнер
		|ИЗ
		|	РегистрСведений.ПользователиВКонтейнерах КАК Состав
		|ГДЕ
		|	Состав.Пользователь = &Пользователь
		|	И &Условие");
		
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Если ОграничениеТипа = Неопределено Тогда
		Условие = "ИСТИНА"
	Иначе
		Условие = "ТИПЗНАЧЕНИЯ(Состав.Контейнер) В (&Типы)";
		Запрос.УстановитьПараметр("Типы", ОграничениеТипа.Типы());
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", Условие);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контейнер");
	
КонецФункции

// Возвращает список пользователей и контейнеров для ввода текста и автоподбора.
//
// Параметры:
//   Текст - Строка - символы, введенные пользователем.
//   ВключаяКонтейнеры - Булево - Истина, если в результат следует включать контейнеры пользователей.
//
// Возвращаемое значение:
//   СписокЗначений - пользователи (контейнеры) и их представления с уточнением.
//
Функция СформироватьДанныеВыбора(Текст, ВключаяКонтейнеры = Ложь) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Пользователи.Ссылка КАК Ссылка,
		|	СведенияОПользователяхДокументооборот.Подразделение КАК Пояснение
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|		ПО Пользователи.Ссылка = СведенияОПользователяхДокументооборот.Пользователь
		|ГДЕ
		|	Пользователи.Наименование ПОДОБНО &Текст
		|	И Не Пользователи.Недействителен
		|	И Не Пользователи.ПометкаУдаления
		|");
		
	Если ВключаяКонтейнеры Тогда
		Запрос.Текст = Запрос.Текст + "
		|ОБЪЕДИНИТЬ ВСЕ
		|";
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ
		|	ПолныеРоли.Ссылка,
		|	&Роль
		|ИЗ
		|	Справочник.ПолныеРоли КАК ПолныеРоли
		|ГДЕ
		|	ПолныеРоли.Владелец.Наименование ПОДОБНО &Текст
		|	И Не ПолныеРоли.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РабочиеГруппы.Ссылка,
		|	&Группа
		|ИЗ
		|	Справочник.РабочиеГруппы КАК РабочиеГруппы
		|ГДЕ
		|	РабочиеГруппы.Наименование ПОДОБНО &Текст
		|	И Не РабочиеГруппы.ПометкаУдаления
		|	И Не РабочиеГруппы.Недействительна
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка,
		|	&Подразделение
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Наименование ПОДОБНО &Текст
		|	И Не СтруктураПредприятия.ПометкаУдаления
		|";
		Запрос.УстановитьПараметр("Роль", НСтр("ru = 'роль'"));
		Запрос.УстановитьПараметр("Группа", НСтр("ru = 'группа'"));
		Запрос.УстановитьПараметр("Подразделение", НСтр("ru = 'подразделение'"));
	КонецЕсли;
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Пояснение) Тогда 
			ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка) + " (" + Строка(Выборка.Пояснение) + ")");
		Иначе
			ДанныеВыбора.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

#КонецОбласти
