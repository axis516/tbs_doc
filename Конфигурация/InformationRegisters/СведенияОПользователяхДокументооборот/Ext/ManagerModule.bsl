﻿#Область ПрограммныйИнтерфейс

// Возвращает структуру, содержащую сведения о пользователе
// Подразделение
// Должность
Функция ПолучитьСведенияОПользователе(Пользователь) Экспорт
	
	СведенияОПользователе = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СведенияОПользователяхДокументооборот.Подразделение,
		|	СведенияОПользователяхДокументооборот.Должность
		|ИЗ
		|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
		|ГДЕ
		|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";

	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СведенияОПользователе.Вставить("Подразделение", ВыборкаДетальныеЗаписи.Подразделение);
		СведенияОПользователе.Вставить("Должность", ВыборкаДетальныеЗаписи.Должность);
		
	КонецЦикла;

	Возврат СведенияОПользователе;
	
КонецФункции

#КонецОбласти