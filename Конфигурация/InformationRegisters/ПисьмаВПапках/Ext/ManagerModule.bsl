﻿
// получает папку письма
Функция ПолучитьПапку(Письмо) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ПисьмаВПапках.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Письмо = Письмо;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		Возврат МенеджерЗаписи.Папка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции	

// получает структуру - папку письма и пометку удаления
Функция ПолучитьПапкуИПометкуУдаления(Письмо) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ПисьмаВПапках.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Письмо = Письмо;
	
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		СтруктураВозврата = Новый Структура("Папка, ПометкаУдаления", МенеджерЗаписи.Папка, МенеджерЗаписи.ПометкаУдаления);
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Возврат Новый Структура("Папка, ПометкаУдаления", Справочники.ПапкиПисем.ПустаяСсылка(), Ложь);
	
КонецФункции	

// Записывает папку письма
Процедура ЗаписатьПапку(Письмо, Папка, ПометкаУдаления = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ПисьмаВПапках.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Письмо = Письмо;
	МенеджерЗаписи.Папка = Папка;
	
	Если ПометкаУдаления = Неопределено Тогда
		ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Письмо, "ПометкаУдаления");
	КонецЕсли;
	
	МенеджерЗаписи.ПометкаУдаления = ПометкаУдаления;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры
