﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	ОткрытьФорму(
		"Справочник.ЗаметкиДокументооборота.ФормаОбъекта",
		ПараметрыФормы,,
		Новый УникальныйИдентификатор);
	
КонецПроцедуры
