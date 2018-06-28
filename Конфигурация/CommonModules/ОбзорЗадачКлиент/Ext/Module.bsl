﻿
#Область ПрограммныйИнтерфейс

// Обработчик нажатия поля ПредставлениеHTML в карточках задач
//
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Экспорт
	
	Если ОбзорЗадачКлиентПереопределяемый.ПредставлениеHTMLПриНажатии(
		Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Тогда
		
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) = "v8doc:" Тогда 
		
		НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
		
		#Если Клиент Тогда
			ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
		#КонецЕсли
	ИначеЕсли Найти(ДанныеСобытия.Href, "ИзменитьСрокВыполнения") Тогда
		
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Задача", Форма.Объект.Ссылка);
		ЗначенияЗаполнения.Вставить("ВидВопроса",
			ПредопределенноеЗначение("Перечисление.ВидыВопросовВыполненияЗадач.ПереносСрока"));
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("БизнесПроцесс.РешениеВопросовВыполненияЗадач.ФормаОбъекта",
			ПараметрыФормы);
	ИначеЕсли Найти(ДанныеСобытия.Href, "ПоказатьПричинуПрерыванияПроцесса") Тогда
		КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(Форма);
	ИначеЕсли Найти(ДанныеСобытия.Href, "ОткрытьКарточкуКонтроля") Тогда
		КонтрольКлиент.ОбработкаКомандыКонтроль(форма.Объект.БизнесПроцесс, Форма);
	ИначеЕсли Найти(ДанныеСобытия.Href, "ПоказатьПричинуОтменыВыполнения") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Ошибка при выполнении задачи'"));
		ПараметрыФормы.Вставить("ТекстСообщения", Форма.ПричинаОтменыВыполнения);
		ОткрытьФорму("ОбщаяФорма.Сообщение", ПараметрыФормы, Форма);
		
	// Открываем предмет на вкладке Товары
	ИначеЕсли Найти(ДанныеСобытия.Href, "goods") Тогда
		ОткрытьПредметСТоварами(ДанныеСобытия.Href);
		
	ИначеЕсли Найти(ДанныеСобытия.Href, "ПоказатьПерепискуПоДокументу") Тогда		
		
		ОткрытьПереписку(ДанныеСобытия.Href);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия поля ПолноеОписаниеЗадачи в списке Задачи мне
//
Процедура ЗадачиМнеПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Экспорт
	
	Если ОбзорЗадачКлиентПереопределяемый.ЗадачиМнеПредставлениеHTMLПриНажатии(
		Элемент, ДанныеСобытия, СтандартнаяОбработка, Форма) Тогда
		
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	Если Не ЗначениеЗаполнено(ДанныеСобытия.Href) Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Лев(ДанныеСобытия.Href, 6) = "v8doc:" Тогда 
		
		НавигационнаяСсылкаПоля = Сред(ДанныеСобытия.Href, 7);
		
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаПоля);
		
	// Открываем предмет на вкладке Товары
	ИначеЕсли Найти(ДанныеСобытия.Href, "goods") Тогда
		ОткрытьПредметСТоварами(ДанныеСобытия.Href);
		
	ИначеЕсли Найти(ДанныеСобытия.Href, "ПоказатьПерепискуПоДокументу") Тогда		
		
		ОткрытьПереписку(ДанныеСобытия.Href);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму переписки по документу
//
// Параметры:
//   Href - значение из ДанныеСобытия.Href при клике в ПолеHTMLДокумента
//
Процедура ОткрытьПереписку(Href) Экспорт
	
	ИмяТегаПереписки = "ПоказатьПерепискуПоДокументу";
	
	ПозицияНачала = СтрНайти(Href, ИмяТегаПереписки);
	Если ПозицияНачала <> 0 Тогда
		
		ПозицияКонца = ПозицияНачала + СтрДлина(ИмяТегаПереписки);
		НавигСсылка = Сред(Href, ПозицияКонца + 1);
		
		ПрефиксВнутрДок = "ВнутренниеДокументы";
		ПрефиксВхДок = "ВходящиеДокументы";
		ПрефиксИсхДок = "ИсходящиеДокументы";
		
		ПрефиксДок = "";
		Если СтрНайти(НавигСсылка, ПрефиксВнутрДок) <> 0 Тогда
			ПрефиксДок = ПрефиксВнутрДок;
		ИначеЕсли СтрНайти(НавигСсылка, ПрефиксВхДок) <> 0 Тогда
			ПрефиксДок = ПрефиксВхДок;
		ИначеЕсли СтрНайти(НавигСсылка, ПрефиксИсхДок) <> 0 Тогда
			ПрефиксДок = ПрефиксИсхДок;
		КонецЕсли;	
		
		Если ПрефиксДок <> "" Тогда
			ПозицияНачала = СтрНайти(НавигСсылка, ПрефиксДок);
			Если ПозицияНачала <> 0 Тогда
				
				ПозицияКонца = ПозицияНачала + СтрДлина(ПрефиксДок);
				СтрокаИД = Сред(НавигСсылка, ПозицияКонца + 5); // 5 = это длина строки "?ref="
				
				ДокументСсылка = ОбзорЗадачВызовСервера.ПолучитьСсылкуДокументаПоИдентификатору(
					ПрефиксДок, СтрокаИД);
					
					Если ЗначениеЗаполнено(ДокументСсылка) Тогда
						
						Если ПрефиксДок = ПрефиксВхДок Или ПрефиксДок = ПрефиксИсхДок Тогда

							ПараметрыФормы = Новый Структура("Документ", ДокументСсылка);
							ОткрытьФорму("ОбщаяФорма.ИсторияПереписки", ПараметрыФормы);
							
						КонецЕсли;	

						Если ПрефиксДок = ПрефиксВнутрДок Тогда

							ПараметрыФормы = Новый Структура("ПредметПереписки", ДокументСсылка);
							ОткрытьФорму("ОбщаяФорма.ПерепискаПоПредмету", ПараметрыФормы);
							
						КонецЕсли;	
						
				КонецЕсли;	
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

// Открывает форму документа на вкладке Товары
//
// Параметры:
//   Href - значение из ДанныеСобытия.Href при клике в ПолеHTMLДокумента
//
Процедура ОткрытьПредметСТоварами(Href) Экспорт
	
	ИмяТегаПереписки = "goods";
	
	ПозицияНачала = СтрНайти(Href, ИмяТегаПереписки);
	Если ПозицияНачала <> 0 Тогда
		
		ПозицияКонца = ПозицияНачала + СтрДлина(ИмяТегаПереписки);
		НавигСсылка = Сред(Href, ПозицияКонца);
		ПрефиксДок = "ВнутренниеДокументы";
			
		Если ПозицияНачала <> 0 Тогда
			СтрокаИД = Сред(НавигСсылка, 6); // 6 = это длина строки "?ref="
			
			ДокументСсылка = ОбзорЗадачВызовСервера.ПолучитьСсылкуДокументаПоИдентификатору(
				ПрефиксДок, СтрокаИД);
				
			Если ЗначениеЗаполнено(ДокументСсылка) Тогда
				ПараметрыОткрытия = Новый Структура("Ключ, ОткрытьЗакладкуТовары", ДокументСсылка, Истина);
				ОткрытьФорму("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыОткрытия);
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

