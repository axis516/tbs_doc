﻿// Возвращает массив тем указанной заметки
Функция ПолучитьТемыЗаметки(Заметка) Экспорт
	
	ТемыЗаметки = Новый Массив();

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТемыЗаметокДокументооборота.Тема
		|ИЗ
		|	РегистрСведений.ТемыЗаметокДокументооборота КАК ТемыЗаметокДокументооборота
		|ГДЕ
		|	ТемыЗаметокДокументооборота.Заметка = &Заметка";

	Запрос.УстановитьПараметр("Заметка", Заметка);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ТемыЗаметки.Добавить(ВыборкаДетальныеЗаписи.Тема);
	КонецЦикла;

	Возврат ТемыЗаметки;
	
КонецФункции

// Возвращает число заметок указанной темы
Функция ПолучитьЧислоЗаметок(Тема, СУчетомУдаленных = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ЧислоЗаметок
		|ИЗ
		|	РегистрСведений.ТемыЗаметокДокументооборота КАК ТемыЗаметокДокументооборота
		|ГДЕ
		|	ТемыЗаметокДокументооборота.Тема = &Тема";
		
	Если Не СУчетомУдаленных Тогда
		Запрос.Текст = Запрос.Текст + " И ТемыЗаметокДокументооборота.Заметка.ПометкаУдаления = Ложь";
	КонецЕсли;	

	Запрос.УстановитьПараметр("Тема", Тема);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ЧислоЗаметок;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции	

// Сохраняет список тем заметки
Процедура ЗаписатьТемы(Заметка, Темы) Экспорт
	
	СтарыеТемы = РегистрыСведений.ТемыЗаметокДокументооборота.ПолучитьТемыЗаметки(Заметка);
	
	НаборЗаписей = РегистрыСведений.ТемыЗаметокДокументооборота.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Заметка.Установить(Заметка);
	
	Для каждого Эл Из Темы Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Заметка = Заметка;
		НоваяЗапись.Тема = Эл;
	КонецЦикла;	
	
	НаборЗаписей.Записать();
	
	ОбновитьЧислоЗаметокТем(Заметка, СтарыеТемы);
	ОбновитьЧислоЗаметокТем(Заметка, Темы);

КонецПроцедуры

Процедура ОбновитьЧислоЗаметокТем(Заметка, Темы = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Темы = Неопределено Тогда
		Темы = РегистрыСведений.ТемыЗаметокДокументооборота.ПолучитьТемыЗаметки(Заметка);
	КонецЕсли;
	
	Для каждого Эл Из Темы Цикл
		Эл.ПолучитьОбъект().Записать();
	КонецЦикла;	
	
КонецПроцедуры