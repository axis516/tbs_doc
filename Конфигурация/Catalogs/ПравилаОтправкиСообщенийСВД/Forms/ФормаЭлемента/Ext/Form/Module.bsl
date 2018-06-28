﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И Объект.Транспорт.ФорматСообщения = ПредопределенноеЗначение("Справочник.ФорматыСообщенийСВД.ОператорЭДО1СТакском") Тогда
		
		Элементы.ГруппаОрганизации.Видимость = Ложь;
		Элементы.ГруппаКонтрагенты.Видимость = Ложь;
		Элементы.ГруппаВидыДокументов.Видимость = Ложь;
		Элементы.ГруппаОграничения.Видимость = Ложь;
		Элементы.ГруппаСоглашенияЭД.Видимость = Истина;
		
	Иначе
		
		Элементы.ГруппаОрганизации.Видимость = Истина;
		Элементы.ГруппаКонтрагенты.Видимость = Истина;
		Элементы.ГруппаВидыДокументов.Видимость = Истина;
		Элементы.ГруппаОграничения.Видимость = Истина;
		Элементы.ГруппаСоглашенияЭД.Видимость = Ложь;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭД") Тогда
		ПрофильНастроекЭДО = Параметры.ПрофильНастроекЭДО;
		СписокСоглашенийЧерезОЭДО.Параметры.УстановитьЗначениеПараметра("ПрофильНастроекЭДО", ПрофильНастроекЭДО);
	КонецЕсли;
	
	МаксимальныйРазмерВсехПередаваемыхФайловМб = Объект.МаксимальныйРазмерВсехПередаваемыхФайлов / (1024*1024);
	МаксимальныйРазмерПередаваемогоФайлаМб = Объект.МаксимальныйРазмерПередаваемогоФайла / (1024*1024);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.МаксимальныйРазмерВсехПередаваемыхФайлов = МаксимальныйРазмерВсехПередаваемыхФайловМб * (1024*1024);
	ТекущийОбъект.МаксимальныйРазмерПередаваемогоФайла = МаксимальныйРазмерПередаваемогоФайлаМб * (1024*1024);
	
КонецПроцедуры

&НаКлиенте
Процедура ТранспортОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТранспортОператорЭДО1СТакском(ВыбранноеЗначение) Тогда
		
		Элементы.ГруппаОрганизации.Видимость = Ложь;		
		Элементы.ГруппаКонтрагенты.Видимость = Ложь;		
		Элементы.ГруппаВидыДокументов.Видимость = Ложь;		
		Элементы.ГруппаОграничения.Видимость = Ложь;		
		Элементы.ГруппаСоглашенияЭД.Видимость = Истина;		
		
	Иначе
		
		Элементы.ГруппаОрганизации.Видимость = Истина;		
		Элементы.ГруппаКонтрагенты.Видимость = Истина;		
		Элементы.ГруппаВидыДокументов.Видимость = Истина;		
		Элементы.ГруппаОграничения.Видимость = Истина;		
		Элементы.ГруппаСоглашенияЭД.Видимость = Ложь;		
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТранспортОператорЭДО1СТакском(ВыбранноеЗначение)

	Транспорт = ВыбранноеЗначение.ПолучитьОбъект();
	Возврат Транспорт.ФорматСообщения = ПредопределенноеЗначение("Справочник.ФорматыСообщенийСВД.ОператорЭДО1СТакском");
	
КонецФункции
