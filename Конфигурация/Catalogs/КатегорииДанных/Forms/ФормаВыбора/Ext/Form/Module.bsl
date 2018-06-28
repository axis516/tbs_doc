﻿
&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если НЕ РазрешеноВыбиратьВсеКатегории И Значение = ПредопределенноеЗначение("Справочник.КатегорииДанных.ВсеКатегории") Тогда
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'В правиле автоприсвоения категорий запрещено указывать категорию ""Все категории""'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ЗапрещеноВыбиратьВсеКатегории")
		И Параметры.ЗапрещеноВыбиратьВсеКатегории Тогда
		РазрешеноВыбиратьВсеКатегории = Ложь;
	Иначе
		РазрешеноВыбиратьВсеКатегории = Истина;
	КонецЕсли;
	
	ИспользоватьКатегории = ПолучитьФункциональнуюОпцию("ИспользоватьКатегорииДанных");
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ИспользоватьКатегории Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Использование категорий отключено в системе. Выбор категорий невозможен.'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

