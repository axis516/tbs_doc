﻿
&НаКлиенте
Процедура СоздатьПравило(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("УчетнаяЗапись", УчетнаяЗапись);
	ПараметрыФормы.Вставить("ДляВходящихПисем", ДляВходящихПисем);
	ПараметрыФормы.Вставить("ДляИсходящихПисем", ДляИсходящихПисем);
	
	ПараметрыФормы.Вставить("Условия", СписокУсловия);
	ПараметрыФормы.Вставить("Действия", СписокДействия);
	
	Закрыть(ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	БольшеНеСпрашиватьПриОткрытии = 
		ВстроеннаяПочтаСервер.ПолучитьПерсональнуюНастройку("НеПредлагатьСоздатьПравилоПриПеретаскивании");
		
	БольшеНеСпрашивать = БольшеНеСпрашиватьПриОткрытии;
	
	Папка = Параметры.Папка;
	
	Элементы.ЗаголовокСообщения.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Создать автоматическое правило для перемещения писем в папку ""%1""?'"),
		Справочники.ПапкиПисем.ПолучитьПолныйПутьПапки(Папка));
		
	
	УчетнаяЗапись = Параметры.Письма[0].УчетнаяЗапись;
	ДляВходящихПисем = ТипЗнч(Параметры.Письма[0].Ссылка) = Тип("ДокументСсылка.ВходящееПисьмо");
	ДляИсходящихПисем = ТипЗнч(Параметры.Письма[0].Ссылка) = Тип("ДокументСсылка.ИсходящееПисьмо");		
		
	
	СписокДействия.Очистить();
	СписокИсключения.Очистить();
	
	РаботаСПравиламиОбработкиПисем.СформироватьУсловияПоПисьму(
		Параметры.Письма[0],
		СписокУсловия,
		ДляВходящихПисем,
		ДляИсходящихПисем);
	
	Если ДляВходящихПисем Тогда
					
		ДобавитьДействие(
			Перечисления.ВидыДействийПриОбработкеВходящихПисем.ПереместитьВУказаннуюПапку,
			Папка);
			
	ИначеЕсли ДляИсходящихПисем Тогда
				
		ДобавитьДействие(
			Перечисления.ВидыДействийПриОбработкеИсходящихПисем.ПереместитьВУказаннуюПапку,
			Папка);	
			
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДействие(Вид, Значение)
	
	Структура = Новый Структура;
	Структура.Вставить("Вид", Вид);
	Структура.Вставить("Значение", Значение);
	СписокДействия.Добавить(Структура);		
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если БольшеНеСпрашивать <> БольшеНеСпрашиватьПриОткрытии Тогда
		ВстроеннаяПочтаСервер.УстановитьПерсональнуюНастройку(
			"НеПредлагатьСоздатьПравилоПриПеретаскивании",
			БольшеНеСпрашивать);
		НастройкиВстроеннойПочты = Новый Структура;
		НастройкиВстроеннойПочты.Вставить("НеПредлагатьСоздатьПравилоПриПеретаскивании", БольшеНеСпрашивать);
		Оповестить("ИзмененыНастройкиВстроеннойПочты", НастройкиВстроеннойПочты, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры
