﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ЗаписьКалендаря") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаписьКалендаря = Параметры.ЗаписьКалендаря;
	ДатаНачалаПовторения = ЗаписьКалендаря.ДатаНачала;
	
	ЧастотаПовторения = ЗаписьКалендаря.ЧастотаПовторения;
	Если Не ЗначениеЗаполнено(ЧастотаПовторения) Тогда
		ЧастотаПовторения = Перечисления.ЧастотаПовторения.Еженедельно;
	КонецЕсли;
	
	ИнтервалПовторения = ЗаписьКалендаря.ИнтервалПовторения;
	Если ИнтервалПовторения < 1 Тогда
		ИнтервалПовторения = 1;
	КонецЕсли;
	
	ПравилоОкончанияПовторения = ЗаписьКалендаря.ПравилоОкончанияПовторения;
	Если Не ЗначениеЗаполнено(ПравилоОкончанияПовторения) Тогда
		ПравилоОкончанияПовторения = Перечисления.ПравилаОкончанияПовторения.Никогда;
	КонецЕсли;
	
	КоличествоПовторов = ЗаписьКалендаря.КоличествоПовторов;
	Если КоличествоПовторов = 0 Тогда
		КоличествоПовторов = 5;
	КонецЕсли;
	
	ДатаОкончанияПовторения = ЗаписьКалендаря.ДатаОкончанияПовторения;
	Если Не ЗначениеЗаполнено(ДатаОкончанияПовторения) Тогда
		ДатаОкончанияПовторения = ТекущаяДатаСеанса() + 604800; // 604800 - число секунд в неделе
	КонецЕсли;
	
	ЗаполненыДниНедели = Ложь;
	Для Каждого ПовторениеПоДню Из ЗаписьКалендаря.ПовторениеПоДням Цикл
		Если ПовторениеПоДню.НомерВхождения = 0 Тогда
			ВключитьПовторениеПоДнюНедели(ПовторениеПоДню.ДеньНедели);
			ЗаполненыДниНедели = Истина;
		Иначе
			НастройкаСпособаПовторенияВМесяце = 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗаполненыДниНедели Тогда
		ДеньНеделиНачала = ДеньНедели(ДатаНачалаПовторения);
		ВключитьПовторениеПоДнюНедели(ДеньНеделиНачала);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаписьКалендаря.ПовторениеПоДнямМесяца) Тогда
		НастройкаСпособаПовторенияВМесяце = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтображение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЧастотаПовторенияПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалПовторенияПриИзменении(Элемент)
	
	Если ИнтервалПовторения < 1 Тогда
		ИнтервалПовторения = 1;
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПовторовПриИзменении(Элемент)
	
	Если КоличествоПовторов < 1 Тогда
		КоличествоПовторов = 5;
		ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда");
		ТекущийЭлемент = Элементы.ПравилоОкончанияПовторения;
	Иначе
		ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов");
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПовторенияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ДатаОкончанияПовторения) Тогда
		ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты");
	Иначе
		ДатаОкончанияПовторения = ТекущаяДата() + 604800; // 604800 - число секунд в неделе
		ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда");
		ТекущийЭлемент = Элементы.ПравилоОкончанияПовторения;
	КонецЕсли;
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиПонедельникПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиВторникПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиСредаПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиЧетвергПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиПятницаПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиСубботаПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеньНеделиВоскресеньеПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпособаПовторенияВМесяцеПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ПроверитьКорректностьНастройкиПовторения() Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСРабочимКалендаремКлиент.УстановитьПовторение(ЗаписьКалендаря, ПолучитьНастройкиПовторения());
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьОтображение()
	
	Если ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.Никогда") Тогда
		Элементы.СтраницыНастройкиПравилОкончанияПовторения.ТекущаяСтраница = Элементы.СтраницаПравилоОкончаниеНикогда;
	ИначеЕсли ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов") Тогда
		Элементы.СтраницыНастройкиПравилОкончанияПовторения.ТекущаяСтраница = Элементы.СтраницаПравилоОкончанияПосле;
	ИначеЕсли ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты") Тогда
		Элементы.СтраницыНастройкиПравилОкончанияПовторения.ТекущаяСтраница = Элементы.СтраницаПравилоОкончанияПоДате;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЧастотаПовторения) Тогда
		
		Элементы.СтраницыПовторение.ТекущаяСтраница = Элементы.СтраницаПовторение;
		
		Если ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежедневно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиДень;
		ИначеЕсли ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиНеделя;
		ИначеЕсли ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежемесячно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиМесяц;
		ИначеЕсли ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежегодно") Тогда
			Элементы.СтраницыНастройки.ТекущаяСтраница = Элементы.СтраницаНастройкиГод;
		КонецЕсли;
		
	Иначе
		
		Элементы.СтраницыПовторение.ТекущаяСтраница = Элементы.СтраницаНеЗаданоПовторение;
		
	КонецЕсли;
	
	НастройкиПовторения = ПолучитьНастройкиПовторения();
	
	ПовторениеСтрокой =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьТекстовоеПредставлениеПовторения(НастройкиПовторения);
	
	ИнтервалЕдиницаИзмерения =
		РаботаСРабочимКалендаремКлиентСервер.ПолучитьТекстовоеПредставлениеЕдиницыИзмеренияИнтервалаПовторения(
			НастройкиПовторения);
	
	Если КоличествоПовторов = 1 Тогда
		КоличествоПовторовЕдиницаИзмерения = НСтр("ru = 'повтора'");
	Иначе
		КоличествоПовторовЕдиницаИзмерения = НСтр("ru = 'повторов'");
	КонецЕсли;
	
	Элементы.КоличествоПовторов.Доступность =
		(ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов"));
	Элементы.КоличествоПовторовЕдиницаИзмерения.Доступность =
		(ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов"));
	
	Элементы.ДатаОкончанияПовторения.Доступность =
		(ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты"));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПовторениеПоДнямНедели()
	
	ПовторениеПоДням = Новый Соответствие;
	Если ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно") Тогда
		ПовторениеПоДням.Вставить(1, ДеньНеделиПонедельник);
		ПовторениеПоДням.Вставить(2, ДеньНеделиВторник);
		ПовторениеПоДням.Вставить(3, ДеньНеделиСреда);
		ПовторениеПоДням.Вставить(4, ДеньНеделиЧетверг);
		ПовторениеПоДням.Вставить(5, ДеньНеделиПятница);
		ПовторениеПоДням.Вставить(6, ДеньНеделиСуббота);
		ПовторениеПоДням.Вставить(7, ДеньНеделиВоскресенье);
	Иначе
		ПовторениеПоДням.Вставить(1, Ложь);
		ПовторениеПоДням.Вставить(2, Ложь);
		ПовторениеПоДням.Вставить(3, Ложь);
		ПовторениеПоДням.Вставить(4, Ложь);
		ПовторениеПоДням.Вставить(5, Ложь);
		ПовторениеПоДням.Вставить(6, Ложь);
		ПовторениеПоДням.Вставить(7, Ложь);
	КонецЕсли;
	
	Возврат ПовторениеПоДням;
	
КонецФункции

&НаКлиенте
Функция ПолучитьНастройкиПовторения()
	
	ПовторениеПоДнямНедели = ПолучитьПовторениеПоДнямНедели();
	
	ПовторениеПоДнямМесяца = 0;
	ПовторениеПоДнямНеделиВМесяце = Неопределено;
	ПовторениеПоМесяцам = 0;
	ПовторениеКоличествоПовторов = 0;
	ПовторениеДатаОкончанияПовторения = Дата(1,1,1);
	
	Если ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежемесячно") Тогда
		
		Если НастройкаСпособаПовторенияВМесяце = 0 Тогда
			ПовторениеПоДнямМесяца = День(ДатаНачалаПовторения);
		ИначеЕсли НастройкаСпособаПовторенияВМесяце = 1 Тогда
			ПовторениеПоДнямНеделиВМесяце = РаботаСРабочимКалендаремКлиентСервер.ПолучитьДеньНеделиВМесяце(ДатаНачалаПовторения);
		КонецЕсли;
		
	ИначеЕсли ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Ежегодно") Тогда
		
		ПовторениеПоДнямМесяца = День(ДатаНачалаПовторения);
		ПовторениеПоМесяцам = Месяц(ДатаНачалаПовторения);
		
	КонецЕсли;
	
	Если ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов") Тогда
		ПовторениеКоличествоПовторов = КоличествоПовторов;
	ИначеЕсли ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ДоДаты") Тогда
		ПовторениеДатаОкончанияПовторения = ДатаОкончанияПовторения;
	КонецЕсли;
	
	НастройкиПовторения = РаботаСРабочимКалендаремКлиентСервер.ПолучитьСтруктуруНастройкиПовторения(
		ЧастотаПовторения, ИнтервалПовторения, ПравилоОкончанияПовторения,
		ПовторениеКоличествоПовторов, ПовторениеДатаОкончанияПовторения, ПовторениеПоДнямНедели,
		ПовторениеПоДнямМесяца, ПовторениеПоДнямНеделиВМесяце, ПовторениеПоМесяцам);
	
	Возврат НастройкиПовторения;
	
КонецФункции

&НаСервере
Процедура ВключитьПовторениеПоДнюНедели(ДеньНедели)
	
	Если ДеньНедели = 1 Тогда
		ДеньНеделиПонедельник = Истина;
	ИначеЕсли ДеньНедели = 2 Тогда
		ДеньНеделиВторник = Истина;
	ИначеЕсли ДеньНедели = 3 Тогда
		ДеньНеделиСреда = Истина;
	ИначеЕсли ДеньНедели = 4 Тогда
		ДеньНеделиЧетверг = Истина;
	ИначеЕсли ДеньНедели = 5 Тогда
		ДеньНеделиПятница = Истина;
	ИначеЕсли ДеньНедели = 6 Тогда
		ДеньНеделиСуббота = Истина;
	ИначеЕсли ДеньНедели = 7 Тогда
		ДеньНеделиВоскресенье = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьКорректностьНастройкиПовторения()
	
	Если ЧастотаПовторения = ПредопределенноеЗначение("Перечисление.ЧастотаПовторения.Еженедельно")
		И Не ДеньНеделиПонедельник И Не ДеньНеделиВторник И Не ДеньНеделиСреда И Не ДеньНеделиЧетверг
		И Не ДеньНеделиПятница И Не ДеньНеделиСуббота И Не ДеньНеделиВоскресенье Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Не указаны дни повторения.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПравилоОкончанияПовторенияПриИзменении(Элемент)
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОкончанияПовторенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПравилоОкончанияПовторения = ПредопределенноеЗначение("Перечисление.ПравилаОкончанияПовторения.ПослеЧислаПовторов");
	Если КоличествоПовторов = 0 Тогда
		КоличествоПовторов = 5;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти