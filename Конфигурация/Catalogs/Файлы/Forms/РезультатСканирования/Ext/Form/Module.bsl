﻿&НаКлиенте
Перем НарастающийНомерИзображения;

&НаКлиенте
Перем ПозицияДляВставки;

&НаСервере
Процедура ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление()
	
	РаботаСФайламиВызовСервера.ПреобразоватьПеречисленияВПараметрыСканера(
		Разрешение, Цветность, Поворот, РазмерБумаги, СжатиеTIFFЧисло,
		РазрешениеПеречисление, ЦветностьПеречисление, ПоворотПеречисление, РазмерБумагиПеречисление, СжатиеTIFF);
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF Тогда
			ФорматКартинки = Строка(ФорматСканированногоИзображения);
		Иначе	
			ФорматКартинки = Строка(ФорматХраненияОдностраничный);
		КонецЕсли;
	Иначе	
		ФорматКартинки = Строка(ФорматСканированногоИзображения);
	КонецЕсли;
	
	Представление = "";
	// информационная надпись вида:
	// "Формат хранения: PDF. Формат сканирования: JPG. Качество: 75. Формат хранения многостраничный: PDF. Разрешение: 200. Цветное";
	
	Представление = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекСканирования(
		ИспользоватьImageMagickДляПреобразованияВPDF, ФорматКартинки,
		ФорматХраненияОдностраничный, ФорматХраненияМногостраничный, ФорматСканированногоИзображения,
		КачествоJPG, СжатиеTIFF, Разрешение, ЦветностьПеречисление,
		ПоворотПеречисление, РазмерБумагиПеречисление, ДвустороннееСканирование);
	
	Если ИспользоватьРаспознавание Тогда
		Представление = Представление + Символы.ВК + НСтр("ru = 'Режим распознавания: '") + ПредставлениеНастроекРаспознавания;
	КонецЕсли;	
	
	ТекстНастроек = Представление;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаФайлов.Видимость = Ложь;
	Элементы.ФормаПринятьВсеКакОдинФайл.Видимость = Ложь;
	Элементы.ФормаПринятьВсеКакОтдельныеФайлы.Видимость = Ложь;
	Элементы.Принять.КнопкаПоУмолчанию = Истина;
	
	Если Параметры.Свойство("ВладелецФайла") Тогда
		ВладелецФайла = Параметры.ВладелецФайла;
	КонецЕсли;
	
	Если Параметры.Свойство("ИдентификаторРодительскойФормы") Тогда
		ИдентификаторРодительскойФормы = Параметры.ИдентификаторРодительскойФормы;
	КонецЕсли;
	
	ИдентификаторКлиента = Параметры.ИдентификаторКлиента;
	
	Если Параметры.Свойство("НеОткрыватьКарточкуПослеСозданияИзФайла") Тогда
		НеОткрыватьКарточкуПослеСозданияИзФайла = Параметры.НеОткрыватьКарточкуПослеСозданияИзФайла;
	КонецЕсли;
	
	ПрефиксИнформационнойБазы = ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы");
	
	НомерФайла = РаботаСФайламиВызовСервера.ПолучитьНовыйНомерДляСканирования(ВладелецФайла);
	ИмяФайла = РаботаСФайламиКлиентСервер.ИмяСканированногоФайла(НомерФайла, ПрефиксИнформационнойБазы);

	ФорматСканированногоИзображения = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ФорматСканированногоИзображения", 
			ИдентификаторКлиента, Перечисления.ФорматыСканированногоИзображения.PNG);
	
	ФорматХраненияОдностраничный = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ФорматХраненияОдностраничный", 
			ИдентификаторКлиента, Перечисления.ФорматыХраненияОдностраничныхФайлов.PNG);
	
	ФорматХраненияМногостраничный = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ФорматХраненияМногостраничный", 
			ИдентификаторКлиента, Перечисления.ФорматыХраненияМногостраничныхФайлов.TIF);
	
	Если ИспользоватьImageMagickДляПреобразованияВPDF Тогда
		Если ФорматХраненияОдностраничный = Перечисления.ФорматыХраненияОдностраничныхФайлов.PDF Тогда
			ФорматКартинки = Строка(ФорматСканированногоИзображения);
		Иначе	
			ФорматКартинки = Строка(ФорматХраненияОдностраничный);
		КонецЕсли;
	Иначе	
		ФорматКартинки = Строка(ФорматСканированногоИзображения);
	КонецЕсли;
	
	РазрешениеПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/Разрешение", ИдентификаторКлиента);
	ЦветностьПеречисление =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/Цветность", ИдентификаторКлиента);
	
	ПоворотПеречисление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/Поворот", ИдентификаторКлиента);
	РазмерБумагиПеречисление =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/РазмерБумаги", ИдентификаторКлиента);
	
	ДвустороннееСканирование = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ДвустороннееСканирование", ИдентификаторКлиента);
	ИспользоватьImageMagickДляПреобразованияВPDF =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ИспользоватьImageMagickДляПреобразованияВPDF", ИдентификаторКлиента);
	
	КачествоJPG =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/КачествоJPG", ИдентификаторКлиента, 100);
	
	СжатиеTIFF =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/СжатиеTIFF", 
		ИдентификаторКлиента, Перечисления.ВариантыСжатияTIFF.БезСжатия);
	
	ПутьКПрограммеКонвертации =  ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ПутьКПрограммеКонвертации", 
		ИдентификаторКлиента, "magick.exe");
	
	ПоказыватьДиалогСканераЗагрузка = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ПоказыватьДиалогСканера", ИдентификаторКлиента);
	Если ПоказыватьДиалогСканераЗагрузка = Неопределено Тогда
		ПоказыватьДиалогСканераЗагрузка = Истина;
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ПоказыватьДиалогСканера", ИдентификаторКлиента, ПоказыватьДиалогСканераЗагрузка);
	КонецЕсли;
	ПоказыватьДиалогСканера = ПоказыватьДиалогСканераЗагрузка;
	
	ИмяУстройства = 
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиСканирования/ИмяУстройства", ИдентификаторКлиента);
	Если ИмяУстройства = Неопределено Тогда
		ИмяУстройства = "";
		ХранилищеОбщихНастроек.Сохранить("НастройкиСканирования/ИмяУстройства", ИдентификаторКлиента, ИмяУстройства);
	КонецЕсли;
	ИмяУстройстваСканирования = ИмяУстройства;
	
	ФорматJPG = Перечисления.ФорматыСканированногоИзображения.JPG;
	ФорматTIF = Перечисления.ФорматыСканированногоИзображения.TIF;
	
	ИспользоватьРаспознавание = РаботаСФайламиВызовСервера.ПолучитьИспользоватьРаспознавание();
	Если ИспользоватьРаспознавание = Ложь Тогда
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.НеРаспознавать;
	Иначе
		ЯзыкРаспознавания = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Распознавание", "ЯзыкРаспознавания");
		Если НЕ ЗначениеЗаполнено(ЯзыкРаспознавания) Тогда
			ЯзыкРаспознавания = РаботаСФайламиВызовСервера.ПолучитьЯзыкРаспознавания();
		КонецЕсли;
		
		СтратегияРаспознавания = Перечисления.СтратегииРаспознаванияТекста.ПоместитьТолькоВТекстовыйОбраз;
		
		ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
	КонецЕсли;	
	
	ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПриОткрытииКлиент", 0.2, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииКлиент()
	
	Отказ = Ложь;
	ПриОткрытииАвтомат(Отказ, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииАвтомат(ОтказИлиРезультат, ПараметрыОткрытия) Экспорт
	ПрямойВызовИзПриОткрытии = (ПараметрыОткрытия = Неопределено);
	
	Если ПрямойВызовИзПриОткрытии Тогда
		// Первичная инициализация автомата (вызов из ПриОткрытии()).
		Если ПроверкиПриОткрытииВыполнены Тогда
			Возврат; // Открыть форму (проверки были выполнены ранее).
		КонецЕсли;
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТекущийШаг", 1);
		ПараметрыОткрытия.Вставить("ПоказыватьДиалог", Неопределено);
		ПараметрыОткрытия.Вставить("ВыбранноеУстройство", Неопределено);
	Иначе
		// Вторичная инициализация автомата (вызов из диалога, открытого автоматом).
		Если ПараметрыОткрытия.ТекущийШаг = 2 Тогда
			Если ТипЗнч(ОтказИлиРезультат) = Тип("Структура") Тогда
				ПараметрыОткрытия.ВыбранноеУстройство = ОтказИлиРезультат.Значение;
				ИмяУстройстваСканирования = ПараметрыОткрытия.ВыбранноеУстройство;
			КонецЕсли;
			Если ПараметрыОткрытия.ВыбранноеУстройство = "" Тогда 
				Закрыть();
				Возврат; // Не открывать форму.
			КонецЕсли;
			ПараметрыОткрытия.ТекущийШаг = 3;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТекущийШаг = 1 Тогда
		Если Не РаботаСоСканеромКлиент.ПроинициализироватьКомпоненту() Тогда
			ОтказИлиРезультат = Истина; // Не открывать форму.
			Закрыть();
			Возврат;
		КонецЕсли;
		
		// Вызывается здесь, т.к. вызов КомпонентаTwain.ЕстьУстройства()
		// занимает очень много времени (больше, чем ОбновитьПовторноИспользуемыеЗначения()).
		Если Не РаботаСоСканеромКлиентПовтИсп.ДоступнаКомандаСканировать() Тогда
			ОтказИлиРезультат = Истина; // Не открывать форму.
			ОбновитьПовторноИспользуемыеЗначения();
			Закрыть();
			Возврат;
		КонецЕсли;
		
		ПараметрыОткрытия.ТекущийШаг = 2;
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТекущийШаг = 2 Тогда
		ПараметрыОткрытия.ПоказыватьДиалог = ПоказыватьДиалогСканера;
		ПараметрыОткрытия.ВыбранноеУстройство = ИмяУстройстваСканирования;
		
		Если ПараметрыОткрытия.ВыбранноеУстройство = "" Тогда
			ОтказИлиРезультат = Истина; // Не открывать форму.
			Обработчик = Новый ОписаниеОповещения("ПриОткрытииАвтомат", ЭтотОбъект, ПараметрыОткрытия);
			ОткрытьФорму("Справочник.Файлы.Форма.ВыборУстройстваСканирования", , ЭтотОбъект, , , , Обработчик, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			Возврат;
		КонецЕсли;
		
		ПараметрыОткрытия.ТекущийШаг = 3;
	КонецЕсли;
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	
	Если ПараметрыОткрытия.ТекущийШаг = 3 Тогда
		
		Если Разрешение = -1 ИЛИ Цветность = -1 ИЛИ Поворот = -1 ИЛИ РазмерБумаги = -1 Тогда
		
			Разрешение  = РаботаСоСканеромКлиент.ПолучитьНастройку(ВыбранноеУстройство, "XRESOLUTION");
			Цветность   = РаботаСоСканеромКлиент.ПолучитьНастройку(ВыбранноеУстройство, "PIXELTYPE");
			Поворот  	= РаботаСоСканеромКлиент.ПолучитьНастройку(ВыбранноеУстройство, "ROTATION");
			РазмерБумаги = РаботаСоСканеромКлиент.ПолучитьНастройку(ВыбранноеУстройство, "SUPPORTEDSIZES");
			ДвустороннееСканированиеЧисло = РаботаСоСканеромКлиент.ПолучитьНастройку(ВыбранноеУстройство, "DUPLEX");
			
			ДоступностьПоворот = (Поворот <> -1);
			ДоступностьРазмерБумаги = (РазмерБумаги <> -1);
			ДоступностьДвустороннееСканирование = (ДвустороннееСканированиеЧисло <> -1);
			
			СистемнаяИнформация = Новый СистемнаяИнформация();
			ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
			
			РаботаСФайламиВызовСервера.ПреобразоватьИСохранитьПараметрыСканера(Разрешение, Цветность, 
				Поворот, РазмерБумаги, ИдентификаторКлиента);
		Иначе
			
			ДоступностьПоворот = Не ПоворотПеречисление.Пустая();
			ДоступностьРазмерБумаги = Не РазмерБумагиПеречисление.Пустая();
			ДоступностьДвустороннееСканирование = Истина;

		КонецЕсли;	
	
		ИмяФайлаКартинки = "";
		Элементы.Принять.Доступность = Ложь;
		
		ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
		
		ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].НачатьСканирование(
			ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
			Разрешение, Цветность, Поворот, РазмерБумаги, 
			ПараметрСжатие,
			ДвустороннееСканирование);
		
	КонецЕсли;		

	Если Не ПрямойВызовИзПриОткрытии Тогда
		ПроверкиПриОткрытииВыполнены = Истина;
		Открыть();
		ПроверкиПриОткрытииВыполнены = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УдалитьВременныеФайлы(ПараметрыВыполнения.МассивФайловКопия);
	Если НЕ ПустаяСтрока(ПараметрыВыполнения.ФайлРезультата) Тогда
		УдалитьФайлы(ПараметрыВыполнения.ФайлРезультата);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОдинФайлЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УдалитьВременныеФайлы(ПараметрыВыполнения.МассивФайловКопия);
	УдалитьФайлы(ПараметрыВыполнения.ФайлРезультата);
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОдинФайлЗавершениеПослеПредупреждения(ПараметрыВыполнения) Экспорт
	
	УдалитьВременныеФайлы(ПараметрыВыполнения.МассивФайловКопия);
	УдалитьФайлы(ПараметрыВыполнения.ФайлРезультата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.НастройкаСканированияНаСеанс") Тогда
		
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		РазрешениеПеречисление   = ВыбранноеЗначение.Разрешение;
		ЦветностьПеречисление    = ВыбранноеЗначение.Цветность;
		ПоворотПеречисление      = ВыбранноеЗначение.Поворот;
		РазмерБумагиПеречисление = ВыбранноеЗначение.РазмерБумаги;
		ДвустороннееСканирование = ВыбранноеЗначение.ДвустороннееСканирование;
		
		ИспользоватьImageMagickДляПреобразованияВPDF = ВыбранноеЗначение.ИспользоватьImageMagickДляПреобразованияВPDF;
		
		ПоказыватьДиалогСканера         = ВыбранноеЗначение.ПоказыватьДиалогСканера;
		ФорматСканированногоИзображения = ВыбранноеЗначение.ФорматСканированногоИзображения;
		КачествоJPG                     = ВыбранноеЗначение.КачествоJPG;
		СжатиеTIFF                      = ВыбранноеЗначение.СжатиеTIFF;
		ФорматХраненияОдностраничный    = ВыбранноеЗначение.ФорматХраненияОдностраничный;
		ФорматХраненияМногостраничный   = ВыбранноеЗначение.ФорматХраненияМногостраничный;
		
		СтратегияРаспознавания = ВыбранноеЗначение.СтратегияРаспознавания;
		ЯзыкРаспознавания = ВыбранноеЗначение.ЯзыкРаспознавания;
		ПредставлениеНастроекРаспознавания = РаботаСФайламиВызовСервера.ПолучитьПредставлениеНастроекРаспознавания(СтратегияРаспознавания, ЯзыкРаспознавания);
		
		ПреобразоватьПеречисленияВПараметрыИПолучитьПредставление();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьВременныеФайлы(ТаблицаФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	УдалитьВременныеФайлы(ТаблицаФайлов);
	Закрыть();
КонецПроцедуры

// Кнопка "Пересканировать" замещает выделенную (или единственную, если она одна) картинку 
//  (или добавляет в конец новые картинки, если ничего не выделено) новым изображением (изображениями).
&НаКлиенте
Процедура Пересканировать(Команда)
	
	УдалитьВременныеФайлы(ТаблицаФайлов);
	
	Если АдресКартинки <> "" Тогда
		УдалитьИзВременногоХранилища(АдресКартинки);
	КонецЕсли;	
	АдресКартинки = "";
	ПутьКВыбранномуФайлу = "";
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].НачатьСканирование(
		ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
		Разрешение, Цветность, Поворот, РазмерБумаги, 
		ПараметрСжатие,
		ДвустороннееСканирование);
		
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Источник = "TWAIN" И Событие = "ImageAcquired" Тогда
		
		ИмяФайлаКартинки = Данные;
		Элементы.Принять.Доступность = Истина;
		
		КоличествоСтрокДоДобавления = ТаблицаФайлов.Количество();
		
		СтрокаТаблицы = Неопределено;
		
		Если ПозицияДляВставки = Неопределено Тогда
			СтрокаТаблицы = ТаблицаФайлов.Добавить();
		Иначе	
			СтрокаТаблицы = ТаблицаФайлов.Вставить(ПозицияДляВставки);
			ПозицияДляВставки = ПозицияДляВставки + 1;
		КонецЕсли;
		
		СтрокаТаблицы.ПутьКФайлу = ИмяФайлаКартинки;
		
		Если НарастающийНомерИзображения = Неопределено Тогда
			НарастающийНомерИзображения = 1;
		КонецЕсли;	
			
		СтрокаТаблицы.Представление = "Изображение" + Строка(НарастающийНомерИзображения);
		НарастающийНомерИзображения = НарастающийНомерИзображения + 1;
		
		Если КоличествоСтрокДоДобавления = 0 Тогда
			ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
			СтрокаТаблицы.АдресКартинки = АдресКартинки;
		КонецЕсли;
		
		Если ТаблицаФайлов.Количество() > 1 И Элементы.ТаблицаФайлов.Видимость = Ложь Тогда
			Элементы.ТаблицаФайлов.Видимость = Истина;
			Элементы.ФормаПринятьВсеКакОдинФайл.Видимость = Истина;
			Элементы.ФормаПринятьВсеКакОтдельныеФайлы.Видимость = Истина;
			Элементы.Принять.Видимость = Ложь;
			Элементы.ФормаПринятьВсеКакОдинФайл.КнопкаПоУмолчанию = Истина;
		КонецЕсли;	
		
		Если ТаблицаФайлов.Количество() > 1 Тогда
			Элементы.ТаблицаФайловКонтекстноеМенюУдалить.Доступность = Истина;
		КонецЕсли;	
		
	ИначеЕсли Источник = "TWAIN" И Событие = "EndBatch" Тогда
		
		Если ТаблицаФайлов.Количество() <> 0 Тогда
			ИдентификаторСтроки = ТаблицаФайлов[ТаблицаФайлов.Количество() - 1].ПолучитьИдентификатор();
			Элементы.ТаблицаФайлов.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;	
		
	ИначеЕсли Источник = "TWAIN" И Событие = "UserPressedCancel" Тогда	
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СканироватьЕще(Команда)
	
	ПоказыватьДиалог = ПоказыватьДиалогСканера;
	ВыбранноеУстройство = ИмяУстройстваСканирования;
	ПараметрСжатие = ?(ВРег(ФорматКартинки) = "JPG", КачествоJPG, СжатиеTIFFЧисло);
	
	ПозицияДляВставки = Неопределено;
	
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].НачатьСканирование(
		ПоказыватьДиалог, ВыбранноеУстройство, ФорматКартинки, 
		Разрешение, Цветность, Поворот, РазмерБумаги, 
		ПараметрСжатие,
		ДвустороннееСканирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПриАктивизацииСтроки(Элемент)
	
#Если НЕ ВебКлиент Тогда	
	
	Если Элементы.ТаблицаФайлов.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НомерТекущейСтроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСтроки);
	
	Если ПутьКВыбранномуФайлу <> СтрокаТаблицы.ПутьКФайлу Тогда
		
		ПутьКВыбранномуФайлу = СтрокаТаблицы.ПутьКФайлу;
		
		Если ПустаяСтрока(СтрокаТаблицы.АдресКартинки) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКВыбранномуФайлу);
			СтрокаТаблицы.АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;	
		
		АдресКартинки = СтрокаТаблицы.АдресКартинки;
		
	КонецЕсли;	
	
#КонецЕсли	

КонецПроцедуры

&НаКлиенте
Процедура УдалитьВременныеФайлы(ТаблицаЗначенийФайлов)
	
	Для Каждого Строка Из ТаблицаЗначенийФайлов Цикл
		УдалитьФайлы(Строка.ПутьКФайлу);
	КонецЦикла;	
	
	ТаблицаЗначенийФайлов.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОтдельныеФайлы(Команда)
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;	
	
	ТаблицаФайлов.Очистить(); // чтобы не удалились файлы в ПриЗакрытии
	
	Закрыть();
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	ПолныйТекстВсехОшибок = "";
	КоличествоОшибок = 0;
	
	// здесь работаем со всеми картинками -каждую как отдельный файл принимаем
	Для Каждого Строка Из МассивФайловКопия Цикл
		
		ПутьКФайлуЛокальный = Строка.ПутьКФайлу;
		
		ФайлРезультата = "";
		Если РасширениеРезультата = "pdf" Тогда
			
		#Если НЕ ВебКлиент Тогда 	
			ФайлРезультата = ПолучитьИмяВременногоФайла("pdf");
		#КонецЕсли	
		
			СтрокаВсехПутей = ПутьКФайлуЛокальный;
			ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(
				СтрокаВсехПутей, ФайлРезультата, ПутьКПрограммеКонвертации);
			
			ОбъектФайлРезультата = Новый Файл(ФайлРезультата);
			Если НЕ ОбъектФайлРезультата.Существует() Тогда				
				ТекстОшибки = ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата);
				Если ПолныйТекстВсехОшибок <> "" Тогда
					ПолныйТекстВсехОшибок = ПолныйТекстВсехОшибок + Символы.ПС + Символы.ПС + "---" + Символы.ПС + Символы.ПС;
				КонецЕсли;
				ПолныйТекстВсехОшибок = ПолныйТекстВсехОшибок + ТекстОшибки;
				КоличествоОшибок = КоличествоОшибок + 1;
				ФайлРезультата = "";
			КонецЕсли;	
			
			ПутьКФайлуЛокальный = ФайлРезультата;
			
		КонецЕсли;	
		
		ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", 
			СтратегияРаспознавания, ЯзыкРаспознавания);
			
		Если НЕ ПустаяСтрока(ПутьКФайлуЛокальный) Тогда
			НеОткрыватьКарточку = Истина;
			ДополнительныеПараметры = Новый Структура("Сканирование", Истина);
			РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПутьКФайлуЛокальный, ВладелецФайла, ЭтаФорма, 
				НеОткрыватьКарточку, ИмяФайла, ПараметрыРаспознавания, 
				Неопределено, // список категорий
				ДополнительныеПараметры);
		КонецЕсли;	
		
		Если НЕ ПустаяСтрока(ФайлРезультата) Тогда
			УдалитьФайлы(ФайлРезультата);
		КонецЕсли;
		
		НомерФайла = НомерФайла + 1;
		ИмяФайла = РаботаСФайламиКлиентСервер.ИмяСканированногоФайла(НомерФайла, ПрефиксИнформационнойБазы);
		
	КонецЦикла;
	
	РаботаСФайламиВызовСервера.ЗанестиМаксимальныйНомерДляСканирования(ВладелецФайла, НомерФайла - 1);
	
	УдалитьВременныеФайлы(МассивФайловКопия);
	
	Если КоличествоОшибок > 0 Тогда
		ПоказатьПредупреждение(, ПолныйТекстВсехОшибок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьВсеКакОдинФайл(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивФайловКопия", Новый Массив);
	ПараметрыВыполнения.Вставить("ФайлРезультата", "");
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		ПараметрыВыполнения.МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;	
	
	ТаблицаФайлов.Очистить(); // чтобы не удалились файлы в ПриЗакрытии
	
	Закрыть();
	
	// здесь работаем со всеми картинками - объединяем их в один многостраничный файл
	СтрокаВсехПутей = "";
	Для Каждого Строка Из ПараметрыВыполнения.МассивФайловКопия Цикл
		СтрокаВсехПутей = СтрокаВсехПутей + "*";
		СтрокаВсехПутей = СтрокаВсехПутей + Строка.ПутьКФайлу;
	КонецЦикла;
	
	ФайлРезультата = "";
#Если НЕ ВебКлиент Тогда 	
	РасширениеРезультата = Строка(ФорматХраненияМногостраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	ПараметрыВыполнения.ФайлРезультата = ПолучитьИмяВременногоФайла(РасширениеРезультата);
#КонецЕсли	
	ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(
		СтрокаВсехПутей, ПараметрыВыполнения.ФайлРезультата, ПутьКПрограммеКонвертации);
	
	ОбъектФайлРезультата = Новый Файл(ПараметрыВыполнения.ФайлРезультата);
	Если НЕ ОбъектФайлРезультата.Существует() Тогда				
		ТекстСообщения = ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата);					
		ПараметрыВыполнения.ФайлРезультата = "";
		Обработчик = Новый ОписаниеОповещения("ПринятьВсеКакОдинФайлЗавершениеПослеПредупреждения", ЭтотОбъект, ПараметрыВыполнения);
		ПоказатьПредупреждение(Обработчик, ТекстСообщения);
		Возврат;
	КонецЕсли;	
	
	ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", 
		СтратегияРаспознавания, ЯзыкРаспознавания);
		
	Если НЕ ПустаяСтрока(ПараметрыВыполнения.ФайлРезультата) Тогда
		Обработчик = Новый ОписаниеОповещения("ПринятьВсеКакОдинФайлЗавершение", ЭтотОбъект, ПараметрыВыполнения);
		
		ПараметрыДобавления = Новый Структура;
		ПараметрыДобавления.Вставить("ОбработчикРезультата", Обработчик);
		ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
		ПараметрыДобавления.Вставить("ПолноеИмяФайла", ПараметрыВыполнения.ФайлРезультата);
		ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", ИмяФайла);
		ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточкуПослеСозданияИзФайла);
		ПараметрыДобавления.Вставить("ПараметрыРаспознавания", ПараметрыРаспознавания);
		
		РаботаСФайламиКлиент.ДобавитьИзФайловойСистемыСРасширением(ПараметрыДобавления);
		
		Возврат;
	КонецЕсли;
	
	ПринятьВсеКакОдинФайлЗавершение(-1, ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ФайлРезультата)
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не найден файл ""%1"". Проверьте, что установлена программа ImageMagick и указан правильный путь к программе преобразования в PDF в форме персональных настроек.'"),
		ФайлРезультата);
		
	Возврат ТекстСообщения;
	
КонецФункции		

&НаКлиенте
Процедура Принять(Команда)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивФайловКопия", Новый Массив);
	ПараметрыВыполнения.Вставить("ФайлРезультата", "");
	
	МассивФайловКопия = Новый Массив;
	Для Каждого Строка Из ТаблицаФайлов Цикл
		ПараметрыВыполнения.МассивФайловКопия.Добавить(Новый Структура("ПутьКФайлу", Строка.ПутьКФайлу));
	КонецЦикла;	
	
	// здесь работаем с одним файлом
	СтрокаТаблицы = ТаблицаФайлов.Получить(0);
	ПутьКФайлуЛокальный = СтрокаТаблицы.ПутьКФайлу;
	
	ТаблицаФайлов.Очистить(); // чтобы не удалились файлы в ПриЗакрытии
	
	Закрыть();
	
	РасширениеРезультата = Строка(ФорматХраненияОдностраничный);
	РасширениеРезультата = НРег(РасширениеРезультата); 
	
	ФайлРезультата = "";
	Если РасширениеРезультата = "pdf" Тогда
		
		#Если НЕ ВебКлиент Тогда 	
			ПараметрыВыполнения.ФайлРезультата = ПолучитьИмяВременногоФайла("pdf");
		#КонецЕсли	
	
		СтрокаВсехПутей = ПутьКФайлуЛокальный;
		ПараметрыПриложения["СтандартныеПодсистемы.КомпонентаTwain"].ОбъединитьВМногостраничныйФайл(
			СтрокаВсехПутей, ПараметрыВыполнения.ФайлРезультата, ПутьКПрограммеКонвертации);
		
		ОбъектФайлРезультата = Новый Файл(ПараметрыВыполнения.ФайлРезультата);
		Если НЕ ОбъектФайлРезультата.Существует() Тогда				
			ТекстСообщения = ПолучитьТекстСообщенияОшибкиПреобразованияВPDF(ПараметрыВыполнения.ФайлРезультата);					
			ПоказатьПредупреждение(,ТекстСообщения);
			УдалитьФайлы(ПутьКФайлуЛокальный);
			ПринятьЗавершение(-1, ПараметрыВыполнения);
			Возврат;
		КонецЕсли;	
		
		УдалитьФайлы(ПутьКФайлуЛокальный);
		ПутьКФайлуЛокальный = ПараметрыВыполнения.ФайлРезультата;
		
	КонецЕсли;	
	
	ПараметрыРаспознавания = Новый Структура("СтратегияРаспознавания, ЯзыкРаспознавания", 
		СтратегияРаспознавания, ЯзыкРаспознавания);
		
	Если НЕ ПустаяСтрока(ПутьКФайлуЛокальный) Тогда
		Обработчик = Новый ОписаниеОповещения("ПринятьЗавершение", ЭтотОбъект, ПараметрыВыполнения);
		
		ПараметрыДобавления = Новый Структура;
		ПараметрыДобавления.Вставить("ОбработчикРезультата", Обработчик);
		ПараметрыДобавления.Вставить("ПолноеИмяФайла", ПутьКФайлуЛокальный);
		ПараметрыДобавления.Вставить("ВладелецФайла", ВладелецФайла);
		ПараметрыДобавления.Вставить("ФормаВладелец", ЭтотОбъект);
		ПараметрыДобавления.Вставить("ИмяСоздаваемогоФайла", ИмяФайла);
		ПараметрыДобавления.Вставить("НеОткрыватьКарточкуПослеСозданияИзФайла", НеОткрыватьКарточкуПослеСозданияИзФайла);
		ПараметрыДобавления.Вставить("ПараметрыРаспознавания", ПараметрыРаспознавания);
		
		РаботаСФайламиКлиент.ДобавитьИзФайловойСистемыСРасширением(ПараметрыДобавления);
		
		Возврат;
	КонецЕсли;
	
	ПринятьЗавершение(-1, ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Настройка(Команда)
	
	ДвустороннееСканированиеЧисло = РаботаСоСканеромКлиент.ПолучитьНастройку(ИмяУстройстваСканирования, "DUPLEX");
	ДоступностьДвустороннееСканирование = (ДвустороннееСканированиеЧисло <> -1);
	
	ПараметрыФормы = Новый Структура(
		"ПоказыватьДиалогСканера, Разрешение, Цветность, Поворот, РазмерБумаги, 
			| ДвустороннееСканирование, ИспользоватьImageMagickДляПреобразованияВPDF, ДоступностьПоворот, 
			| ДоступностьРазмерБумаги, ДоступностьДвустороннееСканирование, ФорматСканированногоИзображения, КачествоJPG, СжатиеTIFF,
			| ФорматХраненияОдностраничный, ФорматХраненияМногостраничный, СтратегияРаспознавания, ЯзыкРаспознавания",
		ПоказыватьДиалогСканера, РазрешениеПеречисление, ЦветностьПеречисление, ПоворотПеречисление, 
		РазмерБумагиПеречисление, ДвустороннееСканирование, ИспользоватьImageMagickДляПреобразованияВPDF,
		ДоступностьПоворот, ДоступностьРазмерБумаги, ДоступностьДвустороннееСканирование,
		ФорматСканированногоИзображения, КачествоJPG, СжатиеTIFF,
		ФорматХраненияОдностраничный, ФорматХраненияМногостраничный,
		СтратегияРаспознавания, ЯзыкРаспознавания);
	
	ОткрытьФорму("Справочник.Файлы.Форма.НастройкаСканированияНаСеанс", ПараметрыФормы, ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПередУдалением(Элемент, Отказ)
	
	Если ТаблицаФайлов.Количество() < 2 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	НомерТекущейСтроки = Элементы.ТаблицаФайлов.ТекущаяСтрока;
	СтрокаТаблицы = Элементы.ТаблицаФайлов.ДанныеСтроки(НомерТекущейСтроки);
	УдалитьФайлы(СтрокаТаблицы.ПутьКФайлу);
	
	Если ТаблицаФайлов.Количество() = 2 Тогда
		Элементы.ТаблицаФайловКонтекстноеМенюУдалить.Доступность = Ложь;
	КонецЕсли;	
	
КонецПроцедуры
