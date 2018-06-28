﻿
////////////////////////////////////////////////////////////////////////////////
// Сроки исполнения процессов клиент переопределяемый: модуль содержит переопределяемые
// процедуры для поддержки особой логики работы сроков исполнения в редакциях КОРП и ДГУ.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс_ПереносСроков

// Вызывается из СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцесса при
// подтверждении переноса срока процесса.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона.
//  Отказ, ПараметрыЗаписи - параметры обработчика ПередЗаписью.
//  СтандартнаяОбработка – Булево - в случае значения Истина подтверждение
//                         переноса срока будет обработано способом по умолчанию.
//
Процедура ПриПодтвержденииПереносаСрокаПроцесса(
	Форма, Отказ, ПараметрыЗаписи, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ПодтвердитьПереносСрокаПроцесса(Форма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ПродолжитьПослеПодтвержденияПереносаСрока при
// продолжении после подтверждения переноса срока процесса.
//
// Параметры:
//  РезультатПодтверждения - Произвольный - результат оповещения.
//  ДопПараметры - Структура - доп. параметры обработчика оповещения.
//  СтандартнаяОбработка – Булево - в случае значения Истина обработка подтверждения
//                         переноса срока будет произведена способом по умолчанию.
//
Процедура ПриПродолженииПослеПодтвержденияПереносаСрока(
	РезультатПодтверждения, ДопПараметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ПродолжитьПослеПодтвержденияПереносаСрока(
		РезультатПодтверждения, ДопПараметры);
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку при
// подтверждении переноса срока процесса при возврате на доработку.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение, которое будет исполнено после подтверждения.
//  СтандартнаяОбработка – Булево - в случае значения Истина подтверждение
//                         переноса срока будет обработано способом по умолчанию.
//
Процедура ПриПодтвержденииПереносаСрокаПроцессаПриВозвратеНаДоработку(
	Форма, ОписаниеОповещения, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ПодтвердитьПереносСрокаПроцессаПриВозвратеНаДоработку(
		Форма, ОписаниеОповещения);
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ПродолжитьПослеПодтвержденияПереносаСрокаПриВозвратеНаДоработку при
// продолжении после подтверждения переноса срока процесса.
//
// Параметры:
//  РезультатПодтверждения - Произвольный - результат оповещения.
//  ДопПараметры - Структура - доп. параметры обработчика оповещения.
//  СтандартнаяОбработка – Булево - в случае значения Истина обработка подтверждения
//                         переноса срока будет произведена способом по умолчанию.
//
Процедура ПриПродолженииПослеПодтвержденияПереносаСрокаПриВозвратеНаДоработку(
	РезультатПодтверждения, ДопПараметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ПродолжитьПослеПодтвержденияПереносаСрокаПриВозвратеНаДоработку(
		РезультатПодтверждения, ДопПараметры);
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ПродолжитьПослеПодтвержденияПереносаСрокаПриВозвратеНаДоработку при
// продолжении после подтверждения переноса срока процесса.
//
// Параметры:
//  РезультатПодтверждения - Произвольный - результат оповещения.
//  ДопПараметры - Структура - доп. параметры обработчика оповещения.
//  СтандартнаяОбработка – Булево - в случае значения Истина обработка подтверждения
//                         переноса срока будет произведена способом по умолчанию.
//
Процедура ПриОповещениеОПереносеСроков(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ОповеститьОПереносеСроков(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_КарточкиПроцессовИШаблонов

// Вызывается из СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияПоПредставлению при
// изменении срок исполнения по представлению.
//
// Параметры:
//  Дата - Дата - срок исполнения датой (точный срок).
//  Дни - Число - относительный срок, дни.
//  Часы - Число - относительный срок, часы.
//  Минуты - Число - относительный срок, минуты.
//  ВариантУстановкиСрока - ПеречислениеСсылка.ВариантыУстановкиСрокаИсполнения - 
//                          вариант установки срока.
//  Представление - Строка - представление срока строкой.
//  ДопПараметры - Структура - структура вспомогательных параметров.
//   * ТекстСообщенияПредупреждения - Строка - возвращаемый текст сообщения/предупреждения в
//                                  случае ошибки.
//   * ВПредставленииМожетБытьДата - Булево - признак того, что в представлении может быть дата.
//  Результат - Булево - в случае успешного изменения срока, в этот параметр следует поместить значение Истина,
//              иначе Ложь.
//  СтандартнаяОбработка – Булево - в случае значения Истина изменение будет осуществляться
//                                  способом по умолчанию.
//
Процедура ПриИзмененииСрокаИсполненияПоПредставлению(
	Дата, Дни, Часы, Минуты, ВариантУстановкиСрока, Представление,
	ДопПараметры, Результат, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыИзменения = Новый Структура(
		"ТекстСообщенияПредупреждения, ВПредставленииМожетБытьДата, Исполнитель");
	ЗаполнитьЗначенияСвойств(ПараметрыИзменения, ДопПараметры);
	
	Результат = СрокиИсполненияПроцессовВызовСервераКОРП.ИзменитьСрокИсполненияПоПредставлению(
		Дата, Дни, Часы, Минуты, ВариантУстановкиСрока, Представление, ПараметрыИзменения);
		
	ЗаполнитьЗначенияСвойств(ДопПараметры, ПараметрыИзменения);
	
КонецПроцедуры

//////////////////////////////
// Проверка корректности сроков исполнения процессов

// Вызывается из СрокиИсполненияПроцессовКлиент.ТочныеСрокиПроцесса при
// определении точных сроков процесса.
//
// Параметры:
//  Процесс - ДанныеФормыСтруктура, Структура - процесс в форме или структура для расчета сроков.
//  ТочныеСрокиПроцесса - Массив - в этот параметр следует поместить массив дат точных сроков процесса.
//  СтандартнаяОбработка – Булево - в случае значения Истина формирование точных сроков будет осуществляться
//                                  способом по умолчанию.
//
Процедура ПриФормированииТочныхСроковПроцесса(
	Процесс, ТочныеСрокиПроцесса, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ТочныеСрокиПроцесса = СрокиИсполненияПроцессовКлиентКОРП.ТочныеСрокиПроцесса(Процесс);
	
КонецПроцедуры

//////////////////////////////
// Сроки участников процесса

// Вызывается из СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению при
// получении доп. параметров для изменения срока по представлению.
//
// Параметры:
//  Результат - Структура - в этот параметр следует записать результат.
//  СтандартнаяОбработка – Булево - в случае значения Истина будет возвращен
//                                  набор параметров по умолчанию.
//
Процедура ПриФормированииДопПараметровДляИзмененияСрокаПоПредставлению(
	Результат, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Результат = СрокиИсполненияПроцессовКлиентКОРП.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса при
// получении параметров для выбора срока.
//
// Параметры:
//  Результат - Структура - в этот параметр следует записать результат.
//  СтандартнаяОбработка – Булево - в случае значения Истина будет возвращен
//                                  набор параметров по умолчанию.
//
Процедура ПриФормированииПараметровВыбораСрокаУчастникаПроцесса(
	Результат, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Результат = СрокиИсполненияПроцессовКлиентКОРП.ПараметрыВыбораСрокаУчастникаПроцесса();
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса при
// выборе срока участника процесса.
//
// Параметры:
//  Параметры - Структура - параметры выбора.
//  СтандартнаяОбработка – Булево - в случае значения Истина выбор срок будет
//                         осуществляться способом по умолчанию.
//
Процедура ПриВыбореСрокаУчастникаПроцесса(Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ВыбратьСрокУчастникаПроцесса(Параметры);
	
КонецПроцедуры

//////////////////////////////
// Сроки в таблице Исполнители

// Вызывается из СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияПоПредставлениюВТаблицеИсполнители
// при изменении срока по представлению в таблице исполнители.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона процесса
//  ЭлементИсполнители - ТаблицаФормы - элемент формы таблица исполнителей.
//  РеквизитИсполнители - ДанныеФормыКоллекция - таблица исполнителей процесса.
//  ВариантИсполнения - ПеречислениеСсылка.ВариантыМаршрутизацииЗадач - вариант исполнения задач процесса.
//  СтандартнаяОбработка – Булево - в случае значения Истина обработка изменения срока
//                         будет осуществляться способом по умолчанию.
//
Процедура ПриИзмененииСрокаИсполненияПоПредставлениюВТаблицеИсполнители(
	Форма, ЭлементИсполнители, РеквизитИсполнители, ВариантИсполнения, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ИзменитьСрокИсполненияПоПредставлениюВТаблицеИсполнители(
		Форма, ЭлементИсполнители, РеквизитИсполнители, ВариантИсполнения);
	
КонецПроцедуры

// Вызывается из СрокиИсполненияПроцессовКлиент.ВыбратьСрокИсполненияДляСтрокиТаблицыИсполнители при
// выборе срока для стр. таблицы Исполнители процесса.
//
// Параметры:
//  Форма - УправляемаяФорма - форма процесса или шаблона процесса
//  ЭлементИсполнители - ТаблицаФормы - элемент формы таблица исполнителей.
//  РеквизитИсполнители - ДанныеФормыКоллекция - таблица исполнителей процесса.
//  ВариантИсполнения - ПеречислениеСсылка.ВариантыМаршрутизацииЗадач - вариант исполнения задач процесса.
//  СтандартнаяОбработка – Булево - в случае значения Истина обработка выбора срока
//                         будет осуществляться способом по умолчанию.
//
Процедура ПриВыбореСрокаИсполненияДляСтрокиТаблицыИсполнители(
	Форма, ЭлементИсполнители, РеквизитИсполнители, ВариантИсполнения, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	СрокиИсполненияПроцессовКлиентКОРП.ВыбратьСрокИсполненияДляСтрокиТаблицыИсполнители(
		Форма, ЭлементИсполнители, РеквизитИсполнители, ВариантИсполнения);
	
КонецПроцедуры

#КонецОбласти
