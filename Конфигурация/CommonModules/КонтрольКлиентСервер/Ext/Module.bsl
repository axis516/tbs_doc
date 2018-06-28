﻿////////////////////////////////////////////////////////////////////////////////
// Контроль объектов
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует срок контроля в днях.
//
// Параметры:
//  СрокИсполнения - Дата - Срок, указанный в контрольной карточке.
//
// Возвращаемое значение:
//  Число - Число дней до срока контроля.
//
Функция СрокКонтроля(СрокИсполнения) Экспорт
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		ТекущаяДата = ТекущаяДата();
	#Иначе
		ТекущаяДата = ТекущаяДатаСеанса();
	#КонецЕсли
	СрокКонтроля = (НачалоДня(СрокИсполнения) - НачалоДня(ТекущаяДата)) / (24 * 3600);
	
	Возврат СрокКонтроля;
	
КонецФункции

#КонецОбласти