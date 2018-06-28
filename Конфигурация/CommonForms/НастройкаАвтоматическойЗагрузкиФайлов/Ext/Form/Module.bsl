﻿&НаКлиенте
Перем мПредставлениеПустогоРасписания;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мПредставлениеПустогоРасписания = Строка(Новый РасписаниеРегламентногоЗадания);
	ОбновитьПредставлениеРасписания();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	РедактированиеРасписанияРегламентногоЗадания();
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗадания()
	
	// если расписание не инициализировано в форме на сервере, то создаем новое
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
		
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	// открываем диалог для редактирования Расписания
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РедактированиеРасписанияРегламентногоЗаданияПродолжение",
		ЭтотОбъект);
		
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеРасписанияРегламентногоЗаданияПродолжение(Расписание, Параметры) Экспорт
	
	РасписаниеРегламентногоЗадания = Расписание;	
	ОбновитьПредставлениеРасписания();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеРасписания()
	
	ПредставлениеРасписания = Строка(РасписаниеРегламентногоЗадания);
	
	Если ПредставлениеРасписания = мПредставлениеПустогоРасписания Тогда
		
		ПредставлениеРасписания = НСтр("ru = 'Расписание не задано'");
		
	КонецЕсли;
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок = ПредставлениеРасписания;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	Если НЕ ИспользоватьРаспознавание Тогда
		Элементы.ТаблицаНастроекПредставлениеНастроекРаспознавания.Видимость = Ложь;
	КонецЕсли;	
	
	ТипПлатформыСервера = ФайловыеФункции.ТипПлатформыСервера();
	Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
		Элементы.ТаблицаНастроекКаталогWindows.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.ТаблицаНастроекКаталогLinux.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;	
	
	СтратегияРаспознаванияПоУмолчанию = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
	ЯзыкРаспознаванияПоУмолчанию = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
	
	РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	
	// тут читаем из параметров регл задания - если оно есть
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗадание();
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = РегламентноеЗаданиеОбъект.Расписание;
		МассивПараметров = РегламентноеЗаданиеОбъект.Параметры;
		
		Если ТипЗнч(МассивПараметров) = Тип("Массив") И МассивПараметров.Количество() > 0 Тогда
			
			МассивНастроек = МассивПараметров[0];
			
			Для Каждого Настройка Из МассивНастроек Цикл
				Строка = ТаблицаНастроек.Добавить();
				Строка.КаталогLinux = Настройка.КаталогLinux;
				Строка.КаталогWindows = Настройка.КаталогWindows;
				Строка.Папка = Настройка.Папка;
				Строка.Пользователь = Настройка.Пользователь;
				Если Настройка.Свойство("Категории") Тогда
					РаботаСКатегориямиДанныхКлиентСервер.СкопироватьСписок(Настройка.Категории, Строка.Категории); 
				КонецЕсли;
				
				Если Настройка.Свойство("СтратегияРаспознавания") Тогда
					Строка.СтратегияРаспознавания = Настройка.СтратегияРаспознавания;
				Иначе
					Строка.СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
				КонецЕсли;	
				
				Если Настройка.Свойство("ЯзыкРаспознавания") Тогда
					Строка.ЯзыкРаспознавания = Настройка.ЯзыкРаспознавания;
				Иначе
					Строка.ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
				КонецЕсли;	
				
				Строка.ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(Строка.СтратегияРаспознавания, Строка.ЯзыкРаспознавания);
			КонецЦикла;	
			
		КонецЕсли;	
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	// тут проверяем что все заполнено
	ОчиститьСообщения();
	
	Если ЗаписатьПараметрыРегламентногоЗадания() Тогда
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ЗаписатьПараметрыРегламентногоЗадания()
	
	МассивПараметров = Новый Массив;
	МассивНастроек = Новый Массив;
	НайденыОшибки = Ложь;
	
	ВсеПутиWindows = Новый Соответствие;
	ВсеПутиLinux = Новый Соответствие;
	
	Индекс = 0;
	Для Каждого Настройка Из ТаблицаНастроек Цикл
		
		СтруктураНастройки = Новый Структура("КаталогLinux, КаталогWindows, Папка, Пользователь, СтратегияРаспознавания, ЯзыкРаспознавания, Категории", 
			Настройка.КаталогLinux, Настройка.КаталогWindows, Настройка.Папка, Настройка.Пользователь,
			Настройка.СтратегияРаспознавания, Настройка.ЯзыкРаспознавания, Настройка.Категории);
			
		КаталогНаДиске = "";
		ТипПлатформыСервера = ФайловыеФункции.ТипПлатформыСервера();
		Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
			
			КаталогНаДиске = Настройка.КаталогWindows;
			
			Если Не ПустаяСтрока(Настройка.КаталогWindows) Тогда
				
				Если ВсеПутиWindows.Получить(Настройка.КаталогWindows) <> Неопределено Тогда
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Неуникальный путь к каталогу Microsoft Windows: ""%1""'"), 
						Настройка.КаталогWindows);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
					НайденыОшибки = Истина;
				Иначе	
					ВсеПутиWindows.Вставить(Настройка.КаталогWindows, 1);
				КонецЕсли;	
				
			КонецЕсли;

			Если Не ПустаяСтрока(Настройка.КаталогLinux) Тогда
				
				Если ВсеПутиLinux.Получить(Настройка.КаталогLinux) <> Неопределено Тогда
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Неуникальный путь к каталогу Linux: ""%1""'"), 
						Настройка.КаталогLinux);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
				Иначе	
					ВсеПутиLinux.Вставить(Настройка.КаталогLinux, 1);
				КонецЕсли;	
				
			КонецЕсли;
			
			Если Не ПустаяСтрока(Настройка.КаталогWindows) И (Лев(Настройка.КаталогWindows, 2) <> "\\" ИЛИ Найти(Настройка.КаталогWindows, ":") <> 0) Тогда
				
				ТекстОшибки = НСтр("ru = 'Путь к тому должен быть в формате UNC (\\servername\resource) '");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
				
				НайденыОшибки = Истина;
			КонецЕсли;	
			
		Иначе	
			КаталогНаДиске = Настройка.КаталогLinux;
		КонецЕсли;	
		
		Папка = Настройка.Папка;
		Пользователь = Настройка.Пользователь;
		
		Если ПустаяСтрока(КаталогНаДиске) Тогда
			
			ТекстОшибки = "";
			Если ТипПлатформыСервера = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыСервера = ТипПлатформы.Windows_x86_64 Тогда
				ТекстОшибки = НСтр("ru = 'Не заполнен путь к каталогу Microsoft Windows на диске'");
			Иначе	
				ТекстОшибки = НСтр("ru = 'Не заполнен путь к каталогу Linux на диске'");
			КонецЕсли;	
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
			
			НайденыОшибки = Истина;
		КонецЕсли;	
		
		Если Не ПустаяСтрока(КаталогНаДиске) Тогда
			
			Попытка
				
				КаталогНаДиске = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
					КаталогНаДиске, ОбщегоНазначенияДокументооборотПовтИсп.ТипПлатформыСервера());
				
				ИмяКаталогаТестовое = КаталогНаДиске + "ПроверкаДоступа\";
				СоздатьКаталог(ИмяКаталогаТестовое);
				УдалитьФайлы(ИмяКаталогаТестовое);
			
			Исключение
			
				ТекстОшибки = 
					НСтр("ru = 'Путь к каталогу некорректен. Возможно учетная запись, от лица которой работает сервер 1С:Предприятия, не имеет прав доступа к каталогу: '")
					+ Символы.ВК + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
				НайденыОшибки = Истина;
					
			КонецПопытки;

		КонецЕсли;		
		
		Если Папка.Пустая() Тогда
			
			ТекстОшибки = НСтр("ru = 'Не заполнена папка'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
			
			НайденыОшибки = Истина;
		КонецЕсли;	
		
		Если Пользователь.Пустая() Тогда
			ТекстОшибки = НСтр("ru = 'Не заполнен пользователь'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
			
			НайденыОшибки = Истина;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Папка) И ЗначениеЗаполнено(Пользователь) Тогда
			
			Если Не ЕстьПравоДоступа(Пользователь, Папка) Тогда
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'У пользователя ""%1"" нет прав на добавление файлов в папку ""%2""'"),
					Пользователь, Папка);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ТаблицаНастроек");
				
				НайденыОшибки = Истина;
				
			КонецЕсли;
			
		КонецЕсли;	
		
		МассивНастроек.Добавить(СтруктураНастройки);
		
		Индекс = Индекс + 1;
	КонецЦикла;	
	
	Если НайденыОшибки Тогда
		Возврат Ложь;
	КонецЕсли;	
		
	РегламентноеЗаданиеОбъект = СоздатьРегламентноеЗаданиеПриНеобходимости();
	РегламентноеЗаданиеОбъект.Расписание = РасписаниеРегламентногоЗадания;
		
	МассивПараметров.Добавить(МассивНастроек);
	РегламентноеЗаданиеОбъект.Параметры = МассивПараметров;
	
	
	РегламентноеЗаданиеОбъект.Записать();
	Возврат Истина;
КонецФункции

Функция ЕстьПравоДоступа(Пользователь, Папка)
	
	// если не включена функциональная опция "использовать права доступа" - то не делаем проверки.
	Если Не УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Папка, Пользователь).Добавление;
	
КонецФункции	

&НаСервере
Функция СоздатьРегламентноеЗаданиеПриНеобходимости()
	
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗадание();
	
	// при необходимости создаем регл. задание
	Если РегламентноеЗаданиеОбъект = Неопределено Тогда
		РегламентноеЗаданиеОбъект = РегламентныеЗадания.СоздатьРегламентноеЗадание("ЗагрузкаФайлов");
		
		// именно без пробела, т.к. потом идет отбор по наименованию "ЗагрузкаФайлов"
		РегламентноеЗаданиеОбъект.Наименование = НСтр("ru = 'ЗагрузкаФайлов'");
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

&НаСервере
Функция НайтиРегламентноеЗадание()
	
	РегламентноеЗаданиеОбъект = Неопределено;
	
	Отбор = Новый Структура("Наименование", "ЗагрузкаФайлов");
	МассивЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Если МассивЗаданий.Количество() <> 0 Тогда
		РегламентноеЗаданиеОбъект = МассивЗаданий[0];
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаНастроекПредставлениеНастроекРаспознаванияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", Элементы.ТаблицаНастроек.ТекущиеДанные.СтратегияРаспознавания, Элементы.ТаблицаНастроек.ТекущиеДанные.ЯзыкРаспознавания);	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ТаблицаНастроекПредставлениеНастроекРаспознаванияНачалоВыбораПродолжение",
		ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.Файлы.Форма.НастройкаРаспознавания", 
		ПараметрыОткрытия,,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПредставлениеНастроекРаспознаванияНачалоВыбораПродолжение(РезультатОткрытия, Параметры) Экспорт
	
	Если ТипЗнч(РезультатОткрытия) = Тип("Структура") Тогда
		Элементы.ТаблицаНастроек.ТекущиеДанные.СтратегияРаспознавания = РезультатОткрытия.СтратегияРаспознавания;
		Элементы.ТаблицаНастроек.ТекущиеДанные.ЯзыкРаспознавания = РезультатОткрытия.ЯзыкРаспознавания;
		Элементы.ТаблицаНастроек.ТекущиеДанные.ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(РезультатОткрытия.СтратегияРаспознавания, РезультатОткрытия.ЯзыкРаспознавания);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекПриИзменении(Элемент)
	
	Если Элементы.ТаблицаНастроек.ТекущиеДанные <> Неопределено Тогда
	
		Если Элементы.ТаблицаНастроек.ТекущиеДанные.СтратегияРаспознавания.Пустая() ИЛИ ПустаяСтрока(Элементы.ТаблицаНастроек.ТекущиеДанные.ЯзыкРаспознавания) Тогда
			Элементы.ТаблицаНастроек.ТекущиеДанные.СтратегияРаспознавания = СтратегияРаспознаванияПоУмолчанию;
			Элементы.ТаблицаНастроек.ТекущиеДанные.ЯзыкРаспознавания = ЯзыкРаспознаванияПоУмолчанию;
			Элементы.ТаблицаНастроек.ТекущиеДанные.ПредставлениеНастроекРаспознавания 
				= РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(Элементы.ТаблицаНастроек.ТекущиеДанные.СтратегияРаспознавания, Элементы.ТаблицаНастроек.ТекущиеДанные.ЯзыкРаспознавания);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекКатегорииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РаботаСКатегориямиДанныхКлиент.ОткрытьФормуПодбораКатегорийДляСпискаКатегорий(
		Элемент.Родитель.ТекущиеДанные.Категории,, Истина); 
		
КонецПроцедуры
