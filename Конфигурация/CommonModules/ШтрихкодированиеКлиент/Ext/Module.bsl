﻿// Показывает форму настроек положения штрихкода
//
// Параметры:
// - Параметры (Структура)
// 	- НастройкиШтрихкода (Структура) - не обязателен, ранее сохраненные настройки
//	- РежимИспользованияНастроек (Число), не обязателен
//			0:задание положения регистрационного штампа
//	 		1:задание положения штрихкода на странице
//	        2:задание положения отметки о контроле на странице
//  - ЗаголовокФормы (Строка)
//	- ЗапросОриентацииСтраницы (Булево) - не обязателен, запрашивать у пользователя ориентацию страницы
//	- ДляВставки (Булево) - не обязателен, запрос положения для вставки в файл
//	- ОписаниеОповещения - описание оповещения для вызывающего контекста о совершенном выборе
//
// Пример вызова:
//  Параметры = Новый Структура;
//  Параметры.Вставить("ЗаголовокФормы", НСтр("ru = 'Положение штрихкода на странице'"));
//  Параметры.Вставить("РежимИспользованияНастроек", 1);
//  Параметры.Вставить("ЗапросОриентацииСтраницы", Истина);
//  ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКомандыПродолжение", ЭтотОбъект, ПараметрКоманды);
//  ШтрихкодированиеКлиент.ПолучитьНастройкиШтрихкода(Параметры, ОписаниеОповещения);

Процедура ПолучитьНастройкиШтрихкода(Параметры, ОписаниеОповещения) Экспорт
	
	Если Не Параметры.Свойство("РежимИспользованияНастроек") Тогда
		Параметры.Вставить("РежимИспользованияНастроек", 0);
	КонецЕсли;
	Если Не Параметры.Свойство("ЗапросОриентацииСтраницы") Тогда
		Параметры.Вставить("ЗапросОриентацииСтраницы", Ложь);
	КонецЕсли;
	Если Не Параметры.Свойство("ДляВставки") Тогда
		Параметры.Вставить("ДляВставки", Ложь);
	КонецЕсли;
	
	Если Не Параметры.Свойство("НастройкиШтрихкода")
	 Или Не ЗначениеЗаполнено(Параметры.НастройкиШтрихкода.ПоложениеНаСтранице) 
	 Или Параметры.НастройкиШтрихкода.ПоказыватьФормуНастройки Тогда
		
		ОписаниеОповещенияОВыборе = Новый ОписаниеОповещения("ПолучитьНастройкиШтрихкодаПродолжение", ЭтотОбъект, ОписаниеОповещения);
		ОткрытьФорму("ОбщаяФорма.ВыборВариантаРасположенияПриПечати", Параметры, , , , ,
			ОписаниеОповещенияОВыборе, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Параметры.НастройкиШтрихкода);
		
	КонецЕсли;
	
КонецПроцедуры

// После совершения выбора оповещает код, вызвавший получение настроек
Процедура ПолучитьНастройкиШтрихкодаПродолжение(НастройкиШтрихкода, ОписаниеОповещения) Экспорт
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, НастройкиШтрихкода)
	
КонецПроцедуры

//Сохраняет изображение штрихкода в файл на жестком диске
//Параметры:
//			ДДИзображения - двоичные данные изображения штрихкода
//Возвращает: 
//			нет
Процедура СохранитьИзображениеШК(ДДИзображения) Экспорт
	
	#Если не ВебКлиент Тогда
	ВременныйФайл = ПолучитьИмяВременногоФайла("png");
	Режим = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Текст = НСтр("ru = 'Изображения'");
	Фильтр = Текст + "(*.png)|*.png";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ДДИзображения.Записать(ВременныйФайл);
		ПереместитьФайл(ВременныйФайл, ДиалогОткрытияФайла.ПолноеИмяФайла);
		УдалитьФайлы(ВременныйФайл);
		Текст = НСтр("ru = 'Изображение штрихкода сохранено!'");
	Иначе
	    Текст = НСтр("ru = 'Файл не выбран!'");
	КонецЕсли;
	ПоказатьПредупреждение(, Текст);
    #КонецЕсли
КонецПроцедуры

// Выполняет поиск данных по штрихкоду
Процедура ПоискПоШтрихкоду(СтрокаШК, ОкноВладелец) Экспорт
	
	Если Не ШтрихкодированиеКлиентПовтИсп.ШтрихкодированиеВключено() или Не ЗначениеЗаполнено(СтрокаШК) Тогда
		Возврат;
	КонецЕсли;
	
	МассивНайденных = ШтрихкодированиеСервер.НайтиОбъектыПоШтрихкоду(СтрокаШК, Истина);
	Если МассивНайденных.Количество() = 1 Тогда
		ДанныеДляОткрытияФормы = МассивНайденных[0];
		Если ДанныеДляОткрытияФормы <> Неопределено Тогда
			Если Найти(НРег(ДанныеДляОткрытияФормы.Метаданные), "задача") = 0 Тогда
				ИмяФормы = "Справочник." + ДанныеДляОткрытияФормы.Метаданные + ".ФормаОбъекта";
				ОткрытьФорму(ИмяФормы, ДанныеДляОткрытияФормы); 
			Иначе
				БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(ДанныеДляОткрытияФормы.Ключ);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли МассивНайденных.Количество() > 1 Тогда 
		ПараметрыФормы = Новый Структура;
		Если Найти(НРег(МассивНайденных[0].Метаданные), "задача") = 0 Тогда 
			ПараметрыФормы.Вставить("СписокНайденного", МассивНайденных);
			ОткрытьФорму("ОбщаяФорма.РезультатыПоискаПоШтрихкоду", ПараметрыФормы, ОкноВладелец, , , , , 
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		Иначе
				
			МассивСсылок = Новый Массив;
			Для Каждого Данные Из МассивНайденных Цикл
				МассивСсылок.Добавить(Данные.Ключ);
			КонецЦикла;	
				
			ПараметрыФормы.Вставить("МассивСсылок", МассивСсылок);
			ОткрытьФорму("Задача.ЗадачаИсполнителя.Форма.ФормаСписка", ПараметрыФормы, ОкноВладелец, , , , , 
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
	Иначе
		Текст = НСтр("ru = 'Документы и файлы не найдены'");
		ПоказатьПредупреждение(, Текст);	
	КонецЕсли;
	
КонецПроцедуры

// Выполняет ввод штрихкода с последующим запуском поиска по нему
Процедура ПоискПоШтрихкодуСоВводом(ОкноВладелец) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоискПоШтрихкодуСоВводомПродолжение", ЭтотОбъект, ОкноВладелец);
	СтрокаШК = "";
	ПоказатьВводСтроки(ОписаниеОповещения, СтрокаШК, "Введите значение штрихкода");
		
КонецПроцедуры

// После ввода штрихкода выполняет его поиск
Процедура ПоискПоШтрихкодуСоВводомПродолжение(Результат, ОкноВладелец) Экспорт
	
	ПоискПоШтрихкоду(Результат, ОкноВладелец);
	
КонецПроцедуры

Процедура ВставитьШтрихкод(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если Элементы.Обзор.Видимость Тогда
		ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ФайлыСоздание.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущийФайл = ТекущиеДанные.Ссылка;	
	ДанныеОШтрихкодеФайла = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(ТекущийФайл,, Истина);
	
	Если ДанныеОШтрихкодеФайла <> Неопределено 
		И ДанныеОШтрихкодеФайла.Свойство("СообщениеОбОшибке") Тогда
		ВызватьИсключение(ДанныеОШтрихкодеФайла.СообщениеОбОшибке);
	КонецЕсли;
	
	Если ДанныеОШтрихкодеФайла = Неопределено  Тогда
		ВызватьИсключение(НСтр("ru = 'Штрихкод отсутствует'"));
	КонецЕсли;
	
	ПараметрыНастройки = Новый Структура;
	ПараметрыНастройки.Вставить("НастройкиШтрихкода", ДанныеОШтрихкодеФайла.НастройкиШтрихкода);
	ПараметрыНастройки.Вставить("ЗаголовокФормы", НСтр("ru = 'Положение штрихкода на странице'"));
	ПараметрыНастройки.Вставить("РежимИспользованияНастроек", 1);
	ПараметрыНастройки.Вставить("ЗапросОриентацииСтраницы", Ложь);
	ПараметрыНастройки.Вставить("ДляВставки", Истина);
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("ТекущиеДанные", ТекущиеДанные);
	ПараметрыОбработки.Вставить("ТекущийФайл", ТекущийФайл);
	ПараметрыОбработки.Вставить("ДанныеОШтрихкодеФайла", ДанныеОШтрихкодеФайла);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьШтрихкодПродолжение", ЭтотОбъект, ПараметрыОбработки);
	ШтрихкодированиеКлиент.ПолучитьНастройкиШтрихкода(ПараметрыНастройки, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ВставитьШтрихкодПродолжение(НастройкиПоложенияШК, Параметры) Экспорт
	
	ТекущиеДанные = Параметры.ТекущиеДанные;
	ТекущийФайл = Параметры.ТекущийФайл;
	ДанныеОШтрихкодеФайла = Параметры.ДанныеОШтрихкодеФайла;
	
	Если НастройкиПоложенияШК = Неопределено Тогда	
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Расширение = "doc" Тогда
		#Если НЕ ВебКлиент Тогда
			Если ДанныеОШтрихкодеФайла <> Неопределено
				И ДанныеОШтрихкодеФайла.Свойство("ДвоичныеДанныеФайла")
				И (НастройкиПоложенияШК.ВысотаШК <> ДанныеОШтрихкодеФайла.НастройкиШтрихкода.ВысотаШК
				ИЛИ НастройкиПоложенияШК.ПоказыватьЦифры <> ДанныеОШтрихкодеФайла.НастройкиШтрихкода.ПоказыватьЦифры) Тогда
				ДанныеОШтрихкодеФайла.ДвоичныеДанныеИзображения = 
					ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(ДанныеОШтрихкодеФайла.Штрихкод,, НастройкиПоложенияШК.ВысотаШК, НастройкиПоложенияШК.ПоказыватьЦифры).ПолучитьДвоичныеДанные(); 
			КонецЕсли;
			
			Состояние(НСтр("ru = 'Выполняется вставка штрихкода в файл.
				|Пожалуйста, подождите...'"));
				
			Если ДанныеОШтрихкодеФайла <> Неопределено И ДанныеОШтрихкодеФайла.Свойство("ДвоичныеДанныеФайла") Тогда
			    Результат = ШтрихкодированиеКлиентСервер.ВставитьШтрихкодСИспользованиемНастроек(ТекущийФайл, 
					НастройкиПоложенияШК, 
					Истина, 
					ДанныеОШтрихкодеФайла.ДвоичныеДанныеИзображения, 
					ДанныеОШтрихкодеФайла.ДвоичныеДанныеФайла,
					ДанныеОШтрихкодеФайла.Расширение,
					ДанныеОШтрихкодеФайла.ФайлРедактируется, 
					ДанныеОШтрихкодеФайла.ИзменениеФайловMSWordТолькоНаСервере);
			Иначе
				Результат = Ложь;
			КонецЕсли;
				
			Если НЕ Результат Тогда
				Результат = ШтрихкодированиеСервер.ВставитьШтрихкод(ТекущийФайл, ДанныеОШтрихкодеФайла);
			КонецЕсли;
			Состояние();
		#Иначе
			Состояние(НСтр("ru = 'Выполняется вставка штрихкода в файл.
				|Пожалуйста, подождите...'"));
			Результат = ШтрихкодированиеСервер.ВставитьШтрихкод(ТекущийФайл, ДанныеОШтрихкодеФайла);
			Состояние();
		#КонецЕсли
	Иначе
		Результат = ШтрихкодированиеСервер.ВставитьШтрихкод(ТекущийФайл, ДанныеОШтрихкодеФайла);
	КонецЕсли;

	Если Результат Тогда
		Текст = НСтр("ru = 'Изображение штрихкода успешно вставлено в файл!'");
		
		ФайлСсылка = ТекущийФайл;
		Оповестить(
			"Запись_Файл", 
			Новый Структура("Событие, Файл, Владелец, ЕстьЗашифрованныеИлиЗанятыеФайлы, ИдентификаторРодительскойФормы", 
				"ДанныеФайлаИзменены", 
				ФайлСсылка, Неопределено, Неопределено,
				Неопределено),
				ФайлСсылка);
		
	Иначе
		Текст = НСтр("ru = 'Не удалось вставить изображение штрихкода в файл'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры

Процедура ВставитьРегистрационныйШтамп(Форма) Экспорт 
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если Элементы.Обзор.Видимость Тогда
		ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ФайлыСоздание.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
    ТекстНадписи = Новый Структура;
	
	Если Элементы.Организация.Видимость Тогда
		ТекстНадписи.Вставить("НазваниеОрганизации", Элементы.Организация.ТекстРедактирования);
	Иначе
		ТекстНадписи.Вставить("НазваниеОрганизации", Форма.НазваниеОрганизации);
	КонецЕсли;
	
	ТекстНадписи.Вставить("РегНомер", Объект.РегистрационныйНомер);
	ТекстНадписи.Вставить("РегДата", Формат(Объект.ДатаРегистрации,"ДФ=dd.MM.yyyy"));
	
	ТекущийФайл = ТекущиеДанные.Ссылка;
	ДанныеОШтрихкодеФайла = ШтрихкодированиеСервер.ПолучитьДанныеДляВставкиШтрихкодаВОбъект(ТекущийФайл,, Истина);
	
	Если ДанныеОШтрихкодеФайла <> Неопределено И ДанныеОШтрихкодеФайла.Свойство("СообщениеОбОшибке") Тогда
		ВызватьИсключение(ДанныеОШтрихкодеФайла.СообщениеОбОшибке);
	КонецЕсли;
	
	ПараметрыНастройки = Новый Структура;
	ПараметрыНастройки.Вставить("НастройкиШтрихкода", ДанныеОШтрихкодеФайла.НастройкиШтрихкода);
	ПараметрыНастройки.Вставить("ЗаголовокФормы", НСтр("ru = 'Положение регистрационного штампа'"));
	ПараметрыНастройки.Вставить("РежимИспользованияНастроек", 0);
	ПараметрыНастройки.Вставить("ЗапросОриентацииСтраницы", Ложь);
	ПараметрыНастройки.Вставить("ДляВставки", Истина);
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("ТекущиеДанные", ТекущиеДанные);
	ПараметрыОбработки.Вставить("ТекущийФайл", ТекущийФайл);
	ПараметрыОбработки.Вставить("ТекстНадписи", ТекстНадписи);
	ПараметрыОбработки.Вставить("ДанныеОШтрихкодеФайла", ДанныеОШтрихкодеФайла);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВставитьРегистрационныйШтампПродолжение", ЭтотОбъект, ПараметрыОбработки);
	ШтрихкодированиеКлиент.ПолучитьНастройкиШтрихкода(ПараметрыНастройки, ОписаниеОповещения);
	
КонецПроцедуры

Процедура ВставитьРегистрационныйШтампПродолжение(НастройкиПоложенияНадписи, Параметры) Экспорт
	
	Если НастройкиПоложенияНадписи = Неопределено Тогда	
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Параметры.ТекущиеДанные;
	ТекстНадписи = Параметры.ТекстНадписи;
	ТекущийФайл = Параметры.ТекущийФайл;
	ДанныеОШтрихкодеФайла = Параметры.ДанныеОШтрихкодеФайла;
	
	Если ТекущиеДанные.Расширение = "doc" Тогда	
		#Если НЕ ВебКлиент Тогда
			Если ДанныеОШтрихкодеФайла <> Неопределено
				И ДанныеОШтрихкодеФайла.Свойство("ДвоичныеДанныеФайла")
				И (НастройкиПоложенияНадписи.ВысотаШК <> ДанныеОШтрихкодеФайла.НастройкиШтрихкода.ВысотаШК
				ИЛИ НастройкиПоложенияНадписи.ПоказыватьЦифры <> ДанныеОШтрихкодеФайла.НастройкиШтрихкода.ПоказыватьЦифры) Тогда
				ДанныеОШтрихкодеФайла.ДвоичныеДанныеИзображения = ШтрихкодированиеСервер.ПолучитьКартинкуШтрихкода(ДанныеОШтрихкодеФайла.Штрихкод,, НастройкиПоложенияНадписи.ВысотаШК, НастройкиПоложенияНадписи.ПоказыватьЦифры).ПолучитьДвоичныеДанные(); 
			КонецЕсли;
			
			Состояние(НСтр("ru = 'Выполняется вставка регистрационного штампа в файл.
				|Пожалуйста, подождите...'"));
			Результат = Ложь;
			
			Если ДанныеОШтрихкодеФайла <> Неопределено 
				И ДанныеОШтрихкодеФайла.Свойство("ДвоичныеДанныеФайла") Тогда
			  	Результат = ШтрихкодированиеКлиентСервер.ВставитьРегистрационныйШтампСИспользованиемНастроек(
					ТекущийФайл, 
					НастройкиПоложенияНадписи, 
					Истина, 
					ТекстНадписи, 
					ДанныеОШтрихкодеФайла.ДвоичныеДанныеФайла,
					ДанныеОШтрихкодеФайла.ДвоичныеДанныеИзображения,
					ДанныеОШтрихкодеФайла.Расширение,
					ДанныеОШтрихкодеФайла.ФайлРедактируется, 
					ДанныеОШтрихкодеФайла.ИзменениеФайловMSWordТолькоНаСервере);
			КонецЕсли;
			
			Если НЕ Результат Тогда
				Результат = ШтрихкодированиеСервер.ВставитьРегистрационныйШтамп(ТекущийФайл, ДанныеОШтрихкодеФайла, ТекстНадписи);
			КонецЕсли;
			Состояние();
		#Иначе
			Состояние(НСтр("ru = 'Выполняется вставка регистрационного штампа в файл.
				|Пожалуйста, подождите...'"));
			Результат = ШтрихкодированиеСервер.ВставитьРегистрационныйШтамп(ТекущийФайл, ДанныеОШтрихкодеФайла, ТекстНадписи);
			Состояние();
		#КонецЕсли
	Иначе
		Результат = ШтрихкодированиеСервер.ВставитьРегистрационныйШтамп(ТекущийФайл, ДанныеОШтрихкодеФайла, ТекстНадписи);
	КонецЕсли;
	
	Если Результат Тогда
		Текст = НСтр("ru = 'Регистрационный штамп успешно вставлен в файл!'");
		
		ФайлСсылка = ТекущийФайл;
		Оповестить(
			"Запись_Файл", 
			Новый Структура("Событие, Файл, Владелец, ЕстьЗашифрованныеИлиЗанятыеФайлы, ИдентификаторРодительскойФормы", 
				"ДанныеФайлаИзменены", 
				ФайлСсылка, Неопределено, Неопределено,
				Неопределено),
				ФайлСсылка);
		
	Иначе
		Текст = НСтр("ru = 'Не удалось вставить регистрационный штамп в файл'");
	КонецЕсли;
	
	ПоказатьПредупреждение(, Текст);
	
КонецПроцедуры	
