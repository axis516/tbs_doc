﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЛогинДоступаКСервисуMorpher = Константы.ЛогинДоступаКСервисуMorpher.Получить();
	
	ВидДоступаКСервисуMorher = ?(ЗначениеЗаполнено(ЛогинДоступаКСервисуMorpher), 1, 0);
	УстановитьДоступностьЭлементов();
	
	УстановитьПривилегированныйРежим(Истина);
	Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.СклоненияПредставленийОбъектов"), "ПарольДоступаКСервисуMorpher"); 
	УстановитьПривилегированныйРежим(Ложь);
	
	ПарольДоступаКСервисуMorpher = ?(ЗначениеЗаполнено(Пароль), ЭтотОбъект.УникальныйИдентификатор, "");
	
	ЧастиСтроки = Новый Массив;
	ЧастиСтроки.Добавить(НСтр("ru = 'Анонимное использование сервиса имеет ограничения.'"));
	ЧастиСтроки.Добавить(" ");	
	ЧастиСтроки.Добавить(Новый ФорматированнаяСтрока("Подробнее", , , , "http://www.morpher.ru/WebService.aspx#limitations"));
	
	Элементы.ИнфоНадписьДоступКСервису.Заголовок = Новый ФорматированнаяСтрока(ЧастиСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДоступаКСервисуMorherПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов();
			
	Если ВидДоступаКСервисуMorher = 0 Тогда
		ЛогинДоступаКСервисуMorpher = "";		
		ПарольДоступаКСервисуMorpher = "";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьИзмененияНаСервере();
	Закрыть();
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьПарольВБезопасноеХранилищеНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
  	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ОбщегоНазначения.ИдентификаторОбъектаМетаданных("РегистрСведений.СклоненияПредставленийОбъектов"), ПарольДоступаКСервисуMorpher, "ПарольДоступаКСервисуMorpher");
  	ПарольДоступаКСервисуMorpher = ?(ЗначениеЗаполнено(ПарольДоступаКСервисуMorpher), ЭтотОбъект.УникальныйИдентификатор, "");
	ПарольДоступаКСервисуMorpherИзменен = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияНаСервере()
	
	Константы.ЛогинДоступаКСервисуMorpher.Установить(ЛогинДоступаКСервисуMorpher);
	ЗаписатьПарольВБезопасноеХранилищеНаСервере();
	
	СклонениеПредставленийОбъектов.УстановитьДоступностьСервисаСклонения(Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ЛогинДоступаКСервисуMorpher",
			"Доступность",
			ВидДоступаКСервисуMorher = 1);
			
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПарольДоступаКСервисуMorpher",
		"Доступность",
		ВидДоступаКСервисуMorher = 1);

КонецПроцедуры

#КонецОбласти



