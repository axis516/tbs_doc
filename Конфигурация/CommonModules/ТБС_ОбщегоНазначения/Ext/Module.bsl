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
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТБС_БаллыСотрудниковОстатки.ФизЛицо,
	|	СУММА(ТБС_БаллыСотрудниковОстатки.РезультатОстаток) КАК РезультатОстаток
	|ИЗ
	|	РегистрНакопления.ТБС_БаллыСотрудников.Остатки(&Период, ) КАК ТБС_БаллыСотрудниковОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ТБС_БаллыСотрудниковОстатки.ФизЛицо";
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
