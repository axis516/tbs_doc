﻿
// Возвращает фактические работы на дату по пользователю
//	
Функция ПолучитьРаботыЗаДень(Дата, Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФактическиеТрудозатраты.Подразделение,
	|	ФактическиеТрудозатраты.Пользователь,
	|	ФактическиеТрудозатраты.Источник,
	|	ФактическиеТрудозатраты.Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.ВидРабот,
	|	ФактическиеТрудозатраты.ДатаДобавления,
	|	ФактическиеТрудозатраты.Начало,
	|	ФактическиеТрудозатраты.Окончание,
	|	ФактическиеТрудозатраты.Длительность,
	|	ФактическиеТрудозатраты.ЕжедневныйОтчет,
	|	ФактическиеТрудозатраты.ОписаниеРаботы
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(ФактическиеТрудозатраты.ДатаДобавления, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|	И ФактическиеТрудозатраты.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("ДатаОтчета", Дата);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Заполняет время начала и окончания дня в зависимости от настроек пользователя
//
Процедура ЗаполнитьНачалоИОкончаниеДня(Объект) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьГрафикиРаботы") Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.Пользователь) Тогда 
		Возврат;
	КонецЕсли;	
	
	ГрафикРаботы = ГрафикиРаботы.ПолучитьГрафикРаботыПользователя(Объект.Пользователь);
	СтруктураВозврата = ГрафикиРаботы.ПолучитьНачалоИОкончаниеРабочегоДня(Объект.Дата, ГрафикРаботы);
	
	Если ЗначениеЗаполнено(СтруктураВозврата.НачалоДня) Тогда 
		Объект.НачалоДня = СтруктураВозврата.НачалоДня;
		Объект.НачалоДня = Объект.НачалоДня - Секунда(Объект.НачалоДня);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураВозврата.ОкончаниеДня) Тогда 
		Объект.ОкончаниеДня = СтруктураВозврата.ОкончаниеДня;
		Объект.ОкончаниеДня = Объект.ОкончаниеДня - Секунда(Объект.ОкончаниеДня);
	КонецЕсли;	
	
КонецПроцедуры	
