﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ВариантОтвета = Истина;
	
	Если БольшеНеСпрашивать Тогда
		ЗапомнитьВариантОтвета(ВариантОтвета);
	КонецЕсли;
	
	Закрыть(ВариантОтвета);
	
КонецПроцедуры

&НаКлиенте
Процедура НеСоздавать(Команда)
	
	ВариантОтвета = Ложь;
	
	Если БольшеНеСпрашивать Тогда
		ЗапомнитьВариантОтвета(ВариантОтвета);
	КонецЕсли;
	
	Закрыть(ВариантОтвета);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗапомнитьВариантОтвета(ВариантОтвета)
	
	Отсутствия.УстановитьПерсональнуюНастройку("ВопросСоздатьПравилоБольшеНеСпрашивать", Истина);
	Отсутствия.УстановитьПерсональнуюНастройку("ВопросСоздатьПравилоВариантОтвета", ВариантОтвета);
	
КонецПроцедуры

#КонецОбласти