﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Преобразует событие уведомление в вид бизнес события, если возможно.
//
// Параметры:
//  СобытиеУведомления - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Событие уведомления.
//
// Возвращаемое значение:
//  СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Приведенный вид события.
//
Функция ВидБизнесСобытия(СобытиеУведомления) Экспорт
	
	ВидБизнесСобытия = СобытиеУведомления;
	Если СобытиеУведомления = ВыполнениеМоейЗадачи Тогда
		ВидБизнесСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи;
		
	ИначеЕсли СобытиеУведомления = ПеренаправлениеМоейЗадачи Тогда
		ВидБизнесСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи;
		
	КонецЕсли;
	
	Возврат ВидБизнесСобытия;
	
КонецФункции

// Формирует список доступных видов событий по объекту.
//
// Параметры:
//  Объект - ЛюбаяСсылка - Объект.
//
// Возвращаемое значение:
//  СписокЗначений - Виды событий по объекту.
//
Функция ВидыСобытийПоОбъекту(Объект) Экспорт
	
	СписокВидовБизнесСобытий = Новый СписокЗначений;
	Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокЗадачи);
		СписокВидовБизнесСобытий.Добавить(ПросроченаЗадача);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ОсвобождениеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ЗахватФайлаДляРедактирования);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеСоставаКомплекта);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиВнутреннихДокументов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.НазначениеОтветственного);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли РаботаСУведомлениями.ЭтоПоддерживаемыйБизнесПроцесс(Объект) Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ВозобновлениеБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ЗавершениеБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ОстановкаБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СтартБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПрерываниеБизнесПроцесса);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеЗадачи);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи);
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокЗадачи);
		СписокВидовБизнесСобытий.Добавить(ПросроченаЗадача);
		СписокВидовБизнесСобытий.Добавить(ПросроченаЗадачаАвтора);
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокКонтроля);
		СписокВидовБизнесСобытий.Добавить(ПросроченКонтроль);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеОтсутствия);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеОтсутствия);
		СписокВидовБизнесСобытий.Добавить(СозданиеЗаписиКалендаря);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Проекты") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеПроекта);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеПроектнойЗадачи);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Контроль") Тогда
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокКонтроля);
		СписокВидовБизнесСобытий.Добавить(ПросроченКонтроль);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Отсутствие") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеОтсутствия);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Мероприятия") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеСообщения);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеМероприятия);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеФайла);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КатегорииДанных") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ДобавлениеВКатегорию);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.УдалениеИзКатегории);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Бронь") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеБрони);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.СозданиеБрони);
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеБрони);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПоказателиПроцессов") Тогда
		СписокВидовБизнесСобытий.Добавить(Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КонтрольныеТочки") Тогда
		СписокВидовБизнесСобытий.Добавить(ПросроченаКонтрольнаяТочка);
		СписокВидовБизнесСобытий.Добавить(ПодошелСрокКонтрольнойТочки);
		СписокВидовБизнесСобытий.Добавить(ПросроченаОценкаКонтрольнойТочки);
		
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВидовБизнесСобытий Цикл
		ЭлементСписка.Представление = ПредставлениеВидаСобытия(ЭлементСписка.Значение, Объект);
	КонецЦикла;
	СписокВидовБизнесСобытий.СортироватьПоПредставлению();
	
	Возврат СписокВидовБизнесСобытий;
	
КонецФункции

// Формирует список видов событий подписки на бизнес-событие.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//
// Возвращаемое значение:
//  Массив - Виды событий подписки.
//
Функция ВидыСобытийПодписки(ВидСобытия) Экспорт
	
	ВидыСобытий = Новый Массив;
	ВидыСобытий.Добавить(ВидСобытия);
	Если ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи Тогда
		ВидыСобытий.Добавить(ВыполнениеМоейЗадачи);
		
	ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи Тогда
		ВидыСобытий.Добавить(ПеренаправлениеМоейЗадачи);
		
	КонецЕсли;
	
	Возврат ВидыСобытий;
	
КонецФункции

// Формирует представление события для конкретного объекта.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
// 
// Возвращаемое значение:
//  Строка - Представление события.
//
Функция ПредставлениеВидаСобытия(ВидСобытия, Объект, Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	КодЯзыка = РаботаСУведомлениями.КодЯзыка(Пользователь);
	Если ТипЗнч(Объект) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		
		Если ВидСобытия = ПодошелСрокЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Истекает срок исполнения задачи'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Выполнена задача'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перенаправлена задача'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Отменено выполнение задачи'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новая задача'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении задачи'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПрерываниеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Прервана задача '", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОстановкаБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Остановлена задача'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ВозобновлениеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Возобновлена задача'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПеренаправлениеМоейЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перенаправлена моя задача'", КодЯзыка);
		ИначеЕсли ВидСобытия = ВыполнениеМоейЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Выполнена моя задача'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Файлы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ЗахватФайлаДляРедактирования Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Захвачен файл для редактирования'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился файл'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОсвобождениеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Освобожден файл'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении файла'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Создан новый файл в папке'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗнч(Объект) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.НазначениеОтветственного Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Вы назначены ответственным за документ'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к входящему документу'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеВходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился входящий документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеререгистрацияВходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перерегистрирован входящий документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.РегистрацияВходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Зарегистрирован входящий документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении входящего документа'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к внутреннему документу'", КодЯзыка)
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился внутренний документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеСоставаКомплекта Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился состав комплекта'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеререгистрацияВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перерегистрирован внутренний документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.РегистрацияВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Зарегистрирован внутренний документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении внутреннего документа'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПапкиВнутреннихДокументов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеВнутреннегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Создан новый внутренний документ в папке'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к исходящему документу'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеИсходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился исходящий документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеререгистрацияИсходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перерегистрирован исходящий документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.РегистрацияИсходящегоДокумента Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Зарегистрирован исходящий документ'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении исходящего документа'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли РаботаСУведомлениями.ЭтоПоддерживаемыйБизнесПроцесс(Объект) Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ВозобновлениеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Возобновлен процесс'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ЗавершениеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Завершен процесс'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ОстановкаБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Остановлен процесс'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СтартБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Стартован процесс'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Ход выполнения процесса'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПрерываниеБизнесПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Прерван процесс'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Поступила новая задача пользователю'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Перенаправлена задача пользователю'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПодошелСрокЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подошел срок задачи пользователя'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаЗадача Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена задача пользователя'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаЗадачаАвтора Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена задача автора'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПодошелСрокКонтроля Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подошел срок контроля пользователя'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченКонтроль Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Истек срок контроля'", КодЯзыка);
		ИначеЕсли ВидСобытия = СозданиеЗаписиКалендаря Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новая запись в календаре пользователя'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ на сообщение обсуждения'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новое сообщение в теме обсуждения'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Проекты") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении проекта'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеПроекта Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменился проект'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
			
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новый ответ в обсуждении проектной задачи'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеПроектнойЗадачи Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменилась проектная задача'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Контроль") Тогда
		
		Если ВидСобытия = ПодошелСрокКонтроля Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подходит срок контроля'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Мероприятия") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеФайла Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Присоединен новый файл к мероприятию'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Получен новый ответ в обсуждении мероприятия'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеМероприятия Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменилось мероприятие'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КатегорииДанных") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ДобавлениеВКатегорию Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Добавлен элемент в категорию'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.УдалениеИзКатегории Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Удален элемент из категории'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("ДокументСсылка.Бронь") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеБрони Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменена бронь'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеБрони Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Создана бронь помещения'", КодЯзыка);
		ИначеЕсли ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеБрони Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменена бронь помещения'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПоказателиПроцессов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Изменилось значение показателя процесса'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ЗаписиРабочегоКалендаря") Тогда
		
		Если ВидСобытия = СозданиеЗаписиКалендаря Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Новая запись календаря'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.КонтрольныеТочки") Тогда
		
		Если ВидСобытия = ПодошелСрокКонтрольнойТочки Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Подошел срок контрольной точки'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаКонтрольнаяТочка Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена контрольная точка'", КодЯзыка);
		ИначеЕсли ВидСобытия = ПросроченаОценкаКонтрольнойТочки Тогда
			ПредставлениеБизнесСобытия = НСтр("ru = 'Просрочена оценка контрольной точки'", КодЯзыка);
		Иначе
			ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		КонецЕсли;
		
	Иначе
		
		ПредставлениеБизнесСобытия = Строка(ВидСобытия);
		
	КонецЕсли;
	
	Возврат ПредставлениеБизнесСобытия;
	
КонецФункции

// Формирует признак доступности подписка на событие для конкретного объекта.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Булево - Доступна подписка на событие.
//
Функция ДоступнаПодпискаНаСобытие(ВидСобытия, ОбъектПодписки) Экспорт
	
	ДоступнаПодпискаНаСобытие = Ложь;
	Если ТипЗнч(ОбъектПодписки) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		
		Если ВидСобытия = ПодошелСрокЗадачи
			Или ВидСобытия = ПросроченаЗадача
			Или ВидСобытия = ПросроченаЗадачаАвтора
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ОтменаВыполненияЗадачи
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ПеренаправлениеЗадачи
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ДоступнаПодпискаНаСобытие = Истина;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВидыВнутреннихДокументов")
		Или ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВидыВходящихДокументов")
		Или ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВидыИсходящихДокументов") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.НазначениеОтветственного Тогда
			ДоступнаПодпискаНаСобытие = Истина;
		КонецЕсли;
		
	ИначеЕсли РаботаСУведомлениями.ЭтоПоддерживаемыйБизнесПроцесс(ОбъектПодписки) Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.ВыполнениеЗадачи
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			ДоступнаПодпискаНаСобытие = Истина;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.СообщенияОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ТемыОбсуждений") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Проекты") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Контроль") Тогда
		
		Если ВидСобытия = Перечисления.СобытияУведомлений.ПодошелСрокКонтроля
			Или ВидСобытия = Перечисления.СобытияУведомлений.ПросроченКонтроль Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Файлы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ВнутренниеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ИсходящиеДокументы") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Мероприятия") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеОтсутствия
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеОтсутствия
			Или ВидСобытия = Перечисления.СобытияУведомлений.СозданиеЗаписиКалендаря Тогда
			
			ДоступнаПодпискаНаСобытие = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ОбъектПодписки) = Тип("СправочникСсылка.ТерриторииИПомещения") Тогда
		
		Если ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеБрони
			Или ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеБрони Тогда
			ДоступнаПодпискаНаСобытие = Истина;;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДоступнаПодпискаНаСобытие;
	
КонецФункции

// Выполняет дополнительную проверку подписки.
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - Пользователь.
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
//  Объект - ЛюбаяСсылка - Объект.
// 
// Возвращаемое значение:
//  Булево - Результат проверки.
//
Функция ДополнительнаяПроверкаПодписки(Пользователь, ВидСобытия, Объект) Экспорт
	
	Результат = Истина;
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.СообщенияОбсуждений")
		И ВидСобытия = Справочники.ВидыБизнесСобытий.СозданиеСообщения Тогда
		// Не посылать уведомление о создание нового сообщения автору этого сообщения.
		Результат = (Объект.Автор <> Пользователь);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.ПоказателиПроцессов")
		И ВидСобытия = Справочники.ВидыБизнесСобытий.ИзменениеЗначенияПоказателяПроцесса Тогда
		
		НастройкаПроцентноеИзменение = РегистрыСведений.НастройкиУведомлений.ПолучитьДополнительнуюНастройку(
			Пользователь,
			Перечисления.НастройкиУведомлений.ПроцентноеИзменение);
		Если НастройкаПроцентноеИзменение <> 0 Тогда
			ТекущиеДанные = РегистрыСведений.ЗначенияПоказателейПроцессов.ТекущиеДанные(Объект);
			Результат = (ТекущиеДанные <> Неопределено)
				И (ТекущиеДанные.ИзменениеПроцент >= НастройкаПроцентноеИзменение);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Определяет вид уведомления программы.
//
// Параметры:
//  ВидСобытия - СправочникСсылка.ВидыБизнесСобытий, ПеречислениеСсылка.СобытияУведомлений - Вид события.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.ВидыУведомленийПрограммы - Вид уведомления программы.
//
Функция ОпределитьВидУведомления(ВидСобытия) Экспорт
	
	ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Информация;
	Если ВидСобытия = ПодошелСрокЗадачи
		Или ВидСобытия = ПросроченаЗадача
		Или ВидСобытия = ПросроченаЗадачаАвтора
		Или ВидСобытия = ПодошелСрокДействияДокумента
		Или ВидСобытия = ЗакончилсяСрокДействияДокумента
		Или ВидСобытия = ПодошелСрокКонтроля
		Или ВидСобытия = ПросроченКонтроль
		Или ВидСобытия = ПросроченаКонтрольнаяТочка
		Или ВидСобытия = ПодошелСрокКонтрольнойТочки
		Или ВидСобытия = ПросроченаОценкаКонтрольнойТочки Тогда
		ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Предупреждение;
	ИначеЕсли ВидСобытия = УведомлениеПрограммы Тогда
		ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Ошибка;
	КонецЕсли;
	
	Возврат ВидУведомления;
	
КонецФункции

#КонецОбласти

#КонецЕсли