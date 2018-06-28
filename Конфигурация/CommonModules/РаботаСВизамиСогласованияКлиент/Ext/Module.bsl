﻿#Область ПрограммныйИнтерфейс

// Выполняет проверку возможности старта бизнес-процесса в зависимости от существующих виз в документе
//
Процедура ПередСтартомБизнесПроцесса(
	Объект, 
	Отказ,
	ИдентификаторФормыПроцесса,
	ПараметрыЗаписиПроцесса) Экспорт 
	
	ТипыДокументов = МультипредметностьКлиентСервер.ПолучитьТипыДокументов();
	Предметы = МультипредметностьКлиентСервер.ПолучитьМассивПредметовОбъекта(Объект, ТипыДокументов, Истина);
	
	Если Предметы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Исполнители = Объект.Исполнители;
	
	Для Каждого Предмет из Предметы Цикл
		Результат = РаботаСВизамиСогласования.ПроверитьПересечениеВизИИсполнителей(Предмет, Исполнители);
		
		Если Результат = "стартовать" Тогда 
			
		ИначеЕсли Результат = "нестартовать" Тогда
			ТекстПредупреждения = НСтр("ru = 'Невозможно стартовать процесс, так как некоторые из согласующих лиц 
			|участвуют в других незавершенных процессах согласования по предмету ""%1"".'");
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, Строка(Предмет));
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Отказ = Истина;
			
		ИначеЕсли Результат = "досогласовать" Тогда
			
			ПоПредметуБылДанОтвет = Ложь; 
			Для Каждого Параметр Из ПараметрыЗаписиПроцесса Цикл
				Если Параметр.Ключ = "Досогласовать" + СтрЗаменить(Строка(Предмет.УникальныйИдентификатор()), "-", "") Тогда
					ПоПредметуБылДанОтвет = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ПоПредметуБылДанОтвет Тогда
				Продолжить;
			КонецЕсли;
			
			ПараметрыОбработчикаОповещения = Новый Структура;
			ПараметрыОбработчикаОповещения.Вставить("ПараметрыЗаписиПроцесса", ПараметрыЗаписиПроцесса);
			ПараметрыОбработчикаОповещения.Вставить("ИдентификаторФормыПроцесса", ИдентификаторФормыПроцесса);
			ПараметрыОбработчикаОповещения.Вставить("Предмет", Предмет);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПередСтартомБизнесПроцессаПродолжениеДосогласовать",
				ЭтотОбъект,
				ПараметрыОбработчикаОповещения);
			
			ТекстВопроса = НСтр("ru = 'В согласуемом документе ""%1"" уже присутствуют результаты согласования других сотрудников.
				|Поместить их в историю или оставить актуальными?'");
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Строка(Предмет));
			
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("ПоместитьВИсторию", 	НСтр("ru = 'Поместить в историю'"));
			Кнопки.Добавить("ОставитьАктуальными", 	НСтр("ru = 'Оставить актуальными'"));
			Кнопки.Добавить("Отменить", 			НСтр("ru = 'Отменить'"));
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
			Отказ = Истина;
			
		ИначеЕсли Результат = "пересогласовать" Тогда 
			
			ПоПредметуБылДанОтвет = Ложь; 
			Для Каждого Параметр Из ПараметрыЗаписиПроцесса Цикл
				Если Параметр.Ключ = "Пересогласовать" + СтрЗаменить(Строка(Предмет.УникальныйИдентификатор()), "-", "") Тогда
					ПоПредметуБылДанОтвет = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ПоПредметуБылДанОтвет Тогда
				Продолжить;
			КонецЕсли;
			
			ПараметрыОбработчикаОповещения = Новый Структура;
			ПараметрыОбработчикаОповещения.Вставить("ПараметрыЗаписиПроцесса", ПараметрыЗаписиПроцесса);
			ПараметрыОбработчикаОповещения.Вставить("ИдентификаторФормыПроцесса", ИдентификаторФормыПроцесса);
			ПараметрыОбработчикаОповещения.Вставить("Предмет", Предмет);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПередСтартомБизнесПроцессаПродолжениеПересогласовать",
				ЭтотОбъект,
				ПараметрыОбработчикаОповещения);
			
			ТекстВопроса = НСтр("ru = 'В согласуемом документе ""%1"" уже присутствуют результаты согласования этих же сотрудников,
				|они будут помещены в историю согласования. Продолжить?'");
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Строка(Предмет));
			
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Отказ = Истина;
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры	

Процедура ПередСтартомБизнесПроцессаПродолжениеДосогласовать(Результат, Параметры) Экспорт
	
	Если Результат = "ПоместитьВИсторию" Или Результат = "ОставитьАктуальными" Тогда 
		Если Результат = "ПоместитьВИсторию" Тогда 
			РаботаСВизамиСогласования.ПоместитьЗакрытиеВизыДокументаВИсторию(Параметры.Предмет);
		КонецЕсли;
		Параметры.ПараметрыЗаписиПроцесса.Вставить("Досогласовать" + СтрЗаменить(Строка(Параметры.Предмет.УникальныйИдентификатор()), "-", ""));
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("ИдентификаторФормы", Параметры.ИдентификаторФормыПроцесса);
		ПараметрыОповещения.Вставить("ПараметрыЗаписиПроцесса", Параметры.ПараметрыЗаписиПроцесса);
		Оповестить("СтартПроцессаПослеВопроса", ПараметрыОповещения);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередСтартомБизнесПроцессаПродолжениеПересогласовать(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		РаботаСВизамиСогласования.ПоместитьЗакрытиеВизыДокументаВИсторию(Параметры.Предмет);
		Параметры.ПараметрыЗаписиПроцесса.Вставить("Пересогласовать" + СтрЗаменить(Строка(Параметры.Предмет.УникальныйИдентификатор()), "-", ""));
		ПараметрыОповещения = Новый Структура();
		ПараметрыОповещения.Вставить("ИдентификаторФормы", Параметры.ИдентификаторФормыПроцесса);
		ПараметрыОповещения.Вставить("ПараметрыЗаписиПроцесса", Параметры.ПараметрыЗаписиПроцесса);
		Оповестить("СтартПроцессаПослеВопроса", ПараметрыОповещения);
	КонецЕсли;	
	
КонецПроцедуры

// Выполняет проверки перед началом добавления визы
//
Процедура ДобавитьВизу(ЭтаФорма) Экспорт 
	
	Документ = ЭтаФорма.Объект;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ЭтаФорма", ЭтаФорма);
	ПараметрыОповещения.Вставить("Документ", Документ);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДобавитьВизуПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);

	Если Не ЗначениеЗаполнено(Документ.Ссылка) Тогда 
		ТекстВопроса = НСтр("ru = 'Для добавления визы согласования необходимо записать документ.
			|Выполнить запись?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
	КонецЕсли;
		
КонецПроцедуры

Процедура ДобавитьВизуПродолжение(Результат, Параметры) Экспорт 

	Документ = Параметры.Документ;
	ЭтаФорма = Параметры.ЭтаФорма;
	
	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда 	
		
		Если Не ЭтаФорма.Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Создание:'"), 
			ПолучитьНавигационнуюСсылку(Документ.Ссылка),
			Строка(Документ.Ссылка),
			БиблиотекаКартинок.Информация32);	
	КонецЕсли;	

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Документ", Документ.Ссылка);
	ОткрытьФорму("Справочник.ВизыСогласования.Форма.ФормаЭлемента", ПараметрыФормы, Параметры.ЭтаФорма);
	
КонецПроцедуры

// Выполняет проверки перед началом изменения визы
//
Процедура ИзменитьВизу(ЭтаФорма) Экспорт 
	
	Виза = ЭтаФорма.Элементы.ВизыСогласования.ТекущиеДанные;
	Документ = ЭтаФорма.Объект;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ЭтаФорма", ЭтаФорма);
	ПараметрыОповещения.Вставить("Документ", Документ);
	ПараметрыОповещения.Вставить("Виза", Виза);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ИзменитьВизуПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);

	Если Не ЗначениеЗаполнено(Документ.Ссылка) Тогда 
		
		ИндексВыбраннойВизы = ЭтаФорма.Элементы.ВизыСогласования.ВыделенныеСтроки[0];
		
		ТекстВопроса = НСтр("ru = 'Для изменения визы согласования необходимо записать документ.
			|Выполнить запись?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.ОК);
	КонецЕсли;
		
КонецПроцедуры	

Процедура ИзменитьВизуПродолжение(Результат, Параметры) Экспорт 

	Документ = Параметры.Документ;
	ЭтаФорма = Параметры.ЭтаФорма;
	Виза = Параметры.Виза;
	
	Если Результат = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда 	
		
		Если Не ЭтаФорма.Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Создание:'"), 
			ПолучитьНавигационнуюСсылку(Документ.Ссылка),
			Строка(Документ.Ссылка),
			БиблиотекаКартинок.Информация32);	
	КонецЕсли;	

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Виза.Ссылка);
	ПараметрыФормы.Вставить("Документ", Документ.Ссылка);
	ОткрытьФорму("Справочник.ВизыСогласования.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// Проверяет наличие визы исполнителя задачи
//
Функция ПроверитьВизуИсполнителяЗадачи(ЗадачаСсылка, ОписаниеОповещения) Экспорт 
	
	НайденныйПредмет = Неопределено;
	НайденнаяВиза = Неопределено;
	
	Если РаботаСВизамиСогласования.УжеЕстьВизаИсполнителяЗадачи(ЗадачаСсылка, НайденныйПредмет, НайденнаяВиза) Тогда 
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В документе ""%1"" уже имеется виза текущего исполнителя, она будет помещена в историю.'"),
			НайденныйПредмет);
			
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
		Кнопки.Добавить("Отмена", НСтр("ru = 'Отмена'"));
		
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		ПараметрыОбработчикаОповещения.Вставить("НайденнаяВиза", НайденнаяВиза);
		
		ОписаниеОповещенияВопроса = Новый ОписаниеОповещения(
			"ПроверитьВизуИсполнителяЗадачиПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);
		
		ПоказатьВопрос(ОписаниеОповещенияВопроса, ТекстВопроса, Кнопки);
	Иначе 
 		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;	
	
КонецФункции	

Процедура ПроверитьВизуИсполнителяЗадачиПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = "Продолжить" Тогда 
		Визы = Новый Массив;
		Визы.Добавить(Параметры.НайденнаяВиза);
		РаботаСВизамиСогласования.ПоместитьВизыВИсторию(Визы);
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Истина);
	Иначе	
		ВыполнитьОбработкуОповещения(Параметры.ОписаниеОповещения, Ложь);
	КонецЕсли;	
	
КонецПроцедуры

// Возвращает структуру реквизитов визы, которые будут подписаны
//
Функция ПолучитьСтруктуруВизДляПодписания() Экспорт
	
	Возврат Новый Структура("Документ,
		|ДатаИсполнения,
		|РезультатСогласования,
		|Исполнитель");
	
КонецФункции

#КонецОбласти