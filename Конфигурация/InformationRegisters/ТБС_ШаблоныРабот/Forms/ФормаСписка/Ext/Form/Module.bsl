﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		 ДобавитьОписаниеРабот(ВыбранноеЗначение);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// установить отбор
	УстановитьОтбор();
	
КонецПроцедуры

#КонецОбласти


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьОписаниеРабот(ВыбранноеЗначение)
	
	мПользователь = ПолучитьТекущегоПользователя();
	НаборЗаписи = РегистрыСведений.ТБС_ШаблоныРабот.СоздатьНаборЗаписей();
	НаборЗаписи.Отбор.Сотрудник.Установить(мПользователь);
	НаборЗаписи.Отбор.ОписаниеРабот.Установить(ВыбранноеЗначение);
	
	НаборЗаписи.Прочитать();
	
	Если НаборЗаписи.Количество() = 0 Тогда
		
		НоваяЗапись 			  = НаборЗаписи.Добавить();
		НоваяЗапись.Сотрудник     = мПользователь;
		НоваяЗапись.ОписаниеРабот = ВыбранноеЗначение;
		НаборЗаписи.Записать();
		Элементы.Список.Обновить();
		
	КонецЕсли; 
	
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	мОтбор = ПолучитьСписокРаботПоШаблону();
	Параметр = Новый Структура;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Наименование", мОтбор);
	
	Параметр.Вставить("Отбор", Отбор);
	Параметр.Вставить("ЗакрыватьПриВыборе", Ложь);	
	ОткрытьФорму("Справочник.ТБС_ОписаниеРабот.ФормаВыбора",Параметр,ЭтаФорма);

КонецПроцедуры

&НаСервере
Функция ПолучитьСписокРаботПоШаблону()
	
	 Запрос = Новый Запрос;
	 Запрос.Текст = 
	 "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	 |	ТБС_ШаблоныРабот.ОписаниеРабот.Наименование КАК Наименование
	 |ПОМЕСТИТЬ ШаблонРабот
	 |ИЗ
	 |	РегистрСведений.ТБС_ШаблоныРабот КАК ТБС_ШаблоныРабот
	 |ГДЕ
	 |	ТБС_ШаблоныРабот.Сотрудник = &Сотрудник
	 |;
	 |
	 |////////////////////////////////////////////////////////////////////////////////
	 |ВЫБРАТЬ
	 |	ТБС_ОписаниеРабот.Наименование
	 |ИЗ
	 |	Справочник.ТБС_ОписаниеРабот КАК ТБС_ОписаниеРабот
	 |		ЛЕВОЕ СОЕДИНЕНИЕ ШаблонРабот КАК ШаблонРабот
	 |		ПО ТБС_ОписаниеРабот.Наименование = ШаблонРабот.Наименование
	 |ГДЕ
	 |	ЕСТЬNULL(ШаблонРабот.Наименование, 0) = 0";
	 Запрос.УстановитьПараметр("Сотрудник",ПолучитьТекущегоПользователя());
	 РезультатЗапроса = Запрос.Выполнить();
	 
	 СписокЗначений = Новый СписокЗначений;
	 СписокЗначений.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Наименование"));
	 
	 Возврат СписокЗначений;
	 
КонецФункции

&НаСервере
Функция ПолучитьТекущегоПользователя()
	
	мПользователь      = ПользователиКлиентСервер.ТекущийПользователь();	
	Возврат мПользователь;
	
КонецФункции

&НаСервере
Процедура УстановитьОтбор()
	
	ОтборВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Список, "Сотрудник",ПолучитьТекущегоПользователя(),
	ОтборВидСравнения, , Истина,РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	
КонецПроцедуры

#КонецОбласти