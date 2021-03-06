﻿
// Возвращает основной вид работ пользователя из настроек учета времени.
//
Функция ПолучитьОсновнойВидРабот() Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "ВидРабот");

КонецФункции

// Возвращает способ указания времени пользователя из настроек учета времени.
//
Функция ПолучитьСпособУказанияВремени() Экспорт 
	
	СпособУказанияВремени = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "СпособУказанияВремени");
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
	КонецЕсли;
	
	Возврат СпособУказанияВремени;
	
КонецФункции	

// Создает запись в регистре сведений ХронометражРабочегоВремениПользователей
Процедура СоздатьЗаписьХронометража(Объект, ДатаНачала) Экспорт
	
	// Создать набор записей
	НаборЗаписей = РегистрыСведений.ХронометражРабочегоВремениПользователей.СоздатьНаборЗаписей();
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
	НаборЗаписей.Отбор.Объект.Установить(Объект);

	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Пользователь = ТекущийПользователь;
	НоваяЗапись.Объект = Объект;
	НоваяЗапись.ВремяНачала = ДатаНачала;
	НоваяЗапись.ВремяОкончания = '00010101';
	НаборЗаписей.Записать();
КонецПроцедуры	

// Очистить хронометраж
Процедура ОчиститьХронометраж(Объект) Экспорт
	// Создать набор записей  - пустой - чтобы очистить регистр сведений
	НаборЗаписей = РегистрыСведений.ХронометражРабочегоВремениПользователей.СоздатьНаборЗаписей();
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
	НаборЗаписей.Отбор.Объект.Установить(Объект);
	НаборЗаписей.Записать();
КонецПроцедуры	

// добавляет в отчет за дату
Процедура ДобавитьВОтчет(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	ПараметрыОповещения = Новый Структура;
	
	// Создать набор записей  - пустой - чтобы очистить регистр сведений
	НаборЗаписей = РегистрыСведений.ХронометражРабочегоВремениПользователей.СоздатьНаборЗаписей();
	
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
	НаборЗаписей.Отбор.Объект.Установить(ПараметрыОтчета.Объект);
	НаборЗаписей.Записать();
	
	
	// запись в регистр ФактическиеТрудозатраты
	МенеджерЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ДатаДобавления	= ПараметрыОтчета.ДатаОтчета;
	МенеджерЗаписи.Пользователь 	= ТекущийПользователь;
	МенеджерЗаписи.Подразделение	= РаботаСПользователями.ПолучитьПодразделение(ТекущийПользователь);
	МенеджерЗаписи.ВидРабот 		= ПараметрыОтчета.ВидРаботы;
	МенеджерЗаписи.ОписаниеРаботы 	= ПараметрыОтчета.ОписаниеРаботы;
	МенеджерЗаписи.Источник 		= ПараметрыОтчета.Объект;
		
	Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
		
		Если ПараметрыОтчета.Свойство("Проект") И ПараметрыОтчета.Свойство("ПроектнаяЗадача") Тогда 
			
			Проект = ПараметрыОтчета.Проект;
			ПроектнаяЗадача = ПараметрыОтчета.ПроектнаяЗадача;
			
		Иначе	
			Объект = ПараметрыОтчета.Объект;
			
			Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
				Проект = Объект.Проект;
				ПроектнаяЗадача = Объект.ПроектнаяЗадача;
				
			ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Проекты") Тогда
				Проект = Объект;
				ПроектнаяЗадача = Неопределено;
				
			ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
				Проект = Объект.Владелец;
				ПроектнаяЗадача = Объект;
				
			ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(Объект) 
				Или ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Объект)
				Или ТипЗнч(Объект) = Тип("СправочникСсылка.Мероприятия") 
				Или ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда 
				
				Проект = Объект.Проект;
				ПроектнаяЗадача = Неопределено;
				
			КонецЕсли; 
			
			ПараметрыОтчета.Вставить("Проект", Проект);
			ПараметрыОтчета.Вставить("ПроектнаяЗадача", ПроектнаяЗадача);
			
		КонецЕсли;	
		
		МенеджерЗаписи.Проект = Проект;
		МенеджерЗаписи.ПроектнаяЗадача = ПроектнаяЗадача;
		
	КонецЕсли;	
	
	СпособУказанияВремени = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени", "СпособУказанияВремени");
	Если Не ЗначениеЗаполнено(СпособУказанияВремени) Тогда
		СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность;
	КонецЕсли;
	
	Если СпособУказанияВремени = Перечисления.СпособыУказанияВремени.Длительность Тогда
		МенеджерЗаписи.Длительность = ПараметрыОтчета.ДлительностьРаботы;
	Иначе
		МенеджерЗаписи.Начало = ПараметрыОтчета.НачалоРаботы;
		МенеджерЗаписи.Окончание = ПараметрыОтчета.ОкончаниеРаботы;
		МенеджерЗаписи.Длительность = МенеджерЗаписи.Окончание - МенеджерЗаписи.Начало;
	КонецЕсли;
	
	МенеджерЗаписи.НомерДобавления = МаксимальныйНомерДобавления(
		МенеджерЗаписи.Подразделение, МенеджерЗаписи.Пользователь, МенеджерЗаписи.ДатаДобавления);
	МенеджерЗаписи.Записать();
	
	ЗначенияКлюча = Новый Структура("Подразделение, Пользователь, Источник, Проект, ПроектнаяЗадача, ВидРабот, УдалитьОписаниеРаботы, ДатаДобавления, НомерДобавления, Начало, Окончание");
	ЗаполнитьЗначенияСвойств(ЗначенияКлюча, МенеджерЗаписи);
	КлючЗаписи = РегистрыСведений.ФактическиеТрудозатраты.СоздатьКлючЗаписи(ЗначенияКлюча);
	
	ПараметрыОповещения.Вставить("КлючЗаписи", КлючЗаписи);
	ПараметрыОповещения.Вставить("Представление", МенеджерЗаписи.ОписаниеРаботы);
	
	Если ТипЗнч(ПараметрыОтчета.Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ПараметрыОповещения.Вставить("Изменение_ФактическиеТрудозатратыЗадачи", ПараметрыОтчета.Объект);
	КонецЕсли;	
		
	Если ПараметрыОтчета.Свойство("ПроектнаяЗадача") И ЗначениеЗаполнено(ПараметрыОтчета.ПроектнаяЗадача) Тогда 
		ПараметрыОповещения.Вставить("Изменение_ФактическиеТрудозатратыПроектнойЗадачи", ПараметрыОтчета.ПроектнаяЗадача);
	КонецЕсли;
	
КонецПроцедуры	

// находит первую запись в регистре ХронометражРабочегоВремениПользователей с пустой датой окончания (00010101)
Процедура НайтиДатыХронометража(Объект, ДатаНачалаХронометража, ДатаКонцаХронометража) Экспорт
	
	Исполнитель = ПользователиКлиентСервер.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Хронометраж.ВремяНачала КАК ВремяНачала,
	|	Хронометраж.ВремяОкончания КАК ВремяОкончания
	|ИЗ
	|	РегистрСведений.ХронометражРабочегоВремениПользователей КАК Хронометраж
	|ГДЕ
	|	Хронометраж.Пользователь = &ТекущийПользователь
	|	И Хронометраж.Объект = &Объект";
	
	Запрос.УстановитьПараметр("ТекущийПользователь", Исполнитель);
	Запрос.УстановитьПараметр("Объект", Объект);
	
	РезультатЗапроса = Запрос.Выполнить(); 
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		ДатаНачалаХронометража = Выборка.ВремяНачала;
		ДатаКонцаХронометража = Выборка.ВремяОкончания;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьВидыРабот(ТочкаМаршрута)
	
	ВидыРабот = Новый СписокЗначений;
	
	ЗапросВРегистр = Новый Запрос;
	ЗапросВРегистр.УстановитьПараметр("ТочкаМаршрута", ТочкаМаршрута);
	
	ЗапросВРегистр.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                       |	СведенияОТочкахМаршрута.ВидРаботы КАК ВидРаботы
	                       |ИЗ
	                       |	РегистрСведений.СведенияОТочкахМаршрута КАК СведенияОТочкахМаршрута
	                       |ГДЕ
	                       |	СведенияОТочкахМаршрута.ТочкаМаршрута = &ТочкаМаршрута";
	
	РезультатЗапроса = ЗапросВРегистр.Выполнить(); 
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ВидыРабот.Добавить(Выборка.ВидРаботы);
	КонецЦикла;
	
	Возврат ВидыРабот;
КонецФункции	

// Находит еж отчет и берет из него СпособУказанияВремени
Функция ПолучитьСпособУказанияВремениИзОтчета(Объект)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЕжедневныйОтчет.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЕжедневныйОтчет КАК ЕжедневныйОтчет
	|ГДЕ
	|	ЕжедневныйОтчет.Пользователь = &Пользователь
	|	И НАЧАЛОПЕРИОДА(ЕжедневныйОтчет.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)";
	
	ДатаОтчета = ТекущаяДатаСеанса();
	Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, "Выполнена, ДатаИсполнения");
		
		Если РеквизитыОбъекта.Выполнена  Тогда
			ДатаОтчета = РеквизитыОбъекта.ДатаИсполнения;
		КонецЕсли;
	КонецЕсли;	
	
	Исполнитель = ПользователиКлиентСервер.ТекущийПользователь();
	
	Запрос.УстановитьПараметр("Дата", ДатаОтчета);
	Запрос.УстановитьПараметр("Пользователь", Исполнитель);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЕжедневныйОтчет = Документы.ЕжедневныйОтчет.ПустаяСсылка();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка.СпособУказанияВремени;
	Иначе
		Возврат ПолучитьСпособУказанияВремени();
	КонецЕсли;
	
КонецФункции	

// Заполнить параметры - ДатаНачалаХронометража и ВидРаботы
Процедура ПолучитьПараметрыХронометража(Объект, ВключенХронометраж, ДатаНачалаХронометража, ДатаКонцаХронометража, 
	ВидыРабот, СпособУказанияВремени) Экспорт
	
	ДатаНачалаХронометража = '00010101000000';
	НайтиДатыХронометража(Объект, ДатаНачалаХронометража, ДатаКонцаХронометража);
	Если ДатаНачалаХронометража <> '00010101000000' И ДатаКонцаХронометража = '00010101000000' Тогда
		ВключенХронометраж = Истина;
	Иначе
		ВключенХронометраж = Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
		ВидыРабот = ПолучитьВидыРабот(Объект.ТочкаМаршрута);
	Иначе	
		ВидыРабот = Новый СписокЗначений;
	КонецЕсли;	
	
	СпособУказанияВремени = ПолучитьСпособУказанияВремениИзОтчета(Объект);
КонецПроцедуры	

// В форме инициализирует параметры в ПриСозданииНаСервере
Процедура ПроинициализироватьПараметрыУчетаВремени(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	ОпцияВестиУчетТрудозатрат,
	Ссылка,
	ВидыРабот,
	СпособУказанияВремени,
	КомандаПереключитьХронометраж,
	ЭлементПереключитьХронометраж,
	ЭлементДобавитьВОтчет) Экспорт
	
	ДатаНачалаХронометража = '00010101';
	ДатаКонцаХронометража = '00010101';
	ВключенХронометраж = Ложь;
	
	ОпцияВестиУчетТрудозатрат = ПолучитьФункциональнуюОпцию("ВестиУчетФактическихТрудозатрат")
		И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ФактическиеТрудозатраты);
	Если ОпцияВестиУчетТрудозатрат Тогда
		ПолучитьПараметрыХронометража(Ссылка, ВключенХронометраж, ДатаНачалаХронометража, ДатаКонцаХронометража, ВидыРабот, СпособУказанияВремени);
	КонецЕсли;

	УстановитьСвойстваЭлементов(ВключенХронометраж, КомандаПереключитьХронометраж, ЭлементПереключитьХронометраж);
	
	Если ТипЗнч(Ссылка) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		РеквизитыСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
			"Выполнена, Исполнитель, РольИсполнителя");
		
		Если РеквизитыСсылки.Выполнена Тогда
			ЭлементПереключитьХронометраж.Видимость = Ложь;
		КонецЕсли;
		
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		ИсполнителиЗадач = БизнесПроцессыИЗадачиСервер.ИсполнителиЗадачПользователя(ТекущийПользователь);
		
		Если ЗначениеЗаполнено(РеквизитыСсылки.Исполнитель) Тогда
			Если ИсполнителиЗадач.Найти(РеквизитыСсылки.Исполнитель) = Неопределено Тогда
				ЭлементПереключитьХронометраж.Доступность = Ложь;
				ЭлементДобавитьВОтчет.Доступность = Ложь;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(РеквизитыСсылки.РольИсполнителя) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	ИсполнителиЗадач.Исполнитель
				|ИЗ
				|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
				|ГДЕ
				|	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
				|	И ИсполнителиЗадач.Исполнитель В(&Исполнители)";
			Запрос.УстановитьПараметр("РольИсполнителя", РеквизитыСсылки.РольИсполнителя);
			Запрос.УстановитьПараметр("Исполнители", ИсполнителиЗадач);
			
			ПользователюНЕДоступнаРольЗадачи = Запрос.Выполнить().Пустой();
			
			Если ПользователюНЕДоступнаРольЗадачи Тогда
				ЭлементПереключитьХронометраж.Доступность = Ложь;
				ЭлементДобавитьВОтчет.Доступность = Ложь;
			КонецЕсли;	
		Иначе
			ЭлементПереключитьХронометраж.Доступность = Ложь;
			ЭлементДобавитьВОтчет.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// В форме инициализирует параметры в ПриСозданииНаСервере
Процедура ПроинициализироватьПараметрыИНачатьХронометраж(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	ОпцияВестиУчетТрудозатрат,
	Ссылка,
	СпособУказанияВремени,
	ВидыРабот) Экспорт
	
	ДатаНачалаХронометража = '00010101000000';
	ДатаКонцаХронометража = '00010101000000';
	ВключенХронометраж = Ложь;
	ВидыРабот = Новый СписокЗначений;
	
	ОпцияВестиУчетТрудозатрат = ПолучитьФункциональнуюОпцию("ВестиУчетФактическихТрудозатрат")
		И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ФактическиеТрудозатраты);
	Если ОпцияВестиУчетТрудозатрат Тогда
		
		СпособУказанияВремени = ПолучитьСпособУказанияВремениИзОтчета(Ссылка);
		ВключенХронометраж = Истина;
		
	КонецЕсли;

КонецПроцедуры

// Устанавливает свойства - подсказка и пометка элементам формы
Процедура УстановитьСвойстваЭлементов(
	ВключенХронометраж, 
	КомандаПереключитьХронометраж, 
	ЭлементПереключитьХронометраж) Экспорт
	
	Если ВключенХронометраж Тогда // хронометраж включен
		КомандаПереключитьХронометраж.Подсказка = НСтр("ru = 'Закончить хронометраж'");
		ЭлементПереключитьХронометраж.Пометка = Истина;
	Иначе
		КомандаПереключитьХронометраж.Подсказка = НСтр("ru = 'Включить хронометраж'");
		ЭлементПереключитьХронометраж.Пометка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// переключает хронометраж, когда не нужно показывать диалог
Процедура ПереключитьХронометражСервер(
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект,
	ВидыРабот,
	КомандаПереключитьХронометраж,
	ЭлементПереключитьХронометраж) Экспорт

	ПереключитьХронометраж(
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		Объект,
		ВидыРабот);
	
	УстановитьСвойстваЭлементов(ВключенХронометраж, КомандаПереключитьХронометраж, ЭлементПереключитьХронометраж);
	
КонецПроцедуры

// переключает хронометраж, когда не нужно показывать диалог
Процедура ПереключитьХронометраж(
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект,
	ВидыРабот = Неопределено) Экспорт

	Если Не ВключенХронометраж Тогда // создаем новую запись
		
		ДатаНачалаХронометража = ТекущаяДатаСеанса();
		ДатаКонцаХронометража = '00010101';
		СоздатьЗаписьХронометража(Объект, ДатаНачалаХронометража);
		ВключенХронометраж = Истина;
		
	Иначе
		
		ВидРаботы = Неопределено;
        
		Если ВидыРабот <> Неопределено И ВидыРабот.Количество() <> 0 Тогда
			ВидРаботы = ВидыРабот[0].Значение;
		КонецЕсли;
		
		КонецХронометража = ТекущаяДатаСеанса();
		ДлительностьРаботы = КонецХронометража - ДатаНачалаХронометража;
		
		Если ДлительностьРаботы >= 60 Тогда // больше 1 минуты
			ПараметрыОтчета = Новый Структура();
			ПараметрыОтчета.Вставить("ДатаОтчета", ТекущаяДатаСеанса());
			ПараметрыОтчета.Вставить("ВидРаботы", ВидРаботы);
			ПараметрыОтчета.Вставить("ОписаниеРаботы", Строка(Объект));
			ПараметрыОтчета.Вставить("ДлительностьРаботы", ДлительностьРаботы);
			ПараметрыОтчета.Вставить("НачалоРаботы", ДатаНачалаХронометража);
			ПараметрыОтчета.Вставить("ОкончаниеРаботы", КонецХронометража);
			ПараметрыОтчета.Вставить("Объект", Объект);
			
			Источник = Объект;
			Если ПолучитьФункциональнуюОпцию("ВестиУчетПоПроектам") Тогда 
				Проект = Неопределено;
				ПроектнаяЗадача = Неопределено;
				
				Если ТипЗнч(Источник) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда 
					РеквизитыЗадачи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Источник,
						"Проект, ПроектнаяЗадача");
					Проект = РеквизитыЗадачи.Проект;
					ПроектнаяЗадача = РеквизитыЗадачи.ПроектнаяЗадача;
				ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.Проекты") Тогда
					Проект = Источник;
					ПроектнаяЗадача = Неопределено;
				ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
					Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник, "Владелец");
					ПроектнаяЗадача = Источник;
				ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.Контроль") Тогда
					Предмет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник, "Предмет");
					
					Если ЗначениеЗаполнено(Предмет) Тогда  
						Если ТипЗнч(Предмет) = Тип("СправочникСсылка.Проекты") Тогда
							Проект = Предмет;
							ПроектнаяЗадача = Неопределено;
						ИначеЕсли ТипЗнч(Предмет) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
							Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "Владелец");
							ПроектнаяЗадача = Предмет;
						ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(Предмет.Метаданные()) Тогда
							Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "Проект");
							ПроектнаяЗадача = Предмет.ПроектнаяЗадача;
						ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(Предмет) 
							Или ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Предмет)
							Или ТипЗнч(Предмет) = Тип("СправочникСсылка.Мероприятия") 
							Или ТипЗнч(Предмет) = Тип("СправочникСсылка.Файлы") Тогда 
							Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Предмет, "Проект");
							ПроектнаяЗадача = Неопределено;
						КонецЕсли;	
		  			КонецЕсли;	
				ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоДокумент(Источник) 
					Или ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Источник)
					Или ТипЗнч(Источник) = Тип("СправочникСсылка.Мероприятия")
					Или ТипЗнч(Источник) = Тип("СправочникСсылка.Файлы") Тогда 
					
					Проект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник, "Проект");
					ПроектнаяЗадача = Неопределено;
				КонецЕсли; 
				
				ПараметрыОтчета.Вставить("Проект", Проект);
				ПараметрыОтчета.Вставить("ПроектнаяЗадача", ПроектнаяЗадача);
			КонецЕсли;
			
			
			ДобавитьВОтчет(ПараметрыОтчета, ПараметрыОповещения);
		Иначе
			ОчиститьХронометраж(Объект);
		КонецЕсли;
		
		ДатаНачалаХронометража = '00010101';
		ДатаКонцаХронометража = '00010101';
		ВключенХронометраж = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

// Отключает хронометраж и делает обновление элементов формы при выключении хронометража
Процедура ОтключитьХронометражСервер(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Задача,
	КомандаПереключитьХронометраж,
	ЭлементПереключитьХронометраж) Экспорт
	
	ОчиститьХронометраж(Задача);
	
	ДатаНачалаХронометража = '00010101000000';
	ДатаКонцаХронометража = '00010101000000';
	ВключенХронометраж = Ложь;
	
	УстановитьСвойстваЭлементов(ВключенХронометраж, КомандаПереключитьХронометраж, ЭлементПереключитьХронометраж);
	
КонецПроцедуры

// Отключает хронометраж
Процедура ОтключитьХронометражСерверБезЭлементов(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Задача) Экспорт
	
	ОчиститьХронометраж(Задача);
	
	ДатаНачалаХронометража = '00010101000000';
	ДатаКонцаХронометража = '00010101000000';
	ВключенХронометраж = Ложь;
	
КонецПроцедуры

// Инициализирует персональные настройки учета времени - для использования на клиенте
Функция ПолучитьПерсональныеНастройкиУчетаВремениСервер() Экспорт
	
	Настройки = Новый Структура;
	ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи = ХранилищеОбщихНастроек.Загрузить("НастройкиУчетаВремени",
		"ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи");
		
	Если Не ЗначениеЗаполнено(ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи) Тогда
		ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи = Ложь;
		ХранилищеОбщихНастроек.Сохранить("НастройкиУчетаВремени", 
			"ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи",
			ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи);
	КонецЕсли;
	
	Настройки.Вставить("ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи",
		ДобавлятьРаботуВЕжедневныйОтчетПриВыполненииЗадачи);
	
	Возврат Настройки; // параметры доступны только для чтения
	
КонецФункции

// Выполняет обновление элементов формы при выключении хронометража
Процедура ДобавитьВОтчетИОбновитьФорму(
	ПараметрыОтчета, 
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	КомандаПереключитьХронометраж,
	ЭлементПереключитьХронометраж) Экспорт
	
	ДобавитьВОтчет(ПараметрыОтчета, ПараметрыОповещения);
	
	ДатаНачалаХронометража = '00010101';
	ДатаКонцаХронометража = '00010101';
	ВключенХронометраж = Ложь;
	
	УстановитьСвойстваЭлементов(ВключенХронометраж, КомандаПереключитьХронометраж, ЭлементПереключитьХронометраж);
	
КонецПроцедуры

Функция НеобходимоПоказатьДиалогВводаТрудозатрат(ЗадачаСсылка) Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ВестиУчетПлановыхТрудозатратВБизнесПроцессах")
		И РаботаСБизнесПроцессамиВызовСервера.ПолучитьФактическиеТрудозатратыПоЗадаче(ЗадачаСсылка) = 0;
	
КонецФункции

Функция ЕстьЕжедневныеОтчетыНаДату(Пользователь, НаДату) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕжедневныйОтчет.Ссылка
	|ИЗ
	|	Документ.ЕжедневныйОтчет КАК ЕжедневныйОтчет
	|ГДЕ
	|	ЕжедневныйОтчет.Пользователь = &Пользователь
	|	И НАЧАЛОПЕРИОДА(ЕжедневныйОтчет.Дата, ДЕНЬ) = НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ)
	|	И ЕжедневныйОтчет.Проведен";
	
	Запрос.УстановитьПараметр("Дата", НаДату);
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция МаксимальныйНомерДобавления(Подразделение, пользователь, ДатаДобавления) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ФактическиеТрудозатраты.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Подразделение.Установить(Подразделение);
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Отбор.ДатаДобавления.Установить(ДатаДобавления);
	НаборЗаписей.Прочитать();
	
	МаксНомерДобавления = 0;
	Если НаборЗаписей.Количество() > 0 Тогда 
		ТаблицаНабора = НаборЗаписей.Выгрузить();
		ТаблицаНабора.Сортировать("НомерДобавления Убыв");
		МаксНомерДобавления = ТаблицаНабора[0].НомерДобавления + 1;
	КонецЕсли;	
	
	Возврат МаксНомерДобавления;
	
КонецФункции	

Функция ПолучитьДанныеАвтоподбораРабот(Текст, Пользователь) Экспорт 
	
	ПериодВыборки = Новый СтандартныйПериод;
	
	ВариантПериодаВыборки = ХранилищеОбщихНастроек.Загрузить("НастройкиПодбораРабот", "ВариантПериодаВыборки");
	Если ЗначениеЗаполнено(ВариантПериодаВыборки) Тогда 
		ПериодВыборки.Вариант = ВариантПериодаВыборки;
	Иначе	
		ПериодВыборки.Вариант = ВариантСтандартногоПериода.Месяц;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФактическиеТрудозатраты.ВидРабот КАК ВидРабот,
	|	ВЫРАЗИТЬ(ФактическиеТрудозатраты.ОписаниеРаботы КАК СТРОКА(500)) КАК Работа,
	|	ФактическиеТрудозатраты.Проект КАК Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача КАК ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.Источник КАК Источник
	|ИЗ
	|	РегистрСведений.ФактическиеТрудозатраты КАК ФактическиеТрудозатраты
	|ГДЕ
	|	ФактическиеТрудозатраты.ДатаДобавления МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ФактическиеТрудозатраты.Пользователь = &Пользователь
	|	И ФактическиеТрудозатраты.ОписаниеРаботы ПОДОБНО &Текст
	|	И НЕ ФактическиеТрудозатраты.Удалена
	|
	|СГРУППИРОВАТЬ ПО
	|	ФактическиеТрудозатраты.Проект,
	|	ФактическиеТрудозатраты.ПроектнаяЗадача,
	|	ФактическиеТрудозатраты.Источник,
	|	ФактическиеТрудозатраты.ВидРабот,
	|	ВЫРАЗИТЬ(ФактическиеТрудозатраты.ОписаниеРаботы КАК СТРОКА(500))";
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("ДатаНачала", ПериодВыборки.ДатаНачала);
	
	Если ЗначениеЗаполнено(ПериодВыборки.ДатаОкончания) Тогда 
		Запрос.УстановитьПараметр("ДатаОкончания", ПериодВыборки.ДатаОкончания);
	Иначе
		Запрос.УстановитьПараметр("ДатаОкончания", '39990101');
	КонецЕсли;	
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Параметр = Новый Структура;
		Параметр.Вставить("Работа",	  Выборка.Работа);
		Параметр.Вставить("ВидРабот", Выборка.ВидРабот);
		Параметр.Вставить("Проект",   Выборка.Проект);
		Параметр.Вставить("ПроектнаяЗадача", Выборка.ПроектнаяЗадача);
		Параметр.Вставить("Источник", Выборка.Источник);
		
		ДанныеВыбора.Добавить(Параметр, Параметр.Работа);
		
	КонецЦикла;	
	
	Возврат ДанныеВыбора;
	
КонецФункции
