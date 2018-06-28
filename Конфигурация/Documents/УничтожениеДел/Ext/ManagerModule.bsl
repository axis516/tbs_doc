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
	КомандаПечати.МенеджерПечати = "Документ.УничтожениеДел";
	КомандаПечати.Идентификатор = "Акт";
	КомандаПечати.Представление = НСтр("ru = 'Акт'");
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
    Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Акт") Тогда

        // Формируем табличный документ и добавляем его в коллекцию печатных форм
        УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
            "Акт", "Акт", ПечатьАкта(МассивОбъектов, ОбъектыПечати), , "Документ.УничтожениеДел.ПФ_MXL_Акт");

	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьАкта(МассивОбъектов, ОбъектыПечати) Экспорт
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_АктУничтоженияДел";
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	// Получаем запросом необходимые данные
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УничтожениеДел.Ссылка КАК Ссылка,
	|	УничтожениеДел.Организация КАК Организация,
	|	УничтожениеДел.Дата КАК Дата,
	|	УничтожениеДел.Номер КАК Номер,
	|	УничтожениеДел.Основание КАК Основание,
	|	УничтожениеДел.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.УничтожениеДел КАК УничтожениеДел
	|ГДЕ
	|	УничтожениеДел.Ссылка В(&МассивОбъектов)";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаСсылка = Запрос.Выполнить().Выбрать();
		
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(1) КАК КоличествоЕдиницХранения,
	|	МИНИМУМ(ДелаХраненияДокументов.ДелоХраненияДокументов.ДатаНачала) КАК ДатаНачала,
	|	МАКСИМУМ(ДелаХраненияДокументов.ДелоХраненияДокументов.ДатаОкончания) КАК ДатаОкончания,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел КАК НоменклатураДел,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Раздел КАК Раздел,
	|	ВЫРАЗИТЬ(ДелаХраненияДокументов.ДелоХраненияДокументов.Комментарий КАК СТРОКА(500)) КАК Примечание,
	|	ДелаХраненияДокументов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.УничтожениеДел.ДелаХраненияДокументов КАК ДелаХраненияДокументов
	|ГДЕ
	|	ДелаХраненияДокументов.Ссылка В(&МассивОбъектов)
	|	И ДелаХраненияДокументов.ДелоХраненияДокументов <> ЗНАЧЕНИЕ(Справочник.ДелаХраненияДокументов.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДелаХраненияДокументов.Ссылка,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел,
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Раздел,
	|	ВЫРАЗИТЬ(ДелаХраненияДокументов.ДелоХраненияДокументов.Комментарий КАК СТРОКА(500))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДелаХраненияДокументов.ДелоХраненияДокументов.НоменклатураДел.Индекс
	|ИТОГИ ПО
	|	Ссылка,
	|	Раздел ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	ВыборкаДетали = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УничтожениеДел.ПФ_MXL_Акт");
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
		Руководитель = РаботаСОрганизациями.ПолучитьОтветственноеЛицо("Руководитель", ВыборкаСсылка.Организация, ВыборкаСсылка.Дата);
		ОбластьЗаголовок.Параметры.Руководитель = Руководитель.ПредставлениеВДокументах;
		ОбластьЗаголовок.Параметры.ДолжностьРуководителя = РаботаСПользователями.ПолучитьДолжность(Руководитель);
		
		ОбластьЗаголовок.Параметры.НаименованиеПредприятия = РаботаСОрганизациями.ПолучитьНаименованиеОрганизации(ВыборкаСсылка.Организация);
		ОбластьЗаголовок.Параметры.ДатаДок = Формат(ВыборкаСсылка.Дата, "ДЛФ=D");
		ОбластьЗаголовок.Параметры.НомерДок = ВыборкаСсылка.Номер;
		ОбластьЗаголовок.Параметры.Основание1 = Лев(ВыборкаСсылка.Основание, 60);
		ОбластьЗаголовок.Параметры.Основание2 = Сред(ВыборкаСсылка.Основание, 61);
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// шапка
		ТабличныйДокумент.Вывести(ОбластьШапка);
		Номер = 0;
		КоличествоЕдиницХранения = 0;
		НачальныйГод = 9999;
		КонечныйГод = 0;
		
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
					КоличествоЕдиницХранения = КоличествоЕдиницХранения + ВыборкаСтроки.КоличествоЕдиницХранения;
					
					ОбластьСтрока.Параметры.Заполнить(ВыборкаСтроки);
					ОбластьСтрока.Параметры.Номер = Номер;
					ОбластьСтрока.Параметры.Индекс = ВыборкаСтроки.НоменклатураДел.Индекс;
					ОбластьСтрока.Параметры.Наименование = ВыборкаСтроки.НоменклатураДел.Наименование;
					ОбластьСтрока.Параметры.КрайниеДаты = Формат(ВыборкаСтроки.ДатаНачала, "ДЛФ=D") + " - " + Формат(ВыборкаСтроки.ДатаОкончания, "ДЛФ=D");
					
					Если Год(ВыборкаСтроки.ДатаНачала) < НачальныйГод Тогда 
						НачальныйГод = Год(ВыборкаСтроки.ДатаНачала);
					КонецЕсли;
					Если Год(ВыборкаСтроки.ДатаОкончания) > КонечныйГод Тогда 
						КонечныйГод = Год(ВыборкаСтроки.ДатаОкончания);
					КонецЕсли;
					
					СрокХранения = ВыборкаСтроки.НоменклатураДел.СрокХранения;
					НомераСтатей = ВыборкаСтроки.НоменклатураДел.НомераСтатей;
					ОтметкаЭПК = ВыборкаСтроки.НоменклатураДел.ОтметкаЭПК;
					Если ТипЗнч(СрокХранения) = Тип("Число") Тогда 
						ОбластьСтрока.Параметры.СрокХранения = Строка(СрокХранения) + " " + ДелопроизводствоКлиентСервер.ПодписьЛет(СрокХранения) + ?(ОтметкаЭПК, " ЭПК", "") + ?(ЗначениеЗаполнено(НомераСтатей), ", " + НомераСтатей, "");
					Иначе
						ОбластьСтрока.Параметры.СрокХранения = СрокХранения + ?(ОтметкаЭПК, " ЭПК", "") + ?(ЗначениеЗаполнено(НомераСтатей), ", " + НомераСтатей, "");
					КонецЕсли;	
					
					ТабличныйДокумент.Вывести(ОбластьСтрока);
				КонецЦикла;	
			КонецЦикла;
			
		КонецЕсли;
		
		Если НачальныйГод = 9999 Тогда 
			НачальныйГод = 0;
		КонецЕсли;
		
		// подвал
		ОбластьПодвал.Параметры.КоличествоЕдиницХранения = Формат(КоличествоЕдиницХранения, "ЧГ=") + " (" + ЧислоПрописью(КоличествоЕдиницХранения, , ",,,,,,,,0") + ")";
		
		Если НачальныйГод = КонечныйГод Тогда 
			ОбластьПодвал.Параметры.НачальныйКонечныйГод = Формат(НачальныйГод, "ЧГ=") + " год";
		Иначе
			ОбластьПодвал.Параметры.НачальныйКонечныйГод = Формат(НачальныйГод, "ЧГ=") + " - " + Формат(КонечныйГод, "ЧГ=") + " годы";
		КонецЕсли;	
		
		ОбластьПодвал.Параметры.ДатаДок = Формат(ВыборкаСсылка.Дата, "ДЛФ=D");
		
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