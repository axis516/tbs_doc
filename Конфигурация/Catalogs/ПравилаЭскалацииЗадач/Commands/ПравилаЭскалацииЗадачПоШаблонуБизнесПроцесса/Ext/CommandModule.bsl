﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Шаблон", ПараметрКоманды);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "ПравилаЭскалацииЗадачПоШаблонуБизнесПроцесса");
	ОткрытьФорму("Справочник.ПравилаЭскалацииЗадач.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти