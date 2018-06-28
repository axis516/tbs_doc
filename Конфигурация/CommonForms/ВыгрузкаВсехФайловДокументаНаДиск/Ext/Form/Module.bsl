﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("МассивВладельцев") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	СписокВладельцев = Новый СписокЗначений;
	СписокВладельцев.ЗагрузитьЗначения(Параметры.МассивВладельцев);
	ДоступныеТипыСвязей = СвязиДокументов.ПолучитьАктуальныеТипыСвязейДокументов(Параметры.МассивВладельцев);
	
	НастройкиФормы = ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(ИмяФормы + "/ТекущиеДанные", "");
	Если НастройкиФормы = Неопределено Тогда
		ЗаполнитьСписокФайлов();
	КонецЕсли;
	
	РасширениеДляЗашифрованныхФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ЭП", "РасширениеДляЗашифрованныхФайлов");
	Если ПустаяСтрока(РасширениеДляЗашифрованныхФайлов) Тогда
		РасширениеДляЗашифрованныхФайлов = "p7m";
	КонецЕсли;
	
	СохранениеВводимыхЗначений.ЗаполнитьСписокВыбора(ЭтаФорма, ЭлементыДляСохранения(), ИмяФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте сохранение файлов не поддерживается.'"));
		Возврат;
	#КонецЕсли
	
	РазвернутьСписокФайлов();
	
	Если Не ВключатьСвязанныеДокументы Тогда 
		Элементы.ТипыСвязей.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьСписокФайлов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ПапкаДляЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Выбрать();
	
	Если ЗначениеЗаполнено(Диалог.Каталог) Тогда
		ПапкаДляЭкспорта = ФайловыеФункцииКлиент.НормализоватьКаталог(Диалог.Каталог);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляЭкспортаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ПапкаДляЭкспорта) Тогда
		ПапкаДляЭкспорта = ФайловыеФункцииКлиент.НормализоватьКаталог(ПапкаДляЭкспорта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловДляВыбораВыгружатьПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокФайловДляВыбора.ТекущиеДанные;
	Если ТекущиеДанные.ЭтоРодитель Тогда 
		Выгружать = ТекущиеДанные.Выгружать;
		СтрокаДерева = СписокФайловДляВыбора.НайтиПоИдентификатору(Элементы.СписокФайловДляВыбора.ТекущаяСтрока);
		Для Каждого Строка Из СтрокаДерева.ПолучитьЭлементы() Цикл
			Строка.Выгружать = Выгружать;
		КонецЦикла;	
	КонецЕсли;	
	
	КоличествоВыбранныхФайлов = ПолучитьКоличествоВыбранныхФайлов(СписокФайловДляВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоОригиналыПриИзменении(Элемент)
	
	ЗаполнитьСписокФайлов();
	РазвернутьСписокФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключатьСвязанныеДокументыПриИзменении(Элемент)
	
	Если ВключатьСвязанныеДокументы Тогда 
		Элементы.ТипыСвязей.ТолькоПросмотр = Ложь;
	Иначе	
		Элементы.ТипыСвязей.ТолькоПросмотр = Истина;
		ТипыСвязей.Очистить();
	КонецЕсли;
	
	ЗаполнитьСписокФайлов();
	РазвернутьСписокФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипыСвязейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыбранныеТипыСвязей", ТипыСвязей.ВыгрузитьЗначения());
	ПараметрыФормы.Вставить("ДоступныеТипыСвязей", ДоступныеТипыСвязей.ВыгрузитьЗначения());
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ТипыСвязейНачалоВыбораПродолжение", 
		ЭтотОбъект);
	
	ОткрытьФорму("Справочник.ТипыСвязей.Форма.ФормаПодбора", ПараметрыФормы, ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ТипыСвязейНачалоВыбораПродолжение(Результат, Параметры) Экспорт 
	
	Если ТипЗнч(Результат) = Тип("Массив") Тогда 
		ТипыСвязей.ЗагрузитьЗначения(Результат);
		
		ЗаполнитьСписокФайлов();
		РазвернутьСписокФайлов();
	КонецЕсли;

КонецПроцедуры	

&НаКлиенте
Процедура СписокФайловНаименованиеОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокФайловДляВыбора.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	ПоказатьЗначение(, ТекущиеДанные.Файл);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловДляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СписокФайловНаименование Тогда 
		СтандартнаяОбработка = Ложь;
		
		ДанныеСтроки = СписокФайловДляВыбора.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ДанныеСтроки.ЭтоРодитель Тогда 
			ПоказатьЗначение(, ДанныеСтроки.ВладелецФайла);
		Иначе
			ПоказатьЗначение(, ДанныеСтроки.Файл);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловДляВыбораПередНачаломИзменения(Элемент, Отказ)
	
	Поле = Элементы.СписокФайловДляВыбора.ТекущийЭлемент;
	Если Поле = Элементы.СписокФайловНаименование Тогда 
		Отказ = Истина;
		
		ТекущиеДанные = Элементы.СписокФайловДляВыбора.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда 
			Возврат;
		КонецЕсли;	
		
		Если ТекущиеДанные.ЭтоРодитель Тогда 
			ПоказатьЗначение(, ТекущиеДанные.ВладелецФайла);
		Иначе
			ПоказатьЗначение(, ТекущиеДанные.Файл);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Сохранить(Команда)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте сохранение файлов не поддерживается.'"));
		Возврат;
	#КонецЕсли
	
	Обработчик = Новый ОписаниеОповещения("СохранитьПослеУстановкиРасширения", ЭтотОбъект);
	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры	

&НаКлиенте
Процедура СохранитьПослеУстановкиРасширения(Результат, ПараметрыВыполнения) Экспорт
	
	Если НЕ ФайловыеФункцииСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами(Неопределено);
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ЕстьПредупреждения = Ложь;
	СтрокаПредупреждения = "";
	МассивПредупреждений = Новый Массив;
	
	СписокИменФайлов = Новый СписокЗначений;
	СписокСчетчиковИменФайлов = Новый Массив;
	
	КоличествоВыбранныхФайлов = ПолучитьКоличествоВыбранныхФайлов(СписокФайловДляВыбора);
	Если КоличествоВыбранныхФайлов = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не выбраны выгружаемые файлы'"),, "СписокФайловДляВыбора");
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ПапкаДляЭкспорта) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указана папка для сохранения файлов'"),, "ПапкаДляЭкспорта");
		Возврат;
	КонецЕсли;
	
	КаталогВыгрузки = Новый Файл(ПапкаДляЭкспорта);
	Если Не КаталогВыгрузки.Существует() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Указанная папка не найдена'"),, "ПапкаДляЭкспорта");
		Возврат;			
	КонецЕсли;	
	
	МассивСтрокФайлов = Новый Массив;
	Для Каждого СтрокаРодитель Из СписокФайловДляВыбора.ПолучитьЭлементы() Цикл
		Для Каждого ДанныеСтроки Из СтрокаРодитель.ПолучитьЭлементы() Цикл
			Если ДанныеСтроки.Выгружать Тогда
				МассивСтрокФайлов.Добавить(ДанныеСтроки);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
	
	Для Каждого ДанныеСтроки Из МассивСтрокФайлов Цикл
		
		Наименование = ДанныеСтроки.ИмяФайлаДляСохранения;
		Расширение = ДанныеСтроки.Расширение;
		
		ИмяФайлаСРасширением = Наименование + "." + Расширение;
		ВыбранноеПолноеИмяФайла = ПапкаДляЭкспорта + ИмяФайлаСРасширением;
		
		ПредлагаемоеПолноеИмяФайла = "";
		Файл = Новый Файл(ВыбранноеПолноеИмяФайла);
		Если Файл.Существует() Тогда
			ЕстьПредупреждения = Истина;
			
			Счетчик = НайтиВМассивеСчетчиков(ИмяФайлаСРасширением, СписокСчетчиковИменФайлов);
			Пока Файл.Существует() Цикл
				
				ПредлагаемоеИмяФайла = Наименование;
				ПредлагаемоеИмяФайла = 
					ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(
					ПредлагаемоеИмяФайла + " (" + Строка(Счетчик) + ")", Расширение); 
				ПредлагаемоеПолноеИмяФайла = ПапкаДляЭкспорта + ПредлагаемоеИмяФайла;
				
				Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);
				Счетчик = Счетчик + 1;
				
			КонецЦикла;
			ДобавитьВМассивСчетчиков(ИмяФайлаСРасширением, Счетчик, СписокСчетчиковИменФайлов);
			
			СтрокаПредупреждения = СтрокаПредупреждения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файл с именем ""%1"" уже существует в указанной папке. Можно сохранить с именем ""%2"".'") + Символы.ПС,
				ИмяФайлаСРасширением,
				ПредлагаемоеИмяФайла);
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файл с именем ""%1"" уже существует в указанной папке.'"),
				ИмяФайлаСРасширением);
			
			ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
				"СписокФайловДляВыбора", 
				ДанныеСтроки.ПолучитьИдентификатор(),
				"ИмяФайлаДляСохранения");
			
			ОписаниеОшибки = Новый Структура;
			ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
			ОписаниеОшибки.Вставить("ЭлементФормы", ПутьКТабличнойЧасти);
			
			МассивПредупреждений.Добавить(ОписаниеОшибки);
		КонецЕсли;
		
		Если СписокИменФайлов.НайтиПоЗначению(ИмяФайлаСРасширением) = Неопределено
			Или (ЗначениеЗаполнено(ПредлагаемоеПолноеИмяФайла)
			И СписокИменФайлов.НайтиПоЗначению(ПредлагаемоеПолноеИмяФайла) = Неопределено) Тогда
			
			СписокИменФайлов.Добавить(ИмяФайлаСРасширением);
			
		Иначе
			ЕстьПредупреждения = Истина;
			
			Счетчик = НайтиВМассивеСчетчиков(ИмяФайлаСРасширением, СписокСчетчиковИменФайлов);
			ПредлагаемоеИмяФайла = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(
				Наименование + " (" + Строка(Счетчик) + ")", Расширение);
			ПредлагаемоеПолноеИмяФайла = ПапкаДляЭкспорта + ПредлагаемоеИмяФайла;
			
			Счетчик = Счетчик + 1;
			Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);
			Пока Файл.Существует() Цикл
				ПредлагаемоеИмяФайла = ФайловыеФункцииКлиентСервер.ПолучитьИмяСРасширением(
					Наименование + " (" + Строка(Счетчик) + ")", Расширение); 
				ПредлагаемоеПолноеИмяФайла = ПапкаДляЭкспорта + ПредлагаемоеИмяФайла;
				
				Файл = Новый Файл(ПредлагаемоеПолноеИмяФайла);						
				Счетчик = Счетчик + 1;
			КонецЦикла;
			ДобавитьВМассивСчетчиков(ИмяФайлаСРасширением, Счетчик, СписокСчетчиковИменФайлов);
			
			СтрокаПредупреждения = СтрокаПредупреждения + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файл с именем ""%1"" уже указан. Можно сохранить с именем ""%2""'") + Символы.ПС,
				ИмяФайлаСРасширением,
				ПредлагаемоеИмяФайла);
			
			ТекстОшибки = НСтр("ru = 'Файл с таким именем уже указан.'");		
			
			ПутьКТабличнойЧасти = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
				"СписокФайловДляВыбора", 
				ДанныеСтроки.ПолучитьИдентификатор(),
				"ИмяФайлаДляСохранения");
			
			ОписаниеОшибки = Новый Структура;
			ОписаниеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
			ОписаниеОшибки.Вставить("ЭлементФормы", ПутьКТабличнойЧасти);
			
			МассивПредупреждений.Добавить(ОписаниеОшибки);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстВариантаСохранитьСНовымИменем = НСтр("ru = 'Сохранить с предложенными именами'");		
	ТекстВариантаУточнить = НСтр("ru = 'Уточнить вариант для каждого файла'");
	ТекстВариантаОтмена = НСтр("ru = 'Скорректировать имена вручную'");

	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ТекстВариантаСохранитьСНовымИменем", ТекстВариантаСохранитьСНовымИменем);
	ПараметрыОповещения.Вставить("ТекстВариантаУточнить", ТекстВариантаУточнить);
	ПараметрыОповещения.Вставить("ТекстВариантаОтмена", ТекстВариантаОтмена);
	ПараметрыОповещения.Вставить("МассивСтрокФайлов", МассивСтрокФайлов);
	ПараметрыОповещения.Вставить("МассивПредупреждений", МассивПредупреждений);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СохранитьПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);

	Если ЕстьПредупреждения Тогда
		ТекстВопроса = СтрокаПредупреждения + НСтр("ru = 'Выберите вариант сохранения для указанных файлов:'");
							
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(ТекстВариантаСохранитьСНовымИменем);
		Кнопки.Добавить(ТекстВариантаУточнить);
		Кнопки.Добавить(ТекстВариантаОтмена);

		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Возврат;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(ОписаниеОповещения); 

КонецПроцедуры

&НаКлиенте
Процедура СохранитьПродолжение(КодВозврата, Параметры) Экспорт 
	
	СохранитьСНовымИменем = Ложь;

	Если КодВозврата = Параметры.ТекстВариантаСохранитьСНовымИменем Тогда 
		СохранитьСНовымИменем = Истина;	
	ИначеЕсли КодВозврата = Параметры.ТекстВариантаОтмена Тогда
		Для Каждого ОписаниеПредупреждения Из Параметры.МассивПредупреждений Цикл
			ТекстОшибки = ОписаниеПредупреждения.ТекстОшибки;
			ЭлементФормы = ОписаниеПредупреждения.ЭлементФормы;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,ЭлементФормы);
		КонецЦикла;
		Возврат;
	КонецЕсли;

	МассивСтрокФайлов = Параметры.МассивСтрокФайлов;
	
	СписокФайлов = Новый СписокЗначений;
	Для Каждого ДанныеСтроки Из МассивСтрокФайлов Цикл
		СписокФайлов.Добавить(ДанныеСтроки.Файл);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СохранитьЗавершение",
		ЭтотОбъект);
	
	Если МассивСтрокФайлов.Количество() > 0 Тогда
		ДанныеСохраняемыхФайлов = ПолучитьДанныеФайловДляСохраненияФайлов(СписокФайлов, УникальныйИдентификатор);
		ДанныеСохраняемыхФайлов = ОтобратьДанныеФайловДляСохранения(ДанныеСохраняемыхФайлов, МассивСтрокФайлов, ПапкаДляЭкспорта);
		РаботаСФайламиКлиент.СохранитьФайлы(ОписаниеОповещения, ДанныеСохраняемыхФайлов, 
			УникальныйИдентификатор, , Истина, СохранитьСНовымИменем);
		Возврат;	
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЗавершение(КодВозврата, Параметры) Экспорт 
	
	Закрыть();
	
КонецПроцедуры
	

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	Для Каждого Строка1 Из СписокФайловДляВыбора.ПолучитьЭлементы() Цикл
		Строка1.Выгружать = Истина;
		Для Каждого Строка2 Из Строка1.ПолучитьЭлементы() Цикл
			Строка2.Выгружать = Истина;
		КонецЦикла;	
	КонецЦикла;
	
	КоличествоВыбранныхФайлов = ПолучитьКоличествоВыбранныхФайлов(СписокФайловДляВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	
	Для Каждого Строка1 Из СписокФайловДляВыбора.ПолучитьЭлементы() Цикл
		Строка1.Выгружать = Ложь;
		Для Каждого Строка2 Из Строка1.ПолучитьЭлементы() Цикл
			Строка2.Выгружать = Ложь;
		КонецЦикла;	
	КонецЦикла;
	
	КоличествоВыбранныхФайлов = ПолучитьКоличествоВыбранныхФайлов(СписокФайловДляВыбора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьСписокФайлов()
	
	ВладельцыФайлов = Новый Массив;
	Для Каждого Строка Из СписокВладельцев Цикл
		ВладельцыФайлов.Добавить(Строка.Значение);
	КонецЦикла;
	
	Если ВключатьСвязанныеДокументы Тогда 
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СвязиДокументов.СвязанныйДокумент,
		|	СвязиДокументов.Комментарий,
		|	СвязиДокументов.Установил,
		|	СвязиДокументов.ДатаУстановки
		|ИЗ
		|	РегистрСведений.СвязиДокументов КАК СвязиДокументов
		|ГДЕ
		|	СвязиДокументов.Документ В(&Документы)";
		Запрос.УстановитьПараметр("Документы", ВладельцыФайлов);
		
		Если ТипыСвязей.Количество() > 0 Тогда 
			Запрос.Текст = Запрос.Текст + " И СвязиДокументов.ТипСвязи В (&ТипыСвязей) ";
			Запрос.УстановитьПараметр("ТипыСвязей", ТипыСвязей.ВыгрузитьЗначения());
		КонецЕсли;	
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ВладельцыФайлов.Добавить(Выборка.СвязанныйДокумент);
		КонецЦикла;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.ТекущаяВерсия,
	|	Файлы.ПолноеНаименование КАК ПолноеНаименование,
	|	Файлы.ПолноеНаименование КАК ИмяФайлаДляСохранения,
	|	Файлы.ТекущаяВерсия.Расширение КАК Расширение,
	|	Файлы.ТекущаяВерсия.Размер КАК Размер,
	|	Файлы.ТекущаяВерсия.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
	|	Файлы.Ссылка КАК Файл,
	|	Файлы.ПометкаУдаления,
	|	Файлы.Зашифрован,
	|	Файлы.ВладелецФайла КАК ВладелецФайла,
	|	ТИПЗНАЧЕНИЯ(Файлы.ВладелецФайла) КАК ТипВладельца,
	|	Файлы.ИндексКартинки,
	|	ISNULL(СведенияОФайлах.ЯвляетсяОригиналом, ЛОЖЬ) КАК ЯвляетсяОригиналом,
	|	ЛОЖЬ КАК ЭтоРодитель,
	|	ИСТИНА КАК Выгружать
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОФайлах КАК СведенияОФайлах
	|		ПО (СведенияОФайлах.Файл = Файлы.Ссылка)
	|ГДЕ
	|	Файлы.ВладелецФайла В(&ВладельцыФайлов)
	|	И Файлы.ТекущаяВерсия <> ЗНАЧЕНИЕ(Справочник.ВерсииФайлов.ПустаяСсылка)
	|	И НЕ Файлы.ПометкаУдаления";
	
	Если ТолькоОригиналы И ПолучитьФункциональнуюОпцию("ВестиУчетСканКопийОригиналовДокументов") Тогда 
		Запрос.Текст = Запрос.Текст + " И СведенияОФайлах.ЯвляетсяОригиналом = ИСТИНА ";
	КонецЕсли;
	Запрос.Текст = Запрос.Текст + " ИТОГИ ПО ВладелецФайла ";
	
	Запрос.Параметры.Вставить("ВладельцыФайлов", ВладельцыФайлов);
	
	ДеревоФайлов = РеквизитФормыВЗначение("СписокФайловДляВыбора");
	ДеревоФайлов.Строки.Очистить();
	
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИтоги.Следующий() цикл
		СтрокаРодитель = ДеревоФайлов.Строки.Добавить();
		СтрокаРодитель.ИндексКартинки = -1;
		СтрокаРодитель.ПолноеНаименование = Строка(ВыборкаИтоги.ВладелецФайла);
		СтрокаРодитель.ВладелецФайла = ВыборкаИтоги.ВладелецФайла;
		СтрокаРодитель.ЭтоРодитель = Истина;
		СтрокаРодитель.Выгружать = Истина;
		
		ВыборкаДетали = ВыборкаИтоги.Выбрать();
		Пока ВыборкаДетали.Следующий() Цикл
			НоваяСтрока = СтрокаРодитель.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетали);
			
			РазмерФайла = ФайловыеФункцииКлиентСервер.ПолучитьСтрокуСРазмеромФайлаДляКарточкиПапки(НоваяСтрока.Размер);
			Если ЗначениеЗаполнено(РазмерФайла) Тогда 
				НоваяСтрока.ПолноеНаименование = НоваяСтрока.ПолноеНаименование + ", " + РазмерФайла;
			КонецЕсли;	
			
			СтруктураКлюча = Новый Структура("ВерсияФайла", НоваяСтрока.ТекущаяВерсия);
			КлючЗаписи = РегистрыСведений.ХранимыеФайлыВерсий.СоздатьКлючЗаписи(СтруктураКлюча);
			НавигационнаяСсылкаТекущейВерсии = ПолучитьНавигационнуюСсылку(КлючЗаписи, "ХранимыйФайл");
			НоваяСтрока.Адрес = НавигационнаяСсылкаТекущейВерсии;
		КонецЦикла;	
	КонецЦикла;	
	
	ЗначениеВРеквизитФормы(ДеревоФайлов, "СписокФайловДляВыбора");
	
	КоличествоВыбранныхФайлов = ПолучитьКоличествоВыбранныхФайлов(СписокФайловДляВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьСписокФайлов()
	
	Для Каждого Элемент Из СписокФайловДляВыбора.ПолучитьЭлементы() Цикл
		Элементы.СписокФайловДляВыбора.Развернуть(Элемент.получитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКоличествоВыбранныхФайлов(Дерево)
	
	КоличествоВыбранныхФайлов = 0;
	
	Для Каждого Строка1 Из Дерево.ПолучитьЭлементы() Цикл
		Для Каждого Строка2 Из Строка1.ПолучитьЭлементы() Цикл
			Если Строка2.Выгружать Тогда
				КоличествоВыбранныхФайлов = КоличествоВыбранныхФайлов + 1;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
	
	Возврат КоличествоВыбранныхФайлов;
	
КонецФункции

&НаСервере
Функция ЭлементыДляСохранения()
	
	СохраняемыеЭлементы = Новый Структура;
	СохраняемыеЭлементы.Вставить("ПапкаДляЭкспорта", ПапкаДляЭкспорта);
	
	Возврат СохранениеВводимыхЗначений.СформироватьТаблицуСохраняемыхЭлементов(СохраняемыеЭлементы);
	
КонецФункции

&НаКлиенте
Функция НайтиВМассивеСчетчиков(ИскомоеЗначение, МассивСчетчиков)
	
	Для Каждого ЭлементМассива Из МассивСчетчиков Цикл
		Если ЭлементМассива.Значение = ИскомоеЗначение Тогда
			Возврат ЭлементМассива.Счетчик; 
		КонецЕсли;
	КонецЦикла;
	
	Возврат 1;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьВМассивСчетчиков(Значение, Счетчик, МассивСчетчиков)

	Для Каждого ЭлементМассива Из МассивСчетчиков Цикл
		Если ЭлементМассива.Значение = Значение Тогда
			ЭлементМассива.Счетчик = Счетчик;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Структура = Новый Структура;
	Структура.Вставить("Значение", Значение);
	Структура.Вставить("Счетчик", Счетчик);
	
	МассивСчетчиков.Добавить(Структура);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеФайловДляСохраненияФайлов(СписокФайлов, УникальныйИдентификатор)
	
	СписокДанныхФайлов = Новый СписокЗначений;
	
	ОбщийРазмер = 0;
	Для Каждого Файл Из СписокФайлов Цикл
		ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляСохранения(
			Файл.Значение,
			Неопределено,
			УникальныйИдентификатор);
		
		СписокДанныхФайлов.Добавить(ДанныеФайла);
		ОбщийРазмер = ОбщийРазмер + ДанныеФайла.Размер;
	КонецЦикла;		
	
	ДанныеСохраняемыхФайлов = Новый Структура;
	ДанныеСохраняемыхФайлов.Вставить("СписокДанныхФайлов", СписокДанныхФайлов);
	ДанныеСохраняемыхФайлов.Вставить("СписокФайлов", СписокФайлов);
	ДанныеСохраняемыхФайлов.Вставить("ПутьВыбора", "");
	ДанныеСохраняемыхФайлов.Вставить("КоличествоФайлов", СписокФайлов.Количество());
	ДанныеСохраняемыхФайлов.Вставить("ОбщийРазмер", ОбщийРазмер);
	
	Возврат ДанныеСохраняемыхФайлов;
	
КонецФункции

&НаКлиенте
Функция ОтобратьДанныеФайловДляСохранения(ДанныеСохраняемыхФайлов, МассивСтрокФайлов, ПутьВыбора)
	
	СписокДанныхФайлов = Новый СписокЗначений;
	ОбщийРазмер = 0;
	
	Для Каждого СтрокаФайл Из ДанныеСохраняемыхФайлов.СписокДанныхФайлов Цикл
		
		ДанныеФайла = СтрокаФайл.Значение;
		
		ФайлВСписке = Неопределено;
		Для Каждого ДанныеСтроки Из МассивСтрокФайлов Цикл
			Если ДанныеСтроки.Файл = ДанныеФайла.Ссылка Тогда 
				ФайлВСписке = ДанныеСтроки;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
		
		Если ФайлВСписке <> Неопределено Тогда
			Наименование = ФайлВСписке.ИмяФайлаДляСохранения;
			Расширение = ФайлВСписке.Расширение;
				
			ДанныеФайла.ПолноеНаименованиеВерсии = Наименование; 
			ДанныеФайла.Расширение = Расширение;
				
			СписокДанныхФайлов.Добавить(ДанныеФайла);
			ОбщийРазмер = ОбщийРазмер + ДанныеФайла.Размер;
		КонецЕсли;
			
	КонецЦикла;
	
	СписокФайлов = Новый СписокЗначений;
	Для Каждого ДанныеСтроки Из МассивСтрокФайлов Цикл
		СписокФайлов.Добавить(ДанныеСтроки.Файл);
	КонецЦикла;
	
	ДанныеСохраняемыхФайлов = Новый Структура;
	ДанныеСохраняемыхФайлов.Вставить("СписокДанныхФайлов", СписокДанныхФайлов);
	ДанныеСохраняемыхФайлов.Вставить("СписокФайлов", СписокФайлов);
	ДанныеСохраняемыхФайлов.Вставить("ПутьВыбора", ПутьВыбора);
	ДанныеСохраняемыхФайлов.Вставить("КоличествоФайлов", СписокФайлов.Количество());
	ДанныеСохраняемыхФайлов.Вставить("ОбщийРазмер", ОбщийРазмер);
	
	Возврат ДанныеСохраняемыхФайлов;
	
КонецФункции

