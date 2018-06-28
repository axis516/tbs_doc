﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДляСохранения = Параметры.ДанныеДляСохранения;
	СтруктураДанные = ДанныеДляСохранения.Получить();
	Если ЗначениеЗаполнено(СтруктураДанные.ТекущееНаименование) Тогда
		НаименованиеСохраненногоПоиска = СтруктураДанные.ТекущееНаименование;
	КонецЕсли;
	
	ЗагрузитьСписокСохраненныхПараметровПоиска();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписокСохраненныхПараметровПоиска()
	
	СписокНастроек = ХранилищеНастроекДанныхФорм.ПолучитьСписок("Обработка.ПоискПоРеквизитам.Форма.ПоискДокументовИФайлов");
	СохраненныеПоиски.Очистить();
	Для Каждого СохраненныйПоиск Из СписокНастроек Цикл
		Если Найти(СохраненныйПоиск.Значение, "_временный_") > 0 Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = СохраненныеПоиски.Добавить();
		НоваяСтрока.НаименованиеСохраненногоПоиска = СохраненныйПоиск.Представление;
		НоваяСтрока.КлючСохраненногоПоиска = СохраненныйПоиск.Значение;
	КонецЦикла;
	СохраненныеПоиски.Сортировать("ТипСохраненногоПоиска Возр, НаименованиеСохраненногоПоиска Возр");
	
	Если СохраненныеПоиски.Количество() = 0 Тогда
		Элементы.ДекорацияПояснение.Видимость = Ложь;
		Элементы.СохраненныеПоиски.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	ОчиститьСообщения();
	Если НЕ ЗначениеЗаполнено(НаименованиеСохраненногоПоиска) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Поле ""Наименование"" не заполнено'"),, "НаименованиеСохраненногоПоиска");
		Возврат;
	КонецЕсли;
	
	КлючНайденногоПоиска = НайтиСохраненныйПоискПоНаименованию(НаименованиеСохраненногоПоиска);
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("СохранитьПродолжение", ЭтотОбъект, КлючНайденногоПоиска);
	
	Если ЗначениеЗаполнено(КлючНайденногоПоиска)
		И Найти(КлючНайденногоПоиска, "_временный_") = 0 Тогда
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Перезаписать шаблон поиска ""%1""?'"),
			НаименованиеСохраненногоПоиска);
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Режим, 0);
		
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПродолжение(Ответ, КлючНайденногоПоиска) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьПоиск(НаименованиеСохраненногоПоиска, КлючНайденногоПоиска);

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("НаименованиеСохраненногоПоиска", НаименованиеСохраненногоПоиска);
	СтруктураВозврата.Вставить("КлючСохраненногоПоиска", КлючНайденногоПоиска);
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПоиск(Наименование, КлючНастроек)
	
	СтруктураДанные = ДанныеДляСохранения.Получить();
	НастройкиДляСохранения = Новый Соответствие;
	
	Если СтруктураДанные.Свойство("КлючНайденный")
		И СтруктураДанные.КлючНайденный <> Ложь Тогда		
		УстановитьПривилегированныйРежим(Истина);
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ПараметрыСеанса.ТекущийПользователь.ИдентификаторПользователяИБ);
		Если ПользовательИБ <> Неопределено Тогда
			ХранилищеНастроекДанныхФорм.Удалить("Обработка.ПоискПоРеквизитам.Форма.ПоискДокументовИФайлов", СтруктураДанные.КлючНайденный, ПользовательИБ.Имя);	
			СтруктураДанные.Удалить("КлючНайденный");
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ПараЗначений Из СтруктураДанные Цикл
		НастройкиДляСохранения.Вставить(ПараЗначений.Ключ, ПараЗначений.Значение);
	КонецЦикла;
	
	КопияКлючНастроек = КлючНастроек;
	КлючНастроек = СтрЗаменить(КлючНастроек, "_временный_", "");

	СоздатьСохраненныйПоиск(НастройкиДляСохранения, КлючНастроек, Наименование, Ложь);
	Если Найти(КопияКлючНастроек, "_временный_") > 0 Тогда
		УстановитьПривилегированныйРежим(Истина);
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ПараметрыСеанса.ТекущийПользователь.ИдентификаторПользователяИБ);
		Если ПользовательИБ <> Неопределено Тогда
			ХранилищеНастроекДанныхФорм.Удалить("Обработка.ПоискПоРеквизитам.Форма.ПоискДокументовИФайлов", КопияКлючНастроек, ПользовательИБ.Имя);	
		КонецЕсли;			
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура СоздатьСохраненныйПоиск(СоответствиеДляСохранения, КлючНастроек, НаименованиеСохраненногоПоиска, ВременныйСохраненныйПоиск)
	
	ОписаниеНастроек = Новый ОписаниеНастроек;
	ОписаниеНастроек.Представление = НаименованиеСохраненногоПоиска;
	Если НЕ ЗначениеЗаполнено(КлючНастроек) Тогда
		КлючНастроек = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	ХранилищеНастроекДанныхФорм.Сохранить("Обработка.ПоискПоРеквизитам.Форма.ПоискДокументовИФайлов", КлючНастроек, СоответствиеДляСохранения, ОписаниеНастроек); 
	
КонецПроцедуры

&НаСервере
Функция НайтиСохраненныйПоискПоНаименованию(Имя)
	
	СписокНастроек = ХранилищеНастроекДанныхФорм.ПолучитьСписок("Обработка.ПоискПоРеквизитам.Форма.ПоискДокументовИФайлов");
	Для Каждого СохраненныйПоиск Из СписокНастроек Цикл
		
		Если СохраненныйПоиск.Представление	= Имя Тогда
			Возврат СохраненныйПоиск.Значение; 
		КонецЕсли;		
	КонецЦикла;		
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохраненныеПоискиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	НаименованиеСохраненногоПоиска = Элементы.СохраненныеПоиски.ТекущиеДанные.НаименованиеСохраненногоПоиска;
КонецПроцедуры

