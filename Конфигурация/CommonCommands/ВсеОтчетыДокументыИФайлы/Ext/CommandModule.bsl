﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ИмяПодсистемы", "ДокументыИФайлы");
	
	ОткрытьФорму(
		"Обработка.ВсеОтчеты.Форма",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, 
		"ДокументыИФайлы", 
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
