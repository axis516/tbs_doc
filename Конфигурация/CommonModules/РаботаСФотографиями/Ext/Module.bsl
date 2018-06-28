﻿////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ФОТО
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Прочитать фото и вернуть адрес (навигационную ссылку)
// Параметры:
//  Ссылка - ссылка на справочник, для которого надо показать фото
//  УникальныйИдентификатор - уникальный идентификатор формы, откуда идет вызов
//  ЕстьКартинка - возвращаемое значение - Булево - Истина, если в объекте есть картинка
//
// Возвращаемое значение:
//   Строка - навигационная ссылка - или "", если нет картинки
Функция ПолучитьАдресФото(Ссылка, УникальныйИдентификатор, ЕстьКартинка) Экспорт
	
	ЕстьКартинка = Ложь;
	АдресКартинки = "";
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Ссылка);
	Если МенеджерОбъекта <> Неопределено Тогда
		
		ЕстьФункцияПолученияФото = Ложь;
		
		Попытка 
			ЕстьФункцияПолученияФото = МенеджерОбъекта.ЕстьФункцияПолученияФото()
		Исключение
			// ничего не делаем - у объекта метаданных может не быть фото - это не ошибка
		КонецПопытки;
		
		Если ЕстьФункцияПолученияФото Тогда
			АдресКартинки = МенеджерОбъекта.ПолучитьАдресФото(Ссылка, УникальныйИдентификатор, ЕстьКартинка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат АдресКартинки;
	
КонецФункции

// Прочитать фото из реквизита ФайлФотографии и поместить во временное хранилище
// Параметры:
//  Ссылка - ссылка на справочник, для которого надо показать фото
//  УникальныйИдентификатор - уникальный идентификатор формы, откуда идет вызов
//  ЕстьКартинка - возвращаемое значение - Булево - Истина, если в объекте есть картинка
//
// Возвращаемое значение:
//   Строка - адрес во временном хранилище - или "", если нет картинки
Функция ПолучитьНавигационнуюСсылкуРеквизита(ФизЛицо, УникальныйИдентификатор, ЕстьКартинка) Экспорт
	
	ЕстьКартинка = Истина;
	АдресКартинки = ПолучитьНавигационнуюСсылку(ФизЛицо, "ФайлФотографии");
	
	ФайлФотографии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФизЛицо, "ФайлФотографии");
	Попытка
		ДвоичныеДанные = ФайлФотографии.Получить();
		ЕстьКартинка = ЗначениеЗаполнено(ДвоичныеДанные);
	Исключение
		ЕстьКартинка = Ложь;
	КонецПопытки;
	
	Если Не ЕстьКартинка Тогда
		АдресКартинки = "";
	КонецЕсли;
	
	Возврат АдресКартинки;
	
КонецФункции

// Получает двоичные данные реквизита
Функция ПолучитьДвоичныеДанныеФото(Контакт) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Контакт);
	Если МенеджерОбъекта = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЕстьФункцияПолученияФото = Ложь;
	
	Попытка
		ЕстьФункцияПолученияФото = МенеджерОбъекта.ЕстьФункцияПолученияФото()
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Если Не ЕстьФункцияПолученияФото Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДвоичныеДанные = МенеджерОбъекта.ПолучитьДвоичныеДанныеФото(Контакт);
	
	Возврат ДвоичныеДанные;
	
КонецФункции

// Возвращает двоичные данные реквизита.
//
Функция ПолучитьДвоичныеДанныеРеквизита(Ссылка, ИмяРеквизита) Экспорт
	
	ЗначениеРеквизита = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	ДвоичныеДанные = ЗначениеРеквизита.Получить();
	Возврат ДвоичныеДанные;
	
КонецФункции

// Записать фото в физлицо - если его нет - создать новое
Процедура ЗаписатьИзображение(АдресВременногоХранилищаФайла, УникальныйИдентификатор, Ссылка, Наименование, 
	ПривилегированныйРежим = Ложь)  Экспорт
	
	Если ПривилегированныйРежим Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;	
	
	НачатьТранзакцию();
	Попытка
		
		ФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ФизЛицо");
		Если ЗначениеЗаполнено(ФизЛицо) Тогда
			
			ЗаблокироватьДанныеДляРедактирования(ФизЛицо, , УникальныйИдентификатор);
			ФизЛицоОбъект = ФизЛицо.ПолучитьОбъект();
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
			ПроверитьПредельныйРазмерФото(ДвоичныеДанные);
			
			ФизЛицоОбъект.ФайлФотографии = Новый ХранилищеЗначения(ДвоичныеДанные);
			ФизЛицоОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(ФизЛицо, УникальныйИдентификатор);
			
		Иначе // создадим физлицо и поставим на него ссылку в пользователе
			
			ФизЛицоОбъект = Справочники.ФизическиеЛица.СоздатьЭлемент();
			ФизЛицоОбъект.Наименование = Наименование;
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
			ПроверитьПредельныйРазмерФото(ДвоичныеДанные);
			
			ФизЛицоОбъект.ФайлФотографии = Новый ХранилищеЗначения(ДвоичныеДанные);
			ФизЛицоОбъект.Записать();
			
			ЗаблокироватьДанныеДляРедактирования(Ссылка, , УникальныйИдентификатор);
			ПользовательОбъект = Ссылка.ПолучитьОбъект();
			ПользовательОбъект.ФизЛицо = ФизЛицоОбъект.Ссылка;
			ПользовательОбъект.Записать();
			РазблокироватьДанныеДляРедактирования(Ссылка, УникальныйИдентификатор);
			
		КонецЕсли;	
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры	

Процедура ПроверитьПредельныйРазмерФото(Знач ДвоичныеДанные)
	
	РазмерФото = ДвоичныеДанные.Размер();
	Если РазмерФото > 200000 Тогда // больше 200 кб
		СтрокаИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Размер файла фотографии (%1 Кб) превышает предельно допустимый (%2 Кб). 
			|Выберите файл меньшего размера.'"), 
			Цел(РазмерФото / 1024), 200);
		ВызватьИсключение СтрокаИсключения;
	КонецЕсли;	
	
КонецПроцедуры	

// Очищает в физлице фото
Процедура ОчиститьИзображение(Ссылка, УникальныйИдентификатор, ПривилегированныйРежим = Ложь) Экспорт
	
	Если ПривилегированныйРежим Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;	
	
	ФизЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ФизЛицо");
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		
		ЗаблокироватьДанныеДляРедактирования(ФизЛицо, , УникальныйИдентификатор);
		ФизЛицоОбъект = ФизЛицо.ПолучитьОбъект();
		ФизЛицоОбъект.ФайлФотографии = Новый ХранилищеЗначения(Неопределено);
		ФизЛицоОбъект.Записать();
		РазблокироватьДанныеДляРедактирования(Ссылка, УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры	

// Записывает изображение в реквизит справочника территория
//
// Параметры:
//  ТерриторияПомещениеСсылка     - СправочникСсылка.ТерриторииИПомещения - ссылка на справочник, для которого надо записать фото
//  АдресВременногоХранилищаФайла - Хранилище значений - адрес хранилища значений, в котором хранится изображение
//  УникальныйИдентификатор       - уникальный идентификатор формы, откуда идет вызов процедуры
//
Процедура ЗаписатьИзображениеТерритории(ТерриторияПомещениеСсылка,
	АдресВременногоХранилищаФайла, УникальныйИдентификатор) Экспорт 
	
	ЗаблокироватьДанныеДляРедактирования(ТерриторияПомещениеСсылка, , УникальныйИдентификатор);
	ТерриторияПомещениеОбъект = ТерриторияПомещениеСсылка.ПолучитьОбъект();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
	ТерриторияПомещениеОбъект.ФайлФотографии = Новый ХранилищеЗначения(ДвоичныеДанные);
	ТерриторияПомещениеОбъект.ДоступнаСхема = Истина;
	ТерриторияПомещениеОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ТерриторияПомещениеСсылка, УникальныйИдентификатор);
	
КонецПроцедуры

// Очищает изображение для указанной территории
//
// Параметры:
//  ТерриторияПомещениеСсылка - СправочникСсылка.ТерриторииИПомещения - ссылка на справочник, для которого надо очистить изображение
//  УникальныйИдентификатор   - уникальный идентификатор формы, откуда идет вызов процедуры
//
Процедура ОчиститьИзображениеТерритории(ТерриторияПомещениеСсылка, УникальныйИдентификатор) Экспорт
	
	ЗаблокироватьДанныеДляРедактирования(ТерриторияПомещениеСсылка, , УникальныйИдентификатор);
	ТерриторияПомещениеСсылкаОбъект = ТерриторияПомещениеСсылка.ПолучитьОбъект();
	ТерриторияПомещениеСсылкаОбъект.ФайлФотографии = Новый ХранилищеЗначения(Неопределено);
	ТерриторияПомещениеСсылкаОбъект.ДоступнаСхема = Ложь;
	ТерриторияПомещениеСсылкаОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ТерриторияПомещениеСсылка, УникальныйИдентификатор);
	
КонецПроцедуры

// Возвращает двоичные данные картинки схемы справочника территория
//
// Параметры:
//  ТерриторияПомещениеСсылка - СправочникСсылка.ТерриторииИПомещения - ссылка на справочник, для которого надо получить данные
//  АдресВременногоХранилищаФайла - Хранилище значений - адрес хранилища значений, в котором хранится изображение
//
// Возвращает:
//  ДвоичныеДанные - ДвоичныеДанные - файла картинки
//
Функция ПолучитьДвоичныеДанныеСхемыТерритории(ТерриторияПомещениеСсылка, АдресВременногоХранилищаФайла) Экспорт 
	
	ДвоичныеДанные = Неопределено;
	
	Если ЭтоАдресВременногоХранилища(АдресВременногоХранилищаФайла) Тогда 
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
	КонецЕсли;
	
	Если ДвоичныеДанные = Неопределено И ЗначениеЗаполнено(ТерриторияПомещениеСсылка.ФайлФотографии) Тогда 
		ДвоичныеДанные = ТерриторияПомещениеСсылка.ФайлФотографии.Получить();
	КонецЕсли;
	
	Возврат ДвоичныеДанные;
	
КонецФункции

// Сформировать подсказку для указанного пользователя - телефон, комната, отдел
// Параметры:
//  Контакт - ссылка на пользователя
//
// Возвращаемое значение:
//   Строка - подсказка
Функция СформироватьПодсказку(Контакт) Экспорт
	
	Если ТипЗнч(Контакт) <> Тип("СправочникСсылка.Пользователи") Тогда
		Возврат "";
	КонецЕсли;	
	
	Подсказка = "";
	ОписаниеПользователяТелефон = "";
	ОписаниеПользователяКомната = "";
	ОписаниеПользователяПодразделение = "";
	
	// чтение подразделения
	СведенияПользователей = РегистрыСведений.СведенияОПользователяхДокументооборот.Получить(
		Новый Структура("Пользователь", Контакт));
	ПодразделениеИмя = Строка(СведенияПользователей.Подразделение);
	Если ЗначениеЗаполнено(ПодразделениеИмя) Тогда
		ОписаниеПользователяПодразделение = НСтр("ru='Отдел: '") + ПодразделениеИмя;
	КонецЕсли;	
	
	Телефон = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Контакт, 
		Справочники.ВидыКонтактнойИнформации.ТелефонПользователя);
		
	Если ЗначениеЗаполнено(Телефон) Тогда
		ОписаниеПользователяТелефон = НСтр("ru='Телефон: '") + Телефон;
	КонецЕсли;	
	
	Email = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Контакт, 
		Справочники.ВидыКонтактнойИнформации.EmailПользователя);
		
	Если ЗначениеЗаполнено(Email) Тогда
		ОписаниеПользователяEmail = НСтр("ru='Email: '") + Email;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ОписаниеПользователяТелефон) Тогда
		Подсказка = Подсказка + ОписаниеПользователяТелефон;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ОписаниеПользователяEmail) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Подсказка, Символы.ПС, ОписаниеПользователяEmail);	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ОписаниеПользователяПодразделение) Тогда
		ДобавитьЗначениеКСтрокеЧерезРазделитель(Подсказка, Символы.ПС, ОписаниеПользователяПодразделение);	
	КонецЕсли;	
	
	Возврат Подсказка;
	
КонецФункции	

#КонецОбласти