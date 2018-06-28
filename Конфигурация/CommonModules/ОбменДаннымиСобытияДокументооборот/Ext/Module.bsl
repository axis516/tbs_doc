﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий изменения данных

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО - БП

Процедура ОбменДаннымиДОБППередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменБухгалтерияПредприятияДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОБППередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.Отбор.Найти("Состояние") <> Неопределено
		и Источник.Отбор.Состояние.Значение = Перечисления.СостоянияДокументов.Согласован
		и Источник.Количество() > 0 
		и Источник.Отбор.Найти("Документ") <> Неопределено
		и ТипЗнч(Источник.Отбор.Документ.Значение) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Узлы = ОбменДаннымиПовтИсп.УзлыПланаОбмена("ОбменБухгалтерияПредприятияДокументооборот20");
		ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Источник.Отбор.Документ.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбменДаннымиДОБППередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменБухгалтерияПредприятияДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО - УНФ

Процедура ОбменДаннымиДОУНФПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеНебольшойФирмойДокументооборот", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУНФПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеНебольшойФирмойДокументооборот", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУНФПередЗаписьюКонстанты(Источник, Отказ) Экспорт
		
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("ОбменУправлениеНебольшойФирмойДокументооборот", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУНФПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеНебольшойФирмойДокументооборот", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО - УП

Процедура ОбменДаннымиДОУППередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУППередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.СведенияОПользователяхДокументооборот") Тогда
		Если Источник.Отбор.Найти("Пользователь") <> Неопределено
			И Источник.Отбор.Пользователь.Использование
			И Источник.Отбор.Пользователь <> Справочники.Пользователи.ПустаяСсылка() Тогда
		
			ИмяПланаОбмена = "ОбменУправлениеПредприятиемДокументооборот20";
			УзлыПланаОбмена = ОбменДаннымиПовтИсп.УзлыПланаОбмена(ИмяПланаОбмена);
			Если УзлыПланаОбмена.Количество() = 0 Тогда
				Возврат;
			КонецЕсли;
			
			СоставПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав;
			
			Для Каждого Запись Из Источник Цикл
				ПланыОбмена.ЗарегистрироватьИзменения(УзлыПланаОбмена, Запись.Пользователь);
			КонецЦикла; 
			
		КонецЕсли;
	Иначе
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ, Замещение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбменДаннымиДОУППередЗаписьюКонстанты(Источник, Отказ) Экспорт
		
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУППередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО - УТ

Процедура ОбменДаннымиДОУТПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеТорговлейДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУТПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеТорговлейДокументооборот20", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУТПередЗаписьюКонстанты(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("ОбменУправлениеТорговлейДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУТПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеТорговлейДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО - УПП 1.3

Процедура ОбменДаннымиДОУПП13ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью(
		"ОбменУправлениеПроизводственнымПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУПП13ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра(
		"ОбменУправлениеПроизводственнымПредприятиемДокументооборот20", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУПП13ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением(
		"ОбменУправлениеПроизводственнымПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО - УХ

Процедура ОбменДаннымиДОУХПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеХолдингомДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

Процедура ОбменДаннымиДОУХПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеХолдингомДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен ДО21 - ДО21

Процедура ОбменДаннымиДО20ДО21ПередЗаписью(Источник, Отказ) Экспорт
	
	Если Не Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ОбменДанными")
		Или Не Источник.ДополнительныеСвойства.ОбменДанными.Свойство("Отправитель") Тогда
		// если это не план обмена ОбменДокументооборот20Документооборот21
		//  ничего не делаем.
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(Источник.ДополнительныеСвойства.ОбменДанными.Отправитель) <> Тип("ПланОбменаСсылка.ОбменДокументооборот20Документооборот21") Тогда
		// если это не план обмена ОбменДокументооборот20Документооборот21
		//  ничего не делаем.
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(Источник) = Тип("СправочникОбъект.ВидыВнутреннихДокументов") Тогда
		
		Если Источник.ЭтоНовый() Тогда
			
			Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда
			
				Если Не Источник.ВестиУчетПоОрганизациям И Не Источник.ЭтоГруппа Тогда
					Источник.ВестиУчетПоОрганизациям = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;	
		
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.ПравилаАвтозаполненияФайлов") Тогда
		
		НужнаЗапись = Ложь;
		ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_ПравилаАвтозаполненияФайлов_Корреспондент(
			Источник, НужнаЗапись);
			
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.УсловияМаршрутизации") Тогда
		
		НужнаЗапись = Ложь;
		ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УсловияМаршрутизации_Корреспондент(
			Источник, НужнаЗапись);
			
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.Нумераторы") Тогда
		
		НужнаЗапись = Ложь;
		ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_Нумераторы_Корреспондент(
			Источник, НужнаЗапись);
			
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.ГруппыДоступа") Тогда
			
		Если Источник.ЭтоНовый() Тогда
			
			Для Каждого Пользователь Из Источник.Пользователи Цикл
				РегистрыСведений.ПолномочияПользователей.ДобавитьПолномочия(
					Пользователь, Источник.Профиль);
			КонецЦикла;
			
		Иначе
			
			Если Источник.ПометкаУдаления Тогда
				
				// удалим все
				
				Для Каждого СтрокаПользователь Из Источник.Пользователи Цикл
					
					Пользователь = СтрокаПользователь.Пользователь;
					
					Если Не ПолномочияПользователей_Используются(Пользователь, Источник.Профиль, Источник.Ссылка) Тогда
						РегистрыСведений.ПолномочияПользователей.УдалитьПолномочия(
							Пользователь, Источник.Профиль);
						ОбновлениеИнформационнойБазыДокументооборот.УдалитьСуществующуюСлужебнуюРабочуюГруппу(
							Источник.Ссылка);	
					КонецЕсли;		
						
				КонецЦикла;
				
			Иначе	
			
				СтарыйОбъект = Источник.Ссылка;
				МассивПользователейДобавить = Новый Массив;
				МассивПользователейУдалить = Новый Массив;
				
				// найдем, что удалено
				Для Каждого СтрокаПользователь Из СтарыйОбъект.Пользователи Цикл
					
					Пользователь = СтрокаПользователь.Пользователь;
					
					Если Источник.Пользователи.Найти(Пользователь, "Пользователь") = Неопределено Тогда
						
						// проверить что не используется кем то еще
						Если Не ПолномочияПользователей_Используются(Пользователь, Источник.Профиль, Источник.Ссылка) Тогда
							РегистрыСведений.ПолномочияПользователей.УдалитьПолномочия(
								Пользователь, Источник.Профиль);
						КонецЕсли;		
						
					КонецЕсли;	
				КонецЦикла;	
				
				
				// найдем, что добавлено
				Для Каждого СтрокаПользователь Из Источник.Пользователи Цикл
					
					Пользователь = СтрокаПользователь.Пользователь;
					
					Если СтарыйОбъект.Пользователи.Найти(Пользователь, "Пользователь") = Неопределено Тогда
						
						РегистрыСведений.ПолномочияПользователей.ДобавитьПолномочия(
							Пользователь, Источник.Профиль);
						
					КонецЕсли;		
						
				КонецЦикла;	
				
				Если МассивПользователейДобавить.Количество() <> 0 
					Или МассивПользователейУдалить.Количество() <> 0 Тогда 
					ОбновлениеИнформационнойБазыДокументооборот.ОбновитьСуществующуюСлужебнуюРабочуюГруппу(
						Источник.Ссылка, МассивПользователейДобавить, МассивПользователейУдалить)
				КонецЕсли;	
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.УведомленияПрограммы") Тогда
		
		ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УведомленияПрограммы(Источник);
		
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.ВизыСогласования")
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.Инструкции")
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.КатегорииДанных") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.Контроль") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.Мероприятия") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.НастройкиДоступностиПоСостоянию") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ПроектныеЗадачи") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.Проекты") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ПротоколыМероприятий") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.Резолюции") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныВнутреннихДокументов") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныВходящихДокументов") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныИсполнения") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныИсходящихДокументов") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныОзнакомления") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныПоручения") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныПриглашения") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныРассмотрения") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныРегистрации") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныСогласования") 
		Или ТипЗнч(Источник) = Тип("СправочникОбъект.ШаблоныУтверждения") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Исполнение") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.КомплексныйПроцесс") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Ознакомление") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Поручение") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Приглашение") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Рассмотрение") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Регистрация") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.РешениеВопросовВыполненияЗадач") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Согласование") 
		Или ТипЗнч(Источник) = Тип("БизнесПроцессОбъект.Утверждение") 
		Или ТипЗнч(Источник) = Тип("ЗадачаОбъект.ЗадачаИсполнителя") Тогда
		
		ОбновлениеИнформационнойБазыДокументооборот.РеорганизацияРолейСОбъектамиАдресацииОбработатьПроизвольныйОбъект(Источник);
		
	КонецЕсли;		
	
КонецПроцедуры

Процедура ОбменДаннымиДО20ДО21ПередЗаписьюДокумента(Источник, Отказ) Экспорт
	
	Если Не Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ОбменДанными")
		Или Не Источник.ДополнительныеСвойства.ОбменДанными.Свойство("Отправитель") Тогда
		// если это не план обмена ОбменДокументооборот20Документооборот21
		//  ничего не делаем.
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(Источник.ДополнительныеСвойства.ОбменДанными.Отправитель) <> Тип("ПланОбменаСсылка.ОбменДокументооборот20Документооборот21") Тогда
		// если это не план обмена ОбменДокументооборот20Документооборот21
		//  ничего не делаем.
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.ВходящееПисьмо") Тогда
		
		Если Источник.ЭтоНовый() Тогда
			
			Если Источник.НомерСпособаАдресации = 0 Тогда
				Источник.НомерСпособаАдресации = ВстроеннаяПочтаСервер.ПолучитьСпособАдресацииОбъекта(Источник);
			КонецЕсли;
			
		КонецЕсли;	
		
	КонецЕсли;		
	
КонецПроцедуры

Процедура ОбменДаннымиДО20ДО21ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	Если Не Источник.ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ДополнительныеСвойства.Свойство("ОбменДанными")
		Или Не Источник.ДополнительныеСвойства.ОбменДанными.Свойство("Отправитель") Тогда
		// если это не план обмена ОбменДокументооборот20Документооборот21
		//  ничего не делаем.
		Возврат;
	КонецЕсли;	
	
	Если ТипЗнч(Источник.ДополнительныеСвойства.ОбменДанными.Отправитель) <> Тип("ПланОбменаСсылка.ОбменДокументооборот20Документооборот21") Тогда
		// если это не план обмена ОбменДокументооборот20Документооборот21
		//  ничего не делаем.
		Возврат;
	КонецЕсли;	
	
	Если Источник.Количество() <> 0 Тогда
		
		Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.НастройкиУведомлений") Тогда	
			
			Настройка = Источник.Отбор.Настройка.Значение;
			ВидСобытия = Источник.Отбор.ВидСобытия.Значение;
			
			Если (Настройка = Перечисления.НастройкиУведомлений.УдалитьУведомленияПрограммы
				И ВидСобытия = Перечисления.СобытияУведомлений.УведомлениеПрограммы) Тогда
				
				Источник.Очистить();
			
			КонецЕсли;	
			
		КонецЕсли;	
		
		Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ОчередьУведомлений") Тогда	
			
			ВидСобытия = Источник.Отбор.ВидСобытия.Значение;
			
			Если ВидСобытия = Перечисления.СобытияУведомлений.УведомлениеПрограммы Тогда
				
				Источник.Очистить();
			
			КонецЕсли;	
			
		КонецЕсли;	
		
		Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ОчередьУведомлений") Тогда	
			
			ЗаписиКУдалению = Новый Массив;
			
			Для Каждого Запись Из Источник Цикл
				
				Если Запись.Пользователь = Справочники.Пользователи.ПустаяСсылка() Тогда
					ЗаписиКУдалению.Добавить(Запись);
				КонецЕсли;	
				
			КонецЦикла;	
			
			Для Каждого Запись Из ЗаписиКУдалению Цикл
				
				Источник.Удалить(Запись);
				
			КонецЦикла;	
			
		КонецЕсли;	
		
		Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ИсполнителиЗадач")
			Или ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ИсполнителиРолейИДелегаты")
			Или ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.РабочиеГруппы")
			Или ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.СведенияОбИсполнителяхЗадач")
			Или ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.СоставСубъектовПравДоступа")
			Или ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.УчастникиМероприятия")
			Или ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.УчастникиПроцессов") Тогда
			
			ОбновлениеИнформационнойБазыДокументооборот.РеорганизацияРолейСОбъектамиАдресацииОбработатьПроизвольныйОбъект(Источник);
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.УдалитьПраваПоДескрипторамДоступа") Тогда	
		
		Дескриптор = Источник.Отбор.Дескриптор.Значение;
		Пользователь = Источник.Отбор.Пользователь.Значение;
		
		Если ТипЗнч(Дескриптор) = Тип("СправочникСсылка.ДескрипторыДоступаРегистров") Тогда
		
			Набор = РегистрыСведений.ПраваПоДескрипторамДоступаРегистров.СоздатьНаборЗаписей();
			Если ЗначениеЗаполнено(Дескриптор) Тогда
				Набор.Отбор.Дескриптор.Установить(Дескриптор);
			КонецЕсли;	
			Если ЗначениеЗаполнено(Пользователь) Тогда
				Набор.Отбор.Пользователь.Установить(Пользователь);
			КонецЕсли;	
			
			Для Каждого Запись Из Источник Цикл
				
				ЗаполнитьЗначенияСвойств(Набор.Добавить(), Запись);
				
			КонецЦикла;	
			
			Набор.Записать();
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Для Каждого Запись Из Источник Цикл
		
		Если ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.НастройкиУведомлений") Тогда
			
			Если (Запись.Настройка = Перечисления.НастройкиУведомлений.ВыполнениеЗадачПоПочте
				И Запись.ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеЗадачи)
				Или (Запись.Настройка = Перечисления.НастройкиУведомлений.ПроцентноеИзменение
				И Запись.ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса) Тогда
			
				РегистрыСведений.НастройкиУведомлений.УстановитьДополнительнуюНастройку(
					Запись.Пользователь,
					Запись.Настройка,
					Запись.Значение);
					
			КонецЕсли;	
				
		ИначеЕсли ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.УдалитьНастройкиУведомленийПоУмолчанию") Тогда
				
			ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УдалитьНастройкиУведомленийПоУмолчанию(Запись);
			
		ИначеЕсли ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.УдалитьНастройкиУведомленияОЗадачах") Тогда
			
			ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УдалитьНастройкиУведомленияОЗадачах(Запись);
			
		ИначеЕсли ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.УдалитьНастройкиУведомленияОкончанияСрокаДействия") Тогда
			
			ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УдалитьНастройкиУведомленияОкончанияСрокаДействия(Запись);
			
		ИначеЕсли ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.УдалитьНастройкиУведомленияОКонтроле") Тогда
			
			ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УдалитьНастройкиУведомленияОКонтроле(Запись);
			
		ИначеЕсли ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.УдалитьПодпискиНаУведомления") Тогда
			
			ОбновлениеИнформационнойБазыДокументооборот.ОбновлениеС20_УдалитьПодпискиНаУведомления(Запись);
			
		ИначеЕсли ТипЗнч(Запись) = Тип("РегистрСведенийЗапись.СпособыУведомленияПользователей") Тогда
			
			РегистрыСведений.СпособыУведомленияПользователей.УстановитьСпособУведомленияПользователя(
				Запись.Пользователь,
				Запись.СпособУведомления,
				Неопределено,
				Запись.ДанныеСпособа);
				
		КонецЕсли;	
			
	КонецЦикла;			
	
КонецПроцедуры

Функция ПолномочияПользователей_Используются(Пользователь, Профиль, ТекущаяГруппаДоступа)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ГруппыДоступаПользователи.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|ГДЕ
		|	ГруппыДоступаПользователи.Ссылка.Профиль = &Профиль
		|	И ГруппыДоступаПользователи.Пользователь = &Пользователь
		|	И ГруппыДоступаПользователи.Ссылка <> &ТекущаяГруппаДоступа";
		
	Запрос.УстановитьПараметр("Профиль", Профиль);	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);	
	Запрос.УстановитьПараметр("ТекущаяГруппаДоступа", ТекущаяГруппаДоступа);	
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции	

#КонецОбласти

#КонецЕсли