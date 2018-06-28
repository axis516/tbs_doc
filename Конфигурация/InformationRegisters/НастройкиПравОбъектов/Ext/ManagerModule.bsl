﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает настройки прав объекта
//
// Параметры:
//  СсылкаНаОбъект - ссылка на объект для которого нужно прочитать настройки прав
//
// Возвращаемое значение:
//  Структура
//    Наследовать        - Булево - флажок наследования настроек прав родителей
//    Настройки          - ТаблицаЗначений
//                         - ВладелецНастройки     - ссылка на объект или родителя объекта
//                                                   (из иерархии родителей объекта)
//                         - НаследованиеРазрешено - Булево - разрешено наследование
//                         - Пользователь          - СправочникСсылка.Пользователи
//                                                   СправочникСсылка.РабочиеГруппы
//                                                   СправочникСсылка.ВнешниеПользователи
//                                                   СправочникСсылка.ГруппыВнешнихПользователей
//                         - <ИмяПрава1>           - Неопределено, Булево
//                                                       Неопределено - право не настроено,
//                                                       Истина       - право разрешено,
//                                                       Ложь         - право запрещено
//                         - <ИмяПрава2>           - ...
//
Функция Прочитать(Знач СсылкаНаОбъект) Экспорт
	
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	ТаблицаОбъекта = МетаданныеОбъекта.ПолноеИмя();
	ВозможныеПрава = УправлениеДоступомСлужебныйПовтИсп.Параметры().ВозможныеПраваДляНастройкиПравОбъектов;
	Отбор = Новый Структура("ВладелецПрав", ТаблицаОбъекта);
	ВозможныеПраваДляОбъекта = ВозможныеПрава.НайтиСтроки(Отбор);
	
	Если ВозможныеПраваДляОбъекта.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в процедуре РегистрыСведений.НастройкиПравОбъектов.Прочитать()
			           |
			           |Неверное значение параметра СсылкаНаОбъект ""%1"".
			           |Для объектов таблицы ""%2"" права не настраиваются.'"),
			Строка(СсылкаНаОбъект),
			ТаблицаОбъекта);
	КонецЕсли;
	
	НастройкиПрав = Новый Структура;
	
	// Получения значения настройки наследования
	НаборЗаписей = РегистрыСведений.НаследованиеНастроекПравОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(СсылкаНаОбъект);
	НаборЗаписей.Отбор.Родитель.Установить(СсылкаНаОбъект);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		НастройкиПрав.Вставить("Наследовать", Истина);
	Иначе
		НастройкиПрав.Вставить("Наследовать", НаборЗаписей[0].Наследовать);
	КонецЕсли;
	
	// Подготовка структуры таблицы настроек прав
	Настройки = Новый ТаблицаЗначений;
	Настройки.Колонки.Добавить("Пользователь");
	Настройки.Колонки.Добавить("ВладелецНастройки");
	Настройки.Колонки.Добавить("НаследованиеРазрешено", Новый ОписаниеТипов("Булево"));
	Настройки.Колонки.Добавить("НастройкаРодителя",     Новый ОписаниеТипов("Булево"));
	Для каждого СвойстваПрава Из ВозможныеПраваДляОбъекта Цикл
		Настройки.Колонки.Добавить(СвойстваПрава.Имя);
	КонецЦикла;
	
	// Чтение настроек объекта и родителей от которых наследуются настройки
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", СсылкаНаОбъект);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НаследованиеНастроекПравОбъектов.Родитель КАК ВладелецНастройки,
	|	НастройкиПравОбъектов.Пользователь КАК Пользователь,
	|	НастройкиПравОбъектов.Право КАК Право,
	|	ВЫБОР
	|		КОГДА НаследованиеНастроекПравОбъектов.Родитель <> &Объект
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НастройкаРодителя,
	|	НастройкиПравОбъектов.ПравоЗапрещено КАК ПравоЗапрещено,
	|	НастройкиПравОбъектов.НаследованиеРазрешено КАК НаследованиеРазрешено
	|ИЗ
	|	РегистрСведений.НастройкиПравОбъектов КАК НастройкиПравОбъектов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НаследованиеНастроекПравОбъектов КАК НаследованиеНастроекПравОбъектов
	|		ПО НастройкиПравОбъектов.Объект = НаследованиеНастроекПравОбъектов.Родитель
	|ГДЕ
	|	НаследованиеНастроекПравОбъектов.Объект = &Объект
	|	И НЕ(НаследованиеНастроекПравОбъектов.Родитель <> &Объект
	|				И НЕ(НаследованиеНастроекПравОбъектов.Наследовать = ИСТИНА
	|						И НастройкиПравОбъектов.НаследованиеРазрешено = ИСТИНА))
	|
	|УПОРЯДОЧИТЬ ПО
	|	НастройкаРодителя УБЫВ,
	|	ВладелецНастройки,
	|	Пользователь,
	|	Право";
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ТекущийВладелецНастройки = Неопределено;
	ТекущийПользователь = Неопределено;
	Для каждого Строка Из Таблица Цикл
		Если ТекущийВладелецНастройки <> Строка.ВладелецНастройки
		 ИЛИ ТекущийПользователь <> Строка.Пользователь Тогда
			ТекущийВладелецНастройки = Строка.ВладелецНастройки;
			ТекущийПользователь      = Строка.Пользователь;
			Настройка = Настройки.Добавить();
			Настройка.Пользователь      = Строка.Пользователь;
			Настройка.ВладелецНастройки = Строка.ВладелецНастройки;
			Настройка.НастройкаРодителя = Строка.НастройкаРодителя;
		КонецЕсли;
		Если Настройки.Колонки.Найти(Строка.Право) = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка в процедуре РегистрыСведений.НастройкиПравОбъектов.Прочитать()
				           |
				           |Для объектов таблицы ""%1""
				           |право ""%2"" не настраивается, однако оно записано
				           |в регистре сведений НастройкиПравОбъектов для
				           |объекта ""%3"".
				           |
				           |Возможно, обновление информационной базы
				           |не выполнено или выполнено с ошибкой.
				           |Требуется исправить данные регистра.'"),
				ТаблицаОбъекта,
				Строка.Право,
				Строка(СсылкаНаОбъект));
		КонецЕсли;
		Настройка.НаследованиеРазрешено = Настройка.НаследованиеРазрешено ИЛИ Строка.НаследованиеРазрешено;
		Настройка[Строка.Право] = НЕ Строка.ПравоЗапрещено;
	КонецЦикла;
	
	НастройкиПрав.Вставить("Настройки", Настройки);
	
	Возврат НастройкиПрав;
	
КонецФункции

// Записывает настройки прав объекта
//
// Параметры:
//  Наследовать - Булево - флажок наследования настроек прав родителей
//  Настройки   - ТаблицаЗначений со структурой возвращенной функцией Прочитать()
//                записываются только строки, у которых ВладелецНастройки = СсылкаНаОбъект
//
Процедура Записать(Знач СсылкаНаОбъект, Знач Настройки, Знач Наследовать) Экспорт
	
	ТаблицаОбъекта = СсылкаНаОбъект.Метаданные().ПолноеИмя();
	ВозможныеПрава = УправлениеДоступомСлужебныйПовтИсп.Параметры().ВозможныеПраваДляНастройкиПравОбъектов;
	Отбор = Новый Структура("ВладелецПрав", ТаблицаОбъекта);
	ВозможныеПраваДляОбъекта = ВозможныеПрава.НайтиСтроки(Отбор);
	
	Если ВозможныеПраваДляОбъекта.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка в процедуре РегистрыСведений.НастройкиПравОбъектов.Прочитать()
			           |
			           |Неверное значение параметра СсылкаНаОбъект ""%1"".
			           |Для объектов таблицы ""%2"" права не настраиваются.'"),
			Строка(СсылкаНаОбъект),
			ТаблицаОбъекта);
	КонецЕсли;
	
	// Установка значения настройки наследования
	НаборЗаписей = РегистрыСведений.НаследованиеНастроекПравОбъектов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(СсылкаНаОбъект);
	НаборЗаписей.Отбор.Родитель.Установить(СсылкаНаОбъект);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		НаследованиеИзменено = Истина;
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Объект      = СсылкаНаОбъект;
		НоваяЗапись.Родитель    = СсылкаНаОбъект;
		НоваяЗапись.Наследовать = Наследовать;
	Иначе
		НаследованиеИзменено = НаборЗаписей[0].Наследовать <> Наследовать;
		НаборЗаписей[0].Наследовать = Наследовать;
	КонецЕсли;
	
	// Подготовка новых настроек
	НовыеНастройкиПрав = УправлениеДоступомПовтИспДокументооборот.ТаблицаПустогоНабораЗаписей(
		"РегистрСведений.НастройкиПравОбъектов").Скопировать();
	
	Отбор = Новый Структура("ВладелецНастройки", СсылкаНаОбъект);
	Для каждого Настройка Из Настройки.НайтиСтроки(Отбор) Цикл
		Для каждого СвойстваПрава Из ВозможныеПраваДляОбъекта Цикл
			Если ТипЗнч(Настройка[СвойстваПрава.Имя]) = Тип("Булево") Тогда
				НастройкаПрав = НовыеНастройкиПрав.Добавить();
				НастройкаПрав.Объект                = СсылкаНаОбъект;
				НастройкаПрав.Пользователь          = Настройка.Пользователь;
				НастройкаПрав.Право                 = СвойстваПрава.Имя;
				НастройкаПрав.ПравоЗапрещено        = НЕ Настройка[СвойстваПрава.Имя];
				НастройкаПрав.НаследованиеРазрешено = Настройка.НаследованиеРазрешено;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Запись настроек прав объекта и значения наследования настроек прав
	НачатьТранзакцию();
	Попытка
		
		ЕстьИзменения = Ложь;
		
		УправлениеДоступомСлужебный.ОбновитьНаборЗаписей(
			РегистрыСведений.НастройкиПравОбъектов, 
			НовыеНастройкиПрав, , 
			"Объект", СсылкаНаОбъект, ЕстьИзменения);
			
		Если ЕстьИзменения Тогда
			ОбъектыСИзмененниями = Новый Массив;
		Иначе
			ОбъектыСИзмененниями = Неопределено;
		КонецЕсли;
		
		Если НаследованиеИзменено Тогда
			НаборЗаписей.Записать();
			РегистрыСведений.НаследованиеНастроекПравОбъектов.Обновить(СсылкаНаОбъект, , Истина, ОбъектыСИзмененниями);
		КонецЕсли;
		
		Если ОбъектыСИзмененниями <> Неопределено Тогда
			ДобавитьОбъектыИерархии(СсылкаНаОбъект, ОбъектыСИзмененниями);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

Процедура ДобавитьОбъектыИерархии(Ссылка, МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст = СтрЗаменить(
	"ВЫБРАТЬ
	|	ТаблицаСИерархией.Ссылка
	|ИЗ
	|	ТаблицаОбъектов КАК ТаблицаСИерархией
	|ГДЕ
	|	ТаблицаСИерархией.Ссылка В ИЕРАРХИИ(&Ссылка)
	|	И НЕ ТаблицаСИерархией.Ссылка В (&МассивОбъектов)",
	"ТаблицаОбъектов",
	Ссылка.Метаданные().ПолноеИмя());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивОбъектов.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
