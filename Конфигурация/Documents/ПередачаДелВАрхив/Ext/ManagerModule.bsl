﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Печать итоговой записи
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ПередачаДелВАрхив";
	КомандаПечати.Идентификатор = "Опись";
	КомандаПечати.Представление = НСтр("ru = 'Опись'");
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Опись") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Опись", "Опись", ПечатьОписи(МассивОбъектов, ОбъектыПечати), , "Документ.ПередачаДелВАрхив.ПФ_MXL_Опись");
	
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьОписи(МассивОбъектов, ОбъектыПечати) Экспорт
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_ОписьПередачиДелВАрхив";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Получаем запросом необходимые данные
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПередачаДелВАрхив.Ссылка КАК Ссылка,
	|	ПередачаДелВАрхив.Организация КАК Организация,
	|	ПередачаДелВАрхив.Дата КАК Дата,
	|	ПередачаДелВАрхив.Номер КАК Номер,
	|	ПередачаДелВАрхив.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.ПередачаДелВАрхив КАК ПередачаДелВАрхив
	|ГДЕ
	|	ПередачаДелВАрхив.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаСсылка = Запрос.Выполнить().Выбрать();
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Индекс КАК Индекс,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.ПолноеНаименование КАК Наименование,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Раздел КАК Раздел,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.СрокХранения КАК СрокХранения,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.ОтметкаЭПК КАК ОтметкаЭПК,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.Комментарий КАК Примечание,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.ДатаНачала КАК ДатаНачала,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.ДатаОкончания КАК ДатаОкончания,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.КоличествоЛистов КАК КоличествоЛистов,
	|	ДелаХраненияДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПередачаДелВАрхив.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|ГДЕ
	|	ДелаХраненияДокументов.Ссылка В(&МассивОбъектов)
	|	И ДелаХраненияДокументов.ДелоХраненияДокументов <> ЗНАЧЕНИЕ(Справочник.ДелаХраненияДокументов.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Индекс
	|ИТОГИ ПО
	|	Ссылка,
	|	Раздел ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаДетали = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ПередачаДелВАрхив.ПФ_MXL_Опись");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка 	 = Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока 	 = Макет.ПолучитьОбласть("Строка");
	ОбластьРаздел 	 = Макет.ПолучитьОбласть("Раздел");
	ОбластьПодвал 	 = Макет.ПолучитьОбласть("Подвал");
	
	ПервыйДокумент = Истина;
	Пока ВыборкаСсылка.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		
		// заголовок
		ОбластьЗаголовок.Параметры.НаименованиеПредприятия = РаботаСОрганизациями.ПолучитьНаименованиеОрганизации(ВыборкаСсылка.Организация);
		ОбластьЗаголовок.Параметры.ДатаДок = Формат(ВыборкаСсылка.Дата, "ДЛФ=D");
		ОбластьЗаголовок.Параметры.НомерДок = ВыборкаСсылка.Номер;
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// шапка
		ТабличныйДокумент.Вывести(ОбластьШапка);
		Номер = 0;
		
		// разделы
		Если ВыборкаДетали.НайтиСледующий(ВыборкаСсылка.Ссылка, "Ссылка") Тогда
			
			ВыборкаРазделы = ВыборкаДетали.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаРазделы.Следующий() Цикл
				
				ОбластьРаздел.Параметры.Индекс = ВыборкаРазделы.Раздел.Индекс;
				ОбластьРаздел.Параметры.Наименование = ВыборкаРазделы.Раздел.Наименование;
				ТабличныйДокумент.Вывести(ОбластьРаздел);
				
				// строки
				ВыборкаСтроки = ВыборкаРазделы.Выбрать();
				Пока ВыборкаСтроки.Следующий() Цикл
					Номер = Номер + 1;
					
					ОбластьСтрока.Параметры.Заполнить(ВыборкаСтроки);
					ОбластьСтрока.Параметры.Номер = Номер;
					ОбластьСтрока.Параметры.КрайниеДаты = Формат(ВыборкаСтроки.ДатаНачала, "ДЛФ=D") + " - " + Формат(ВыборкаСтроки.ДатаОкончания, "ДЛФ=D");
					
					СрокХранения = ВыборкаСтроки.СрокХранения;
					ОтметкаЭПК = ВыборкаСтроки.ОтметкаЭПК;
					Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
						ОбластьСтрока.Параметры.СрокХранения = Строка(СрокХранения) + " " + ДелопроизводствоКлиентСервер.ПодписьЛет(СрокХранения) + ?(ОтметкаЭПК, " ЭПК", "");
					Иначе
						ОбластьСтрока.Параметры.СрокХранения = СрокХранения + ?(ОтметкаЭПК, " ЭПК", "");
					КонецЕсли;	
					ТабличныйДокумент.Вывести(ОбластьСтрока);
				КонецЦикла;	
			КонецЦикла;
			
		КонецЕсли;
		
		// подвал
		ОбластьПодвал.Параметры.КоличествоДел = Формат(Номер, "ЧГ=") + " (" + ЧислоПрописью(Номер, , ",,,,,,,,0") + ")";
		ОбластьПодвал.Параметры.НачальныйНомер = 1;
		ОбластьПодвал.Параметры.КонечныйНомер = Номер;
		ОбластьПодвал.Параметры.ДатаДок = Формат(ВыборкаСсылка.Дата, "ДЛФ=D");
		
		РуководительДОУ = РаботаСОрганизациями.ПолучитьОтветственноеЛицо("РуководительСлужбыДОУ", ВыборкаСсылка.Организация, ВыборкаСсылка.Дата);
		ОбластьПодвал.Параметры.РуководительДОУ = РуководительДОУ.ПредставлениеВДокументах;
		ОбластьПодвал.Параметры.ДолжностьРуководителяДОУ = РаботаСПользователями.ПолучитьДолжность(РуководительДОУ);
		
		ОбластьПодвал.Параметры.Составитель = ВыборкаСсылка.Ответственный.ПредставлениеВДокументах;
		ОбластьПодвал.Параметры.ДолжностьСоставителя = РаботаСПользователями.ПолучитьДолжность(ВыборкаСсылка.Ответственный);
		
		РуководительАрхива = РаботаСОрганизациями.ПолучитьОтветственноеЛицо("РуководительАрхива", ВыборкаСсылка.Организация, ВыборкаСсылка.Дата);
		ОбластьПодвал.Параметры.РуководительАрхива = РуководительАрхива.ПредставлениеВДокументах;
		ОбластьПодвал.Параметры.ДолжностьРуководителяАрхива = РаботаСПользователями.ПолучитьДолжность(РуководительАрхива);
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаСсылка.Ссылка);
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
КонецФункции

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
КонецПроцедуры

#КонецЕсли