﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПользователиПустаяСсылка = Справочники.Пользователи.ПустаяСсылка();
	
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.ИсторияЦикловДатаИсполнения);
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.ИсторияИсполнителяДатаИсполнения);
	
	ЗадачаСсылка = Параметры.ЗадачаСсылка;
	БизнесПроцесс = ЗадачаСсылка.БизнесПроцесс;
	АвторСогласования = БизнесПроцесс.Автор;
	Если НЕ ЗначениеЗаполнено(ЗадачаСсылка)
		ИЛИ ЗадачаСсылка.Исполнитель <> ПользователиКлиентСервер.ТекущийПользователь()
		ИЛИ ЗадачаСсылка.Автор = ПользователиКлиентСервер.ТекущийПользователь() Тогда
		Элементы.ЗадачаЗадачаИсполнителяЗадатьВопросАвтору.Видимость = Ложь;
		Элементы.АвторСогласования.Видимость = Ложь;
	КонецЕсли;
	
	НомерИтерации = 0;
	Если ЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Ознакомиться Тогда 
		
		НайденнаяСтрока = БизнесПроцесс.РезультатыОзнакомлений.Найти(ЗадачаСсылка, "ЗадачаИсполнителя");
		Если НайденнаяСтрока <> Неопределено Тогда 
			НомерИтерации = НайденнаяСтрока.НомерИтерации;
		КонецЕсли;		
	
		// заполнить дерево
		ДеревоИсторияЦиклов = РеквизитФормыВЗначение("ИсторияЦиклов");
		
		НомераИтераций = БизнесПроцесс.РезультатыСогласования.Выгрузить(,"НомерИтерации");
		НомераИтераций.Свернуть("НомерИтерации",);
		НомераИтераций.Сортировать("НомерИтерации Убыв");
		
		Для Каждого СтрокаИтерации Из НомераИтераций Цикл
			Если СтрокаИтерации.НомерИтерации >= НомерИтерации Тогда 
				Продолжить;
			КонецЕсли;	
			
			СтрокаДереваЦикл = ДеревоИсторияЦиклов.Строки.Добавить();
			СтрокаДереваЦикл.Исполнитель = "Цикл " + СтрокаИтерации.НомерИтерации;
			СтрокаДереваЦикл.НомерИтерации = СтрокаИтерации.НомерИтерации;
			
			Для Каждого Строка Из БизнесПроцесс.РезультатыСогласования Цикл
				Если СтрокаИтерации.НомерИтерации <> Строка.НомерИтерации Тогда 
					Продолжить;
				КонецЕсли;	
				
				СтрокаДереваИсполнитель = СтрокаДереваЦикл.Строки.Добавить();
				СтрокаДереваИсполнитель.ЗадачаИсполнителя = Строка.ЗадачаИсполнителя;
				СтрокаДереваИсполнитель.РезультатСогласования = Строка.РезультатСогласования;
								
				Если Строка.ЗадачаИсполнителя.Выполнена Тогда
					СтрокаДереваИсполнитель.ДатаИсполнения = Строка.ЗадачаИсполнителя.ДатаИсполнения;
				КонецЕсли;                                                                            
				
				СтрокаДереваИсполнитель.РезультатВыполнения = Строка.ЗадачаИсполнителя.РезультатВыполнения;
				СтрокаДереваИсполнитель.НомерИтерации = Строка.НомерИтерации;
				
				Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя.Исполнитель) Тогда 
					СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.Исполнитель;
				Иначе
					СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.РольИсполнителя;
				КонецЕсли;	
				
			КонецЦикла;	
			
		КонецЦикла;	
		
		ЗначениеВРеквизитФормы(ДеревоИсторияЦиклов, "ИсторияЦиклов");
		
		Элементы.ГруппаИсторияЦиклов.Видимость = Истина;
		Элементы.ГруппаИсторияИсполнителя.Видимость = Ложь;
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
		Заголовок = НСтр("ru = 'История согласования'");
		
	ИначеЕсли ЗадачаСсылка.ТочкаМаршрута = БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать Тогда 
		  
		НайденнаяСтрока = БизнесПроцесс.РезультатыСогласования.Найти(ЗадачаСсылка, "ЗадачаИсполнителя");
		Если НайденнаяСтрока <> Неопределено Тогда 
			НомерИтерации = НайденнаяСтрока.НомерИтерации;
		КонецЕсли;
		
		ДоступностьПоШаблону = ШаблоныБизнесПроцессов.ДоступностьПоШаблону(БизнесПроцесс);
		
		ВариантСогласования = БизнесПроцесс.ВариантСогласования;
		Если ВариантСогласования <> Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда 
			Элементы.ИсторияИсполнителяПорядокСогласования.Видимость = Ложь;
		КонецЕсли;	
		Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Параллельно Тогда 
			Элементы.ПереместитьВверх.Видимость = Ложь;
			Элементы.ПереместитьВниз.Видимость = Ложь;
			Элементы.КонтекстноеМенюПереместитьВверх.Видимость = Ложь;
			Элементы.КонтекстноеМенюПереместитьВниз.Видимость = Ложь;
		КонецЕсли;	
		
		Если НомерИтерации <> БизнесПроцесс.НомерИтерации Или Не ДоступностьПоШаблону 
			Или Не БизнесПроцессыИЗадачиСервер.БизнесПроцессАктивен(БизнесПроцесс) Тогда
			Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
			Элементы.ДобавитьСогласующего.Видимость = Ложь;
			Элементы.ПереместитьВверх.Видимость = Ложь;
			Элементы.ПереместитьВниз.Видимость = Ложь;
			
			Элементы.КонтекстноеМенюДобавитьСогласующего.Видимость = Ложь;
			Элементы.КонтекстноеМенюПереместитьВверх.Видимость = Ложь;
			Элементы.КонтекстноеМенюПереместитьВниз.Видимость = Ложь;
			Элементы.КонтекстноеМенюУдалитьСогласующего.Видимость = Ложь;
			
			Элементы.ИсторияИсполнителя.ТолькоПросмотр = Истина;
			Элементы.ИсторияИсполнителяПорядокСогласования.ТолькоПросмотр = Истина;
		КонецЕсли;	
		
		// заполнить дерево
		ДеревоИсторияИсполнителя = РеквизитФормыВЗначение("ИсторияИсполнителя");
		
		НомераИтераций = БизнесПроцесс.РезультатыСогласования.Выгрузить(,"НомерИтерации");
		НомераИтераций.Свернуть("НомерИтерации",);
		НомераИтераций.Сортировать("НомерИтерации Убыв");
		
		Для Каждого СтрокаИтерации Из НомераИтераций Цикл
			Если СтрокаИтерации.НомерИтерации > НомерИтерации Тогда 
				Продолжить;
			КонецЕсли;	
			
			Если СтрокаИтерации.НомерИтерации = БизнесПроцесс.НомерИтерации Тогда 
				
				СтрокаДереваЦикл = ДеревоИсторияИсполнителя.Строки.Добавить();
				СтрокаДереваЦикл.Исполнитель = "Цикл " + СтрокаИтерации.НомерИтерации + " (" + НРег(БизнесПроцесс.ВариантСогласования) + ")";
				СтрокаДереваЦикл.НомерИтерации = СтрокаИтерации.НомерИтерации;
				
				Для Каждого Строка Из БизнесПроцесс.Исполнители Цикл
					СтрокаДереваИсполнитель = СтрокаДереваЦикл.Строки.Добавить();
					СтрокаДереваИсполнитель.ЗадачаИсполнителя = Строка.ЗадачаИсполнителя;
					СтрокаДереваИсполнитель.ПорядокСогласования = Строка.ПорядокСогласования;
					СтрокаДереваИсполнитель.НомерИтерации = БизнесПроцесс.НомерИтерации;
					СтрокаДереваИсполнитель.Пройдена = Строка.Пройден;
					
					Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) Тогда 
												
						Если Строка.ЗадачаИсполнителя.Выполнена Тогда
							СтрокаДереваИсполнитель.ДатаИсполнения = Строка.ЗадачаИсполнителя.ДатаИсполнения;
						КонецЕсли;                                                                            
						
						СтрокаДереваИсполнитель.РезультатВыполнения = Строка.ЗадачаИсполнителя.РезультатВыполнения;
						
						Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя.Исполнитель) Тогда 
							СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.Исполнитель;
						Иначе
							СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.РольИсполнителя;
						КонецЕсли;	
						
						НайденнаяСтрока = БизнесПроцесс.РезультатыСогласования.Найти(Строка.ЗадачаИсполнителя, "ЗадачаИсполнителя");
						Если НайденнаяСтрока <> Неопределено Тогда 
							СтрокаДереваИсполнитель.РезультатСогласования = НайденнаяСтрока.РезультатСогласования;
						КонецЕсли;
						
					Иначе
						СтрокаДереваИсполнитель.Исполнитель = Строка.Исполнитель;
					КонецЕсли;	
				КонецЦикла;	
				
			Иначе
				
				СтрокаДереваЦикл = ДеревоИсторияИсполнителя.Строки.Добавить();
				СтрокаДереваЦикл.Исполнитель = "Цикл " + СтрокаИтерации.НомерИтерации;
				СтрокаДереваЦикл.НомерИтерации = СтрокаИтерации.НомерИтерации;
				
				Для Каждого Строка Из БизнесПроцесс.РезультатыСогласования Цикл
					Если СтрокаИтерации.НомерИтерации <> Строка.НомерИтерации Тогда 
						Продолжить;
					КонецЕсли;	
					
					СтрокаДереваИсполнитель = СтрокаДереваЦикл.Строки.Добавить();
					СтрокаДереваИсполнитель.ЗадачаИсполнителя = Строка.ЗадачаИсполнителя;
					СтрокаДереваИсполнитель.РезультатСогласования = Строка.РезультатСогласования;
					
					Если Строка.ЗадачаИсполнителя.Выполнена Тогда
						СтрокаДереваИсполнитель.ДатаИсполнения = Строка.ЗадачаИсполнителя.ДатаИсполнения;
					КонецЕсли;                                                                            					
					
					СтрокаДереваИсполнитель.РезультатВыполнения = Строка.ЗадачаИсполнителя.РезультатВыполнения;
					СтрокаДереваИсполнитель.НомерИтерации = Строка.НомерИтерации;
					СтрокаДереваИсполнитель.Пройдена = Строка.ЗадачаИсполнителя.Выполнена;
					
					Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя.Исполнитель) Тогда 
						СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.Исполнитель;
					Иначе
						СтрокаДереваИсполнитель.Исполнитель = Строка.ЗадачаИсполнителя.РольИсполнителя;
					КонецЕсли;	
					
				КонецЦикла;	
				
			КонецЕсли;	
			
			
		КонецЦикла;	
		
		ЗначениеВРеквизитФормы(ДеревоИсторияИсполнителя, "ИсторияИсполнителя");
		
		Элементы.ГруппаИсторияЦиклов.Видимость = Ложь;
		Элементы.ГруппаИсторияИсполнителя.Видимость = Истина;
		Заголовок = НСтр("ru = 'Ход согласования'");
		
	КонецЕсли;	
	
	Если ТолькоПросмотр Тогда 
		Элементы.ИсторияИсполнителя.ТолькоПросмотр = Истина;
		Элементы.ДобавитьСогласующего.Доступность = Ложь;
		Элементы.ПереместитьВверх.Доступность = Ложь;
		Элементы.ПереместитьВниз.Доступность = Ложь;
		
		Элементы.КонтекстноеМенюДобавитьСогласующего.Доступность = Ложь;
		Элементы.КонтекстноеМенюПереместитьВверх.Доступность = Ложь;
		Элементы.КонтекстноеМенюПереместитьВниз.Доступность = Ложь;
		Элементы.КонтекстноеМенюУдалитьСогласующего.Доступность = Ложь;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Элементы.ГруппаИсторияЦиклов.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	
	Если ЭлементыДерева.Количество() > 0 Тогда 
		ЭлементДерева = ЭлементыДерева[0];
		Элементы.ИсторияИсполнителя.Развернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсторияЦикловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИсторияЦиклов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда
		БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ТекущиеДанные.ЗадачаИсполнителя, Поле, СтандартнаяОбработка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияЦикловПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ИсторияЦиклов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда
		ПоказатьЗначение(,ТекущиеДанные.ЗадачаИсполнителя);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИсторияИсполнителя

&НаКлиенте
Процедура ИсторияИсполнителяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		СтандартнаяОбработка = Ложь;
		
		Если Элементы.ИсторияИсполнителя.Развернут(ТекущиеДанные.ПолучитьИдентификатор()) Тогда 
			Элементы.ИсторияИсполнителя.Свернуть(ТекущиеДанные.ПолучитьИдентификатор());
		Иначе
			Элементы.ИсторияИсполнителя.Развернуть(ТекущиеДанные.ПолучитьИдентификатор());
		КонецЕсли;	
		
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Добавлена Тогда 
		Возврат;
	КонецЕсли;	
		
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда  
		БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ТекущиеДанные.ЗадачаИсполнителя, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	ЭлементДерева = ИсторияИсполнителя.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	
	Если ЭлементДерева = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЭлементыДерева.Индекс(ЭлементДерева) = 0 Тогда 
		ДобавитьСтрокуСогласующего();
		Возврат;
	КонецЕсли;	
	
	РодительЭлементаДерева = ЭлементДерева.ПолучитьРодителя();
	Если ЭлементыДерева.Индекс(РодительЭлементаДерева) = 0 Тогда 
		ДобавитьСтрокуСогласующего();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяПередНачаломИзменения(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Добавлена Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗначениеЗаполнено(ТекущиеДанные.ЗадачаИсполнителя) Тогда  
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ТекущиеДанные.ЗадачаИсполнителя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Добавлена Тогда 
		ПоказатьПредупреждение(,НСтр("ru = 'Можно удалить только строки, созданные самостоятельно и не сохраненные.'"));
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Возврат;
	КонецЕсли;	
	
	РаботаСАдреснойКнигойКлиент.ВыбратьИсполнителяДляПроцесса(ЭтаФорма, Элементы.ИсторияИсполнителя);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("Строка, СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИсполнителяИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("Строка, СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьСогласующего(Команда)
	
	ДобавитьСтрокуСогласующего();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВверх(Команда)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Добавлена Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Можно передвинуть только строки, созданные самостоятельно и не сохраненные.'"));
		Возврат;
	КонецЕсли;
	
	ЭлементДерева = ИсторияИсполнителя.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	ЭлементРодитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если ЭлементРодитель <> Неопределено Тогда 
		ЭлементыДерева = ЭлементРодитель.ПолучитьЭлементы();
		
		Индекс = ЭлементыДерева.Индекс(ЭлементДерева);
		Если Индекс = 0 Тогда 
			Возврат;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(ЭлементыДерева[Индекс-1].ЗадачаИсполнителя) Тогда 
			ПоказатьПредупреждение(,НСтр("ru = 'Задача предыдущего исполнителя уже сформирована, изменение порядка строки невозможно.'"));
			Возврат;
		КонецЕсли;
		
		ЭлементыДерева.Сдвинуть(Индекс, -1); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьВниз(Команда)
	
	ТекущиеДанные = Элементы.ИсторияИсполнителя.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.Исполнитель) = Тип("Строка") Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Добавлена Тогда 
		ПоказатьПредупреждение(,НСтр("ru = 'Можно передвинуть только строки, созданные самостоятельно и не сохраненные.'"));
		Возврат;
	КонецЕсли;
	
	ЭлементДерева = ИсторияИсполнителя.НайтиПоИдентификатору(ТекущиеДанные.ПолучитьИдентификатор());
	ЭлементРодитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если ЭлементРодитель <> Неопределено Тогда 
		ЭлементыДерева = ЭлементРодитель.ПолучитьЭлементы();
		Индекс = ЭлементыДерева.Индекс(ЭлементДерева);
		Если Индекс < ЭлементыДерева.Количество()-1 Тогда 
			ЭлементыДерева.Сдвинуть(Индекс, 1); 
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаИсторияЦиклов Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	Если ЭлементыДерева.Количество() = 0 Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	СтрокаДерева = ЭлементыДерева[0];
	ЭлементыСтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
	
	// Удаление пустых строк
	КоличествоСтрокДерева = ЭлементыСтрокиДерева.Количество();
	Для Инд = 1 По КоличествоСтрокДерева Цикл
		Строка = ЭлементыСтрокиДерева[КоличествоСтрокДерева - Инд];
		Если Строка.Добавлена И Не ЗначениеЗаполнено(Строка.Исполнитель) Тогда
			ЭлементыСтрокиДерева.Удалить(Строка);
		КонецЕсли;
	КонецЦикла;
	
	// Проверка добавленных строк
	ЕстьДобавленныеСтроки = Ложь;
	Для Каждого Строка Из ЭлементыСтрокиДерева Цикл
		Если Строка.Добавлена Тогда
			ЕстьДобавленныеСтроки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;	
	
	Если Не ЕстьДобавленныеСтроки Тогда 
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	// проверка дублей
	ОчиститьСообщения();
	
	КоличествоИсполнителей = ЭлементыСтрокиДерева.Количество();
	Для Инд1 = 0 По КоличествоИсполнителей-2 Цикл
		Строка1 = ЭлементыСтрокиДерева[Инд1];
		
		Для Инд2 = Инд1+1 По КоличествоИсполнителей-1 Цикл
			Строка2 = ЭлементыСтрокиДерева[Инд2];
			
			Если Строка1.Исполнитель = Строка2.Исполнитель Тогда 
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке согласующих!'"), 
					Строка(Строка1.Исполнитель));
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,,
					"ИсторияИсполнителя",,);
					
				Возврат;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	
	ТекстВопроса = НСтр("ru = 'В список согласующих были добавлены новые исполнители. Будет выполнено обновление процесса.
		|Продолжить?'");
		
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОКПродолжениеПослеВопроса",
		ЭтотОбъект);
		
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);		
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьБизнесПроцесс()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДеревоИсторияИсполнителя = РеквизитФормыВЗначение("ИсторияИсполнителя");
	Если ДеревоИсторияИсполнителя.Строки.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	ЗадачаСсылка = Параметры.ЗадачаСсылка;
	БизнесПроцесс = ЗадачаСсылка.БизнесПроцесс;
	
	Если Не БизнесПроцессыИЗадачиСервер.БизнесПроцессАктивен(БизнесПроцесс) Тогда 
		ВызватьИсключение НСтр("ru = 'Бизнес процесс не активен, данные запрещено изменять.
		|Обратитесь к администратору.'");
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		БизнесПроцессОбъект = БизнесПроцесс.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
		
		СтарыеУчастникиПроцесса = БизнесПроцессыИЗадачиВызовСервера.ТекущиеУчастникиПроцесса(БизнесПроцессОбъект);
		
		СтрокиДерева = ДеревоИсторияИсполнителя.Строки[0].Строки;
		Для Каждого Строка Из СтрокиДерева Цикл
			Если Строка.Добавлена Тогда 
				Индекс = СтрокиДерева.Индекс(Строка);
				НоваяСтрока = БизнесПроцессОбъект.Исполнители.Вставить(Индекс);
				НоваяСтрока.Исполнитель = Строка.Исполнитель;
				НоваяСтрока.ПорядокСогласования = Строка.ПорядокСогласования;
			КонецЕсли;
		КонецЦикла;
		
		БизнесПроцессОбъект.Записать();
		
		УзелОбменаПроцесса = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
			БизнесПроцесс, "УзелОбмена");
		ЭтотУзелОбмена = РаботаСБизнесПроцессами.ЭтотУзелОбменаДляОбработкиПроцессов();
		
		Если УзелОбменаПроцесса = ЭтотУзелОбмена Тогда
			БизнесПроцессОбъект.ИзменитьРеквизитыНевыполненныхЗадач(СтарыеУчастникиПроцесса, Новый Структура);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрокуСогласующего()
	
	ЭлементыДерева = ИсторияИсполнителя.ПолучитьЭлементы();
	
	Если ЭлементыДерева.Количество() > 0 Тогда 
		СтрокаДерева = ЭлементыДерева[0];
		ЭлементыСтрокиДерева = СтрокаДерева.ПолучитьЭлементы();
		
		
		ВсеПройдены = Истина;
		Для Каждого Строка Из ЭлементыСтрокиДерева Цикл
			Если ЗначениеЗаполнено(Строка.ЗадачаИсполнителя) И Не Строка.Пройдена Тогда 
				ВсеПройдены = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;	
		
		Если ВсеПройдены Тогда 
			ПоказатьПредупреждение(,НСтр("ru = 'Все исполнители завершили свои задачи, добавление строки невозможно!'"));
			Отказ = Истина;
		КонецЕсли;
		
		
		НоваяСтрока = ЭлементыСтрокиДерева.Добавить();
		НоваяСтрока.Добавлена = Истина;
		НоваяСтрока.Исполнитель = ПользователиПустаяСсылка;
		
		Если ВариантСогласования = ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Смешанно") Тогда 
			Индекс = ЭлементыСтрокиДерева.Индекс(НоваяСтрока);
			Если Индекс > 0 Тогда 
				ПредыдущаяСтрока = ЭлементыСтрокиДерева.Получить(Индекс-1);
				НоваяСтрока.ПорядокСогласования = ПредыдущаяСтрока.ПорядокСогласования;
			КонецЕсли;
		КонецЕсли;	
		
		Элементы.ИсторияИсполнителя.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		Элементы.ИсторияИсполнителя.ИзменитьСтроку();
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ОКПродолжениеПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;	
	
	ОбновитьБизнесПроцесс();	
	
	Оповестить("ИзмененСоставСогласующих", БизнесПроцесс);
	Оповестить("ИзмененыРеквизитыНевыполненныхЗадач", БизнесПроцесс);
	
	ПоказатьОповещениеПользователя(
		"Изменение:", 
		ПолучитьНавигационнуюСсылку(БизнесПроцесс),
		Строка(БизнесПроцесс),
		БиблиотекаКартинок.Информация32);
		
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
