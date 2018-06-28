﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавляет запись о пересчете в очередь.
//
// Параметры:
//  ПоказательПроцесса - СправочникСсылка.ПоказателиПроцессов - Показатель процесса.
//  ДатаПересчета - Дата - Дата до которой следует выполнить пересчет.
//
Процедура Добавить(ПоказательПроцесса, Знач ДатаПересчета = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ДатаПересчета = Неопределено Тогда
		ДатаПересчета = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ОчередьПересчетаПоказателейПроцессов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПоказательПроцесса = ПоказательПроцесса;
	МенеджерЗаписи.ДатаПересчета = ДатаПересчета;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

// Удаляет запись о пересчете из очереди.
//
// Параметры:
//  ПоказательПроцесса - СправочникСсылка.ПоказателиПроцессов - Показатель процесса.
//  ВерсияДанных - Строка - Показатель процесса.
//
Процедура Удалить(ПоказательПроцесса, ВерсияДанных = Неопределено) Экспорт
	
	Если ВерсияДанных <> Неопределено Тогда
		ВерсияДанныхПоказателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПоказательПроцесса, "ВерсияДанных");
		Если ВерсияДанныхПоказателя <> ВерсияДанных Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ОчередьПересчетаПоказателейПроцессов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПоказательПроцесса = ПоказательПроцесса;
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

