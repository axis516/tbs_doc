﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// УправлениеДоступом

// Возвращает строку, содержащую перечисление полей доступа через запятую
// Это перечисление используется в дальнейшем для передачи в метод 
// ОбщегоНазначения.ЗначенияРеквизитовОбъекта()
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка";
	
КонецФункции

// Заполняет переданный дескриптор доступа
//
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
КонецПроцедуры

// Конец УправлениеДоступом

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Перем КлючФормы, ВидЭД;
	
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("Ключ",КлючФормы) Тогда
		ОбменСКонтрагентамиСлужебныйВызовСервера.ПолучитьРеквизитыЭД(КлючФормы).Свойство("ВидЭД", ВидЭД);
		Если ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			ВыбраннаяФорма = "Документ.ЭлектронныйДокументВходящий.Форма.ФормаПроизвольногоДокумента";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
