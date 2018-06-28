﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	КлючеваяОперация = "ВнутренниеДокументыОткрытиеФормыФормаСпискаСПапками";
	УИДЗамера = ОценкаПроизводительностиКлиентСервер.НачатьРучнойЗамерВремени(КлючеваяОперация);
	
	Форма = ПолучитьФорму("Справочник.ВнутренниеДокументы.Форма.ФормаСпискаСПапками", , ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	Если Форма.Открыта() Тогда 
		Форма.Активизировать();
		Возврат;
	КонецЕсли;
	Форма.Открыть();
	
	ОценкаПроизводительностиКлиентСервер.ЗакончитьРучнойЗамерВремени(УИДЗамера);
	
КонецПроцедуры
