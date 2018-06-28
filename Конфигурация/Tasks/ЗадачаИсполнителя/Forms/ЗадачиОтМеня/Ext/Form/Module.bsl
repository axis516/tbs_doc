﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию(
		"ИспользоватьДатуИВремяВСрокахЗадач");
	
	ФорматДатыДляКолонок = ?(ИспользоватьДатуИВремяВСрокахЗадач, 
		"ДФ='dd.MM.yy H:mm'",
		"ДФ='dd.MM.yy'");

	Элементы.ЗадачиОтМеняСрокИсполнения.Формат = ФорматДатыДляКолонок;
	Элементы.ЗадачиОтМеняДата.Формат = ФорматДатыДляКолонок;
	
	НастройкиФормы = ХранилищеСистемныхНастроек.Загрузить(ИмяФормы + "/ТекущиеДанные");
	Если ТипЗнч(НастройкиФормы) = Тип("Соответствие") Тогда
		СохраненныеРеквизиты = Новый Структура;
		Для Каждого КлючЗначение Из НастройкиФормы Цикл
			СохраненныеРеквизиты.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение);
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СохраненныеРеквизиты);
	КонецЕсли;
	
	Если ПоказыватьОбластьГруппировки
		И ЗадачиОтМеняВидГруппировки = "" Тогда
		
		ЗадачиОтМеняВидГруппировки = "Исполнитель";
	КонецЕсли;
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Исполнители = БизнесПроцессыИЗадачиСервер.ИсполнителиЗадачПользователя(ТекущийПользователь);
	
	ЗадачиОтМеняИсполнители.Параметры.УстановитьЗначениеПараметра(
		"Исполнители",
		Исполнители);
		
	ЗадачиОтМеняПроекты.Параметры.УстановитьЗначениеПараметра(
		"Исполнители",
		Исполнители);
	ЗадачиОтМеняПроекты.Параметры.УстановитьЗначениеПараметра(
		"ИмяГруппыБезПроекта", 
		НСтр("ru = 'Без проекта'"));
		
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь",
		ТекущийПользователь);
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"Исполнители",
		Исполнители);
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"БезФлага", 
		НСтр("ru = 'Без флага'"));
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"КрасныйФлаг", 
		НСтр("ru = 'Красный'"));
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"СинийФлаг", 
		НСтр("ru = 'Синий'"));
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"ЖелтыйФлаг", 
		НСтр("ru = 'Желтый'"));
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"ЗеленыйФлаг", 
		НСтр("ru = 'Зеленый'"));
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"ОранжевыйФлаг", 
		НСтр("ru = 'Оранжевый'"));
	ЗадачиОтМеняФлаги.Параметры.УстановитьЗначениеПараметра(
		"ЛиловыйФлаг", 
		НСтр("ru = 'Лиловый'"));
	
	ЗадачиОтМеня.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь",
		ТекущийПользователь);
	ЗадачиОтМеня.Параметры.УстановитьЗначениеПараметра(
		"Исполнители",
		Исполнители);
	ЗадачиОтМеня.Параметры.УстановитьЗначениеПараметра(
		"ТекущаяДата",
		НачалоДня(ТекущаяДатаСеанса()));
	ЗадачиОтМеня.Параметры.УстановитьЗначениеПараметра(
		"ИспользоватьДатуИВремяВСрокахЗадач",
		ИспользоватьДатуИВремяВСрокахЗадач);
		
	УстановитьВидимостьВыполненныхЗадач();
	УстановитьГруппировкуЗадачОтМеня(ЭтаФорма);
	УстановитьПараметрыГруппировокВЗадачахОтМеняСервер();
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(ЗадачиОтМеня.УсловноеОформление);
	
	Если ОбщегоНазначенияДокументооборот.ПриложениеЯвляетсяВебКлиентом() Тогда
		Элементы.ЗадачиОтМеняАвтообновление.Видимость = Ложь;
	Иначе
		НастройкиАвтообновления = Автообновление.ПолучитьНастройкиАвтообновленияФормы(ЭтаФорма);
		Элементы.ЗадачиОтМеняАвтообновление.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ЗадачиОтМеняПоказатьВыполненные.Пометка = ЗадачиОтМеняПоказыватьВыполненные;
	
	// Контроль
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда
		Элементы.ЗадачиОтМеняСостояниеКонтроля.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если Не ВебКлиент Тогда
		УстановитьАвтообновлениеФормы();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗадачаИзменена"
		ИЛИ ИмяСобытия = "Перенаправление_ЗадачаИсполнителя"
		ИЛИ ИмяСобытия = "БизнесПроцессСтартован"
		ИЛИ (ИмяСобытия = "ИзменилсяФлаг"
			И ТипЗнч(Параметр[0]) = Тип("ЗадачаСсылка.ЗадачаИсполнителя"))
		ИЛИ (ИмяСобытия = "ЗаписьКонтроля"
			И ЗначениеЗаполнено(Параметр.Предмет)
			И ТипЗнч(Параметр.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя"))Тогда
		
		ОбновитьСписокЗадачОтМеня();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиОтМеняИсполнители

&НаКлиенте
Процедура ЗадачиОтМеняИсполнителиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ЗадачиОтМеняИсполнители.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйТекущийИсполнитель = Элементы.ЗадачиОтМеняИсполнители.ТекущиеДанные.Ссылка;
	
	Если ЗадачиОтМеняВидГруппировки = "Исполнитель"
		И НовыйТекущийИсполнитель <> Неопределено
		И (НовыйТекущийИсполнитель <> ЗадачиОтМеняТекущийИсполнитель) Тогда
		
		ЗадачиОтМеняТекущийИсполнитель = НовыйТекущийИсполнитель;
		
		ПодключитьОбработчикОжидания("УстановитьПараметрыГруппировокВЗадачахОтМеня", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиОтМеняПроекты

&НаКлиенте
Процедура ЗадачиОтМеняПроектыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ЗадачиОтМеняПроекты.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйТекущийПроект = Элементы.ЗадачиОтМеняПроекты.ТекущиеДанные.Ссылка;
	
	Если ЗадачиОтМеняВидГруппировки = "Проект"
		И НовыйТекущийПроект <> Неопределено
		И НовыйТекущийПроект <> ЗадачиОтМеняТекущийПроект Тогда
		
		ЗадачиОтМеняТекущийПроект = НовыйТекущийПроект;
		
		ПодключитьОбработчикОжидания("УстановитьПараметрыГруппировокВЗадачахОтМеня", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиОтМеняФлаги

&НаКлиенте
Процедура ЗадачиОтМеняФлагиПриАктивизацииСтроки(Элемент)
	
	УстановитьПараметрыГруппировокВЗадачахОтМеняПриВыбореФлага();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиОтМеня

&НаКлиенте
Процедура ЗадачиОтМеняВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ЗадачиОтМеняНомерФлага Тогда
		Если ТипЗнч(ВыбраннаяСтрока) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			РаботаСФлагамиОбъектовКлиент.ПереключитьФлагЗадачи(ВыбраннаяСтрока);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ЗадачиОтМеня.ТекущаяСтрока = Неопределено 
		ИЛИ ТипЗнч(Элементы.ЗадачиОтМеня.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Элементы.ЗадачиОтМеня.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Если ЗадачиОтМеняВидГруппировки = "Исполнитель" Тогда
			Элементы.ЗадачиОтМеняИсполнители.Обновить();
		ИначеЕсли ЗадачиОтМеняПроекты = "Проект" Тогда
			Элементы.ЗадачиОтМеняИсполнители.Обновить();
		ИначеЕсли ЗадачиОтМеняВидГруппировки = "Флаг" Тогда
			Элементы.ЗадачиОтМеняФлаги.Обновить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФорму("ОбщаяФорма.СозданиеБизнесПроцесса");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьСписокЗадачОтМеня();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняНаписатьПисьмо(Команда)
	
	ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Исполнитель) Тогда
		Возврат;
	КонецЕсли;
	
	СписокПочтовыхАдресов = Новый СписокЗначений;
	
	ЗаполнитьСписокАдресов(ТекущиеДанные.Исполнитель, СписокПочтовыхАдресов);
	
	Если Не ЗначениеЗаполнено(СписокПочтовыхАдресов) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("СписокПочтовыхАдресов", СписокПочтовыхАдресов);
	ОткрытьФорму("Документ.ИсходящееПисьмо.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняОткрытьПроцесс(Команда)
	
	Если Элементы.ЗадачиОтМеня.ТекущиеДанные <> Неопределено 
		И ТипЗнч(Элементы.ЗадачиОтМеня.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		ПоказатьЗначение(, Элементы.ЗадачиОтМеня.ТекущиеДанные.БизнесПроцесс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПоказатьВыполненные(Команда)
	
	ЗадачиОтМеняПоказыватьВыполненные = Не ЗадачиОтМеняПоказыватьВыполненные;
	
	Элементы.ЗадачиОтМеняПоказатьВыполненные.Пометка = ЗадачиОтМеняПоказыватьВыполненные;
	
	УстановитьВидимостьВыполненныхЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняСгруппироватьПоИсполнителю(Команда)
	
	СгруппироватьЗадачиОтМеняПоВиду("Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняСгруппироватьПоПроекту(Команда)
	
	СгруппироватьЗадачиОтМеняПоВиду("Проект");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняСгруппироватьПоФлагу(Команда)
	
	СгруппироватьЗадачиОтМеняПоВиду("Флаг");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняСгруппироватьПоБезГруппировки(Команда)
	
	СгруппироватьЗадачиОтМеняПоВиду("")
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняАвтообновление(Команда)
	
	УстановитьПараметрыАвтообновленияФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_РаботаСФлагами

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"));
	
КонецПроцедуры

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"));
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	УстановитьФлаги(ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	УстановитьФлаги(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСписокЗадачОтМеня()
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьПараметрыУсловногоОформленияПросроченныхЗадач(
		ЗадачиОтМеня.УсловноеОформление);
	
	Если ПоказыватьОбластьГруппировки Тогда
		Если ЗадачиОтМеняВидГруппировки = "Исполнитель" Тогда
			ЗадачиОтМеняТекущийИсполнитель = Неопределено;
			Элементы.ЗадачиОтМеняИсполнители.Обновить();
			Элементы.ЗадачиОтМеня.Обновить();
		ИначеЕсли ЗадачиОтМеняВидГруппировки = "Проект" Тогда
			ЗадачиОтМеняТекущийПроект = Неопределено;
			Элементы.ЗадачиОтМеняПроекты.Обновить();
			Элементы.ЗадачиОтМеня.Обновить();
		ИначеЕсли ЗадачиОтМеняВидГруппировки = "Флаг" Тогда
			ЗадачиОтМеняТекущийФлаг = Неопределено;
			Элементы.ЗадачиОтМеняФлаги.Обновить();
			СписокЗадачОбновлен = Ложь;
			УстановитьПараметрыГруппировокВЗадачахОтМеняПриВыбореФлага(СписокЗадачОбновлен);
			Если Не СписокЗадачОбновлен Тогда
				Элементы.ЗадачиОтМеня.Обновить();
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ЗадачиОтМеня.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВыполненныхЗадач()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеня,
		"Выполнена",
		Ложь,
		Не ЗадачиОтМеняПоказыватьВыполненные);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеняИсполнители, 
		"Выполнена",
		Ложь,
		Не ЗадачиОтМеняПоказыватьВыполненные);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеняПроекты, 
		"Выполнена",
		Ложь,
		Не ЗадачиОтМеняПоказыватьВыполненные);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеняФлаги, 
		"Выполнена",
		Ложь,
		Не ЗадачиОтМеняПоказыватьВыполненные);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокАдресов(ПользовательСсылка, СписокПочтовыхАдресов)
	
	ТаблицаКонтактовEmail = УправлениеКонтактнойИнформацией.ЗначенияКонтактнойИнформацииОбъекта(
		ПользовательСсылка,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
	Если ТаблицаКонтактовEmail.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	АдресПользователя = ТаблицаКонтактовEmail[0].Значение;
	
	АдресИнфо = Новый Структура("Контакт, Адрес, ОтображаемоеИмя",
		ПользовательСсылка, АдресПользователя, Строка(ПользовательСсылка));
		
	СписокПочтовыхАдресов.Добавить(АдресИнфо);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлаги(Флаг)
	
	МассивЗадач = Новый Массив;
	
	УстановитьФлагЗадачам = Ложь;
	
	МассивЗадач = Элементы.ЗадачиОтМеня.ВыделенныеСтроки;
	
	ИтоговыйМассивЗадач = Новый Массив;
	Для Каждого СтрокаМассива Из МассивЗадач Цикл
		Если ТипЗнч(СтрокаМассива) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			ИтоговыйМассивЗадач.Добавить(СтрокаМассива);
		КонецЕсли;
	КонецЦикла;
	
	Результат = РаботаСФлагамиОбъектовКлиент.УстановитьФлагиЗадачам(ИтоговыйМассивЗадач, Флаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьЗадачиОтМеняПоВиду(НовыйВидГруппировки)
	
	Если ЗадачиОтМеняВидГруппировки = НовыйВидГруппировки Тогда
		Возврат;
	КонецЕсли;
	
	ЗадачиОтМеняВидГруппировки = НовыйВидГруппировки;
	
	ПоказыватьОбластьГруппировки = ЗадачиОтМеняВидГруппировки <> "";
	
	УстановитьГруппировкуЗадачОтМеня(ЭтаФорма);
	
	УстановитьПараметрыГруппировокВЗадачахОтМеняСервер();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьГруппировкуЗадачОтМеня(ЭтаФорма)
	
	ЭтаФорма.Элементы.СтраницыГруппировкиОтМеня.Видимость = ЭтаФорма.ПоказыватьОбластьГруппировки;
	
	ЭтаФорма.Элементы.ЗадачиОтМеняСгруппироватьПоИсполнителю.Пометка = Ложь;
	ЭтаФорма.Элементы.ЗадачиОтМеняСгруппироватьПоПроекту.Пометка = Ложь;
	ЭтаФорма.Элементы.ЗадачиОтМеняСгруппироватьПоФлагу.Пометка = Ложь;
	
	ВидимостьКолонкиИсполнитель = Истина;
	
	Если ЭтаФорма.ПоказыватьОбластьГруппировки Тогда
		Если ЭтаФорма.ЗадачиОтМеняВидГруппировки = "Исполнитель" Тогда
			ЭтаФорма.Элементы.ЗадачиОтМеняСгруппироватьПоИсполнителю.Пометка = Истина;
			ВидимостьКолонкиИсполнитель = Ложь;
			ЭтаФорма.Элементы.СтраницыГруппировкиОтМеня.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаОтМеняИсполнители;
		ИначеЕсли ЭтаФорма.ЗадачиОтМеняВидГруппировки = "Проект" Тогда
			ЭтаФорма.Элементы.ЗадачиОтМеняСгруппироватьПоПроекту.Пометка = Истина;
			ЭтаФорма.Элементы.СтраницыГруппировкиОтМеня.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаОтМеняПроекты;
		ИначеЕсли ЭтаФорма.ЗадачиОтМеняВидГруппировки = "Флаг" Тогда
			ЭтаФорма.Элементы.ЗадачиОтМеняСгруппироватьПоФлагу.Пометка = Истина;
			ЭтаФорма.Элементы.СтраницыГруппировкиОтМеня.ТекущаяСтраница = ЭтаФорма.Элементы.СтраницаОтМеняФлаги;
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФорма.Элементы.ГруппаЗадачиОтМеняИсполнитель.Видимость = ВидимостьКолонкиИсполнитель;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыГруппировокВЗадачахОтМеня()

	УстановитьПараметрыГруппировокВЗадачахОтМеняСервер();

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыГруппировокВЗадачахОтМеняСервер()
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеня, "ТекущийИсполнитель", Неопределено, Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеня, "Проект", Неопределено, Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		ЗадачиОтМеня, "Флаг", Неопределено, Ложь);
		
	Если ПоказыватьОбластьГруппировки Тогда
		Если ЗадачиОтМеняВидГруппировки = "Исполнитель" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				ЗадачиОтМеня, "ТекущийИсполнитель", ЗадачиОтМеняТекущийИсполнитель);
		ИначеЕсли ЗадачиОтМеняВидГруппировки = "Проект" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				ЗадачиОтМеня, "Проект", ЗадачиОтМеняТекущийПроект);
		ИначеЕсли ЗадачиОтМеняВидГруппировки = "Флаг" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				ЗадачиОтМеня, "Флаг", ЗадачиОтМеняТекущийФлаг);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыГруппировокВЗадачахОтМеняПриВыбореФлага(СписокЗадачОбновлен = Ложь)
	
	Если Элементы.ЗадачиОтМеняФлаги.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйТекущийФлаг = Элементы.ЗадачиОтМеняФлаги.ТекущиеДанные.Флаг;
	
	Если ЗадачиОтМеняВидГруппировки = "Флаг"
		И НовыйТекущийФлаг <> Неопределено
		И НовыйТекущийФлаг <> ЗадачиОтМеняТекущийФлаг Тогда
		
		ЗадачиОтМеняТекущийФлаг = НовыйТекущийФлаг;
		
		ПодключитьОбработчикОжидания("УстановитьПараметрыГруппировокВЗадачахОтМеня", 0.2, Истина);
		
		СписокЗадачОбновлен = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Автообновление

&НаКлиенте
Процедура УстановитьАвтообновлениеФормы()
	
	Если ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И НастройкиАвтообновления.Автообновление Тогда
		ПодключитьОбработчикОжидания(
			"Автообновление", 
			НастройкиАвтообновления.ПериодАвтоОбновления,
			Ложь);
	Иначе
		ОтключитьОбработчикОжидания("Автообновление");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление()
	
	Если ТипЗнч(НастройкиАвтообновления) <> Тип("Структура")
		Или (ТипЗнч(НастройкиАвтообновления) = Тип("Структура")
		И Не НастройкиАвтообновления.Автообновление) Тогда
		ОтключитьОбработчикОжидания("Автообновление");
	Иначе
		ОбновитьСписокЗадачОтМеня();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыАвтообновленияФормы()
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения(
			"УстановитьПараметрыАвтообновленияФормыПродолжение",
			ЭтотОбъект);
	
	АвтообновлениеКлиент.УстановитьПараметрыАвтообновленияФормы(
		ЭтаФорма, 
		НастройкиАвтообновления,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыАвтообновленияФормыПродолжение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		НастройкиАвтообновления = Результат;
		УстановитьАвтообновлениеФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
