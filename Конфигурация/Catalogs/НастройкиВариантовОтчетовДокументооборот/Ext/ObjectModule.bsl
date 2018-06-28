﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если НЕ Пользовательский Тогда
		ИсключаемыеРеквизиты.Добавить("Автор");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") И ДополнительныеСвойства.ЗаполнениеПредопределенных Тогда 
		Возврат;
	КонецЕсли;
	
	ПользователемИзмененаПометкаУдаления = (
		НЕ ЭтоНовый()
		И ПометкаУдаления <> Ссылка.ПометкаУдаления
		И НЕ ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных")
	);
	
	Если НЕ Пользовательский И ПользователемИзмененаПометкаУдаления Тогда
		Если ПометкаУдаления Тогда
			ТекстОшибки = НСтр("ru = 'Пометка на удаление предопределенного варианта отчета запрещена.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'Снятие пометки удаления предопределенного варианта отчета запрещена.'");
		КонецЕсли;
		ОшибкаПоВарианту(Ссылка, ТекстОшибки);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОшибкаПоВарианту(Вариант, Сообщение, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Варианты отчетов'"),
		УровеньЖурналаРегистрации.Ошибка,
		Метаданные.Справочники.НастройкиВариантовОтчетовДокументооборот,
		Вариант,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Сообщение,
			Строка(Реквизит1),
			Строка(Реквизит2),
			Строка(Реквизит3)
		)
	);
КонецПроцедуры

#КонецЕсли
