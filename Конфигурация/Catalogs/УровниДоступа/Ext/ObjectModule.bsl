﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	УровниДоступа.Ссылка
		|ИЗ
		|	Справочник.УровниДоступа КАК УровниДоступа
		|ГДЕ
		|	УровниДоступа.Ссылка <> &Ссылка
		|	И УровниДоступа.Приоритет = &Приоритет");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Приоритет", Приоритет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ТекстПредупреждения = СтрШаблон(
			НСтр("ru = 'Приоритет ""%1"" уже используется элементом ""%2""'"),
			Приоритет, Выборка.Ссылка);
		
		ВызватьИсключение ТекстПредупреждения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли