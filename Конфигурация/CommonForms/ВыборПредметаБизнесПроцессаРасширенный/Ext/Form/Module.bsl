﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("БизнесПроцесс", БизнесПроцесс);
	Параметры.Свойство("Предмет", Предмет);
	Параметры.Свойство("ИменаПредметов", ИменаПредметов);
	Параметры.Свойство("ИмяПредмета", ИмяПредмета);
	Параметры.Свойство("РольПредмета", РольПредмета);
	Параметры.Свойство("ИдентификаторПроцесса", ИдентификаторПроцесса);
	Параметры.Свойство("Проект", Проект);
	Параметры.Свойство("ПроектнаяЗадача", ПроектнаяЗадача);
		
	Если (РольПредмета = Перечисления.РолиПредметов.Заполняемый И ЗначениеЗаполнено(БизнесПроцесс) 
	   И ЗначениеЗаполнено(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БизнесПроцесс, "ВедущаяЗадача")))
	   Или МультипредметностьКлиентСервер.ЭтоКомплексныйПроцесс(БизнесПроцесс) 
	   Или МультипредметностьКлиентСервер.ЭтоПроцессОбработкиДокументов(БизнесПроцесс)
	   ИЛИ МультипредметностьКлиентСервер.ЭтоПроцессРассмотрения(БизнесПроцесс) Тогда
	   ВыборФайлаСДиска = Ложь;
	Иначе
		ВыборФайлаСДиска = Истина;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ИсходныеПредметы") Тогда
		ИсходныеПредметы.Загрузить(Мультипредметность.ПолучитьПредметыПроцесса(БизнесПроцесс));
	Иначе
		ИсходныеПредметы.Загрузить(Параметры.ИсходныеПредметы.Выгрузить());
	КонецЕсли;
	
	УстановитьТипыПредмета();
	ПостроитьДеревоВариантов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭлементыДерева = ДеревоВариантов.ПолучитьЭлементы();
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Развернуть = Ложь;
		Если СтруктураРазвернутости <> Неопределено Тогда
			СтруктураРазвернутости.Свойство(ЭлементДерева.КомандаСсылка, Развернуть);
		Иначе
			Развернуть = Истина;
		КонецЕсли;
		Если Развернуть = Истина Или Развернуть = Неопределено Тогда
			Элементы.ДеревоВариантов.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Ложь);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("СтруктураРазвернутости", СтруктураРазвернутости);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураРазвернутости = Настройки.Получить("СтруктураРазвернутости");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" 
	   И Параметр.ИдентификаторРодительскойФормы = УникальныйИдентификатор 
	   И ЗначениеЗаполнено(Параметр.Файл) Тогда
		УстановитьПредмет(Параметр.Файл);
	ИначеЕсли ИмяСобытия = "ИмпортФайловЗавершен" Тогда 
		Если ТипЗнч(Источник) = Тип("Структура") Тогда
			Если Источник.СвойСтво("ВладелецФайлов") И Источник.ВладелецФайлов = БизнесПроцесс Тогда
				Если Источник.Свойство("МассивСсылокФайлов") Тогда
					УстановитьНесколькоПредметов(Источник.МассивСсылокФайлов);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Процесс_ЗаписанВладелецФайла" И Параметр = УникальныйИдентификатор Тогда
		БизнесПроцесс = Источник;
		НеОткрыватьФормуВыбораРежимаСозданияФайла = Истина;
		РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, БизнесПроцесс, 
			ЭтаФорма, 2, Истина,,,,,НеОткрыватьФормуВыбораРежимаСозданияФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)

	УстановитьПредмет(ВыбранноеЗначение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ "ДЕРЕВО ВАРИАТНОВ"

&НаКлиенте
Процедура ДеревоВариантовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ВыбратьПредметКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовПередРазворачиванием(Элемент, Строка, Отказ)
	
	СохранитьПараметрыРазвернутости(Строка, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовПередСворачиванием(Элемент, Строка, Отказ)
	
	СохранитьПараметрыРазвернутости(Строка, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовПриАктивизацииСтроки(Элемент)
	
	Элементы.ДеревоВариантовКонтекстноеМенюОткрытьКарточку.Доступность =
		(ТипЗнч(Элементы.ДеревоВариантов.ТекущиеДанные.КомандаСсылка) <> Тип("Строка"));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьПредмет(Команда)
	
	ВыбратьПредметКлиент();

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ПоказатьЗначение(, Элементы.ДеревоВариантов.ТекущиеДанные.КомандаСсылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыбратьПредметКлиент()
	
	ТекущиеДанные = Элементы.ДеревоВариантов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено 
		ИЛИ ТекущиеДанные.ЭтоЗаголовок Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.КомандаСсылка) = Тип("Строка") Тогда
		Если ТекущиеДанные.КомандаСсылка = "ФайлСДиска" Тогда
			Если Не ЗначениеЗаполнено(БизнесПроцесс) Тогда
				Оповестить("Процесс_ТребуетсяЗаписьВладельцаФайла",ИдентификаторПроцесса ,УникальныйИдентификатор)
			Иначе
				НеОткрыватьФормуВыбораРежимаСозданияФайла = Истина;
				РаботаСФайламиКлиент.ДобавитьФайл(Неопределено, БизнесПроцесс, ЭтаФорма, 2, 
					Истина,,,,УникальныйИдентификатор, НеОткрыватьФормуВыбораРежимаСозданияФайла);
			КонецЕсли;
		Иначе
			ПараметрыФормы = Новый Структура;
			ИмяФормыВыбора = ТекущиеДанные.КомандаСсылка + ".ФормаВыбора";
			
			Если ТекущиеДанные.КомандаСсылка = "Справочник.Файлы" Тогда
				ИмяФормыВыбора = "Справочник.Файлы.Форма.ФормаВыбораФайлаВПапках";
			ИначеЕсли ТекущиеДанные.КомандаСсылка = "Справочник.ПроектныеЗадачи" Тогда	
				Если ЗначениеЗаполнено(Проект) Или ЗначениеЗаполнено(ПроектнаяЗадача) Тогда 
					ПараметрыФормы.Вставить("Проект", Проект);
					ПараметрыФормы.Вставить("ПроектнаяЗадача", ПроектнаяЗадача);
				КонецЕсли;
				
				ПараметрыФормы.Вставить("ВыбиратьТолькоПроектнуюЗадачу", Истина);
				ИмяФормыВыбора = "ОбщаяФорма.ВыборПроектаЗадачи";
				
			ИначеЕсли ТекущиеДанные.КомандаСсылка = "Справочник.УведомленияПрограммы" Тогда
				
				ПараметрыФормы.Вставить("РежимВыбора", Истина);
				
			ИначеЕсли ТекущиеДанные.КомандаСсылка = "Справочник.ПротоколыМероприятий" Тогда
				
				ПараметрыФормы.Вставить("РежимВыбора", Истина);
				
			ИначеЕсли ТекущиеДанные.КомандаСсылка = "Документ.Бронь" Тогда
				
				ПараметрыФормы.Вставить("РежимВыбора", Истина);
				
			КонецЕсли;
			
			ОткрытьФорму(ИмяФормыВыбора, ПараметрыФормы, ЭтаФорма);
		КонецЕсли;
	Иначе
		УстановитьПредмет(ТекущиеДанные.КомандаСсылка);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьТипыПредмета()
	
	Если ЗначениеЗаполнено(РольПредмета) И Предмет = Неопределено Тогда
		ТипыПредмета = МультипредметностьВызовСервера.ПолучитьСписокТиповПредметовПроцесса(БизнесПроцесс, РольПредмета);
		Возврат;
	КонецЕсли;
	
	Если Предмет <> Неопределено Тогда
		МетаданныеПредмета = Предмет.Метаданные();
	КонецЕсли;
	
	ЗаполнятьДоступныеТипы = Истина;
	СтрокиТекущегоВида = ИсходныеПредметы.НайтиСтроки(Новый Структура("ИмяПредмета",ИмяПредмета));
	Если СтрокиТекущегоВида.Количество() > 0 Тогда
		Если ЗначениеЗаполнено(СтрокиТекущегоВида[0].ШаблонОснование) Тогда
			ШаблонДокумента = СтрокиТекущегоВида[0].ШаблонОснование;
		КонецЕсли;
		СтрокиОснования = ИсходныеПредметы.НайтиСтроки(Новый Структура("ИмяПредмета",СтрокиТекущегоВида[0].ИмяПредметаОснование));
		Если СтрокиОснования.Количество() > 0 Тогда
			ПредметОснование = СтрокиОснования[0].Предмет;
		КонецЕсли;
		Если СтрокиТекущегоВида[0].Предмет <> Неопределено Тогда
			ЗаполнятьДоступныеТипы = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаполнятьДоступныеТипы Тогда
		СписокМетаданных = ПолучитьСписокМетаданных(БизнесПроцесс);
	Иначе
		СписокМетаданных = Новый Массив;
		СписокМетаданных.Добавить(СтрокиТекущегоВида[0].Предмет.Метаданные());
	КонецЕсли;
	
	Для каждого ЭлементМетаданных Из СписокМетаданных Цикл
		Если ПравоДоступа("Чтение", ЭлементМетаданных) Тогда
			ПредставлениеОбъекта = ЭлементМетаданных.ПредставлениеОбъекта;
			Если ПустаяСтрока(ПредставлениеОбъекта) Тогда
				ПредставлениеОбъекта = Строка(ЭлементМетаданных);
			КонецЕсли;
			ТипыПредмета.Добавить(ЭлементМетаданных.ПолноеИмя(), ПредставлениеОбъекта);
		КонецЕсли;
	КонецЦикла;
	
	ТипыПредмета.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьДеревоВариантов()
	
	Дерево = РеквизитФормыВЗначение("ДеревоВариантов");
	Дерево.Строки.Очистить();
	
	ПолучитьСвязанныеПредметы(Дерево);
	ПолучитьНедавниеПредметы(Дерево);
	ПолучитьДругиеПредметы(Дерево);
	
	ЗначениеВДанныеФормы(Дерево, ДеревоВариантов);

КонецПроцедуры

&НаСервере
Процедура ПолучитьСвязанныеПредметы(Дерево)
	
	ОсновныеПредметы = ИсходныеПредметы.НайтиСтроки(Новый Структура("РольПредмета", Перечисления.РолиПредметов.Основной));
	Если ОсновныеПредметы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПредметыСвязей = Новый Массив;
	Для Каждого СтрокаПредмета Из ОсновныеПредметы Цикл
		ПредметыСвязей.Добавить(СтрокаПредмета.Предмет);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Объекты.СвязанныйДокумент
	|ИЗ
	|	(ВЫБРАТЬ
	|		РегистрСведенийСвязиДокументов.Документ КАК Документ,
	|		ВЫБОР
	|			КОГДА РегистрСведенийСвязиДокументов.СвязаннаяСтрока <> """"
	|				ТОГДА РегистрСведенийСвязиДокументов.СвязаннаяСтрока
	|			ИНАЧЕ РегистрСведенийСвязиДокументов.СвязанныйДокумент
	|		КОНЕЦ КАК СвязанныйДокумент
	|	ИЗ
	|		РегистрСведений.СвязиДокументов КАК РегистрСведенийСвязиДокументов
	|	ГДЕ
	|		ТИПЗНАЧЕНИЯ(РегистрСведенийСвязиДокументов.СвязанныйДокумент) В (&ТипыПредметов)
	|		И РегистрСведенийСвязиДокументов.Документ В(&ПредметыСвязей)) КАК Объекты
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	ТипыПредметов = Новый Массив;
	Для Каждого Элемент Из ТипыПредмета Цикл
		ИмяТипа = СтрЗаменить(СтрЗаменить(Элемент.Значение,"Справочник.","СправочникСсылка."),"Документ.","ДокументСсылка.");
		ТипыПредметов.Добавить(Тип(ИмяТипа));
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ПредметыСвязей", ПредметыСвязей);
	Запрос.УстановитьПараметр("ТипыПредметов", ТипыПредметов); 
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	СтрокаЗаголовка = Дерево.Строки.Добавить();
	СтрокаЗаголовка.КомандаСсылка = "Связанные";
	СтрокаЗаголовка.ЭтоЗаголовок = Истина;
	Количество = 0;
	
	Пока Выборка.Следующий() Цикл
		Если ПравоДоступа("Чтение", Выборка.СвязанныйДокумент.Метаданные()) Тогда
			СтрокаПредмета = СтрокаЗаголовка.Строки.Добавить();
			СтрокаПредмета.Наименование = ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(Выборка.СвязанныйДокумент);
			СтрокаПредмета.КомандаСсылка = Выборка.СвязанныйДокумент;
			Количество = Количество + 1;
		КонецЕсли;
	КонецЦикла;
	
	СтрокаЗаголовка.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Связанные (%1)'"), Количество);
	
	Если Количество = 0 Тогда
		Дерево.Строки.Удалить(СтрокаЗаголовка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНедавниеПредметы(Дерево)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 10
		|	РегистрСведенийОбращенияКОбъектам.Объект,
		|	РегистрСведенийОбращенияКОбъектам.ДатаПоследнегоОбращения КАК ДатаПоследнегоОбращения
		|ПОМЕСТИТЬ ПоследниеОбращения
		|ИЗ
		|	РегистрСведений.ОбращенияКОбъектам КАК РегистрСведенийОбращенияКОбъектам
		|ГДЕ
		|	РегистрСведенийОбращенияКОбъектам.Пользователь = &ТекущийПользователь
		|	И ТИПЗНАЧЕНИЯ(РегистрСведенийОбращенияКОбъектам.Объект) В (&ТипыПредметов)
		|	И РегистрСведенийОбращенияКОбъектам.Объект.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПоследнегоОбращения УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПоследниеОбращения.Объект,
		|	ПоследниеОбращения.ДатаПоследнегоОбращения
		|ИЗ
		|	ПоследниеОбращения КАК ПоследниеОбращения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Файлы КАК Файлы
		|		ПО ПоследниеОбращения.Объект = Файлы.Ссылка
		|ГДЕ
		|	(&ОтображатьФайлы
		|				И НЕ ТИПЗНАЧЕНИЯ(Файлы.ВладелецФайла) В (&ТипыБизнесПроцессов)
		|			ИЛИ ТИПЗНАЧЕНИЯ(ПоследниеОбращения.Объект) <> ТИП(Справочник.Файлы))";
		
	ТипыПредметов = Новый Массив;
	Для Каждого Элемент Из ТипыПредмета Цикл
		ИмяТипа = СтрЗаменить(СтрЗаменить(Элемент.Значение,"Справочник.","СправочникСсылка."),"Документ.","ДокументСсылка.");
		ТипыПредметов.Добавить(Тип(ИмяТипа));
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТипыПредметов", ТипыПредметов);
	
	ТипыБизнесПроцессов = Новый Массив;
	Для Каждого БизнесПроцессОбъектМетаданных ИЗ Метаданные.БизнесПроцессы Цикл
		ПолноеИмя = БизнесПроцессОбъектМетаданных.ПолноеИмя();
		ИмяТипаПроцесса = СтрЗаменить(ПолноеИмя, "БизнесПроцесс", "БизнесПроцессСсылка");
		ТипыБизнесПроцессов.Добавить(Тип(ИмяТипаПроцесса));
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТипыБизнесПроцессов", ТипыБизнесПроцессов);
	
	Запрос.УстановитьПараметр("ОтображатьФайлы", Не Параметры.НеОтображатьФайлы);
	
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	СтрокаЗаголовка = Дерево.Строки.Добавить();
	СтрокаЗаголовка.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Недавние (%1)'"), Выборка.Количество());
	СтрокаЗаголовка.КомандаСсылка = "Недавние";
	СтрокаЗаголовка.ЭтоЗаголовок = Истина;
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаПредмета = СтрокаЗаголовка.Строки.Добавить();
		СтрокаПредмета.Наименование = ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(Выборка.Объект);
		СтрокаПредмета.КомандаСсылка = Выборка.Объект;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПолучитьДругиеПредметы(Дерево)
	
	КоличествоТипов = ТипыПредмета.Количество();
	
	СтрокаЗаголовка = Дерево.Строки.Добавить();
	СтрокаЗаголовка.КомандаСсылка = "Другие";
	СтрокаЗаголовка.ЭтоЗаголовок = Истина;
	
	Для Каждого Строка Из ТипыПредмета Цикл
		
		Если Параметры.НеОтображатьФайлы И Строка.Значение = "Справочник.Файлы" Тогда
			КоличествоТипов = КоличествоТипов - 1;
			Продолжить;
		КонецЕсли;
		
		СтрокаПредмета = СтрокаЗаголовка.Строки.Добавить();
		СтрокаПредмета.Наименование = Строка.Представление;
		СтрокаПредмета.КомандаСсылка = Строка.Значение;
	КонецЦикла;
	
	// Возможность добавить файл с диска
	Если Не Параметры.НеОтображатьФайлы
		И ТипыПредмета.НайтиПоЗначению("Справочник.Файлы") <> Неопределено
		И ВыборФайлаСДиска Тогда
		
		СтрокаПредмета = СтрокаЗаголовка.Строки.Добавить();
		СтрокаПредмета.Наименование = НСтр("ru='Файл с диска'");
		СтрокаПредмета.КомандаСсылка = "ФайлСДиска";
		КоличествоТипов = КоличествоТипов + 1;
	КонецЕсли;
	
	СтрокаЗаголовка.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Другие (%1)'"), КоличествоТипов);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПараметрыРазвернутости(Строка, Развернуть)
	
	Если СтруктураРазвернутости = Неопределено Тогда
		СтруктураРазвернутости = Новый Структура;
	КонецЕсли;
	
	СтрокаДерева = ДеревоВариантов.НайтиПоИдентификатору(Строка);
	
	СтруктураРазвернутости.Вставить(СтрокаДерева.КомандаСсылка,Развернуть);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредмет(НовыйПредмет)
	
	Предмет = НовыйПредмет;
	НовоеИмяПредмета = ?(ЗначениеЗаполнено(ИмяПредмета),ИмяПредмета, 
			МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(Предмет, ИменаПредметов));
			
	ПараметрыРезультата = Новый Структура;
	ПараметрыРезультата.Вставить("РольПредмета", РольПредмета);
	ПараметрыРезультата.Вставить("Предмет", Предмет);
	ПараметрыРезультата.Вставить("ИмяПредмета", НовоеИмяПредмета);
	
	ОповещениеОЗакрытииФормыВопроса = Новый ОписаниеОповещения(
		"УстановитьПредметЗавершение", ЭтотОбъект, ПараметрыРезультата);
	
	Если ЗначениеЗаполнено(Предмет) Тогда
		
		Если РаботаСРабочимиГруппами.ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы(Предмет) Тогда
			
			СписокКнопок = Новый СписокЗначений;
			СписокКнопок.Добавить(Истина, НСтр("ru = 'Добавить'"));
			СписокКнопок.Добавить(Ложь, НСтр("ru = 'Отмена'"));
			
			ТекстВопроса = НСтр("ru = 'Внимание!
				|%1""%2"" станет доступен всем участникам этого процесса.
				|Добавить%3?'");
			
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса,
				?(ЗначениеЗаполнено(НовоеИмяПредмета), Строка(НовоеИмяПредмета) + " ", ""),
				Предмет,
				?(ЗначениеЗаполнено(НовоеИмяПредмета), НРег(" " + НовоеИмяПредмета), ""));
				
			ПоказатьВопрос(ОповещениеОЗакрытииФормыВопроса, ТекстВопроса, СписокКнопок);
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытииФормыВопроса, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредметЗавершение(УстановитьПредмет, ПараметрыРезультата) Экспорт
	
	Если НЕ УстановитьПредмет Тогда
		Возврат;
	КонецЕсли;
	
	Описание = ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(
		ПараметрыРезультата.Предмет, ПараметрыРезультата.ИмяПредмета);
	
	Результат = Новый Структура;
	Результат.Вставить("РольПредмета", ПараметрыРезультата.РольПредмета);
	Результат.Вставить("Предмет", ПараметрыРезультата.Предмет);
	Результат.Вставить("ИмяПредмета", ПараметрыРезультата.ИмяПредмета);
	Результат.Вставить("Описание", Описание);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте 
Процедура УстановитьНесколькоПредметов(МассивПредметов)
	
	Результат = НовыйМассивСтруктурПредметов(МассивПредметов);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокМетаданных(БизнесПроцесс)
	
	Результат = Новый Массив;
	Типы = БизнесПроцесс.Метаданные().ТабличныеЧасти.Предметы.Реквизиты.Предмет.Тип.Типы();
	Для каждого Тип Из Типы Цикл
		ПредметСсылка = Новый(Тип);
		Результат.Добавить(ПредметСсылка.Метаданные());
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция НовыйМассивСтруктурПредметов(МассивПредметов)
	
	МассивСтруктур = Новый Массив;
	
	ПервоеИмяИспользовано = Ложь;
	
	Для Каждого НовыйПредмет Из МассивПредметов Цикл
		
		Если Не ПервоеИмяИспользовано И ЗначениеЗаполнено(ИмяПредмета) Тогда
			НовоеИмяПредмета = ИмяПредмета;
			ПервоеИмяИспользовано = Истина;
		Иначе
			НовоеИмяПредмета =  МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(НовыйПредмет, ИменаПредметов);
        КонецЕсли;
		ИменаПредметов.Добавить(НовоеИмяПредмета);
		
		СтруктураПредмета = Новый Структура;
		СтруктураПредмета.Вставить("РольПредмета", РольПредмета);
		СтруктураПредмета.Вставить("ИмяПредмета", НовоеИмяПредмета);
		СтруктураПредмета.Вставить("Предмет", НовыйПредмет);
		СтруктураПредмета.Вставить("Описание", ОбщегоНазначенияДокументооборотВызовСервера.ПредметСтрокой(НовыйПредмет, НовоеИмяПредмета));
		
		МассивСтруктур.Добавить(СтруктураПредмета);
		
	КонецЦикла;
	
	Возврат МассивСтруктур;
	
КонецФункции

