﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "СписокНепринятыхЗадач");
	ПараметрыФормы.Вставить("Подразделение", ПараметрКоманды);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ОтчетПоЗадачам.Форма.ФормаОтчета",
		ПараметрыФормы);
		
КонецПроцедуры
