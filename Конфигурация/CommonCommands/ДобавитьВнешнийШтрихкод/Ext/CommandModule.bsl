﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначениеКода = "";
	РаботаСТорговымОборудованием.ОтключитьСканерШтрихкодов();
	РаботаСТорговымОборудованием.ПодключитьСканерШтрихкодов("ДобавлениеВнешнегоШтрихкода");
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ПараметрКоманды", ПараметрКоманды);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОбработкаКомандыПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчика);
	ОткрытьФорму(
		"ОбщаяФорма.ДобавлениеВнешнегоШтрихкода",,,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыПродолжение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ШтрихкодированиеСервер.ПрисвоитьШтрихКод(Параметры.ПараметрКоманды, Результат, Ложь);
		Текст = НСтр("ru = 'Штрихкод успешно добавлен!'");
		ПоказатьПредупреждение(, Текст);
	КонецЕсли;
	РаботаСТорговымОборудованием.ОтключитьСканерШтрихкодов();
	РаботаСТорговымОборудованием.ПодключитьСканерШтрихкодов("ПоискДокументовПоШтрихкоду");
	
КонецПроцедуры