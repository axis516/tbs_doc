﻿&НаКлиенте
Перем КомпонентаЗагрузкиCuneiForm;  // компонента для загрузки картинок 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторКлиента = "";
	Если Параметры.Свойство("ИдентификаторКлиента") Тогда 
		ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	КонецЕсли;
	
	ИнтервалВремениВыполнения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"АвтоматическоеРаспознаваниеИзображений", "ИнтервалВремениВыполнения");
	Если ИнтервалВремениВыполнения = 0 Тогда
		ИнтервалВремениВыполнения = 60;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"АвтоматическоеРаспознаваниеИзображений", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	КонецЕсли;	
	
	ПриложениеЗапускаCuneiForm = ПолучитьОбщийМакет("ПриложениеЗапускаCuneiForm");
	АдресПриложенияЗапускаCuneiForm = ПоместитьВоВременноеХранилище(ПриложениеЗапускаCuneiForm
		, УникальныйИдентификатор);
	
	ИспользоватьImageMagickДляРаспознаванияPDF = 
		РаботаСФайламиВызовСервера.ПолучитьИспользоватьImageMagickДляРаспознаванияPDF();
	
	ПутьКПрограммеКонвертацииPDF = 
		ХранилищеОбщихНастроек.Загрузить("НастройкиСканирования/ПутьКПрограммеКонвертации",
		ИдентификаторКлиента);
		
	Если ПустаяСтрока(ПутьКПрограммеКонвертацииPDF) Тогда
		ПутьКПрограммеКонвертацииPDF = "magick.exe"; // ImageMagick
	КонецЕсли;	
	
	Если ИспользоватьImageMagickДляРаспознаванияPDF Тогда
		ИнформационнаяНадпись = НСтр("ru = 'Включена настройка ""Использовать ImageMagick для распознавания отсканированных документов формата PDF"". 
                                      |Путь к программе преобразования PDF: ""'");
		ИнформационнаяНадпись = ИнформационнаяНадпись + ПутьКПрограммеКонвертацииPDF;
		ИнформационнаяНадпись = ИнформационнаяНадпись + """";
	Иначе
		Элементы.ИнформационнаяНадпись.Видимость = Ложь;
	КонецЕсли;	
	
	КоличествоФайловВПорции = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"АвтоматическоеРаспознаваниеИзображений", "КоличествоФайловВПорции");
	Если КоличествоФайловВПорции = 0 Тогда
		КоличествоФайловВПорции = 100;
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"АвтоматическоеРаспознаваниеИзображений", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
	КонецЕсли;	
	
	КоличествоНераспознанныхФайлов = РаботаСФайламиВызовСервера.ПолучитьКоличествоНераспознанныхВерсий();
	Если КоличествоНераспознанныхФайлов > 0 Тогда 
		Элементы.ФормаСтарт.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'В Веб-клиенте распознавание изображений не поддерживается.'"));
		Возврат;
	#КонецЕсли
	
	Если КомпонентаЗагрузкиCuneiForm = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаЗагрузкиCuneiForm",
			"CuneiFormLoaderAddIn", ТипВнешнейКомпоненты.Native);
		
		Если КодВозврата = Ложь Тогда
			Элементы.ГруппаУстановкиКомпоненты.Видимость = Истина;
			Возврат;
		Иначе
			КомпонентаЗагрузкиCuneiForm = Новый("AddIn.CuneiFormLoaderAddIn.AddInNativeExtension");
		КонецЕсли;
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалВремениВыполненияПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"АвтоматическоеРаспознаваниеИзображений", "ИнтервалВремениВыполнения",  ИнтервалВремениВыполнения);
	
	Если НачатоРаспознавание Тогда
		ОтключитьОбработчикОжидания("РаспознаваниеИзображенийКлиентОбработчик");
		ПрогнозируемоеВремяНачалаРаспознавания = ТекущаяДата() + ИнтервалВремениВыполнения;
		ПодключитьОбработчикОжидания("РаспознаваниеИзображенийКлиентОбработчик", ИнтервалВремениВыполнения);
		ОбновлениеОбратногоОтсчета();
	КонецЕсли;
	
КонецПроцедуры

// обновляет обратный отсчет
&НаКлиенте
Процедура ОбновлениеОбратногоОтсчета()
	
	Осталось = ПрогнозируемоеВремяНачалаРаспознавания - ТекущаяДата();
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							 НСтр("ru = 'До начала распознавания изображений осталось %1 сек'"), 
							 Осталось);
							 
	Если Осталось <= 1 Тогда
		ТекстСообщения = "";
	КонецЕсли;
	
	ИнтервалВремениВыполнения = Элементы.ИнтервалВремениВыполнения.ТекстРедактирования;
	Статус = ТекстСообщения;
	
КонецПроцедуры

&НаСервере
Процедура ЗанестиИнформациюОбОшибкеРаспознавания(ВерсияСсылка, ТекстСообщения)
	
	ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
	ВерсияОбъект.СтатусРаспознаванияТекста = Перечисления.СтатусыРаспознаванияТекста.НеРаспознано;
	ВерсияОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина); // чтобы прошла запись ранее подписанного объекта
	ВерсияОбъект.Записать();
	
	// запись в журнал регистрации
	ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
	
КонецПроцедуры

// Распознает изображения из файлов на диске на клиенте
&НаКлиенте
Процедура РаспознаваниеИзображенийКлиентОбработчик()
	
	РаспознаваниеИзображенийКлиент();
	
КонецПроцедуры	

// Распознает изображения из файлов на диске на клиенте
&НаКлиенте
Процедура РаспознаваниеИзображенийКлиент(РазмерПорции = Неопределено)
	
	#Если НЕ ВебКлиент Тогда
		
	ПрогнозируемоеВремяНачалаРаспознавания = ТекущаяДата() + ИнтервалВремениВыполнения;
	
	ИмяСРасширениемФайла = "";	
	
	Состояние(НСтр("ru = 'Начато распознавание изображений'"));
	
	Попытка	
		
		РазмерПорцииТекущий = КоличествоФайловВПорции;
		Если РазмерПорции <> Неопределено Тогда
			РазмерПорцииТекущий = РазмерПорции;
		КонецЕсли;	
		МассивВерсий = РаботаСФайламиВызовСервера.ПолучитьМассивВерсийДляРаспознавания(РазмерПорцииТекущий);
		
		Если МассивВерсий.Количество() = 0 Тогда
			Состояние(НСтр("ru = 'Нет файлов для распознавания изображений'"));
			Возврат;
		КонецЕсли;
		
		Для Индекс = 0 По МассивВерсий.Количество() - 1 Цикл
			
			ВерсияСсылка = МассивВерсий[Индекс];
			
			Попытка
				СтруктураВозврата = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИНавигационнуюСсылкуВерсииДляРаспознавания(
					ВерсияСсылка, УникальныйИдентификатор);
				ДанныеФайла = СтруктураВозврата.ДанныеФайла; 
				АдресФайла = СтруктураВозврата.НавигационнаяСсылкаВерсии;
				РасширениеФайлаРезультата = СтруктураВозврата.РасширениеФайлаРезультата;
				ЯзыкРаспознавания = СтруктураВозврата.ЯзыкРаспознавания;
				Если ПустаяСтрока(ЯзыкРаспознавания) Тогда
					ЯзыкРаспознавания = "7"; // русско-английский
				КонецЕсли;	
				
				Если ДанныеФайла.СтатусРаспознаванияТекста <> "НужноРаспознать" Тогда
					
					// для варианта с хранением файлов на диске (на сервере) удаляем Файл из временного хранилища после получения
					Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
						УдалитьИзВременногоХранилища(АдресФайла);
					КонецЕсли;
					
					Продолжить; // другой клиент уже обработал файл
				КонецЕсли;	
				
				ИмяСРасширением = ФайловыеФункцииКлиент.ПолучитьИмяСРасширением(
					ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
				ИмяСРасширениемФайла = ИмяСРасширением;
				Прогресс = Индекс * 100 / МассивВерсий.Количество();
				Состояние(НСтр("ru = 'Идет распознавание изображения'"), Прогресс, ИмяСРасширением);
				Расширение = ДанныеФайла.Расширение;
				
				РаспознатьИзображениеКлиент(ВерсияСсылка, АдресФайла, Расширение, УникальныйИдентификатор,
					РасширениеФайлаРезультата, ЯзыкРаспознавания, ИмяСРасширениемФайла);
			Исключение
				ОписаниеОшибкиИнфо = ОписаниеОшибки();
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										 НСтр("ru = 'Во время распознавания изображения из файла ""%1"" произошла неизвестная ошибка.'"), 
										 ИмяСРасширениемФайла);
				ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
				Состояние(ТекстСообщения);
				
				ЗанестиИнформациюОбОшибкеРаспознавания(ВерсияСсылка, ТекстСообщения);		
				
			КонецПопытки;	
		КонецЦикла;
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								 НСтр("ru = 'Распознавание изображений завершено. Обработано файлов: %1'"), 
								 МассивВерсий.Количество());
		Состояние(ТекстСообщения);
		
	Исключение
		
		ОписаниеОшибкиИнфо = ОписаниеОшибки();
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								 НСтр("ru = 'Во время распознавания изображения из файла ""%1"" произошла неизвестная ошибка.'"), 
								 ИмяСРасширениемФайла);
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
		Состояние(ТекстСообщения);
		
		// запись в журнал регистрации
		ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
		
	КонецПопытки;
	
	КоличествоНераспознанныхФайлов = РаботаСФайламиВызовСервера.ПолучитьКоличествоНераспознанныхВерсий();
	
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Распознавание изображения'", Метаданные.ОсновнойЯзык.КодЯзыка), 
		УровеньЖурналаРегистрации.Ошибка, , ,
		ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомпонентуЗагрузкиИзображений(Команда)
	
	Если КомпонентаЗагрузкиCuneiForm = Неопределено Тогда
		
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаЗагрузкиCuneiForm",
			"CuneiFormLoaderAddIn", ТипВнешнейКомпоненты.Native);
		
		Если КодВозврата Тогда
			Состояние(НСтр("ru = 'Компонента загрузки изображений уже установлена!'"));
		Иначе
			
			ОписаниеОповещения = 
				Новый ОписаниеОповещения("УстановитьКомпонентуЗагрузкиИзображенийПродолжение", ЭтотОбъект);
			
			НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, "ОбщийМакет.КомпонентаЗагрузкиCuneiForm");
			
			Возврат;
			
		КонецЕсли;
		КомпонентаЗагрузкиCuneiForm = Новый("AddIn.CuneiFormLoaderAddIn.AddInNativeExtension");
		
	Иначе
		Состояние(НСтр("ru = 'Компонента загрузки изображений уже установлена!'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомпонентуЗагрузкиИзображенийПродолжение(Параметры) Экспорт
	
	КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаЗагрузкиCuneiForm",
		"CuneiFormLoaderAddIn", ТипВнешнейКомпоненты.Native);
	
	Элементы.ГруппаУстановкиКомпоненты.Видимость = Ложь;
	
	ПрогнозируемоеВремяНачалаРаспознавания = ТекущаяДата() + ИнтервалВремениВыполнения;
	ПодключитьОбработчикОжидания("РаспознаваниеИзображенийКлиентОбработчик", ИнтервалВремениВыполнения);
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
	КомпонентаЗагрузкиCuneiForm = Новый("AddIn.CuneiFormLoaderAddIn.AddInNativeExtension");
	
КонецПроцедуры

&НаКлиенте
// Функция нижнего уровня - вызывается для версии файла
Процедура РаспознатьИзображениеКлиент(ВерсияСсылка, АдресФайла, Расширение, УникальныйИдентификатор, 
	РасширениеФайлаРезультата, ЯзыкРаспознавания, ИмяСРасширениемФайла)
	
#Если Не ВебКлиент Тогда	
	
	ИмяФайлаКартинки = ПолучитьИмяВременногоФайла(Расширение);
	
	Если Не ПолучитьФайл(АдресФайла, ИмяФайлаКартинки, Ложь) Тогда
		Возврат;
	КонецЕсли;	
		
	// для варианта с хранением файлов на диске (на сервере) удаляем Файл из временного хранилища после получения
	Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
		УдалитьИзВременногоХранилища(АдресФайла);
	КонецЕсли;
	
	ОписаниеОшибки = "";
	РаспознанныйТекст = "";
	ИмяФайлаРезультата = "";
	СтрокаВозврата = РаспознатьИзображение(ИмяФайлаКартинки, ЯзыкРаспознавания,
		РасширениеФайлаРезультата, ОписаниеОшибки, РаспознанныйТекст, ИмяФайлаРезультата);
	
	Если СтрокаВозврата = "Ошибка" Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								 НСтр("ru = 'Во время распознавания изображения из файла ""%1"" произошла ошибка.'"), 
								 ИмяСРасширениемФайла);
		ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибки);
		
		ЗанестиИнформациюОбОшибкеРаспознавания(ВерсияСсылка, ТекстСообщения);		
		Возврат;
	КонецЕсли;	
	
	АдресВременногоХранилищаФайла = "";
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("РаспознанныйТекст", РаспознанныйТекст);
	ПараметрыОповещения.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	ПараметрыОповещения.Вставить("СтрокаВозврата", СтрокаВозврата);
	ПараметрыОповещения.Вставить("ВерсияСсылка", ВерсияСсылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РаспознатьИзображениеКлиентПродолжить", ЭтотОбъект, ПараметрыОповещения);
		
	НачатьПомещениеФайла(ОписаниеОповещения, АдресВременногоХранилищаФайла,
		ИмяФайлаРезультата, Ложь, УникальныйИдентификатор);
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура РаспознатьИзображениеКлиентПродолжить(
	Результат, АдресВременногоХранилищаФайла, ИмяФайлаРезультата, ДополнительныеПараметры) Экспорт
	
#Если Не ВебКлиент Тогда	
		
	РаспознанныйТекст = ДополнительныеПараметры.РаспознанныйТекст;
		
	ФайлНаДиске = Новый Файл(ИмяФайлаРезультата);
	ДополнительныеПараметры.Вставить("ВремяИзменения", ФайлНаДиске.ПолучитьВремяИзменения());
	ДополнительныеПараметры.Вставить("ВремяИзмененияУниверсальное",
		ФайлНаДиске.ПолучитьУниверсальноеВремяИзменения());
	ДополнительныеПараметры.Вставить("РазмерФайла", ФайлНаДиске.Размер());
	ДополнительныеПараметры.Вставить("Расширение", ФайлНаДиске.Расширение);
	ДополнительныеПараметры.Вставить("АдресВременногоХранилищаФайла", АдресВременногоХранилищаФайла);
	
	УдалитьФайлы(ИмяФайлаРезультата);
	
	АдресВременногоХранилищаТекста = "";
	
	Если Не ПустаяСтрока(РаспознанныйТекст) Тогда
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
		ТекстовыйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
		ТекстовыйФайл.Записать(РаспознанныйТекст);
		ТекстовыйФайл.Закрыть();
		
		ДополнительныеПараметры.Вставить("ИмяВременногоФайла", ИмяВременногоФайла);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"РаспознатьИзображениеКлиентЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		НачатьПомещениеФайла(ОписаниеОповещения, АдресВременногоХранилищаТекста,
			ИмяВременногоФайла, Ложь, УникальныйИдентификатор);
			
		Возврат;
		
	КонецЕсли;
	
	РаспознатьИзображениеКлиентЗавершение(
		Ложь, АдресВременногоХранилищаТекста, ИмяФайлаРезультата, ДополнительныеПараметры);
	
#КонецЕсли

КонецПроцедуры
	
&НаКлиенте
Процедура РаспознатьИзображениеКлиентЗавершение(
	Результат, АдресВременногоХранилищаТекста, ИмяФайлаРезультата, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		УдалитьФайлы(ДополнительныеПараметры.ИмяВременногоФайла);
	КонецЕсли;
	
	ВерсияСсылка = ДополнительныеПараметры.ВерсияСсылка;
	СтрокаВозврата = ДополнительныеПараметры.СтрокаВозврата;
	ОписаниеОшибки = ДополнительныеПараметры.ОписаниеОшибки;
	АдресВременногоХранилищаФайла = ДополнительныеПараметры.АдресВременногоХранилищаФайла;
	ВремяИзменения = ДополнительныеПараметры.ВремяИзменения;
	ВремяИзмененияУниверсальное = ДополнительныеПараметры.ВремяИзмененияУниверсальное;
	РазмерФайла = ДополнительныеПараметры.РазмерФайла;
	Расширение = ДополнительныеПараметры.Расширение;
	
	ЭтоРегламентноеЗадание = Ложь;
	РаботаСФайламиВызовСервера.ЗаписатьРезультатРаспознавания(ВерсияСсылка, 
		СтрокаВозврата, ОписаниеОшибки, АдресВременногоХранилищаФайла, 
		АдресВременногоХранилищаТекста, УникальныйИдентификатор,
		ВремяИзменения, ВремяИзмененияУниверсальное, РазмерФайла, Расширение,
		ЭтоРегламентноеЗадание);
	
КонецПроцедуры

&НаКлиенте
// Функция нижнего уровня - вызывается для версии файла
Функция РаспознатьИзображение(ИмяФайлаКартинки, ЯзыкРаспознавания, РасширениеФайлаРезультата, ОписаниеОшибки, РаспознанныйТекст, ПутьКФайлу)
	
#Если Не ВебКлиент Тогда	
	Попытка
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаЗагрузкиCuneiForm",
			"CuneiFormLoaderAddIn", ТипВнешнейКомпоненты.Native);
		КомпонентаЗагрузкиCuneiForm = Новый("AddIn.CuneiFormLoaderAddIn.AddInNativeExtension");	
	Исключение
		ОписаниеОшибки = НСтр("ru = 'Не удалось загрузить компоненту загрузки картинок'");
		Возврат "Ошибка";
	КонецПопытки;
	
	ИмяФайлаРезультата = ПолучитьИмяВременногоФайла(РасширениеФайлаРезультата);
	ФорматРезультата = 2; // txt
	Если РасширениеФайлаРезультата = "html" Тогда
		ФорматРезультата = 8192; // html
	КонецЕсли;	
	Кодировка = 2; // ANSI
	
	ПриложениеЗапускаCuneiForm = ПолучитьИзВременногоХранилища(АдресПриложенияЗапускаCuneiForm);
	ПутьПриложенияЗапускаCuneiForm = ПолучитьИмяВременногоФайла("exe");
	ПриложениеЗапускаCuneiForm.Записать(ПутьПриложенияЗапускаCuneiForm);
	
	ВремяОжиданияРаспознавания = 30; // секунды
	
	КодВозврата = КомпонентаЗагрузкиCuneiForm.РаспознатьКартинку(ПутьПриложенияЗапускаCuneiForm,
		ИмяФайлаКартинки, ИмяФайлаРезультата, Число(ЯзыкРаспознавания), ВремяОжиданияРаспознавания, ПутьКПрограммеКонвертацииPDF);
		
	Если КодВозврата = Истина Тогда
		
		Текст = "";
		
		Если РасширениеФайлаРезультата = "html" Тогда
			
			Текст = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекст(ИмяФайлаРезультата);
			
		Иначе
			ТекстовыйДокумент = Новый ТекстовыйДокумент;
			ТекстовыйДокумент.Прочитать(ИмяФайлаРезультата); // если в формате TXT
			Текст = ТекстовыйДокумент.ПолучитьТекст();
		КонецЕсли;	
		
		ПутьКФайлу = ИмяФайлаРезультата;
		РаспознанныйТекст = Текст;
		Возврат "Успешно";
	КонецЕсли;	
	
	УдалитьФайлы(ИмяФайлаРезультата);
	ОписаниеОшибки = НСтр("ru = 'Не удалось распознать картинку. Возможно она не содержит текста для распознавания.'");
	
	Если ТипЗнч(КодВозврата) = Тип("Строка") Тогда
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru= '%1
			|
			|Описание ошибки: %2'"), ОписаниеОшибки, Строка(КодВозврата));
		ОписаниеОшибки = ОписаниеОшибки + Символы.ПС + Символы.ПС + НСтр("ru = 'Описание ошибки:'") + Строка(КодВозврата);
	КонецЕсли;
	
	Возврат "Ошибка";
#КонецЕсли

КонецФункции // РаспознатьФайл()

&НаКлиенте
Процедура ОткрытьПерсональныеНастройки(Команда)
	
	ЭтоВебКлиент = Ложь;
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#КонецЕсли
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	ПараметрыФормы = Новый Структура("ЭтоВебКлиент, ИдентификаторКлиента", ЭтоВебКлиент, ИдентификаторКлиента);
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ОткрытьПерсональныеНастройкиПродолжение", ЭтотОбъект);
	
	ОткрытьФорму(
		"Обработка.ПерсональныеНастройки.Форма.Файлы",
		ПараметрыФормы,,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПерсональныеНастройкиПродолжение(КодВозврата, Параметры) Экспорт
	
	Если КодВозврата = КодВозвратаДиалога.ОК Тогда
		
		ПутьКПрограммеКонвертацииPDF = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
			"НастройкиПрограммы", "ПутьКПрограммеКонвертацииPDF");
		Если ПустаяСтрока(ПутьКПрограммеКонвертацииPDF) Тогда
			ПутьКПрограммеКонвертацииPDF = "magick.exe"; // ImageMagick
		КонецЕсли;
		
		Если ИспользоватьImageMagickДляРаспознаванияPDF Тогда
			ИнформационнаяНадпись = НСтр("ru = 'Включена настройка ""Использовать ImageMagick для распознавания отсканированных документов формата PDF"". 
                                          |Путь к программе преобразования PDF: ""'");
			ИнформационнаяНадпись = ИнформационнаяНадпись + ПутьКПрограммеКонвертацииPDF;
			ИнформационнаяНадпись = ИнформационнаяНадпись + """";
		Иначе
			Элементы.ИнформационнаяНадпись.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоФайловВПорцииПриИзменении(Элемент)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"АвтоматическоеРаспознаваниеИзображений", "КоличествоФайловВПорции",  КоличествоФайловВПорции);
	
КонецПроцедуры

&НаКлиенте
Процедура Старт(Команда)
	
	НачатоРаспознавание = Истина;
	
	ПрогнозируемоеВремяНачалаРаспознавания = ТекущаяДата() + ИнтервалВремениВыполнения;
	ПодключитьОбработчикОжидания("РаспознаваниеИзображенийКлиентОбработчик", ИнтервалВремениВыполнения);
	РаспознаваниеИзображенийКлиентОбработчик();
	
	ПодключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета", 1);
	ОбновлениеОбратногоОтсчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Стоп(Команда)
	
	ОтключитьОбработчикОжидания("РаспознаваниеИзображенийКлиентОбработчик");
	ОтключитьОбработчикОжидания("ОбновлениеОбратногоОтсчета");
	Статус = "";
	НачатоРаспознавание = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспознатьВсе(Команда)
	
	КоличествоНераспознанныхФайловДоНачалаОперации = КоличествоНераспознанныхФайлов;
	Статус = "";
	РазмерПорции = 0; // распознать все
	РаспознаваниеИзображенийКлиент(РазмерПорции);
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Завершено распознавание всех нераспознанных файлов. Обработано файлов: %1.'"),
		КоличествоНераспознанныхФайловДоНачалаОперации);
	ПоказатьПредупреждение(, ТекстСообщения);
	
КонецПроцедуры

