﻿
Функция ПолучитьПараметрыНумерации(Объект) Экспорт 
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЧисловойНомер", 		Объект.ЧисловойНомер);
	СтруктураПараметров.Вставить("ДатаРегистрации", 	Объект.ДатаРегистрации);
	СтруктураПараметров.Вставить("ВидДокумента", 		Объект.ВидДокумента);
	СтруктураПараметров.Вставить("Организация",  		Объект.Организация);
	СтруктураПараметров.Вставить("НоменклатураДел", 	Объект.НоменклатураДел);
	СтруктураПараметров.Вставить("ВопросДеятельности", 	Объект.ВопросДеятельности);
	СтруктураПараметров.Вставить("Подразделение", 		Объект.Подразделение);
	СтруктураПараметров.Вставить("Ответственный", 		Объект.Ответственный);
	СтруктураПараметров.Вставить("Ссылка", 				Объект.Ссылка);
	СтруктураПараметров.Вставить("Проект", 				Объект.Проект);
	
	Если ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		СтруктураПараметров.Вставить("Контрагент", Объект.Отправитель);
		
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 	
		
		Если Объект.Получатели.Количество() > 0 И ЗначениеЗаполнено(Объект.Получатели[0].Получатель) Тогда 
			Получатель = Объект.Получатели[0].Получатель;
		Иначе
			Получатель = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		КонецЕсли;	
		СтруктураПараметров.Вставить("Контрагент", Получатель);
		
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда	
				
		ПараметрыСторон = РаботаСПодписямиДокументовКлиентСервер.ПараметрыРегистрации(Объект);
		СтруктураПараметров.Вставить("Контрагент", ПараметрыСторон.Контрагент);
		СтруктураПараметров.Вставить("Организация", ПараметрыСторон.Организация);
		
	КонецЕсли;	
	
	Если ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда 
		СтруктураПараметров.Вставить("ТипДокумента", ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ВходящиеДокументы"));
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда 
		СтруктураПараметров.Вставить("ТипДокумента", ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ИсходящиеДокументы"));
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда 
		СтруктураПараметров.Вставить("ТипДокумента", ПредопределенноеЗначение("Перечисление.ТипыОбъектов.ВнутренниеДокументы"));
	КонецЕсли;	
	
	Возврат СтруктураПараметров;
	
КонецФункции	
