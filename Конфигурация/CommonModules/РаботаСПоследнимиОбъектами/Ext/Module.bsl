﻿////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ СОДЕРЖИТ РЕАЛИЗАЦИЮ МЕХАНИКИ РАБОТЫ С ПОСЛЕДНИМИ ОБЪЕКТАМИ (Список последних)
// 

// Записывает в регистр ОбращенияКОбъектам обращение к объекту
// Параметры
// Ссылка - ссылка на объект (Вх Исх Внутр документ, файл, задача, бизнес-процесс)
Процедура ЗаписатьОбращениеКОбъекту(Ссылка) Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Запишем в регистр ОбращенияКОбъектам
	МенеджерЗаписи = РегистрыСведений.ОбращенияКОбъектам.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = Ссылка;
	МенеджерЗаписи.Пользователь = Пользователи.ТекущийПользователь();
	МенеджерЗаписи.ДатаПоследнегоОбращения = ТекущаяДата();
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.Файлы") Тогда
		МенеджерЗаписи.ИндексКартинки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИндексКартинки");
	Иначе
		МенеджерЗаписи.ИндексКартинки = 10; // Простое изображение листа
	КонецЕсли;	
	
	МенеджерЗаписи.Записать();
	
	// Проверку превышения числа записей делаем не каждый раз, а один раз из 20 вызовов процедуры
	ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел(Секунда(ТекущаяДата()));
	СлучайноеЧисло = ГенераторСлучайныхЧисел.СлучайноеЧисло(0, 20);
	Если СлучайноеЧисло % 20 = 0 Тогда
		ПроверитьМаксимальноеЧислоЗаписейИУдалить();
	КонецЕсли;	
	
КонецПроцедуры	

// Проверяет, что число записей не превышает 200 и удаляет, если превысило.
Процедура ПроверитьМаксимальноеЧислоЗаписейИУдалить()
	
	// Максимальное число записей для одного пользователя
	МаксимальноеЧислоЗаписей = 200; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(*), 0) КАК ЧислоЗаписей
		|ИЗ
		|	РегистрСведений.ОбращенияКОбъектам КАК ОбращенияКОбъектам
		|ГДЕ
		|	ОбращенияКОбъектам.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Если Таблица[0].ЧислоЗаписей <= МаксимальноеЧислоЗаписей Тогда
		Возврат;
	КонецЕсли;
	
	// Удаляем записи, превышающие максимальное число записей + 10% от МаксимальноеЧислоЗаписей
	Превышение = Таблица[0].ЧислоЗаписей - МаксимальноеЧислоЗаписей;
	СколькоЗаписейНадоУдалить = Цел(Превышение + МаксимальноеЧислоЗаписей / 10);
	
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ <СколькоЗаписейНадоУдалить>
		|	ОбращенияКОбъектам.Объект,
		|	ОбращенияКОбъектам.ДатаПоследнегоОбращения КАК ДатаПоследнегоОбращения
		|ИЗ
		|	РегистрСведений.ОбращенияКОбъектам КАК ОбращенияКОбъектам
		|ГДЕ
		|	ОбращенияКОбъектам.Пользователь = &Пользователь
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПоследнегоОбращения";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "<СколькоЗаписейНадоУдалить>", Формат(СколькоЗаписейНадоУдалить, "ЧГ="));
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Для Каждого Строка Из Таблица Цикл 
		УдалитьИзРегистраОбращенияКОбъектам(Строка.Объект, ТекущийПользователь);
	КонецЦикла;
	
КонецПроцедуры	

// Удалить запись из регистра ОбращенияКОбъектам
Процедура УдалитьИзРегистраОбращенияКОбъектам(Объект, Пользователь)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ОбращенияКОбъектам.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Объект.Установить(Объект);
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	
	// Не добавляем записи в набор - чтобы все стереть
	НаборЗаписей.Записать();
	
КонецПроцедуры	
