﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	#Если ВебКлиент Тогда
		ПараметрыФормы.Вставить("ВебКлиент", Истина);
	#КонецЕсли
	ОткрытьФорму("Обработка.ЗагрузкаЭлектроннойПочты.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры
