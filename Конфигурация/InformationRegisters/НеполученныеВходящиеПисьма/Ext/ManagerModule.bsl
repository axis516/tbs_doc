﻿// Удаляет из регистра запись об не полученном входящем письме.
// Вызывается при успешном получении письма или если письмо отсутствует в почтовом ящике.
//
Процедура УдалитьСведенияОПисьме(УчетнаяЗапись, Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НеПолученныеВходящиеПисьма.СоздатьМенеджерЗаписи();
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.Идентификатор = Идентификатор;
	Запись.Прочитать();
	Если Запись.Выбран() Тогда
		Запись.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Добавляет в регистр запись об не полученном вхоящем письме,
// если запись уже есть, то уменьшает оставщееся количество
// попыток получения.
Процедура НеуспешнаяПопыткаПолучения(УчетнаяЗапись, Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запись = РегистрыСведений.НеПолученныеВходящиеПисьма.СоздатьМенеджерЗаписи();
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.Идентификатор = Идентификатор;
	Запись.Прочитать();
	Если Не Запись.Выбран() Тогда
		Запись.УчетнаяЗапись = УчетнаяЗапись;
		Запись.Идентификатор = Идентификатор;
		Запись.ОсталосьПопытокПолучения = 3;
	КонецЕсли;
	
	Запись.ОсталосьПопытокПолучения = Запись.ОсталосьПопытокПолучения - 1;
	Запись.Записать(Истина);
	
КонецПроцедуры
