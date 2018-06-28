﻿&НаКлиенте
Перем ВнутренниеДанные, КлиентскиеПараметры, СвойстваПароля;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Сертификат        = Параметры.Сертификат;
	ПроверкаПриВыборе = Параметры.ПроверкаПриВыборе;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	Если ПроверкаПриВыборе Тогда
		Элементы.ФормаПроверить.Заголовок = НСтр("ru = 'Проверить и продолжить'");
		Элементы.ФормаЗакрыть.Заголовок   = НСтр("ru = 'Отмена'");
	КонецЕсли;
	
	СтандартныеПроверки = Истина;
	
	Проверки = Новый ТаблицаЗначений;
	Проверки.Колонки.Добавить("Имя",           Новый ОписаниеТипов("Строка"));
	Проверки.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Проверки.Колонки.Добавить("Подсказка",     Новый ОписаниеТипов("Строка"));
	
	ЭлектроннаяПодписьПереопределяемый.ПриСозданииФормыПроверкаСертификата(Параметры.Сертификат,
		Проверки, Параметры.ПараметрыДополнительныхПроверок, СтандартныеПроверки);
	
	Для каждого Проверка Из Проверки Цикл
		Группа = Элементы.Добавить("Группа" + Проверка.Имя, Тип("ГруппаФормы"), Элементы.ГруппаДополнительныеПроверки);
		Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Группа.ОтображатьЗаголовок = Ложь;
		Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
		
		Картинка = Элементы.Добавить(Проверка.Имя + "НаКлиентеКартинка", Тип("ДекорацияФормы"), Группа);
		Картинка.Вид = ВидДекорацииФормы.Картинка;
		Картинка.Картинка = Новый Картинка;
		Картинка.РазмерКартинки = РазмерКартинки.АвтоРазмер;
		Картинка.Ширина = 3;
		Картинка.Высота = 1;
		Картинка.Гиперссылка = Истина;
		Картинка.УстановитьДействие("Нажатие", "Подключаемый_КартинкаНажатие");
		
		Картинка = Элементы.Добавить(Проверка.Имя + "НаСервереКартинка", Тип("ДекорацияФормы"), Группа);
		Картинка.Вид = ВидДекорацииФормы.Картинка;
		Картинка.Картинка = Новый Картинка;
		Картинка.РазмерКартинки = РазмерКартинки.АвтоРазмер;
		Картинка.Ширина = 3;
		Картинка.Высота = 1;
		Картинка.Гиперссылка = Истина;
		Картинка.УстановитьДействие("Нажатие", "Подключаемый_КартинкаНажатие");
		
		Надпись = Элементы.Добавить(Проверка.Имя + "Надпись", Тип("ДекорацияФормы"), Группа);
		Надпись.Заголовок = Проверка.Представление;
		Надпись.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Надпись.РасширеннаяПодсказка.Заголовок = Проверка.Подсказка;
		
		ДополнительныеПроверки.Добавить(Проверка.Имя);
	КонецЦикла;
	
	Если Не СтандартныеПроверки Тогда
		Если ДополнительныеПроверки.Количество() = 0 Тогда
			ВызватьИсключение
				НСтр("ru = 'Для проверки сертификата отключены стандартные проверки,
				           |при этом дополнительных проверок не указано.'");
		КонецЕсли;
		Элементы.ГруппаОбщиеПроверки.Видимость = Ложь;
		Элементы.ГруппаПроверкиОпераций.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "НестандартныеПроверки");
	КонецЕсли;
	
	СвойстваСертификата = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сертификат,
		"ДанныеСертификата, Программа, УсиленнаяЗащитаЗакрытогоКлюча");
	
	Программа = СвойстваСертификата.Программа;
	АдресСертификата = ПоместитьВоВременноеХранилище(СвойстваСертификата.ДанныеСертификата.Получить(), УникальныйИдентификатор);
	СертификатУсиленнаяЗащитаЗакрытогоКлюча = СвойстваСертификата.УсиленнаяЗащитаЗакрытогоКлюча;
	
	Если Программа.ЭтоПрограммаОблачногоСервиса Тогда
		ЭтоПрограммаОблачногоСервиса = Истина;
		Элементы.ГруппаВводаПароля.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьВидимостьНаСервере();
	
	Если СтандартныеПроверки Тогда
		Если Элементы.ГруппаЗаконныйСертификат.Видимость Тогда
			ИмяПервойПроверки = "ЗаконныйСертификат";
		Иначе
			ИмяПервойПроверки = "НаличиеСертификата";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВнутренниеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// При изменении настроек использования.
	Если ВРег(ИмяСобытия) <> ВРег("Запись_НаборКонстант") Тогда
		Возврат;
	КонецЕсли;
	
	Если ВРег(Источник) = ВРег("ПроверятьЭлектронныеПодписиНаСервере")
	 Или ВРег(Источник) = ВРег("СоздаватьЭлектронныеПодписиНаСервере") Тогда
		
		ПодключитьОбработчикОжидания("ПриИзмененияИспользованияПодписанияИлиШифрования", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_КартинкаНажатие(Элемент)
	
	Если ЗначениеЗаполнено(Элемент.Подсказка) Тогда
		ПоказатьПредупреждение(, Элемент.Подсказка);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапомнитьПарольПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриИзмененииРеквизитаЗапомнитьПароль", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляНажатие(ЭтотОбъект, Элемент, СвойстваПароля);
	
КонецПроцедуры

&НаКлиенте
Процедура ПояснениеУстановленногоПароляРасширеннаяПодсказкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ПояснениеУстановленногоПароляОбработкаНавигационнойСсылки(
		ЭтотОбъект, Элемент, НавигационнаяСсылка, СтандартнаяОбработка, СвойстваПароля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьСертификат(Новый ОписаниеОповещения("ПроверитьЗавершение", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение процедуры Проверить.
&НаКлиенте
Процедура ПроверитьЗавершение(Неопределен, Контекст) Экспорт
	
	Если Не ПроверкаПриВыборе Тогда
		Возврат;
	КонецЕсли;
	
	Если КлиентскиеПараметры.Результат.ПроверкиПройдены Тогда
		Закрыть(Истина);
	Иначе
		ПоказатьПредупреждениеОНевозможностиПродолжения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПродолжитьОткрытие(Оповещение, ОбщиеВнутренниеДанные, ВходящиеКлиентскиеПараметры) Экспорт
	
	ВнутренниеДанные = ОбщиеВнутренниеДанные;
	КлиентскиеПараметры = ВходящиеКлиентскиеПараметры;
	КлиентскиеПараметры.Вставить("Результат");
	ОбработкаПродолжения = Новый ОписаниеОповещения("ПродолжитьОткрытие", ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
		ВнутренниеДанные, СвойстваПароля, ДополнительныеПараметры);
	
	Если Не Элементы.Пароль.Доступность Тогда
		ТекущийЭлемент = Элементы.ФормаПроверить;
	КонецЕсли;
	
	Если КлиентскиеПараметры.Свойство("БезПодтверждения")
	   И КлиентскиеПараметры.БезПодтверждения
	   И (    ДополнительныеПараметры.ПарольУказан
	      Или ДополнительныеПараметры.УсиленнаяЗащитаЗакрытогоКлюча) Тогда
	
		
		Если Не КлиентскиеПараметры.Свойство("ОбработкаРезультата")
		 Или ТипЗнч(КлиентскиеПараметры.ОбработкаРезультата) <> Тип("ОписаниеОповещения") Тогда
			Открыть();
		КонецЕсли;
		
		Контекст = Новый Структура("Оповещение", Оповещение);
		ПроверитьСертификат(Новый ОписаниеОповещения("ПродолжитьОткрытиеПослеПроверкиСертификата", ЭтотОбъект, Контекст));
		Возврат;
	КонецЕсли;
	
	Открыть();
	
	ВыполнитьОбработкуОповещения(Оповещение);
	
КонецПроцедуры

// Продолжение процедуры ПродолжитьОткрытие.
&НаКлиенте
Процедура ПродолжитьОткрытиеПослеПроверкиСертификата(Результат, Контекст) Экспорт
	
	Если КлиентскиеПараметры.Результат.ПроверкиПройдены Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение, Истина);
		Возврат;
	КонецЕсли;
	
	Если Не Открыта() Тогда
		Открыть();
	КонецЕсли;
	
	Если ПроверкаПриВыборе Тогда
		ПоказатьПредупреждениеОНевозможностиПродолжения();
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененияИспользованияПодписанияИлиШифрования()
	
	ОбновитьВидимостьНаСервере()
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьНаСервере()
	
	ПроверятьНаСервере = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ПроверятьЭлектронныеПодписиНаСервере;
	СоздаватьНаСервере = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().СоздаватьЭлектронныеПодписиНаСервере;
	
	ОперацииНаСервере = ПроверятьНаСервере Или СоздаватьНаСервере;
	
	Элементы.НаСервереКартинка.Видимость                   = ОперацииНаСервере;
	Элементы.ЗаконныйСертификатНаСервереКартинка.Видимость = ОперацииНаСервере;
	Элементы.НаличиеСертификатаНаСервереКартинка.Видимость = ОперацииНаСервере;
	Элементы.ДанныеСертификатаНаСервереКартинка.Видимость  = ОперацииНаСервере;
	Элементы.НаличиеПрограммыНаСервереКартинка.Видимость   = ОперацииНаСервере;
	Элементы.ПодписаниеНаСервереКартинка.Видимость         = ОперацииНаСервере;
	Элементы.ПроверкаПодписиНаСервереКартинка.Видимость    = ОперацииНаСервере;
	Элементы.ШифрованиеНаСервереКартинка.Видимость         = ОперацииНаСервере;
	Элементы.РасшифровкаНаСервереКартинка.Видимость        = ОперацииНаСервере;
	
	Для каждого ЭлементСписка Из ДополнительныеПроверки Цикл
		Элементы[ЭлементСписка.Значение + "НаСервереКартинка"].Видимость = ОперацииНаСервере;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениеОНевозможностиПродолжения()
	
	ПоказатьПредупреждение(,
		НСтр("ru = 'Не удалось продолжить, т.к. пройдены не все требуемые проверки.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСертификат(Оповещение)
	
	ПарольПринят = Ложь;
	ПроверкиНаКлиенте = Новый Структура;
	ПроверкиНаСервере = Новый Структура;
	
	// Очистка предыдущих результатов проверки.
	Если СтандартныеПроверки Тогда
		ОсновныеПроверки = Новый Структура(
			"ЗаконныйСертификат, НаличиеСертификата, ДанныеСертификата,
			|Подписание, ПроверкаПодписи, Шифрование, Расшифровка");
			
		Если Не ЭтоПрограммаОблачногоСервиса Тогда
			ОсновныеПроверки.Вставить("НаличиеПрограммы");
		КонецЕсли;
		
		Для каждого КлючИЗначение Из ОсновныеПроверки Цикл
			УстановитьЭлемент(ЭтотОбъект, КлючИЗначение.Ключ, Ложь);
			УстановитьЭлемент(ЭтотОбъект, КлючИЗначение.Ключ, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого ЭлементСписка Из ДополнительныеПроверки Цикл
		УстановитьЭлемент(ЭтотОбъект, ЭлементСписка.Значение, Ложь);
		УстановитьЭлемент(ЭтотОбъект, ЭлементСписка.Значение, Истина);
	КонецЦикла;
	
	Контекст = Новый Структура("Оповещение", Оповещение);
	
	ПроверитьНаСторонеКлиента(Новый ОписаниеОповещения(
		"ПроверитьСертификатПослеПроверкиНаКлиенте", ЭтотОбъект, Контекст));
	
КонецПроцедуры

// Продолжение процедуры ПроверитьСертификат.
&НаКлиенте
Процедура ПроверитьСертификатПослеПроверкиНаКлиенте(Результат, Контекст) Экспорт
	
	Если ОперацииНаСервере Тогда
		Если СтандартныеПроверки Тогда
			ПроверитьНаСторонеСервера(СвойстваПароля.Значение);
		Иначе
			ПроверитьНаСторонеСервераДополнительныеПроверки();
		КонецЕсли;
	Иначе
		ПроверкиНаСервере = Неопределено;
	КонецЕсли;
	
	Если ПарольПринят Тогда
		ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьПарольВФорме(ЭтотОбъект,
			ВнутренниеДанные, СвойстваПароля, Новый Структура("ПриУспешномВыполненииОперации", Истина));
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПроверкиПройдены", Ложь);
	Результат.Вставить("ПроверкиНаКлиенте", ПроверкиНаКлиенте);
	Результат.Вставить("ПроверкиНаСервере", ПроверкиНаСервере);
	
	КлиентскиеПараметры.Вставить("Результат", Результат);
	
	Если КлиентскиеПараметры.Свойство("ОбработкаРезультата")
	   И ТипЗнч(КлиентскиеПараметры.ОбработкаРезультата) = Тип("ОписаниеОповещения") Тогда
		
		ВыполнитьОбработкуОповещения(КлиентскиеПараметры.ОбработкаРезультата, Результат.ПроверкиПройдены);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры


&НаКлиенте
Процедура ПроверитьНаСторонеКлиента(Оповещение)
	
	Контекст = Новый Структура("Оповещение", Оповещение);
	
	Если СтандартныеПроверки Тогда
		НачатьПодключениеРасширенияРаботыСКриптографией(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеПодключенияРасширенияРаботыСКриптографией", ЭтотОбъект, Контекст));
	Иначе
		Контекст.Вставить("МенеджерКриптографии", Неопределено);
		ПроверитьНаСторонеКлиентаДополнительныеПроверки(Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПодключенияРасширенияРаботыСКриптографией(Подключено, Контекст) Экспорт
	
	Если Не Подключено Тогда
		ЭлектроннаяПодписьКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеПопыткиСозданияМенеджераКриптографии", ЭтотОбъект, Контекст),
			"ПроверкаСертификата", Ложь);
		Возврат;
	КонецЕсли;
	
	// Проверка данных сертификата.
	Контекст.Вставить("ДанныеСертификата", ПолучитьИзВременногоХранилища(АдресСертификата));
	
	СертификатКриптографии = Новый СертификатКриптографии;
	СертификатКриптографии.НачатьИнициализацию(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеИнициализацииСертификата", ЭтотОбъект, Контекст,
			"ПроверитьНаСторонеКлиентаПослеОшибкиИнициализацииСертификата", ЭтотОбъект),
		Контекст.ДанныеСертификата);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПопыткиСозданияМенеджераКриптографии(Результат, Контекст) Экспорт
	
	УстановитьЭлемент(ЭтотОбъект, ИмяПервойПроверки, Ложь, Результат, Ложь);
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеОшибкиИнициализацииСертификата(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	УстановитьЭлемент(ЭтотОбъект, ИмяПервойПроверки, Ложь, ОписаниеОшибки, Истина);
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеИнициализацииСертификата(СертификатКриптографии, Контекст) Экспорт
	
	Контекст.Вставить("СертификатКриптографии", СертификатКриптографии);
	
	// Законный сертификат
	Если Контекст.СертификатКриптографии.Субъект.Свойство("SN") Тогда
		ОписаниеОшибки = "";
	Иначе
		ОписаниеОшибки = НСтр("ru = 'В описании субъекта сертификата не найдено поле ""SN"".'");
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "ЗаконныйСертификат", Ложь, ОписаниеОшибки);
	
	// Наличие сертификата в личном списке.
	Если ЭтоПрограммаОблачногоСервиса Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Отпечаток", Контекст.СертификатКриптографии.Отпечаток);
		МодульХранилищеСертификатовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ХранилищеСертификатовКлиент");
		МодульХранилищеСертификатовКлиент.НайтиСертификат(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеПоискаСертификатаВМоделиСервиса", ЭтотОбъект, Контекст), СтруктураПоиска);
	Иначе
		ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСертификатПоОтпечатку(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеПоискаСертификата", ЭтотОбъект, Контекст),
			Base64Строка(Контекст.СертификатКриптографии.Отпечаток), Истина, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПоискаСертификата(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("СертификатКриптографии") Тогда
		ОписаниеОшибки = Результат.ОписаниеОшибки + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи и расшифровки не могут быть выполнены.'");
	Иначе
		ОписаниеОшибки = "";
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "НаличиеСертификата", Ложь, ОписаниеОшибки);
	
	// Проверка данных сертификата.
	ЭлектроннаяПодписьКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеСозданияЛюбогоМенеджераКриптографии", ЭтотОбъект, Контекст),
		"ПроверкаСертификата", Ложь);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПоискаСертификатаВМоделиСервиса(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Или Не Результат.Выполнено Тогда
		ОписаниеОшибки = Результат.ОписаниеОшибки.Описание + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи и расшифровки не могут быть выполнены.'");
	ИначеЕсли Результат.Сертификат = Неопределено Тогда
		ОписаниеОшибки = НСтр("ru = 'Сертификат не найден в хранилище сертификатов.'") + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи и расшифровки не могут быть выполнены.'");
	Иначе
		ОписаниеОшибки = "";
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "НаличиеСертификата", Ложь, ОписаниеОшибки);
	
	// Если не нашли сертификат в хранилище сертификатов, проверки прекращаются.
	Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка данных сертификата.
	МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
	МодульСервисКриптографииКлиент.ПроверитьСертификат(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеПроверкиСертификатаВМоделиСервиса", ЭтотОбъект, Контекст),
			Результат.Сертификат.Сертификат);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеСозданияЛюбогоМенеджераКриптографии(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("МенеджерКриптографии") Тогда
		ЭлектроннаяПодписьКлиент.ПроверитьСертификат(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеПроверкиСертификата", ЭтотОбъект, Контекст),
			Контекст.СертификатКриптографии, Результат);
	Иначе
		ПроверитьНаСторонеКлиентаПослеПроверкиСертификата(Результат, Контекст)
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПроверкиСертификата(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		ОписаниеОшибки = "";
	Иначе
		ОписаниеОшибки = Результат;
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "ДанныеСертификата", Ложь, ОписаниеОшибки, Истина);
	
	// Наличие программы
	Если ЗначениеЗаполнено(Программа) Тогда
		ЭлектроннаяПодписьКлиент.СоздатьМенеджерКриптографии(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеСозданияМенеджераКриптографии", ЭтотОбъект, Контекст),
			"ПроверкаСертификата", Ложь, Программа);
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Программа для использования закрытого ключа не указана в сертификате.'");
		ПроверитьНаСторонеКлиентаПослеСозданияМенеджераКриптографии(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПроверкиСертификатаВМоделиСервиса(Результат, Контекст) Экспорт
	
	Если Результат.Выполнено И Результат.Действителен Тогда
		ОписаниеОшибки = "";
	Иначе
		ОписаниеОшибки = Результат.ИнформацияОбОшибке.Описание;
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "ДанныеСертификата", Ложь, ОписаниеОшибки, Истина);
	
	// Наличие программы
	Если ЗначениеЗаполнено(Программа) Тогда
		ПроверитьНаСторонеКлиентаВМоделиСервиса("СервисКриптографии", Контекст);
	Иначе
		ОписаниеОшибки = НСтр("ru = 'Программа для использования закрытого ключа не указана в сертификате.'");
		ПроверитьНаСторонеКлиентаПослеСозданияМенеджераКриптографии(ОписаниеОшибки, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеСозданияМенеджераКриптографии(Результат, Контекст) Экспорт
	
	Контекст.Вставить("МенеджерКриптографии", Неопределено);
	
	Если ТипЗнч(Результат) = Тип("МенеджерКриптографии") Тогда
		Контекст.МенеджерКриптографии = Результат;
		ОписаниеОшибки = "";
	Иначе
		ОписаниеОшибки = Результат + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи, шифрования и
			             |расшифровки не могут быть выполнены.'");
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "НаличиеПрограммы", Ложь, ОписаниеОшибки, Истина);
	
	Если Контекст.МенеджерКриптографии = Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
		Возврат;
	КонецЕсли;
	
	Контекст.МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = СвойстваПароля.Значение;
	
	// Подписание.
	Если ПроверкиНаКлиенте.НаличиеСертификата Тогда
		Контекст.МенеджерКриптографии.НачатьПодписывание(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеПодписания", ЭтотОбъект, Контекст,
				"ПроверитьНаСторонеКлиентаПослеОшибкиПодписания", ЭтотОбъект),
			Контекст.ДанныеСертификата, Контекст.СертификатКриптографии);
	Иначе
		ПроверитьНаСторонеКлиентаПослеПодписания(Null, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаВМоделиСервиса(Результат, Контекст) Экспорт
	
	Контекст.Вставить("МенеджерКриптографии", Неопределено);
	
	Если ТипЗнч(Результат) = Тип("Строка") И Результат = "СервисКриптографии" Тогда
		Контекст.МенеджерКриптографии = Результат;
		ОписаниеОшибки = "";
	Иначе
		ОписаниеОшибки = Результат + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи, шифрования и
			             |расшифровки не могут быть выполнены.'");
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "НаличиеПрограммы", Ложь, ОписаниеОшибки, Истина);
	
	Если Контекст.МенеджерКриптографии = Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
		Возврат;
	КонецЕсли;
	
	// Подписание.
	Если ПроверкиНаКлиенте.НаличиеСертификата Тогда
		МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
		МодульСервисКриптографииКлиент.Подписать(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеПодписанияВМоделиСервиса", ЭтотОбъект, Контекст,
				"ПроверитьНаСторонеКлиентаПослеОшибкиПодписания", ЭтотОбъект),
			Контекст.ДанныеСертификата, Контекст.ДанныеСертификата);
	Иначе
		ПроверитьНаСторонеКлиентаПослеПодписания(Null, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеОшибкиПодписания(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПроверитьНаСторонеКлиентаПослеПодписания(КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПодписания(ДанныеПодписи, Контекст) Экспорт
	
	Если ДанныеПодписи <> Null Тогда
		Если ТипЗнч(ДанныеПодписи) = Тип("Строка") Тогда
			ОписаниеОшибки = ДанныеПодписи;
		Иначе
			ОписаниеОшибки = "";
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДанныеПодписи, ОписаниеОшибки);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			ПарольПринят = Истина;
		КонецЕсли;
		УстановитьЭлемент(ЭтотОбъект, "Подписание", Ложь, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	// Проверка подписи.
	Если ПроверкиНаКлиенте.НаличиеСертификата И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Контекст.МенеджерКриптографии.НачатьПроверкуПодписи(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеПроверкиПодписи", ЭтотОбъект, Контекст,
				"ПроверитьНаСторонеКлиентаПослеОшибкиПроверкиПодписи", ЭтотОбъект),
			Контекст.ДанныеСертификата, ДанныеПодписи);
	Иначе
		ПроверитьНаСторонеКлиентаПослеПроверкиПодписи(Null, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПодписанияВМоделиСервиса(ДанныеПодписи, Контекст) Экспорт
	
	Если ТипЗнч(ДанныеПодписи) = Тип("Структура") Тогда
		Если Не ДанныеПодписи.Выполнено Тогда
			ОписаниеОшибки = ДанныеПодписи.ИнформацияОбОшибке.Описание;
		Иначе
			ОписаниеОшибки = "";
			ДанныеПодписи = ДанныеПодписи.Подпись;
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДанныеПодписи, ОписаниеОшибки);
		Если Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			ПарольПринят = Истина;
		КонецЕсли;
		УстановитьЭлемент(ЭтотОбъект, "Подписание", Ложь, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	// Проверка подписи.
	Если ПроверкиНаКлиенте.НаличиеСертификата И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
		МодульСервисКриптографииКлиент.ПроверитьПодпись(Новый ОписаниеОповещения(
					"ПроверитьНаСторонеКлиентаПослеПроверкиПодписиВМоделиСервиса", ЭтотОбъект, Контекст,
					"ПроверитьНаСторонеКлиентаПослеОшибкиПроверкиПодписи", ЭтотОбъект),
				Контекст.ДанныеСертификата, ДанныеПодписи);
	Иначе
		ПроверитьНаСторонеКлиентаПослеПроверкиПодписиВМоделиСервиса(Null, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеОшибкиПроверкиПодписи(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПроверитьНаСторонеКлиентаПослеПроверкиПодписи(КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПроверкиПодписи(Сертификат, Контекст) Экспорт
	
	Если Сертификат <> Null Тогда
		Если ТипЗнч(Сертификат) = Тип("Строка") Тогда
			ОписаниеОшибки = Сертификат;
		Иначе
			ОписаниеОшибки = "";
		КонецЕсли;
		УстановитьЭлемент(ЭтотОбъект, "ПроверкаПодписи", Ложь, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	// Шифрование.
	Контекст.МенеджерКриптографии.НачатьШифрование(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеШифрования", ЭтотОбъект, Контекст,
			"ПроверитьНаСторонеКлиентаПослеОшибкиШифрования", ЭтотОбъект),
		Контекст.ДанныеСертификата, Контекст.СертификатКриптографии);
	
КонецПроцедуры
	
// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеПроверкиПодписиВМоделиСервиса(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Не Результат.Выполнено Тогда
			ОписаниеОшибки = Результат.ИнформацияОбОшибке.Описание;
		Иначе
			ОписаниеОшибки = "";
		КонецЕсли;
		УстановитьЭлемент(ЭтотОбъект, "ПроверкаПодписи", Ложь, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	// Шифрование.
	МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
	МодульСервисКриптографииКлиент.Зашифровать(Новый ОписаниеОповещения(
			"ПроверитьНаСторонеКлиентаПослеШифрованияВМоделиСервиса", ЭтотОбъект, Контекст,
			"ПроверитьНаСторонеКлиентаПослеОшибкиШифрования", ЭтотОбъект),
			Контекст.ДанныеСертификата, Контекст.ДанныеСертификата);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеОшибкиШифрования(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПроверитьНаСторонеКлиентаПослеШифрования(КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеШифрования(ЗашифрованныеДанные, Контекст) Экспорт
	
	Если ТипЗнч(ЗашифрованныеДанные) = Тип("Строка") Тогда
		ОписаниеОшибки = ЗашифрованныеДанные;
	Иначе
		ОписаниеОшибки = "";
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "Шифрование", Ложь, ОписаниеОшибки, Истина);
	
	// Расшифровка.
	Если ПроверкиНаКлиенте.НаличиеСертификата И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Контекст.МенеджерКриптографии.НачатьРасшифровку(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеРасшифровки", ЭтотОбъект, Контекст,
				"ПроверитьНаСторонеКлиентаПослеОшибкиРасшифровки", ЭтотОбъект),
			ЗашифрованныеДанные);
	Иначе
		ПроверитьНаСторонеКлиентаПослеРасшифровки(Null, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеШифрованияВМоделиСервиса(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Не Результат.Выполнено Тогда
			ОписаниеОшибки = Результат.ИнформацияОбОшибке.Описание;
		Иначе
			ОписаниеОшибки = "";
		КонецЕсли;
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "Шифрование", Ложь, ОписаниеОшибки, Истина);
	
	// Расшифровка.
	Если ПроверкиНаКлиенте.НаличиеСертификата И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		МодульСервисКриптографииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииКлиент");
		МодульСервисКриптографииКлиент.Расшифровать(Новый ОписаниеОповещения(
				"ПроверитьНаСторонеКлиентаПослеРасшифровкиВМоделиСервиса", ЭтотОбъект, Контекст,
				"ПроверитьНаСторонеКлиентаПослеОшибкиРасшифровки", ЭтотОбъект),
			Результат.ЗашифрованныеДанные);
	Иначе
		ПроверитьНаСторонеКлиентаПослеРасшифровкиВМоделиСервиса(Null, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеОшибкиРасшифровки(ИнформацияОбОшибке, СтандартнаяОбработка, Контекст) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПроверитьНаСторонеКлиентаПослеРасшифровки(КраткоеПредставлениеОшибки(ИнформацияОбОшибке), Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеРасшифровки(РасшифрованныеДанные, Контекст) Экспорт
	
	Если РасшифрованныеДанные <> Null Тогда
		Если ТипЗнч(РасшифрованныеДанные) = Тип("Строка") Тогда
			ОписаниеОшибки = РасшифрованныеДанные;
		Иначе
			ОписаниеОшибки = "";
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ОписаниеОшибки);
		УстановитьЭлемент(ЭтотОбъект, "Расшифровка", Ложь, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	ПроверитьНаСторонеКлиентаДополнительныеПроверки(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеРасшифровкиВМоделиСервиса(Результат, Контекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Не Результат.Выполнено Тогда
			ОписаниеОшибки = Результат.ИнформацияОбОшибке.Описание;
		Иначе
			ОписаниеОшибки = "";
		КонецЕсли;
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеРасшифрованныеДанные(Результат.РасшифрованныеДанные, ОписаниеОшибки);
		УстановитьЭлемент(ЭтотОбъект, "Расшифровка", Ложь, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	ПроверитьНаСторонеКлиентаДополнительныеПроверки(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаДополнительныеПроверки(Контекст)
	
	// Дополнительные проверки.
	Контекст.Вставить("Индекс", -1);
	
	ПроверитьНаСторонеКлиентаЦиклНачало(Контекст);
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаЦиклНачало(Контекст)
	
	Если ДополнительныеПроверки.Количество() <= Контекст.Индекс + 1 Тогда
		ВыполнитьОбработкуОповещения(Контекст.Оповещение);
		Возврат;
	КонецЕсли;
	Контекст.Индекс = Контекст.Индекс + 1;
	Контекст.Вставить("ЭлементСписка", ДополнительныеПроверки[Контекст.Индекс]);
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Сертификат",           Сертификат);
	ПараметрыВыполнения.Вставить("Проверка",             Контекст.ЭлементСписка.Значение);
	ПараметрыВыполнения.Вставить("МенеджерКриптографии", Контекст.МенеджерКриптографии);
	ПараметрыВыполнения.Вставить("ОписаниеОшибки",       "");
	ПараметрыВыполнения.Вставить("ЭтоПредупреждение",    Ложь);
	ПараметрыВыполнения.Вставить("ОжидатьПродолжения",   Ложь);
	ПараметрыВыполнения.Вставить("Оповещение",           Новый ОписаниеОповещения(
		"ПроверитьНаСторонеКлиентаПослеДополнительнойПроверки", ЭтотОбъект, Контекст));
	
	Контекст.Вставить("ПараметрыВыполнения", ПараметрыВыполнения);
	
	Попытка
		ЭлектроннаяПодписьКлиентПереопределяемый.ПриДополнительнойПроверкеСертификата(ПараметрыВыполнения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПараметрыВыполнения.ОжидатьПродолжения = Ложь;
		ПараметрыВыполнения.ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Если ПараметрыВыполнения.ОжидатьПродолжения <> Истина Тогда
		ПроверитьНаСторонеКлиентаПослеДополнительнойПроверки(, Контекст);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение процедуры ПроверитьНаСторонеКлиента.
&НаКлиенте
Процедура ПроверитьНаСторонеКлиентаПослеДополнительнойПроверки(Неопределен, Контекст) Экспорт
	
	УстановитьЭлемент(ЭтотОбъект, Контекст.ЭлементСписка.Значение, Ложь,
		Контекст.ПараметрыВыполнения.ОписаниеОшибки,
		Контекст.ПараметрыВыполнения.ЭтоПредупреждение <> Истина);
	
	ПроверитьНаСторонеКлиентаЦиклНачало(Контекст);
	
КонецПроцедуры


&НаСервере
Процедура ПроверитьНаСторонеСервера(Знач ЗначениеПароля)
	
	ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
	
	Попытка
		СертификатКриптографии = Новый СертификатКриптографии(ДанныеСертификата);
		ОписаниеОшибки = "";
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		УстановитьЭлемент(ЭтотОбъект, ИмяПервойПроверки, Истина, ОписаниеОшибки, Истина);
		Возврат;
	КонецЕсли;
	
	// Законный сертификат
	Если СертификатКриптографии.Субъект.Свойство("SN") Тогда
		ОписаниеОшибки = "";
	Иначе
		ОписаниеОшибки = НСтр("ru = 'В описании субъекта сертификата не найдено поле ""SN"".'");
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "ЗаконныйСертификат", Истина, ОписаниеОшибки);
	
	// Наличие сертификата в личном списке.
	Результат = Новый Структура;
	ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(Base64Строка(СертификатКриптографии.Отпечаток),
		Истина, Ложь, , Результат);
	Если ЗначениеЗаполнено(Результат) Тогда
		ОписаниеОшибки = Результат.ОписаниеОшибки + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи и расшифровки не могут быть выполнены.'");
	Иначе
		ОписаниеОшибки = "";
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "НаличиеСертификата", Истина, ОписаниеОшибки);
	
	// Проверка данных сертификата.
	ОписаниеОшибки = "";
	МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("ПроверкаСертификата",
		Ложь, ОписаниеОшибки);
	
	Если Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ЭлектроннаяПодпись.ПроверитьСертификат(МенеджерКриптографии, СертификатКриптографии, ОписаниеОшибки);
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "ДанныеСертификата", Истина, ОписаниеОшибки, Истина);
	
	// Наличие программы
	Если ЗначениеЗаполнено(Программа) Тогда
		ОписаниеОшибки = "";
		МенеджерКриптографии = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии("",
			Ложь, ОписаниеОшибки, Программа);
	Иначе
		МенеджерКриптографии = Неопределено;
		ОписаниеОшибки = НСтр("ru = 'Программа для использования закрытого ключа не указана в сертификате.'");
	КонецЕсли;
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Символы.ПС
			+ НСтр("ru = 'Проверка подписания, созданной подписи, шифрования и
			             |расшифровки не могут быть выполнены.'");
	КонецЕсли;
	УстановитьЭлемент(ЭтотОбъект, "НаличиеПрограммы", Истина, ОписаниеОшибки, Истина);
	
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = ЗначениеПароля;
	
	// Подписание.
	Если ПроверкиНаСервере.НаличиеСертификата Тогда
		ОписаниеОшибки = "";
		Попытка
			ДанныеПодписи = МенеджерКриптографии.Подписать(ДанныеСертификата, СертификатКриптографии);
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеДанныеПодписи(ДанныеПодписи, ОписаниеОшибки);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		Если Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			ПарольПринят = Истина;
		КонецЕсли;
		УстановитьЭлемент(ЭтотОбъект, "Подписание", Истина, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	// Проверка подписи.
	Если ПроверкиНаСервере.НаличиеСертификата И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОписаниеОшибки = "";
		Попытка
			МенеджерКриптографии.ПроверитьПодпись(ДанныеСертификата, ДанныеПодписи);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		УстановитьЭлемент(ЭтотОбъект, "ПроверкаПодписи", Истина, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	// Шифрование.
	ОписаниеОшибки = "";
	Попытка
		ЗашифрованныеДанные = МенеджерКриптографии.Зашифровать(ДанныеСертификата, СертификатКриптографии);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	УстановитьЭлемент(ЭтотОбъект, "Шифрование", Истина, ОписаниеОшибки, Истина);
	
	// Расшифровка.
	Если ПроверкиНаСервере.НаличиеСертификата И Не ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОписаниеОшибки = "";
		Попытка
			РасшифрованныеДанные = МенеджерКриптографии.Расшифровать(ЗашифрованныеДанные);
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ПустыеРасшифрованныеДанные(РасшифрованныеДанные, ОписаниеОшибки);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		УстановитьЭлемент(ЭтотОбъект, "Расшифровка", Истина, ОписаниеОшибки, Истина);
	КонецЕсли;
	
	ПроверитьНаСторонеСервераДополнительныеПроверки(МенеджерКриптографии);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаСторонеСервераДополнительныеПроверки(МенеджерКриптографии = Неопределено)
	
	// Дополнительные проверки.
	Для каждого ЭлементСписка Из ДополнительныеПроверки Цикл
		ОписаниеОшибки = "";
		ЭтоПредупреждение = Ложь;
		Попытка
			ЭлектроннаяПодписьПереопределяемый.ПриДополнительнойПроверкеСертификата(Сертификат,
				ЭлементСписка.Значение, МенеджерКриптографии, ОписаниеОшибки, ЭтоПредупреждение);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		УстановитьЭлемент(ЭтотОбъект, ЭлементСписка.Значение, Истина, ОписаниеОшибки, ЭтоПредупреждение <> Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЭлемент(Форма, НачалоЭлемента, НаСервере, ОписаниеОшибки = Неопределено, ЭтоОшибка = Ложь)
	
	ЭлементКартинка = Форма.Элементы[НачалоЭлемента + ?(НаСервере, "НаСервере", "НаКлиенте") + "Картинка"];
	Проверки = Форма["Проверки" + ?(НаСервере, "НаСервере", "НаКлиенте")];
	
	Если ОписаниеОшибки = Неопределено Тогда
		ЭлементКартинка.Картинка    = Новый Картинка;
		ЭлементКартинка.Подсказка   = НСтр("ru = 'Проверка не выполнялась.'");
		Проверки.Вставить(НачалоЭлемента, Неопределено);
		
	ИначеЕсли ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ЭлементКартинка.Картинка    = ?(ЭтоОшибка, БиблиотекаКартинок.Ошибка32, БиблиотекаКартинок.Предупреждение32);
		ЭлементКартинка.Подсказка   = ОписаниеОшибки;
		Проверки.Вставить(НачалоЭлемента, Ложь);
	Иначе
		ЭлементКартинка.Картинка    = БиблиотекаКартинок.Успешно32;
		ЭлементКартинка.Подсказка   = НСтр("ru = 'Проверка выполнена успешно.'");;
		Проверки.Вставить(НачалоЭлемента, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
