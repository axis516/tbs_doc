﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПротоколированиеРаботыПользователей.ЗаписатьОткрытие(Объект.Ссылка);
	
	УстановитьДоступностьЭлементовПоПравуДоступа();
	
	ВидПроцессаПодписание = Перечисления.ВидыБизнесПроцессаУтверждение.Подписание;
	
	// Инициализация формы механизмом комплексных процессов 
	Если Объект.Ссылка.Пустая() Тогда
		Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда
			ЗаголовокФормы = НСтр("ru = 'Подписание (Создание)'");
		Иначе
			ЗаголовокФормы = НСтр("ru = 'Утверждение (Создание)'");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда 
			Объект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
	Иначе
		Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда
			ЗаголовокФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подписание ""%1""'"), 
				Объект.НаименованиеБизнесПроцесса);
		Иначе
			ЗаголовокФормы = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Утверждение ""%1""'"), 
				Объект.НаименованиеБизнесПроцесса);			
		КонецЕсли;
	КонецЕсли;
		
	// Рабочие группы
	РаботаСРабочимиГруппами.ШаблонПриСозданииНаСервере(ЭтаФорма);
	
	// Инициализация формы механизмом комплексных процессов 
	РаботаСКомплекснымиБизнесПроцессамиСервер.КарточкаШаблонаБизнесПроцессаПриСозданииНаСервере(
		ЭтаФорма, 
		ЗаголовокФормы);
	
	// Учет переносов сроков выполнения
	ПереносСроковВыполненияЗадач.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Отложенный старт.
	СтартПроцессовСервер.КарточкаШаблонаПриСозданииНаСервере(ЭтаФорма);
	
	// Сроки выполнения
	УстановитьУсловноеОформлениеИстекшихСроков();
	СрокиИсполненияПроцессов.КарточкаШаблонаПриСозданииНаСервере(ЭтаФорма);
	
	ВестиУчетПлановыхТрудозатратВБизнесПроцессах = ПолучитьФункциональнуюОпцию("ВестиУчетПлановыхТрудозатратВБизнесПроцессах");
	Элементы.ОписаниеТрудозатрат.Видимость = ВестиУчетПлановыхТрудозатратВБизнесПроцессах;
	
	Если НЕ ЭлектроннаяПодпись.ИспользоватьЭлектронныеПодписи() Тогда
		Элементы.ПодписыватьЭП.Видимость = Ложь;
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", ПустойБизнесПроцесс);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Остальная инициализация
	Если Объект.Ссылка.Пустая() Тогда 
		Если Объект.Исполнитель = Неопределено Тогда 
			Объект.Исполнитель = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Мультипредметность.ШаблонПриСозданииНаСервере(ЭтаФорма, Объект);
	
	// Заполнение трудозатрат
	ЕдиницаТрудозатрат = Константы.ОсновнаяЕдиницаТрудозатрат.Получить();
	ЗаполнитьОписаниеТрудозатрат(ЭтаФорма);
	
	// Заголовки команд
	РаботаСБизнесПроцессамиВызовСервера.УстановитьЗаголовкиКомандШаблонаБизнесПроцесса(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтандартныеКомандыФормы);
	// Конец СтандартныеПодсистемы.Печать

	// СтандартныеПодсистемы.БазоваяФункциональность
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// Настроим отображение группы доступности шаблона.
	ШаблоныБизнесПроцессов.НастроитьОбластьДоступностиШаблонов(ЭтаФорма);	
	
	СформироватьЗаголовкиИПодсказкиЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьТрудозатратыУчастниковПроцесса" И Источник = ЭтаФорма Тогда
		ЗаполнитьОписаниеТрудозатрат(ЭтаФорма);
	КонецЕсли;
	
	// Сроки выполнения
	СрокиИсполненияПроцессовКлиент.ОбработкаОповещенияПослеПереносаСрока(
		ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Сроки исполнения процессов
	СрокиИсполненияПроцессовКлиент.ПодтвердитьПереносСрокаПроцесса(ЭтаФорма, Отказ, ПараметрыЗаписи);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Отложенный старт.
	СтартПроцессовКлиент.КарточкаШаблонаПередЗаписью(ЭтаФорма);
	
	РаботаСКомплекснымиБизнесПроцессамиКлиент.ФормаНастройкиДействияПередЗаписью(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовыйОбъект", НЕ ЗначениеЗаполнено(ТекущийОбъект.Ссылка));
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// Рабочая группа
	РабочаяГруппаТаблицаКоличество = РабочаяГруппаТаблица.Количество();
	Для Инд = 1 По РабочаяГруппаТаблицаКоличество Цикл
		Строка = РабочаяГруппаТаблица[РабочаяГруппаТаблицаКоличество - Инд];
		Если Не ЗначениеЗаполнено(Строка.Участник) Тогда 
			РабочаяГруппаТаблица.Удалить(Строка);
		КонецЕсли;	
	КонецЦикла;
	
	НоваяРабочаяГруппа = РабочаяГруппаТаблица.Выгрузить();
	РабочаяГруппаДобавить = Новый Массив;
	РабочаяГруппаУдалить = Новый Массив;
	
	// Формирование списка удаленных участников рабочей группы
	Для каждого Эл Из ИсходнаяРабочаяГруппа Цикл
		
		Найден = Ложь;
		
		Для каждого Эл2 Из НоваяРабочаяГруппа Цикл
			Если Эл.Участник = Эл2.Участник 
				И Эл.Изменение = Эл2.Изменение Тогда
				
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Не Найден Тогда
			РабочаяГруппаУдалить.Добавить(
				Новый Структура("Участник, Изменение", 
					Эл.Участник,
					Эл.Изменение));
		КонецЕсли;
		
	КонецЦикла;	
	
	// Формирование списка добавленных участников рабочей группы
	Для каждого Эл Из НоваяРабочаяГруппа Цикл
		
		Найден = Ложь;
		
		Для каждого Эл2 Из ИсходнаяРабочаяГруппа Цикл
			Если Эл.Участник = Эл2.Участник 
				И Эл.Изменение = Эл2.Изменение Тогда
				
				Найден = Истина;
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		
		Если Не Найден Тогда
			РабочаяГруппаДобавить.Добавить(
				Новый Структура("Участник, Изменение", 
					Эл.Участник,
					Эл.Изменение));
		КонецЕсли;
		
	КонецЦикла;	
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаУдалить", РабочаяГруппаУдалить);	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("РабочаяГруппаДобавить", РабочаяГруппаДобавить);
	
	// Учет переноса сроков
	ПереносСроковВыполненияЗадач.ПередатьПричинуИЗаявкуНаПереносаСрока(ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьДоступностьШаблона(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Сроки выполнения
	СрокиИсполненияПроцессовКлиент.ОповеститьОПереносеСроков(ЭтаФорма);
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		РаботаСКомплекснымиБизнесПроцессамиКлиент.ОповеститьПослеЗаписиНастройкиДействия(ЭтаФорма);
	КонецЕсли;
	
	ШаблоныБизнесПроцессовКлиент.ПоказатьОповещениеПослеЗаписиШаблона(ЭтаФорма);
	
	Оповестить("Запись_ШаблонПроцесса", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ШаблонВКомплексномПроцессе Тогда
		Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Подписание ""%1""'"), 
				Объект.НаименованиеБизнесПроцесса);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Утверждение ""%1""'"), 
				Объект.НаименованиеБизнесПроцесса);
		КонецЕсли;
	КонецЕсли;
	ПротоколированиеРаботыПользователей.ЗаписатьСоздание(Объект.Ссылка, ПараметрыЗаписи.ЭтоНовыйОбъект);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	
	// Рабочая группа
	РаботаСРабочимиГруппами.ОбъектПослеЗаписиНаСервере(ЭтаФорма, ПараметрыЗаписи);
	
	// Формирование исходной рабочей группы.
	Участники = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(Объект.Ссылка);
	ИсходнаяРабочаяГруппа.Очистить();
	Для каждого Эл Из Участники Цикл
		
		Строка = ИсходнаяРабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник; 
		Строка.Изменение = Эл.Изменение;
		Строка.Изменение = Эл.Изменение;
		
	КонецЦикла;
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// Рабочие группы
	РаботаСРабочимиГруппами.ДокументПриЧтенииНаСервере(ЭтаФорма);
	
	// Формирование исходной рабочей группы.
	Участники = РегистрыСведений.РабочиеГруппы.ПолучитьУчастниковПоОбъекту(Объект.Ссылка);
	ИсходнаяРабочаяГруппа.Очистить();
	Для каждого Эл Из Участники Цикл
		
		Строка = ИсходнаяРабочаяГруппа.Добавить();
		Строка.Участник = Эл.Участник; 
		Строка.Изменение = Эл.Изменение;
		
	КонецЦикла;
	
	МультипредметностьКлиентСервер.ЗаполнитьТаблицуПредметовФормы(Объект);
			
	// СтандартныеПодсистемы.Свойства
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(Объект.Ссылка, ПустойБизнесПроцесс);
	ПустойБизнесПроцессОбъект =
		РеквизитФормыВЗначение("ПустойБизнесПроцесс", Тип("БизнесПроцессОбъект.Утверждение"));
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ПустойБизнесПроцессОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	ПрочитатьДоступностьШаблона();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНедоступенДляЗапускаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПроверитьДоступностьШаблона();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРучнойЗапускОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОчиститьСообщения();
	ПоказатьНезаполненныеПоляНеобходимыеДляСтарта();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Ответственный);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоИтерацийПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.КоличествоИтерацийПриИзменении(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОтложенногоСтартаНажатие(Элемент, СтандартнаяОбработка)
	
	СтартПроцессовКлиент.ОписаниеОтложенногоСтартаНажатие(ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеТрудозатратНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Настройки = Новый Структура;
	Настройки.Вставить("ЕдиницаИзмеренияТрудозатрат", ЕдиницаТрудозатрат);
	Настройки.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	Настройки.Вставить("Участники", Новый Массив);
	
	ТрудозатратыИсполнителя = РаботаСБизнесПроцессамиКлиент.
		СтруктураСтрокиТрудозатратУчастникаПроцесса(
			НСтр("ru = 'Исполнитель'"),
			"ТрудозатратыПланИсполнителя",
			Объект.ТрудозатратыПланИсполнителя,
			Объект.Исполнитель);
	Настройки.Участники.Добавить(ТрудозатратыИсполнителя);
	
	ТрудозатратыАвтора = РаботаСБизнесПроцессамиКлиент.
		СтруктураСтрокиТрудозатратУчастникаПроцесса(
			НСтр("ru = 'Автор'"),
			"ТрудозатратыПланАвтора",
			Объект.ТрудозатратыПланАвтора,
			Объект.Автор);
	Настройки.Участники.Добавить(ТрудозатратыАвтора);
	
	РаботаСБизнесПроцессамиКлиент.НастроитьТрудозатратУчастниковПроцесса(ЭтаФорма, Настройки);
	
КонецПроцедуры


// Шаблоны текста для наименования и описания
&НаКлиенте
Процедура НаименованиеБизнесПроцессаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

    Если ЭтаФорма.Объект.ШаблонВКомплексномПроцессе Тогда  
        РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "НаименованиеБизнесПроцесса",
		    ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ПроцессУтверждениеНаименование"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    Если ЭтаФорма.Объект.ШаблонВКомплексномПроцессе Тогда  
        РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "Описание",
		    ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ПроцессУтверждениеОписание"));
        КонецЕсли;
        
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) и ЭтаФорма.Объект.ШаблонВКомплексномПроцессе Тогда 
		ДанныеВыбора = РаботаСШаблонамиТекстовСервер.СформироватьДанныеВыбораШаблона(
			ПараметрыПолученияДанных, 
			ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ПроцессУтверждениеНаименование"));
			
		Если ДанныеВыбора.Количество() <> 0 Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеБизнесПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")  Тогда 
		Объект.НаименованиеБизнесПроцесса = ВыбранноеЗначение.Шаблон;
		Модифицированность = Истина;	
	КонецЕсли;	
	
КонецПроцедуры
// Шаблоны текста для наименования и описания

&НаКлиенте
Процедура ВидПроцессаПриИзменении(Элемент)
	
	Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда
		Объект.НаименованиеБизнесПроцесса = НСтр("ru = 'Подписать'");
	Иначе
		Объект.НаименованиеБизнесПроцесса = НСтр("ru = 'Утвердить'");
	КонецЕсли;
	
	СформироватьЗаголовкиИПодсказкиЭлементовФормы();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_Исполнитель

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)

	РаботаСБизнесПроцессамиКлиент.УчастникСоСрокомИсполненияПриИзменении(ЭтаФорма, "Исполнитель");
	
	ОтключитьДоступностьШаблона();

КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникСоСрокомИсполненияНачалоВыбора(
		Элемент, Объект.Исполнитель, СтандартнаяОбработка, ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОчистка(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникСоСрокомИсполненияОчистка(СтандартнаяОбработка,
		ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОткрытие(Элемент, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОткрытие(СтандартнаяОбработка,
		ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникОбработкаВыбора(СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.УчастникАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.
		УчастникОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка,
			ЭтаФорма, "Исполнитель");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокИсполненияПредставление

&НаКлиенте
Процедура СрокИсполненияПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокИсполненияПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокИсполнения";
	ДопПараметры.Исполнитель = Объект.Исполнитель;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокИсполнения,
		Объект.СрокИсполненияДни,
		Объект.СрокИсполненияЧасы,
		Объект.СрокИсполненияМинуты,
		Объект.ВариантУстановкиСрокаИсполнения,
		СрокИсполненияПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокИсполнения";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокИсполненияДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокИсполненияЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокИсполненияМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаИсполнения";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокИсполненияПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокИсполнения";
	ПараметрыВыбораСрока.Участник = Объект.Исполнитель;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокИсполнения,
		Объект.СрокИсполненияДни,
		Объект.СрокИсполненияЧасы,
		Объект.СрокИсполненияМинуты,
		СрокИсполненияПредставление,
		Объект.ВариантУстановкиСрокаИсполнения,
		Направление,
		"СрокИсполнения");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_Автор

&НаКлиенте
Процедура АвторПриИзменении(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.АвторСоСрокомИсполненияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСПользователямиКлиент.ВыбратьПользователя(Элемент, Объект.Автор);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы_СрокОбработкиРезультатовПредставление

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеПриИзменении(Элемент)
	
	ДопПараметры = СрокиИсполненияПроцессовКлиент.ДопПараметрыДляИзмененияСрокаПоПредставлению();
	ДопПараметры.Форма = ЭтаФорма;
	ДопПараметры.Поле = "СрокОбработкиРезультатовПредставление";
	ДопПараметры.НаименованиеИзмененногоРеквизита = "СрокОбработкиРезультатов";
	ДопПараметры.Исполнитель = Объект.Автор;
	
	СрокиИсполненияПроцессовКлиент.ИзменитьСрокИсполненияУчастникаПроцессаПоПредставлению(
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		СрокОбработкиРезультатовПредставление,
		ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСрока = СрокиИсполненияПроцессовКлиент.ПараметрыВыбораСрокаУчастникаПроцесса();
	ПараметрыВыбораСрока.Форма = ЭтаФорма;
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполнения = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияДни = "СрокОбработкиРезультатовДни";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияЧасы = "СрокОбработкиРезультатовЧасы";
	ПараметрыВыбораСрока.ИмяРеквизитаСрокИсполненияМинуты = "СрокОбработкиРезультатовМинуты";
	ПараметрыВыбораСрока.ИмяРеквизитаВариантУстановкиСрока = "ВариантУстановкиСрокаОбработкиРезультатов";
	ПараметрыВыбораСрока.ИмяРеквизитаПредставлениеСрока = "СрокОбработкиРезультатовПредставление";
	ПараметрыВыбораСрока.ИмяОбъектаФормы = "Объект";
	ПараметрыВыбораСрока.СрокиПредшественников = Объект.СрокИсполнения;
	ПараметрыВыбораСрока.НаименованиеСрокаУчастника = "СрокОбработкиРезультатов";
	ПараметрыВыбораСрока.Участник = Объект.Автор;
	
	СрокиИсполненияПроцессовКлиент.ВыбратьСрокУчастникаПроцесса(ПараметрыВыбораСрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокОбработкиРезультатовПредставлениеРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СрокиИсполненияПроцессовКлиент.ИзменитьОтносительныйСрокУчастникаПроцесса(
		ЭтаФорма,
		Объект.СрокОбработкиРезультатов,
		Объект.СрокОбработкиРезультатовДни,
		Объект.СрокОбработкиРезультатовЧасы,
		Объект.СрокОбработкиРезультатовМинуты,
		СрокОбработкиРезультатовПредставление,
		Объект.ВариантУстановкиСрокаОбработкиРезультатов,
		Направление,
		"СрокОбработкиРезультатов");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_РабочаяГруппа

&НаКлиенте
Процедура РабочаяГруппаТаблицаУчастникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСАдреснойКнигойКлиент.ВыбратьУчастникаРабочейГруппы(ЭтаФорма, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаУчастникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	РаботаСРабочимиГруппамиКлиент.ДокументРабочаяГруппаУчастникАвтоПодбор(
		Элемент,
		Текст,
		ДанныеВыбора,
		Ожидание,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриНачалеРедактирования(Элемент, НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаПриОкончанииРедактирования(
		ЭтаФорма,
		Элемент,
		ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПередУдалением(Элемент, Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РабочаяГруппаТаблицаПередУдалениемПродолжение",
		ЭтотОбъект);
	РаботаСРабочимиГруппамиКлиент.РабочаяГруппаТаблицаПередУдалением(ЭтаФорма, Отказ, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочаяГруппаТаблицаПередУдалениемПродолжение(Результат, Параметры) Экспорт
	
	ТаблицаРГ = Элементы.РабочаяГруппаТаблица;
	Для Каждого Индекс Из ТаблицаРГ.ВыделенныеСтроки Цикл
		РабочаяГруппаТаблица.Удалить(ТаблицаРГ.ДанныеСтроки(Индекс));
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Предметы

&НаКлиенте
Процедура ПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	МультипредметностьКлиент.ПредметыШаблонаПередНачаломДобавления(ЭтаФорма, Объект, Отказ, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередУдалением(Элемент, Отказ)
	
	МультипредметностьКлиент.ПредметыПередУдалением(ЭтаФорма, Объект, Отказ, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПослеУдаления(Элемент)
	
	МультипредметностьКлиентСервер.УстановитьДоступностьКнопокУправленияПредметами(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПредметыПриАктивизацииСтрокиОтложенно", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПриАктивизацииСтрокиОтложенно()
	
	МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТочкиМаршрута

&НаКлиенте
Процедура ТочкиМаршрутаПриИзменении(Элемент)
	
	МультипредметностьКлиент.ТочкиМаршрутаПриИзменении(ЭтаФорма, Объект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУсловияЗапретаВыполнения

&НаКлиенте
Процедура УсловияЗапретаВыполненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ШаблоныБизнесПроцессовКлиент.УсловияЗапретаВыполненияВыбор(ЭтаФорма, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗаписатьИЗакрыть(Команда, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьВспомогательный(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьВспомогательный(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыДобавитьОсновной(Команда)
	
	МультипредметностьКлиент.ПредметыДобавитьОсновной(ЭтаФорма, Объект, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыИзменитьПредмет(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ПредметыШаблонаИзменитьПредмет(ЭтаФорма, Объект, ВыбраннаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыИзменитьРоль(Команда)
	
	ВыбраннаяСтрока = Элементы.Предметы.ТекущаяСтрока;
	Если ВыбраннаяСтрока <> Неопределено Тогда
		МультипредметностьКлиент.ИзменитьРольПредмета(ЭтаФорма, Объект, ВыбраннаяСтрока, Ложь);
		МультипредметностьКлиент.ПредметыШаблонаПриАктивизацииСтроки(ЭтаФорма, Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.БазоваяФункциональность
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьОписаниеТрудозатрат(Форма)
	
	ПараметрыОписания = Новый Структура;
	ПараметрыОписания.Вставить("Исполнитель", Истина);
	ПараметрыОписания.Вставить("ПредставлениеИсполнителя", НСтр("ru = 'Исполнитель'"));
	ПараметрыОписания.Вставить("Автор", Истина);
	
	РаботаСБизнесПроцессамиКлиентСервер.ЗаполнитьОписаниеТрудозатрат(Форма, ПараметрыОписания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьУчастниковРабочейГруппы(Команда)
	
	РаботаСАдреснойКнигойКлиент.ПодобратьУчастниковРабочейГруппы(ЭтаФорма);
	
КонецПроцедуры

// Устанавливает доступность элементов формы при ее открытии в зависимости от
// прав доступа к шаблону.
//
&НаСервере
Процедура УстановитьДоступностьЭлементовПоПравуДоступа()
	
	Если НЕ Объект.Ссылка.Пустая()
		И НЕ ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка).Изменение Тогда
		
		ТолькоПросмотр = Истина;
		
		Элементы.РабочаяГруппаТаблица.ТолькоПросмотр = Истина;
		Элементы.ТочкиМаршрута.ТолькоПросмотр = Истина;
		
		Элементы.ФормаЗакрытьФорму.Видимость = Истина;
		Элементы.ФормаЗакрытьФорму.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовкиИПодсказкиЭлементовФормы()

	Если Объект.Ссылка.Пустая() Тогда 
		Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда 
			Заголовок = НСтр("ru = 'Шаблон подписания (создание)'");
		Иначе 
			Заголовок = НСтр("ru = 'Шаблон утверждения (создание)'");
		КонецЕсли;
	Иначе
		Заголовок = Объект.Наименование;		
	КонецЕсли;
		
	Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда
		Элементы.СтраницаУсловияЗапретаВыполнения.Заголовок = НСтр("ru = 'Проверка подписания'");
		Элементы.СрокИсполненияПредставление.Заголовок = НСтр("ru = 'Срок подписания'");
		Элементы.СрокИсполненияПредставление.Подсказка = НСтр("ru = 'Срок подписания (по графику работ)'");
	Иначе
		Элементы.СтраницаУсловияЗапретаВыполнения.Заголовок = НСтр("ru = 'Проверка утверждения'");
		Элементы.СрокИсполненияПредставление.Заголовок = НСтр("ru = 'Срок утверждения'");
		Элементы.СрокИсполненияПредставление.Подсказка = НСтр("ru = 'Срок утверждения (по графику работ)'");
	КонецЕсли;
	
	Для Каждого Точка Из ТочкиМаршрута.ПолучитьЭлементы() Цикл
		Если Объект.ВидПроцесса = ВидПроцессаПодписание Тогда
			Если Точка.ТочкаМаршрута = БизнесПроцессы.Утверждение.ТочкиМаршрута.Утвердить Тогда
				Точка.ТочкаМаршрутаПредставление = НСтр("ru = 'Подписать'");
			Иначе
				Точка.ТочкаМаршрутаПредставление = НСтр("ru = 'Ознакомиться с результатом подписания'");
			КонецЕсли;
		Иначе
			Если Точка.ТочкаМаршрута = БизнесПроцессы.Утверждение.ТочкиМаршрута.Ознакомиться Тогда
				Точка.ТочкаМаршрутаПредставление = НСтр("ru = 'Утвердить'");
			Иначе
				Точка.ТочкаМаршрутаПредставление = НСтр("ru = 'Ознакомиться с результатом утверждения'");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ПодсистемаСвойств

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_СрокиИсполненияПроцессов

// Заполняте представление сроков в карточке процесса
//
&НаСервере
Процедура ОбновитьСрокиИсполненияНаСервере() Экспорт
	
	РассчитатьОтносительныйСрок = Ложь;
	РассчитьтатьТочныйСрок = Ложь;
	
	Смещение = СрокиИсполненияПроцессовКлиентСерверКОРП.СмещенияДатыОтсчетаВКарточке(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(Объект.ВладелецШаблона)
		Или ЭтоДействиеШаблонаКомплексногоПроцесса
		Или (ЭтоДействиеКомплексногоПроцессаПоШаблону И Не КомплексныйПроцессСтартован) Тогда
		
		РассчитатьОтносительныйСрок = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаОтсчетаДляРасчетаСроков)
		И (Не КомплексныйПроцессСтартован
			Или ЗначениеЗаполнено(РеквизитСИзмененнымСроком)) Тогда
		
		РассчитьтатьТочныйСрок = Истина;
	КонецЕсли;
	
	Если РассчитатьОтносительныйСрок Тогда
		ДлительностьПроцесса = СрокиИсполненияПроцессов.ДлительностьИсполненияПроцесса(Объект, Смещение);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ДлительностьПроцесса);
	КонецЕсли;
	
	Если РассчитьтатьТочныйСрок Тогда
		ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
		ПараметрыДляРасчетаСроков.ДатаОтсчета = ДатаОтсчетаДляРасчетаСроков;
		
		ПараметрыДляРасчетаСроков.РеквизитТаблицаСИзмененнымСроком = РеквизитСИзмененнымСроком;
		
		ПараметрыДляРасчетаСроков.Смещение = Смещение;
		
		СрокиИсполненияПроцессов.РассчитатьСрокиУтверждения(Объект, ПараметрыДляРасчетаСроков);
			
		СрокиИсполненияПроцессовКОРП.ПроверитьИзменениеСроковВКарточкеШаблонаПроцесса(ЭтаФорма);
	КонецЕсли;
	
	РеквизитСИзмененнымСроком = "";
	
	ОбновитьПризнакиИстекшихСроков();
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// см. ОбновитьСрокиИсполненияНаСервере
&НаКлиенте
Процедура ОбновитьСрокиИсполнения()
	
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// см. ОбновитьСрокиИсполнения
&НаКлиенте
Процедура ОбновитьСрокиИсполненияОтложенно(Реквизит = "") Экспорт
	
	РеквизитСИзмененнымСроком = Реквизит;
	
	ПодключитьОбработчикОжидания("ОбновитьСрокиИсполнения", 0.2, Истина);
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеСроковИсполнения() Экспорт
	
	СрокиИсполненияПроцессовКлиентСервер.ЗаполнитьПредставлениеСроковИсполненияВФорме(ЭтаФорма);
	
КонецПроцедуры

// Обновляет форму процесса после переноса сроков действий
//
&НаСервере
Процедура ОбновитьФормуПослеПереносаСроковИсполнения() Экспорт
	
	Прочитать();
	ОбновитьСрокиИсполненияНаСервере();
	
КонецПроцедуры

// Устанавливает условное оформление истекших сроков.
//
&НаСервере
Процедура УстановитьУсловноеОформлениеИстекшихСроков()
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения истек (Исполнитель)'"),
		"СрокИсполненияИстек",
		"СрокИсполненияПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок обработки результатов истек'"),
		"СрокОбработкиРезультатовИстек",
		"СрокОбработкиРезультатовПредставление");
	
	СрокиИсполненияПроцессов.УстановитьУсловноеОформлениеИстекшегоСрока(
		ЭтаФорма,
		НСтр("ru = 'Срок исполнения процесса истек'"),
		"СрокИсполненияПроцессаИстек",
		"СрокИсполненияПроцессаПредставление");
	
КонецПроцедуры

// Обновляет признаки истекших сроков в карточке.
//
&НаСервере
Процедура ОбновитьПризнакиИстекшихСроков()
	
	Если ЗначениеЗаполнено(ДатаОтсчетаДляРасчетаСроков) Тогда
		СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
			Объект.СрокИсполнения,
			СрокИсполненияИстек,
			ТекущаяДатаСеанса());
		СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаУчастника(
			Объект.СрокОбработкиРезультатов,
			СрокОбработкиРезультатовИстек,
			ТекущаяДатаСеанса());
		СрокиИсполненияПроцессов.ОбновитьПризнакИстекшегоСрокаПроцесса(
			Объект.СрокИсполненияПроцесса, ТекущаяДатаСеанса(), СрокИсполненияПроцессаИстек);
	Иначе
		СрокИсполненияИстек = Ложь;
		СрокОбработкиРезультатовИстек = Ложь;
		СрокИсполненияПроцессаИстек = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДоступностьШаблоновПроцессов

// Помещает доступность шаблона процесса в карточку.
//
&НаСервере
Процедура ПрочитатьДоступностьШаблона()
	
	ШаблоныБизнесПроцессов.ПрочитатьДоступностьШаблона(ЭтаФорма);
	
КонецПроцедуры

// Записывает доступность шаблона процесса из карточки.
//
// Параметры:
//  ШаблонОбъект - СправочникОбъект.<ИмяШаблонаПроцесса> - объект шаблона процесса.
//
&НаСервере
Процедура ЗаписатьДоступностьШаблона(ШаблонОбъект)
	
	ШаблоныБизнесПроцессов.ЗаписатьДоступностьШаблонаИзФормы(ШаблонОбъект, ЭтаФорма);
	
КонецПроцедуры

// Проверяет доступность шаблона и помещает результат в реквизиты
// ДоступенРучнойЗапускПоШаблону, ДоступенАвтоматическийЗапускПоШаблону.
//
&НаСервере
Процедура ПроверитьДоступностьШаблона()
	
	ШаблоныБизнесПроцессов.ПроверитьДоступностьШаблона(ЭтаФорма);
	
КонецПроцедуры

// Выводить сообщения пользователю с привязкой к незаполненным полям
// необходимым для старта процессов по шаблону.
//
&НаСервере
Процедура ПоказатьНезаполненныеПоляНеобходимыеДляСтарта()
	
	ШаблоныБизнесПроцессов.ПоказатьНезаполненныеПоляНеобходимыеДляСтарта(ЭтаФорма);
	
КонецПроцедуры

// Сбрасывает доступность в карточке шаблона процесса.
//
&НаКлиенте
Процедура ОтключитьДоступностьШаблона()
	
	ШаблоныБизнесПроцессовКлиент.ОтключитьДоступностьШаблона(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти