﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ПроверитьЗаполнениеПредопределенного(Отказ);
	КонецЕсли;
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ВызватьИсключение НСтр("ru = 'Справочник ""Предопределенные варианты отчетов"" изменяется только при автоматическом заполнении его данных.'");
	КонецЕсли;
КонецПроцедуры

// Базовые проверки корректности данных предопределенных вариантов отчетов.
Процедура ПроверитьЗаполнениеПредопределенного(Отказ)
	Если ПометкаУдаления Тогда
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(Отчет) Тогда
		ТекстОшибки = НеЗаполненоПоле("Отчет");
	Иначе
		Возврат;
	КонецЕсли;
	Отказ = Истина;
	ВариантыОтчетов.ОшибкаПоВарианту(Ссылка, ТекстОшибки);
КонецПроцедуры

Функция НеЗаполненоПоле(ИмяПоля)
	Возврат СтрШаблон(НСтр("ru = 'Не заполнено поле ""%1""'"), ИмяПоля);
КонецФункции

#КонецОбласти

#КонецЕсли