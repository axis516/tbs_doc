﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру полей Должности
//
// Возвращаемое значение:
//   Структура
//     Наименование
//
Функция ПолучитьСтруктуруДолжности() Экспорт
	
	ПараметрыДолжности = Новый Структура;
	ПараметрыДолжности.Вставить("Наименование");
	
	Возврат ПараметрыДолжности;
	
КонецФункции

// Создает и записывает в БД должность
//
// Параметры:
//   СтруктураДолжности - Структура - структура полей должности.
//
Функция СоздатьДолжность(СтруктураДолжности) Экспорт
	
	НоваяДолжность = СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НоваяДолжность, СтруктураДолжности);
	НоваяДолжность.Записать();
	
	Возврат НоваяДолжность.Ссылка;
	
КонецФункции

#КонецОбласти

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецЕсли