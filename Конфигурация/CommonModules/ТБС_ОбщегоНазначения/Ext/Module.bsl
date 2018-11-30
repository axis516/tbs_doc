﻿
////////////////////////////////////////////////////////////////////////////////
// Общего назначения
//
////////////////////////////////////////////////////////////////////////////////

#Область БезопасноеХранилищеПаролей

// Запись пароля в привязке к текущему объекту
Функция ЗаписатьДанныеВБезопасноеХранилище(Владелец,Данные,Ключ = "Пароль") Экспорт
	
	   УстановитьПривилегированныйРежим(Истина);
	   
	   НаборЗаписей = РегистрыСведений.ТБС_ХранилищеДанных.СоздатьНаборЗаписей();
	   
	   НаборЗаписей.Отбор.Владелец.Установить(Владелец); 
	   
	   НаборЗаписей.Прочитать();
	                        
	   Если НаборЗаписей.Количество() = 0 Тогда
		   
		   ДанныеДляСохранения = Новый Структура();
		   ДанныеДляСохранения.Вставить(Ключ, Данные);
		   
		   ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
		   
		   НоваяЗапись = НаборЗаписей.Добавить(); 
		   НоваяЗапись.Владелец = Владелец; 
		   НоваяЗапись.Данные   = ДанныеДляХранилищеЗначения; 
		   
		   НаборЗаписей.Записать(); 
	   КонецЕсли; 
	  
	   УстановитьПривилегированныйРежим(Ложь);

КонецФункции  //ЗаписатьДанныеВБезопасноеХранилище

// Чтение значений "Пароль", относящихся к текущему объекту
Функция ПрочитатьДанныеИзБезопасногоХранилища(Владелец,Данные, Ключи = "Пароль") Экспорт
	
	Результат = Новый Структура(Ключи);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТБС_ХранилищеДанных.Данные
	|ИЗ
	|	РегистрСведений.ТБС_ХранилищеДанных КАК ТБС_ХранилищеДанных
	|ГДЕ
	|	ТБС_ХранилищеДанных.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец",Владелец);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Если ЗначениеЗаполнено(РезультатЗапроса.Данные) Тогда
			СохраненныеДанные = РезультатЗапроса.Данные.Получить();
			Если ЗначениеЗаполнено(СохраненныеДанные) Тогда
				ЗаполнитьЗначенияСвойств(Результат, СохраненныеДанные);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Результат <> Неопределено И Результат.Количество() = 1 Тогда
		Возврат ?(Результат.Свойство(Ключи), Результат[Ключи], Неопределено);
	КонецЕсли;

	
КонецФункции //ПрочитатьДанныеИзБезопасногоХранилища

// Удаление всех паролей, сохраненных для текущего объекта
Процедура УдалитьДанныеИзБезопасногоХранилища(Владелец, Ключ) Экспорт
	
КонецПроцедуры //УдалитьДанныеИзБезопасногоХранилища

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Пользовательское соглашение
#Область ПользовательскоеСоглашение

// Запись данных в пользовательское соглашение 
Процедура ЗаписатьДанныеВПользовательскоеСоглашение(Пользователь,Результат,ФизЛицо) Экспорт
	
	   УстановитьПривилегированныйРежим(Истина);
	   
	   МенеджерЗаписи = РегистрыСведений.ТБС_ПользовательскоеСоглашение.СоздатьМенеджерЗаписи();
	   
	   МенеджерЗаписи.Период					= ТекущаяДата();
	   МенеджерЗаписи.Пользователь				= Пользователь;
	   МенеджерЗаписи.Результат					= Результат;
	   МенеджерЗаписи.УникальныйИдентификатор	= ФизЛицо.Ссылка.УникальныйИдентификатор();
	   МенеджерЗаписи.Записать();
	  
	   УстановитьПривилегированныйРежим(Ложь);
	   
КонецПроцедуры //ЗаписатьДанныеВПользовательскоеСоглашение

Функция ПолучитьПользовательскоеСоглашение(Пользователь,Период) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТБС_ПользовательскоеСоглашение.УникальныйИдентификатор
	|ИЗ
	|	РегистрСведений.ТБС_ПользовательскоеСоглашение.СрезПоследних(&Период, ) КАК ТБС_ПользовательскоеСоглашение
	|ГДЕ
	|	ТБС_ПользовательскоеСоглашение.Пользователь = &Пользователь
	|	И ТБС_ПользовательскоеСоглашение.Результат = ИСТИНА";
	Запрос.УстановитьПараметр("Пользователь",Пользователь);
	Запрос.УстановитьПараметр("Период",      Период);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Результат = Неопределено;
	
	Если РезультатЗапроса.Следующий() Тогда
		
		Результат = РезультатЗапроса.УникальныйИдентификатор;
		
	КонецЕсли;

	Возврат Результат;
	
КонецФункции
#КонецОбласти

#Область ИсторияПросмотров

// Запись данных в историю просмотров
Процедура ЗаписатьИсториюПросмотров(Структура) Экспорт
	
	   УстановитьПривилегированныйРежим(Истина);
	   
	   МенеджерЗаписи = РегистрыСведений.ТБС_ИсторияПросмотров.СоздатьМенеджерЗаписи();
	   ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Структура);
	   МенеджерЗаписи.Записать();
	  
	   УстановитьПривилегированныйРежим(Ложь);
	   
КонецПроцедуры //ЗаписатьИсториюПросмотров

#Область РасчетныеЛисты

// Чтение данных
Функция ПрочитатьДанныеИзРасчетныхЛистов(Владелец,Ключ) Экспорт
	
	СохраненныеДанные = Новый ТаблицаЗначений;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТБС_РасчетныеЛисты.Данные
	|ИЗ
	|	РегистрСведений.ТБС_РасчетныеЛисты КАК ТБС_РасчетныеЛисты
	|ГДЕ
	|	ТБС_РасчетныеЛисты.Период = &Ключ
	|	И ТБС_РасчетныеЛисты.УникальныйИдентификатор = &УД";
	Запрос.УстановитьПараметр("Ключ",Ключ);
	Запрос.УстановитьПараметр("УД",  Владелец);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Если ЗначениеЗаполнено(РезультатЗапроса.Данные) Тогда
			СохраненныеДанные = РезультатЗапроса.Данные.Получить();
		КонецЕсли;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СохраненныеДанные;

	
КонецФункции //ПрочитатьДанныеИзРасчетныхЛистов

// Чтение данных
Функция ПолучитьПериодыРаботыПоСотруднику(Владелец) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТБС_РасчетныеЛисты.Период КАК Период
	|ИЗ
	|	РегистрСведений.ТБС_РасчетныеЛисты КАК ТБС_РасчетныеЛисты
	|ГДЕ
	|	ТБС_РасчетныеЛисты.УникальныйИдентификатор = &Ключ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Ключ",Владелец);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса;

	
КонецФункции //ПолучитьПериодыРаботыПоСотруднику


#КонецОбласти

#КонецОбласти

#Область БизнесПроцессы
Функция БизнесСобытияПередЗаписьюОбъектаПередЗаписью(Источник, Отказ) Экспорт 
	  //резерв
КонецФункции

#КонецОбласти

#Область БаллыПоИсполнителям
Функция СформироватьБаллыПоИсполнителю(Процесс,ПриходРасход) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого СтрокаПредмета Из Процесс.БизнесПроцесс.Предметы Цикл
		
		Отбор = Новый Структура("ИмяПредмета", Справочники.ИменаПредметов.НайтиПоНаименованию("ТБС_ЗаявкиIT"));
		СтрокиЗадач = Процесс.БизнесПроцесс.Предметы.НайтиСтроки(Отбор);
		Если СтрокиЗадач.Количество() > 0 Тогда
			 ДобавитьБаллыПоИсполнителю(Процесс.ТекущийИсполнитель,СтрокиЗадач[0].Предмет,ПриходРасход);
		КонецЕсли;
		
		Прервать;
		
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
	 
	
		
КонецФункции

Функция СформироватьБаллыПоИсполнителям(Период) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТБС_БаллыСотрудников.ФизЛицо,
	|	СУММА(ТБС_БаллыСотрудников.Результат) КАК Результат,
	|	СУММА(ТБС_ЗаявкиITИсполнители.Оценка) КАК План,
	|	СУММА(ТБС_ЗаявкиITИсполнители.ТрудоемкостьРабЧасов) КАК Факт
	|ИЗ
	|	РегистрНакопления.ТБС_БаллыСотрудников КАК ТБС_БаллыСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ТБС_ЗаявкиIT.Исполнители КАК ТБС_ЗаявкиITИсполнители
	|		ПО ТБС_БаллыСотрудников.Регистратор = ТБС_ЗаявкиITИсполнители.Ссылка
	|			И ТБС_БаллыСотрудников.ФизЛицо = ТБС_ЗаявкиITИсполнители.Исполнитель.ФизЛицо
	|
	|СГРУППИРОВАТЬ ПО
	|	ТБС_БаллыСотрудников.ФизЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Результат УБЫВ
	|АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Период",Период);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
			
КонецФункции

Процедура ДобавитьБаллыПоИсполнителю(Пользователь,ВладелецФайла,ПриходРасход)
	
	ФизЛицо 	   = ПолучитьФизЛицо(Пользователь);
	Если Не ЗначениеЗаполнено(ФизЛицо)  Тогда
		Возврат;
	КонецЕсли; 
	
	Движение = РегистрыНакопления.ТБС_БаллыСотрудников.СоздатьНаборЗаписей();
	Движение.Отбор.Регистратор.Установить(ВладелецФайла);
	Движение.Прочитать();	
	
	ТребуетсяЗапись = Ложь;
	Если Движение.Количество() = 0 И ПриходРасход Тогда //+
		ВидДвижения = ВидДвиженияНакопления.Приход; 
		Результат   = 4;
		ТребуетсяЗапись = Истина;
	ИначеЕсли Движение.Количество() > 0 И ПриходРасход = Ложь Тогда //-
		ВидДвижения = ВидДвиженияНакопления.Расход; 
		Результат   = 1;
		ТребуетсяЗапись = Истина;
	КонецЕсли;
	
	Если ТребуетсяЗапись Тогда
		
		ЗаписьРегистра = Движение.Добавить();
		ЗаписьРегистра.Регистратор = ВладелецФайла;
		ЗаписьРегистра.ФизЛицо 	   = ФизЛицо;
		ЗаписьРегистра.Период      = ТекущаяДата();
		ЗаписьРегистра.Результат   = Результат;
		ЗаписьРегистра.ВидДвижения = ВидДвижения;
		ЗаписьРегистра.Активность = Истина;
		
		Движение.Записать(Ложь);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбщиеПроцедурыИФункции
// Возвращает физлицо для переданного пользователя.
//
Функция ПолучитьФизЛицо(Пользователь) Экспорт 

	Если Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователяхДокументооборот.ФизЛицо
	|ИЗ
	|	РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|ГДЕ
	|	СведенияОПользователяхДокументооборот.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.ФизическиеЛица.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ФизЛицо;

КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Состояния обменов данными с 1С-Документооборот
//
////////////////////////////////////////////////////////////////////////////////

#Область ТБС_СостоянияОбменовДаннымиДО
//Состояния обменов данными с 1С-Документооборот

// Устанавливает состояние документа
Процедура ЗаписатьСостояниеДокументаЭДО(Документ,Период) Экспорт
	
	Структура = ПолучитьДополнительныеРеквизитыДокумента(Документ);
	МенеджерЗаписи = РегистрыСведений.ТБС_СостоянияОбменовДаннымиДО.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Период    = Период;
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Структура);
	МенеджерЗаписи.Сотрудник = Документ.Адресат.ФизЛицо;
	МенеджерЗаписи.Документ  = Документ.Ссылка;
	МенеджерЗаписи.Статус    = Перечисления.СтатусыПакетовЭД.ПодготовленКОтправке;
	МенеджерЗаписи.Записать();

КонецПроцедуры

///////////ПолучитьДополнительныеРеквизитыДокумента/////////////////////////////
//
// Описание:Получить данные из дополнительных реквизитов
//
//
// Параметры (Документ)
//
// Возвращаемое значение: Структура
//
Функция ПолучитьДополнительныеРеквизитыДокумента(Документ) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДополнительныеРеквизиты.Свойство,
	|	ДополнительныеРеквизиты.Ссылка,
	|	ДополнительныеРеквизиты.Значение,
	|	ДополнительныеРеквизиты.ТекстоваяСтрока
	|ИЗ                             	
	|	Справочник.ВнутренниеДокументы.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|ГДЕ
	|	ДополнительныеРеквизиты.Ссылка = &Документ";
	Запрос.УстановитьПараметр("Документ", Документ);
	РезультатЗапроса = Запрос.Выполнить();
	
	Структура = Новый Структура;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Найти(Выборка.Свойство,"Период с") > 0 Тогда
			Структура.Вставить("ДатаНачала",Выборка.Значение);
		ИначеЕсли Найти(Выборка.Свойство,"Период по") > 0 Тогда
			Структура.Вставить("ДатаОкончания",Выборка.Значение);
		ИначеЕсли Найти(Выборка.Свойство,"Количество") > 0 Тогда
			Структура.Вставить("КоличествоДней",Выборка.Значение);	  
		ИначеЕсли Найти(Выборка.Свойство,"06") > 0 Тогда
			Структура.Вставить("ПереносДата",Выборка.Значение);	  				
		ИначеЕсли Найти(Выборка.Свойство,"07") > 0 Тогда
			Структура.Вставить("ПереносДней",Выборка.Значение);	  			
		ИначеЕсли Найти(Выборка.Свойство,"08") > 0 Тогда
			Структура.Вставить("ПричинаПереноса",Выборка.Значение);	  		
			Структура.Вставить("Содержание",Выборка.Значение);	  	
		КонецЕсли; 
	КонецЦикла; 
	
	Возврат Структура;
	   
КонецФункции //ПолучитьДополнительныеРеквизитыДокумента
 
#КонецОбласти


&НаСервере
Процедура СформироватьУведомленияНаСервере() Экспорт
	
	мПериод       = 86400 * 22;
	НачалоПериода = КонецДня(ТекущаяДата());
	КонецПериода  = НачалоПериода + мПериод; 
	РезультатЗапроса = СформироватьУведомленияНаОтпуск(НачалоПериода,КонецПериода);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		 //Создание ВД
		 мДокумент = СформироватьВнутреннийДокумент(Выборка);
		 //Шаблон
		 РаботаСШаблонамиДокументовСервер.ЗаписатьИспользованиеШаблона(мДокумент.Шаблон);
		 //Старт бизнес процесса по шаблону
		 СтартоватьБизнесПроцессПоШаблону(мДокумент);
		 //Изменение статуса в регистре сведений
		 мСтатус = Перечисления.СтатусыПакетовЭД.Распакован;
		 СформироватьСтатусУведомления(Выборка,мДокумент,мСтатус);
		 
		 
	КонецЦикла; 
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомления(Команда)
	СформироватьУведомленияНаСервере();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//
// Функция СформироватьУведомленияНаОтпуск
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
&НаСервере
Функция СформироватьУведомленияНаОтпуск(НачалоПериода,КонецПериода)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияОбменовДанными.Период,
	|	СостоянияОбменовДанными.Организация,
	|	СостоянияОбменовДанными.Сотрудник,
	|	СостоянияОбменовДанными.КоличествоДней,
	|	СостоянияОбменовДанными.Статус,
	|	СостоянияОбменовДанными.Содержание,
	|	СостоянияОбменовДанными.ДатаНачала,
	|	СостоянияОбменовДанными.ДатаОкончания
	|ПОМЕСТИТЬ ДанныеДляУведомлений
	|ИЗ
	|	РегистрСведений.ТБС_СостоянияОбменовДаннымиДО.СрезПоследних(&НачалоПериода, ) КАК СостоянияОбменовДанными
	|ГДЕ
	|	СостоянияОбменовДанными.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПакетовЭД.РаспакованДокументыНеОбработаны)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляУведомлений.Период,
	|	ДанныеДляУведомлений.Организация,
	|	ДанныеДляУведомлений.Сотрудник,
	|	ДанныеДляУведомлений.КоличествоДней,
	|	ДанныеДляУведомлений.Статус,
	|	ДанныеДляУведомлений.Содержание,
	|	ДанныеДляУведомлений.ДатаНачала,
	|	ДанныеДляУведомлений.ДатаОкончания
	|ИЗ
	|	ДанныеДляУведомлений КАК ДанныеДляУведомлений
	|ГДЕ
	|	ДанныеДляУведомлений.ДатаНачала МЕЖДУ &НачалоПериода И &КонецПериода";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериода);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции //СформироватьУведомленияНаОтпуск

&НаСервере
////////////////////////////////////////////////////////////////////////////////
//
// Функция СформироватьВнутреннийДокумент
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Функция СформироватьВнутреннийДокумент(мВыборка)
	
	ФайлыДобавленные = Новый ТаблицаЗначений;
	ФайлыДобавленные.Колонки.Добавить("Наименование");
	ФайлыДобавленные.Колонки.Добавить("ПолныйПуть");
	ФайлыДобавленные.Колонки.Добавить("ИндексКартинки");
	ФайлыДобавленные.Колонки.Добавить("Расширение");
	ФайлыДобавленные.Колонки.Добавить("ДобавленИзШаблона");
	ФайлыДобавленные.Колонки.Добавить("ШаблонОснованиеДляСоздания",Новый ОписаниеТипов("СправочникСсылка.Файлы"));
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ШаблонДокумента",Справочники.ШаблоныВнутреннихДокументов.НайтиПоНаименованию("Уведомление о отпуске"));
	ДанныеЗаполнения.Вставить("Папка",ДанныеЗаполнения.ШаблонДокумента.Папка);
	НовыйЭлемент = Справочники.ВнутренниеДокументы.СоздатьЭлемент();
	НовыйЭлемент.ОбработкаЗаполнения(ДанныеЗаполнения,Истина);
	НовыйЭлемент.Заголовок     = ДанныеЗаполнения.ШаблонДокумента.Наименование;
	НовыйЭлемент.Адресат       = Справочники.Пользователи.НайтиПоНаименованию(мВыборка.Сотрудник);
	НовыйЭлемент.Подготовил    = НовыйЭлемент.Адресат;
	НовыйЭлемент.Ответственный = НовыйЭлемент.Адресат;
	НовыйЭлемент.Шаблон 	   = ДанныеЗаполнения.ШаблонДокумента;
	ШаблоныДокументов.ЗаполнитьРеквизитыДокументаПоШаблону(ДанныеЗаполнения.ШаблонДокумента, НовыйЭлемент);
	
	ШаблоныДокументов.ЗаполнитьФайлыДокументаПоШаблону(ДанныеЗаполнения.ШаблонДокумента, ФайлыДобавленные, Ложь);	

	ЗаполнитьДополнительныеРеквизитыДокумента(НовыйЭлемент,мВыборка);
	
	НовыйЭлемент.Записать();
	
	СформироватьЧисловойНомерДокумента(НовыйЭлемент);
	
	// Создание файлов при сохранении нового документа
	Если ФайлыДобавленные.Количество() > 0 Тогда
		
		Индекс = ФайлыДобавленные.Количество() - 1;
        Пока Индекс >= 0 Цикл
			ФайлТаблицы = ФайлыДобавленные[Индекс]; 
			Если Не ЭтоАдресВременногоХранилища(ФайлТаблицы.ПолныйПуть) Тогда
				Индекс = Индекс - 1;
				Продолжить;
            КонецЕсли;
			
			ДанныеФайла = ПолучитьИзВременногоХранилища(ФайлТаблицы.ПолныйПуть);
			ВладелецФайла = НовыйЭлемент.Ссылка;
			Источник = ДанныеФайла.Ссылка;
			
			ХранитьВерсииНовыйФайл = Источник.ХранитьВерсии;
			
			Если ТипЗнч(НовыйЭлемент.Ссылка) <> ТипЗнч(ДанныеФайла.Владелец) Или ФайлТаблицы.ДобавленИзШаблона Тогда 
				ХранитьВерсииНовыйФайл = Истина;
			КонецЕсли;	
			
			СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
			СведенияОФайле.Комментарий = Источник.Описание;
			СведенияОФайле.ИмяБезРасширения = Источник.ПолноеНаименование;
			СведенияОФайле.ХранитьВерсии = ХранитьВерсииНовыйФайл;
			
			НачатьТранзакцию();
			Попытка
				Приемник = РаботаСФайламиВызовСервера.СоздатьФайл(ВладелецФайла, СведенияОФайле);
				
				Если ЗначениеЗаполнено(ФайлТаблицы.ШаблонОснованиеДляСоздания)
						И ЗначениеЗаполнено(ДанныеЗаполнения.ШаблонДокумента) Тогда
					РегистрыСведений.ФайлыСозданныеПоШаблону.ЗанестиИнформациюОФайле(Приемник, Истина);//СозданПоШаблону
				КонецЕсли;
				
				ХранилищеФайла = Неопределено;
				Если Источник.ТекущаяВерсия.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
					ХранилищеФайла = РаботаСФайламиВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(Источник.ТекущаяВерсия);
				КонецЕсли;
				
				СведенияОФайле.Размер = Источник.ТекущаяВерсия.Размер;
				СведенияОФайле.РасширениеБезТочки = Источник.ТекущаяВерсия.Расширение;
				СведенияОФайле.АдресВременногоХранилищаФайла = ХранилищеФайла;
				СведенияОФайле.АдресВременногоХранилищаТекста = Источник.ТекущаяВерсия.ТекстХранилище;
				СведенияОФайле.СсылкаНаВерсиюИсточник = Источник.ТекущаяВерсия;
				СведенияОФайле.ВремяИзменения = Источник.ТекущаяВерсия.ДатаМодификацииФайла;
				СведенияОФайле.ВремяИзмененияУниверсальное = Источник.ТекущаяВерсия.ДатаМодификацииУниверсальная;

				Версия = РаботаСФайламиВызовСервера.СоздатьВерсию(Приемник, СведенияОФайле);
				
				РаботаСФайламиВызовСервера.ОбновитьВерсиюВФайле(Приемник, Версия, Источник.ТекущаяВерсия.ТекстХранилище);
				
				ПараметрыРаспознавания = РаботаСФайламиВызовСервера.ПодготовитьПараметрыРаспознавания();
				Если ПараметрыРаспознавания <> Неопределено И ПараметрыРаспознавания.Свойство("РаспознатьПослеДобавления") И ПараметрыРаспознавания.РаспознатьПослеДобавления Тогда
					РаспознатьНемедленно = Ложь;
					ОписаниеОшибки = "";
					РаспознанныйТекст = "";
					РаботаСФайламиВызовСервера.РаспознатьФайл(Приемник, ПараметрыРаспознавания, ОписаниеОшибки,
						РаспознанныйТекст, новый УникальныйИдентификатор,  РаспознатьНемедленно);
				КонецЕсли;
				
				Если ФайлТаблицы.ДобавленИзШаблона Тогда
					ФайлОбъект = Приемник.ПолучитьОбъект();
					ФайлОбъект.ШаблонОснованиеДляСоздания = ФайлТаблицы.ШаблонОснованиеДляСоздания;
					Если ФайлОбъект.ПодписанЭП Тогда
						ФайлОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
					КонецЕсли;
					ФайлОбъект.Записать();	
				КонецЕсли;
				
				Если ДанныеФайла.Зашифрован Тогда
					
					ФайлОбъект = Приемник.ПолучитьОбъект();
					ФайлОбъект.Зашифрован = Истина;
					
					Для Каждого Строка Из Источник.СертификатыШифрования Цикл
						НоваяСтрока = ФайлОбъект.СертификатыШифрования.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
					КонецЦикла;
					
					ФайлОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
					ФайлОбъект.Записать();
					
					ВерсияОбъект = Приемник.ТекущаяВерсия.ПолучитьОбъект();
					ВерсияОбъект.Зашифрован = Истина;
					ВерсияОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
					ВерсияОбъект.Записать();
					
				КонецЕсли;
				
				ЗафиксироватьТранзакцию();
				
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
			// Автозаполнение файлов
			Если Источник <> Неопределено И ФайлТаблицы.ДобавленИзШаблона Тогда
				НастройкиАвтозаполнения = ПолучитьНастройкиАвтозаполненийШаблона(Приемник, 
					Приемник.ШаблонОснованиеДляСоздания, Приемник.ВладелецФайла);
				
						РезультатЗаполнения = АвтозаполнениеШаблоновФайловКлиентСервер.ЗаполнитьПоляФайлаДаннымиВладельца(
							Ложь, Приемник, Истина);
				
			КонецЕсли;
				
			ФайлыДобавленные.Удалить(Индекс);
			Индекс = Индекс - 1;
			
		КонецЦикла;
	КонецЕсли;
	
	НовыйЭлемент.Записать();
	
	Возврат НовыйЭлемент;
	
КонецФункции //СформироватьВнутреннийДокумент
&НаСервере
Функция ЗаполнитьДополнительныеРеквизитыДокумента(Документ,мВыборка)
	
	ДополнительныеРеквизиты = Новый ТаблицаЗначений;
	ДополнительныеРеквизиты.Колонки.Добавить("Свойство");
	ДополнительныеРеквизиты.Колонки.Добавить("Значение");
	ДополнительныеРеквизиты.Колонки.Добавить("ТипЗначения");
	
	// Доп. реквизиты
	СписокДопРеквизитов = РаботаСШаблонамиДокументовСервер.ПолучитьНаборДопРеквизитовДокумента(
	"ВнутренниеДокументы", Документ.ВидДокумента, Документ.Шаблон);
	РаботаСШаблонамиДокументовСервер.ПоместитьДопРеквизитыНаФорму(ДополнительныеРеквизиты, СписокДопРеквизитов);
	
	Документ.ДополнительныеРеквизиты.Загрузить(ДополнительныеРеквизиты);
	

	
	Для каждого мСтрока Из Документ.ДополнительныеРеквизиты Цикл
		Если Найти(мСтрока.Свойство,"Период с") > 0 Тогда
			мСтрока.Значение = мВыборка.ДатаНачала;
		ИначеЕсли Найти(мСтрока.Свойство,"Период по") > 0 Тогда
			мСтрока.Значение = мВыборка.ДатаОкончания;
		ИначеЕсли Найти(мСтрока.Свойство,"Количество") > 0 Тогда
			мСтрока.Значение = мВыборка.КоличествоДней;	  
		ИначеЕсли Найти(мСтрока.Свойство,"Физическое") > 0 Тогда
			мСтрока.Значение = Неопределено;	  		
		ИначеЕсли Найти(мСтрока.Свойство,"Дата") > 0 Тогда
			мСтрока.Значение = мВыборка.Содержание;	  			
		ИначеЕсли Найти(мСтрока.Свойство,"Перенос") > 0 Тогда
			мСтрока.Значение = Неопределено;	  				
		ИначеЕсли Найти(мСтрока.Свойство,"Причина") > 0 Тогда
			мСтрока.Значение = "";	  					
		КонецЕсли; 
	КонецЦикла; 
	   
КонецФункции //ПолучитьДополнительныеРеквизитыДокумента

&НаСервере
Функция ПолучитьНастройкиАвтозаполненийШаблона(Файл, Шаблон, Документ)  
	
	СтруктураВозврата = Новый Структура("ВыполнятьНаСервере, РасширениеШаблона,НастройкиЗамены, ДанныеФайла, ДвоичныеДанные, ТекущаяВерсия");
	НаСервере = Константы.ИзменениеФайловMSWordТолькоНаСервере.Получить();
	ПеремДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайла(Файл.Ссылка);
	
	СтруктураВозврата.ВыполнятьНаСервере = НаСервере;
	СтруктураВозврата.РасширениеШаблона = НРег(Файл.ТекущаяВерсияРасширение);
	
	Если Шаблон = Неопределено Тогда
		Шаблон = Файл;
	КонецЕсли;
		
	СтруктураВозврата.НастройкиЗамены = АвтозаполнениеШаблоновФайловСервер.ПолучитьМассивАвтозаполненийШаблона(Файл, Шаблон, Документ);
	СтруктураВозврата.ДанныеФайла = ПеремДанныеФайла;
	
	ТекущаяВерсия = Файл.ТекущаяВерсия.ПолучитьОбъект();
	ИмяСРасширениемФайла = ТекущаяВерсия.ПолноеНаименование + "." + ТекущаяВерсия.Расширение;
	ДвоичныеДанныеФайла = АвтозаполнениеШаблоновФайловСервер.ПолучитьДвоичныеДанныеФайла(Файл);
	
	СтруктураВозврата.ДвоичныеДанные = ДвоичныеДанныеФайла;
	СтруктураВозврата.ТекущаяВерсия = Файл.ТекущаяВерсия;
	
	Возврат СтруктураВозврата;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
//
// Функция СформироватьЧисловойНомерДокумента
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
// Возвращаемое значение: 
//
&НаСервере
Функция СформироватьЧисловойНомерДокумента(НовыйЭлемент)
	
	Нумератор = Нумерация.ПолучитьНумераторДокумента(НовыйЭлемент); 
	Если ЗначениеЗаполнено(Нумератор) Тогда // автоматическая нумерация
		
		НовыйЭлемент.ДатаРегистрации = ТекущаяДата();
		
		// сформируем текущий номер
		СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(НовыйЭлемент);
		Нумерация.СформироватьЧисловойНомерДокумента(СтруктураПараметров, НовыйЭлемент.ЧисловойНомер);
		
		ОписанияОшибок = Новый СписокЗначений;
		СтруктураПараметров = НумерацияКлиентСервер.ПолучитьПараметрыНумерации(НовыйЭлемент);
		Нумерация.СформироватьСтроковыйНомерДокумента(СтруктураПараметров, НовыйЭлемент.РегистрационныйНомер, ОписанияОшибок);
		
		НовыйЭлемент.Зарегистрировал = НовыйЭлемент.Адресат;
		НовыйЭлемент.Записать();
		
		Делопроизводство.ЗаписатьСостояниеДокумента(
		НовыйЭлемент.Ссылка, 
		ТекущаяДата(), 
		Перечисления.СостоянияДокументов.Зарегистрирован, 
		НовыйЭлемент.Адресат);
	КонецЕсли;	
	
	НовыйЭлемент.Записать();

КонецФункции //СформироватьЧисловойНомерДокумента

//////////СтартоватьБизнесПроцессПоШаблону//////////////////////////////////////
//
// Процедура СтартоватьБизнесПроцессПоШаблону
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
&НаСервере
Процедура СтартоватьБизнесПроцессПоШаблону(мПредмет)
	
	Шаблон = Справочники.ШаблоныКомплексныхБизнесПроцессов.НайтиПоНаименованию("Уведомление о начале отпуска сотрудника");
	
	БПОбъект = БизнесПроцессы.КомплексныйПроцесс.СоздатьБизнесПроцесс();
	БПОбъект.Шаблон = Шаблон;
	БПОбъект.ЗаполнитьПоШаблонуИПредмету(Шаблон,мПредмет.Ссылка,мПредмет.Адресат);
	БПОбъект.Записать();
	
	СтартПроцессовСервер.СтартоватьПроцесс(БПОбъект);
	
КонецПроцедуры //СтартоватьБизнесПроцессПоШаблону

//////////СформироватьСтатусУведомления///////////////////////////////////////
//
// Процедура СформироватьСтатусУведомления
//
// Описание: Запись в регистр сведений
//
//
// Параметры (Выборка,Документ)
//
&НаСервере
Процедура СформироватьСтатусУведомления(мВыборка,мДокумент,мСтатус) Экспорт
	
	НаборЗаписи = РегистрыСведений.ТБС_СостоянияОбменовДаннымиДО.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(НаборЗаписи,мВыборка);
	НаборЗаписи.Период   = ТекущаяДата();
	НаборЗаписи.Статус   = мСтатус;
	НаборЗаписи.Документ = мДокумент.Ссылка;
	НаборЗаписи.Записать(Ложь);
	
КонецПроцедуры //СформироватьСтатусУведомления

