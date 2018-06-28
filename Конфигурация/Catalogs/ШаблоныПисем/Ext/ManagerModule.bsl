﻿
// Возвращает текст шаблона письма 
Функция ПолучитьПредставлениеСодержанияШаблона(РеквизитыШаблона, СозданиеHTML = Ложь) Экспорт
	
	ТекстHTML = "";
	
	Если РеквизитыШаблона.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML 
		И ЗначениеЗаполнено(РеквизитыШаблона.ТекстПисьмаHTMLХранилище) Тогда
		
		ТекстHTML = РеквизитыШаблона.ТекстПисьмаHTMLХранилище.Получить();
		
		Если ТекстHTML = Неопределено Тогда
			
			ТекстHTML = РеквизитыШаблона.ТекстХранилище.Получить();
			
			Если ТекстHTML = Неопределено Тогда
				
				ТекстHTML = "";
				
			Иначе
				
				РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстHTML);
				
			КонецЕсли;
			
		Иначе
			
			РаботаС_HTML.ДобавитьТегиКСсылкам(ТекстHTML);
			
		КонецЕсли;
		
		РаботаС_HTML.ПрименитьНастройкиОтображениеПисьма(ТекстHTML);
		
	ИначеЕсли ЗначениеЗаполнено(РеквизитыШаблона.ТекстХранилище) Тогда  
			
		ПростойТекст = РеквизитыШаблона.ТекстХранилище.Получить();
		
		Если ПростойТекст = Неопределено Тогда
			
			ТекстHTML = "";
			
		Иначе
			
			 ТекстHTML = ПростойТекст;
			 
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТекстHTML;
	
КонецФункции

// УправлениеДоступом

Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка,Автор,Пользователи";
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	ДескрипторДоступа.ОбъектДоступа = ОбъектДоступа.Ссылка;
	
КонецПроцедуры

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
		ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Автор, Истина);
		
	ТаблицаДоступа = ОбъектДоступа.Пользователи.Выгрузить();
	Если ТаблицаДоступа.Количество() > 0 Тогда
		Для Каждого СтрДоступа Из ТаблицаДоступа Цикл
			ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
				ОбъектДоступа, ТаблицаДескрипторов, СтрДоступа.ПользовательИлиГруппа, Ложь);
		КонецЦикла;
	КонецЕсли;
		
	Если ПротоколРасчетаПрав <> Неопределено Тогда
		
		ЗаписьПротокола = Новый Структура("Элемент, Описание",
			ОбъектДоступа.Автор, НСтр("ru = 'Автор'"));
		
		Если ТаблицаДоступа.Количество() > 0 Тогда
			ЗаписьПротокола = Новый Структура("Элемент, Описание",
				ОбъектДоступа.Ссылка, НСтр("ru = 'Пользователи общего доступа'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Конец УправлениеДоступом
