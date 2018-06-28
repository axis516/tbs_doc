﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает признак наличия метода ИзменитьРеквизитыНевыполненныхЗадач
//
Функция ЕстьМетодИзменитьРеквизитыНевыполненныхЗадач() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Заполняет бизнес-процесс на основании проектной задачи
//
Процедура ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения) Экспорт 
	
	Проект = ДанныеЗаполнения.Владелец;
	ПроектнаяЗадача = ДанныеЗаполнения;
	
	НаименованиеПоУмолчанию = МультипредметностьКлиентСервер.ПолучитьНаименованиеСПредметами(
		НСтр("ru = 'Обработка исходящего'") + " ", Предметы);
	
	Если Не ЗначениеЗаполнено(Наименование) Или Наименование = НаименованиеПоУмолчанию Тогда
		Наименование = ПроектнаяЗадача.Наименование;
	КонецЕсли;

	Если Предметы.Количество() = 0 Тогда 
		Предмет = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроектнаяЗадача, "Предмет");
		
		Если Предмет <> Неопределено И Предметы.Найти(Предмет,"Предмет") = Неопределено Тогда
			СтрокаПредметов = Предметы.Добавить();
			СтрокаПредметов.РольПредмета = Перечисления.РолиПредметов.Основной;
			СтрокаПредметов.ИмяПредмета =  МультипредметностьВызовСервера.ПолучитьСсылкуНаИмяПредметаПоСсылкеНаПредмет(
				Предмет, Предметы.ВыгрузитьКолонку("ИмяПредмета"));
			СтрокаПредметов.Предмет = Предмет;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_Предметы

// Проверяет права участников процесса на предметы этого процесса.
// Если у участников процесса отсутствуют права на предметы, то выводятся сообщения с привязкой
// к карточке процесса.
//
// Параметры
//  ПроцессОбъект - БизнесПроцессОбъект - процесс.
//  Отказ - Булево - в этот параметр помещается значение Истина, если кто-то из участников не имеет
//                   прав на предметы.
//  ПроверятьПриИзменении - Булево - если указано значение Истина, то проверка выполняется только если
//                          изменены участники или предметы процесса, иначе проверка выполняется всегда.
//
Процедура ПроверитьПраваУчастниковПроцессаНаПредметы(
	ПроцессОбъект, Отказ, ПроверятьПриИзменении) Экспорт
	
	Мультипредметность.ПроверитьПраваУчастниковПроцессаНаПредметы(
		ПроцессОбъект, Отказ, ПроверятьПриИзменении);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//Код процедур и функций
#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата = ТекущаяДатаСеанса();
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	ДатаНачала = '00010101';
	ДатаЗавершения = '00010101';
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если ЭтоНовый() Тогда 
		Дата = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(Автор) Тогда
			Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Проект) Тогда 
			Проект = РаботаСПроектами.ПолучитьПроектПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения, Ложь, Истина);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		ЗадачаСсылка = ДанныеЗаполнения;
		ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ДанныеЗаполнения.Шаблон, ЭтотОбъект);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Предметы") Тогда
			Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ДанныеЗаполнения.Предметы, Ложь, Истина);
			Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ДанныеЗаполнения.Предметы);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("АвторСобытия") Тогда
			Автор = ДанныеЗаполнения.АвторСобытия;
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Шаблон") Тогда
			ЗаполнитьПоШаблону(ДанныеЗаполнения.Шаблон);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ЗадачаИсполнителя") Тогда
			ЗадачаСсылка = ДанныеЗаполнения.ЗадачаИсполнителя;
			ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("ПроектнаяЗадача") Тогда
			ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения.ПроектнаяЗадача);
		КонецЕсли;
		
		Если ДанныеЗаполнения.Свойство("Проект") Тогда
			Проект = ДанныеЗаполнения.Проект;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда 
		ЗаполнитьПоПроектнойЗадаче(ДанныеЗаполнения);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) И Предметы.Количество() > 0 Тогда
		МультипредметностьКлиентСервер.ЗаполнитьНаименованиеПроцесса(ЭтотОбъект, НСтр("ru = 'Обработка исходящего'") + " ");
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Мультипредметность.ПроверитьКорректностьТиповОсновныхПредметов(ЭтотОбъект, Отказ);
	
	Если Не ЗначениеЗаполнено(ШаблонСогласования) И Не ЗначениеЗаполнено(ШаблонУтверждения) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите шаблон согласования или шаблон утверждения!'"),,,,Отказ);
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ШаблонСогласования) И ШаблонСогласования.Исполнители.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'В шаблоне согласования не указаны исполнители.'"), ЭтотОбъект, "ШаблонСогласования",,Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонУтверждения) И Не ЗначениеЗаполнено(ШаблонУтверждения.Исполнитель) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'В шаблоне утверждения не указан исполнитель.'"), ЭтотОбъект, "ШаблонУтверждения",,Отказ);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ШаблонРегистрации) И Не ЗначениеЗаполнено(ШаблонРегистрации.Исполнитель) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'В шаблоне регистрации не указан исполнитель.'"), ЭтотОбъект, "ШаблонРегистрации",,Отказ);
	КонецЕсли;
	
	// Проверка прав участников процесса на предметы
	Если Не РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		
		ПроверитьПраваУчастниковПроцессаНаПредметы(ЭтотОбъект, Отказ, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбычнаяЗапись = Истина;
	ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов = Ложь;
	
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		
		ОбычнаяЗапись = Ложь;
		
		ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов = 
			(ДополнительныеСвойства.ВидЗаписи = 
			"ЗаписьСОбновлением_Предметов_ПредметовЗадач_Проекта_ОбщегоСпискаПроцессов_РабочихГруппПредметов_РабочихГруппПроцессов_ДопРеквизитовПоПредметам");
		
		Если Не ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбычнаяЗапись Тогда
	
		ПредыдущаяПометкаУдаления = Ложь;
		Если Не Ссылка.Пустая() Тогда
			ПредыдущаяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ПометкаУдаления");
		КонецЕсли;
		ДополнительныеСвойства.Вставить("ПредыдущаяПометкаУдаления", ПредыдущаяПометкаУдаления);
		
		Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
			РаботаСФайламиВызовСервера.ПометитьНаУдалениеПриложенныеФайлы(Ссылка, ПометкаУдаления);
		КонецЕсли;
		
		Если Не РаботаСБизнесПроцессамиВызовСервера.ПроверитьПередЗаписью(ЭтотОбъект) Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбычнаяЗапись Или ТолькоЗаполнениеТаблицыПредметыЗадачИОбновлениеРабочейГруппыПроцессов Тогда
		
		// Обработка рабочей группы	
		РаботаСБизнесПроцессамиВызовСервера.СформироватьРабочуюГруппу(ЭтотОбъект);
		
		// Заполнение табличной части ПредметыЗадач
		Мультипредметность.ЗаполнитьПредметыТочекВложенныхПроцессов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	ДатаЗавершения = ТекущаяДатаСеанса();
	
КонецПроцедуры

// согласование
Процедура НаСогласованиеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = ЗначениеЗаполнено(ШаблонСогласования);
	
КонецПроцедуры

Процедура СогласованиеПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	СогласованиеОбъект = БизнесПроцессы.Согласование.СоздатьБизнесПроцесс();
	
	СогласованиеОбъект.Дата = ТекущаяДатаСеанса();
	СогласованиеОбъект.Автор = Автор;
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонСогласования, СогласованиеОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(СогласованиеОбъект, ЭтотОбъект, Ложь, Истина);
	
	СогласованиеОбъект.Проект = Проект;
	СогласованиеОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
	СогласованиеОбъект.ЗаполнитьПоШаблону(ШаблонСогласования);
	СогласованиеОбъект.Состояние = Состояние;

	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, СогласованиеОбъект);
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = 
		СрокиИсполненияПроцессов.ДатаОтсчетаДляНовогоДействияСоставногоПроцесса(Ссылка);
	
	СрокиИсполненияПроцессов.РассчитатьСрокиСогласования(СогласованиеОбъект, ПараметрыДляРасчетаСроков);
	
	// Проверка прав участников процесса на предметы
	Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		// Проверяем права, если процесс создается/выполняется в рег. задании.
		// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
		МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
	КонецЕсли;
	
	ФормируемыеБизнесПроцессы.Добавить(СогласованиеОбъект);
	
КонецПроцедуры

Процедура СогласованиеПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ведущая задача - Согласовать %1'",
				ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)),
			СтрокаПредметов);
		Задача.Автор = Автор;
		Задача.Проект = Проект;
		Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	КонецЦикла;	
		
КонецПроцедуры

Процедура СогласованПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Если Не ЗначениеЗаполнено(ШаблонСогласования) Тогда 
		Результат = Истина;
	Иначе	
		ВложенныйПроцесс = НайтиВложенныйПроцесс(БизнесПроцессы.ОбработкаИсходящегоДокумента.ТочкиМаршрута.Согласование);
		Результат = БизнесПроцессы.Согласование.ПроцессЗавершилсяУдачно(ВложенныйПроцесс)
				Или БизнесПроцессы.Согласование.ПроцессЗавершилсяУдачноСЗамечаниями(ВложенныйПроцесс);
	КонецЕсли;
		
КонецПроцедуры

// утверждение
Процедура НаУтверждениеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат =	ЗначениеЗаполнено(ШаблонУтверждения);
	
КонецПроцедуры

Процедура УтверждениеПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	УтверждениеОбъект = БизнесПроцессы.Утверждение.СоздатьБизнесПроцесс();
	
	УтверждениеОбъект.Дата = ТекущаяДатаСеанса();
	УтверждениеОбъект.Автор = Автор;
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонУтверждения, УтверждениеОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(УтверждениеОбъект, ЭтотОбъект, Ложь, Истина);
	
	УтверждениеОбъект.Проект = Проект;
	УтверждениеОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
	УтверждениеОбъект.ЗаполнитьПоШаблону(ШаблонУтверждения);
	УтверждениеОбъект.Состояние = Состояние;

	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, УтверждениеОбъект);
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = 
		СрокиИсполненияПроцессов.ДатаОтсчетаДляНовогоДействияСоставногоПроцесса(Ссылка);
	
	СрокиИсполненияПроцессов.РассчитатьСрокиУтверждения(УтверждениеОбъект, ПараметрыДляРасчетаСроков);
	
	// Проверка прав участников процесса на предметы
	Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		// Проверяем права, если процесс создается/выполняется в рег. задании.
		// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
		МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
	КонецЕсли;
	
	ФормируемыеБизнесПроцессы.Добавить(УтверждениеОбъект);
	
КонецПроцедуры

Процедура УтверждениеПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ведущая задача - Утвердить %1'",
				ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)),
			СтрокаПредметов);
		Задача.Автор = Автор;
		Задача.Проект = Проект;
		Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	КонецЦикла;
	
КонецПроцедуры

Процедура УтвержденПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Если Не ЗначениеЗаполнено(ШаблонУтверждения) Тогда 
		Результат = Истина;
	Иначе	
		ВложенныйПроцесс = НайтиВложенныйПроцесс(БизнесПроцессы.ОбработкаИсходящегоДокумента.ТочкиМаршрута.Утверждение);
		Результат = БизнесПроцессы.Утверждение.ПроцессЗавершилсяУдачно(ВложенныйПроцесс);
	КонецЕсли;
	
КонецПроцедуры

// регистрация
Процедура РегистрацияПередСозданиемВложенныхБизнесПроцессов(ТочкаМаршрутаБизнесПроцесса, ФормируемыеБизнесПроцессы, Отказ)
	
	РегистрацияОбъект = БизнесПроцессы.Регистрация.СоздатьБизнесПроцесс();
	
	РегистрацияОбъект.Дата = ТекущаяДатаСеанса();
	РегистрацияОбъект.Автор = Автор;
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонРегистрации, РегистрацияОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(РегистрацияОбъект, ЭтотОбъект, Ложь, Истина);
	
	РегистрацияОбъект.Проект = Проект;
	РегистрацияОбъект.ПроектнаяЗадача = ПроектнаяЗадача;
	РегистрацияОбъект.ЗаполнитьПоШаблону(ШаблонРегистрации);
	РегистрацияОбъект.Состояние = Состояние;

	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЭтотОбъект, РегистрацияОбъект);
	
	ПараметрыДляРасчетаСроков = СрокиИсполненияПроцессов.ПараметрыДляРасчетаСроков();
	ПараметрыДляРасчетаСроков.ДатаОтсчета = 
		СрокиИсполненияПроцессов.ДатаОтсчетаДляНовогоДействияСоставногоПроцесса(Ссылка);
	
	СрокиИсполненияПроцессов.РассчитатьСрокиРегистрации(РегистрацияОбъект, ПараметрыДляРасчетаСроков);
	
	// Проверка прав участников процесса на предметы
	Если РаботаСБизнесПроцессами.ЭтоФоновоеВыполнениеПроцесса() Тогда
		// Проверяем права, если процесс создается/выполняется в рег. задании.
		// В интерактивном режим проверка произойдет в обработчике проверки заполнения подчиненного процесса.
		МультипредметностьКОРП.ПроверитьПраваУчастниковПроцессаИОтправитьУведомления(ЭтотОбъект, Автор);
	КонецЕсли;
	
	ФормируемыеБизнесПроцессы.Добавить(РегистрацияОбъект);
	
КонецПроцедуры

Процедура РегистрацияПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	МассивПредметов = МультипредметностьКлиентСервер.ПолучитьМассивСтруктурПредметовОбъекта(ЭтотОбъект);
	СтрокаПредметов = МультипредметностьКлиентСервер.ПредметыСтрокой(МассивПредметов, Истина, Ложь);
	
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		Задача.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ведущая задача - Зарегистрировать %1'",
				ЛокализацияКонфигурации.КодЯзыкаИсполнителяЗадачи(Задача)),
			СтрокаПредметов);
		Задача.Автор = Автор;
		Задача.Проект = Проект;
		Задача.ПроектнаяЗадача = ПроектнаяЗадача;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

Процедура ЗаполнитьБизнесПроцессПоЗадаче(ЗадачаСсылка)
	
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоЗадаче(ЭтотОбъект, ЗадачаСсылка);
	
	Проект = ЗадачаСсылка.Проект;
	ПроектнаяЗадача = ЗадачаСсылка.ПроектнаяЗадача;
	РаботаСБизнесПроцессамиВызовСервера.СкопироватьЗначенияДопРеквизитов(ЗадачаСсылка, ЭтотОбъект);
		
КонецПроцедуры

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//
Процедура ЗаполнитьПоШаблону(ШаблонБизнесПроцесса) Экспорт
	
	ШаблоныБизнесПроцессов.ЗаполнитьПоШаблонуСоставногоБизнесПроцесса(ШаблонБизнесПроцесса, ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ШаблонДляОтложенногоСтарта", ШаблонБизнесПроцесса);
	
КонецПроцедуры

// Заполняет бизнес-процесс на основании шаблона бизнес-процесса, предмета и автора.
//
// Параметры
//  ШаблонБизнесПроцесса  - шаблон бизнес-процесса
//  Предмет - предмет бизнес-процесса
//  Автор  - автор
//
Процедура ЗаполнитьПоШаблонуИПредмету(ШаблонБизнесПроцесса, ПредметСобытия, АвторСобытия) Экспорт
	
	Мультипредметность.ЗаполнитьПредметыПроцессаПоШаблону(ШаблонБизнесПроцесса, ЭтотОбъект);
	Мультипредметность.ПередатьПредметыПроцессу(ЭтотОбъект, ПредметСобытия, Ложь, Истина);
	ЗаполнитьПоШаблону(ШаблонБизнесПроцесса);
	
	Проект = МультипредметностьПереопределяемый.ПолучитьОсновнойПроектПоПредметам(ПредметСобытия);
	
	Дата = ТекущаяДатаСеанса();
	Автор = АвторСобытия;
	
КонецПроцедуры	

Функция НайтиВложенныйПроцесс(ТочкаМаршрута)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеБизнесПроцессов.БизнесПроцесс
	|ИЗ
	|	РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
	|ГДЕ
	|	ДанныеБизнесПроцессов.ВедущаяЗадача.БизнесПроцесс = &БизнесПроцесс
	|	И ДанныеБизнесПроцессов.ВедущаяЗадача.ТочкаМаршрута = &ТочкаМаршрута";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
	Запрос.УстановитьПараметр("ТочкаМаршрута", ТочкаМаршрута);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Неопределено;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.БизнесПроцесс;
	
КонецФункции

// Возвращает описание задачи, специфичное для бизнес-процесса
Функция ПолучитьОписаниеУведомленияЗадачи(Задача, КодЯзыкаПолучателя) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы со стартом процесса

Процедура ОтложенныйСтарт() Экспорт
	
	СтартПроцессовСервер.СтартоватьПроцессОтложенно(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОтключитьОтложенныйСтарт() Экспорт
	
	СтартПроцессовСервер.ОтключитьОтложенныйСтарт(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для поддержки комплексных процессов

// Формирует шаблон по процессу
// Параметры:
//	ВладелецШаблона - ссылка на шаблон комплексного процесса или комплексный процесс, который будет владельцем
//		создаваемого шаблона процесса
// Возвращает:
//	Ссылка на созданный шаблон
Функция СоздатьШаблонПоПроцессу(ВладелецШаблона = Неопределено) Экспорт
	
	ШаблонОбъект = Шаблон.ПолучитьОбъект().Скопировать();
	ШаблонОбъект.ВладелецШаблона = ВладелецШаблона;
	ШаблонОбъект.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	ШаблонОбъект.Записать();
	Возврат ШаблонОбъект.Ссылка;
			
КонецФункции

// Дополняет описание процесса общим описанием 
Процедура ДополнитьОписание(ОбщееОписание) Экспорт	
КонецПроцедуры

// Проверяет что заполнены поля шаблона
Функция ПолучитьСписокНезаполненныхПолейНеобходимыхДляСтарта() Экспорт
	
	МассивПолей = Новый Массив;
	Возврат МассивПолей;
	
КонецФункции	

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ВидЗаписи") Тогда
		Возврат;
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если ДополнительныеСвойства.Свойство("ПредыдущаяПометкаУдаления") Тогда
		ПредыдущаяПометкаУдаления = ДополнительныеСвойства.ПредыдущаяПометкаУдаления;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда
		ПротоколированиеРаботыПользователей.ЗаписатьПометкуУдаления(Ссылка, ПометкаУдаления);
	КонецЕсли;
	
	СтартПроцессовСервер.ПроцессПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецЕсли
