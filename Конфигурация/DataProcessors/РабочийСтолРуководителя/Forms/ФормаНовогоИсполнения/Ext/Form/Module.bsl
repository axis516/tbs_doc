﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДекорацияТекущаяДата.Заголовок = НСтр("ru = 'Сегодня: '") + Формат(Параметры.ТекущаяДата, "ДФ=""дд ММММ""");
	
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ЗаполнитьСписокВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
	Кому = Справочники.Пользователи.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьСообщения();
	Результат = СоздатьИсполнение();
	
	Если Результат <> Неопределено Тогда
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Старт'"),
			Результат.НавигационнаяСсылка,
			Результат.Представление,
			БиблиотекаКартинок.Информация32);
			
		Оповестить("ФормаРаботыСЗаявкойЗакрыта");
			
		Закрыть();
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Функция СоздатьИсполнение()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Исполнение = БизнесПроцессы.Исполнение.СоздатьБизнесПроцесс();
	Исполнение.Дата = ТекущаяДатаСеанса();
	Исполнение.Автор = ПользователиКлиентСервер.ТекущийПользователь();
	Исполнение.Проверяющий = ПользователиКлиентСервер.ТекущийПользователь();
	
	Исполнение.Наименование = ЧтоСделать;
	Исполнение.Наименование = СтрЗаменить(Исполнение.Наименование, Символы.ВК, " ");
	Исполнение.Наименование = СтрЗаменить(Исполнение.Наименование, Символы.ПС, " ");
	Исполнение.Наименование = СтрЗаменить(Исполнение.Наименование, Символы.Таб, " ");
	Исполнение.Описание = ЧтоСделать;
	Исполнение.ВариантИсполнения = Перечисления.ВариантыМаршрутизацииЗадач.Параллельно;
	Исполнение.КоличествоИтераций = 1;
	
	Строка = Исполнение.Исполнители.Добавить();
	Строка.Исполнитель = Кому;
	Если ЗначениеЗаполнено(Срок) Тогда
		Строка.СрокИсполнения = КонецДня(Срок);
		Строка.ВариантУстановкиСрокаИсполнения = Перечисления.ВариантыУстановкиСрокаИсполнения.ТочныйСрок;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Срок) Тогда
		Исполнение.СрокИсполненияПроцесса = КонецДня(Срок);
	КонецЕсли;	
	
	Исполнение.Записать();
	Исполнение.Старт();
	
	ВозвращаемыйРезультат = Новый Структура(
		"Ссылка, НавигационнаяСсылка, Представление",
		Исполнение.Ссылка,
		ПолучитьНавигационнуюСсылку(Исполнение.Ссылка),
		Строка(Исполнение));
		
	// Сохранение вводимых значений
	СохранениеВводимыхЗначений.ОбновитьСпискиВыбора(ЭтаФорма, ЭлементыДляСохранения(), ЭтаФорма.ИмяФормы);
		
	Возврат ВозвращаемыйРезультат;
		
КонецФункции

&НаКлиенте
Процедура Отмена(Команда)
	
	Если Модифицированность Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтменаОтветНаВопрос", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Отменить создание поручения?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура("Кому", Кому);
	
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

&НаКлиенте
Процедура ОтменаОтветНаВопрос(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КомуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникНачалоВыбора(
		Элемент, Кому, СтандартнаяОбработка, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура КомуАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КомуОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДополнениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПолныеРоли");
		ДанныеВыбора = РаботаСПользователями.СформироватьДанныеВыбора(Текст, ДополнениеТипа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЧтоСделатьПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Добавить("ЧтоСделать");
	ПроверяемыеРеквизиты.Добавить("Кому");
	
КонецПроцедуры

#КонецОбласти