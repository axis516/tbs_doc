﻿#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Наименование = Описание;
	
	// Определяем и сохраняем числовой код, для использования его при создании 
	// новых контрольных точек
	СтрокаЧисел = "0123456789";
	Для Индекс = 1 По СтрДлина(КодКТ) Цикл
		СимволПоиска = Сред(КодКТ, Индекс, 1);
		Если СтрНайти(СтрокаЧисел, СимволПоиска) <> 0 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПодстрокаКодаКТ = Сред(КодКТ, Индекс);
	Если Не ПустаяСтрока(ПодстрокаКодаКТ) Тогда
		ЧисловойКод = Число(ПодстрокаКодаКТ);
	Иначе	
		ЧисловойКод = 0;
	КонецЕСли;
	
	// Проверяем группу
	Если ГруппаКТ = Справочники.ШаблоныГруппКонтрольныхТочек.Все 
		ИЛИ ГруппаКТ = Справочники.ШаблоныГруппКонтрольныхТочек.НеВГруппе Тогда
		
		ГруппаКТ = Справочники.ШаблоныГруппКонтрольныхТочек.ПустаяСсылка();
		
	КонецЕсли;	
	
	СтарыеРеквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ОбъектКТ, ГруппаКТ, ПометкаУдаления"); 
	ДополнительныеСвойства.Вставить("СтарыйОбъектКТ", СтарыеРеквизиты.ОбъектКТ);
	ДополнительныеСвойства.Вставить("СтараяГруппаКТ", СтарыеРеквизиты.ГруппаКТ);
	ДополнительныеСвойства.Вставить("ПометкаУдаления", СтарыеРеквизиты.ПометкаУдаления);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.СтараяГруппаКТ <> ГруппаКТ 
		ИЛИ ДополнительныеСвойства.ПометкаУдаления <> ПометкаУдаления Тогда
		
		РегистрыСведений.ЧислоКТВКонтейнерах.ОбновитьЧислоКТПоШаблонуГруппы(ГруппаКТ);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.СтарыйОбъектКТ <> ОбъектКТ 
		ИЛИ ДополнительныеСвойства.ПометкаУдаления <> ПометкаУдаления Тогда
		
		РегистрыСведений.ЧислоКТВКонтейнерах.ОбновитьЧислоКТПоШаблону(ОбъектКТ);
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Проверяющий = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти
