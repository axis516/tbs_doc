﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостояниеВыполненияЗадачи = РегистрыСведений.ЗадачиДляВыполнения.СостояниеВыполненияЗадачи(Объект.Ссылка);
	
	// Выводим состояние задачи
	Элементы.ГруппаСостояниеЗадачи.Видимость = Ложь;
	Если Объект.СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Прерван Тогда
		Элементы.ГруппаСостояниеЗадачи.Видимость = Истина;
		Элементы.ДекорацияСостояния.Картинка = БиблиотекаКартинок.ЗнакПрерванПроцесс;
		Элементы.ДекорацияОписание.Заголовок = НСтр("ru = 'Задача прервана'");
		Элементы.ДекорацияОписание.Гиперссылка = Истина;
	ИначеЕсли Объект.СостояниеБизнесПроцесса = Перечисления.СостоянияБизнесПроцессов.Остановлен Тогда
		Элементы.ГруппаСостояниеЗадачи.Видимость = Истина;
		Элементы.ДекорацияСостояния.Картинка = БиблиотекаКартинок.ЗнакПрерванПроцесс;
		Элементы.ДекорацияОписание.Заголовок = НСтр("ru = 'Задача остановлена'");
	ИначеЕсли СостояниеВыполненияЗадачи.СостояниеВыполнения = Перечисления.СостоянияЗадачДляВыполнения.ВыполнениеОтменено Тогда
		Элементы.ГруппаСостояниеЗадачи.Видимость = Истина;
		Элементы.ДекорацияСостояния.Картинка = БиблиотекаКартинок.Предупреждение;
		Элементы.ДекорацияОписание.Заголовок = СостояниеВыполненияЗадачи.ПричинаОтменыВыполнения;
	ИначеЕсли СостояниеВыполненияЗадачи.СостояниеВыполнения = Перечисления.СостоянияЗадачДляВыполнения.ГотоваКВыполнению Тогда
		Элементы.ГруппаСостояниеЗадачи.Видимость = Истина;
		Элементы.ДекорацияСостояния.Картинка = БиблиотекаКартинок.СтартБизнесПроцесса;
		Элементы.ДекорацияОписание.Заголовок = 
			НСтр("ru = 'Задача находится в очереди для выполнения. Выполнение задачи произойдет автоматически в ближайшее время.'");
	ИначеЕсли Объект.Выполнена Тогда
		Элементы.ГруппаСостояниеЗадачи.Видимость = Истина;
		
		МетаданныеПроцесса = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.БизнесПроцесс);
		ПредставлениеРезультатаЗадачи = МетаданныеПроцесса.ПредставлениеРезультатаЗадачи(Объект.Ссылка);
		
		РезультатВыполненияЗадачи = РегистрыСведений.
			РезультатыВыполненияПроцессовИЗадач.РезультатВыполненияПоОбъекту(Объект.Ссылка);
			
		Если РезультатВыполненияЗадачи = 
				Перечисления.ВариантыВыполненияПроцессовИЗадач.Положительно Тогда
				
			Картинка = БиблиотекаКартинок.РезультатВыполненияПроцессовИЗадач_Положительный;
			ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		ИначеЕсли РезультатВыполненияЗадачи = 
			Перечисления.ВариантыВыполненияПроцессовИЗадач.Отрицательно Тогда
			
			Картинка = БиблиотекаКартинок.РезультатВыполненияПроцессовИЗадач_Отрицательный;
			ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		ИначеЕсли РезультатВыполненияЗадачи = Перечисления.
			ВариантыВыполненияПроцессовИЗадач.ПоложительноСЗамечаниями Тогда
			
			Картинка = БиблиотекаКартинок.РезультатВыполненияПроцессовИЗадач_ПоложительныйСЗамечаниями;
			ЦветТекста = ЦветаСтиля.ОтметкаПоложительногоВыполненияЗадачи;
		Иначе
			Картинка = БиблиотекаКартинок.РезультатВыполненияПроцессовИЗадач;
			ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
		КонецЕсли;
		
		Элементы.ДекорацияСостояния.Картинка = Картинка;
		Элементы.ДекорацияОписание.Заголовок = ПредставлениеРезультатаЗадачи;
		Элементы.ДекорацияОписание.ЦветТекста = ЦветТекста;
		
	КонецЕсли;
	
	// Заполняем важность строкой
	Если Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Высокая Тогда
		ВажностьСтрокой = НСтр("ru = 'Высокая'");
	ИначеЕсли Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Обычная Тогда
		ВажностьСтрокой = НСтр("ru = 'Обычная'");
	ИначеЕсли Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Низкая Тогда
		ВажностьСтрокой = НСтр("ru = 'Низкая'");
	КонецЕсли;
	
	// Заполняем контролеров задачи
	Если ПолучитьФункциональнуюОпцию("ИспользоватьКонтрольОбъектов") Тогда
		Контролеры = РаботаСБизнесПроцессамиВызовСервера.КонтролерыЗадачи(Объект);
		КонтролерыСтрокой = СтрСоединить(Контролеры, ", ");
		КоличествоКонтролеров = Контролеры.Количество();
		Если КоличествоКонтролеров = 1 Тогда
			Элементы.КонтролерыСтрокой.Заголовок = НСтр("ru = 'Контролер'");
		ИначеЕсли КоличествоКонтролеров > 1 Тогда
			Элементы.КонтролерыСтрокой.Заголовок = НСтр("ru = 'Контролеры'");
		Иначе
			Элементы.КонтролерыСтрокой.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.КонтролерыСтрокой.Видимость = Ложь;
	КонецЕсли;
	
	// Выводим иконки делегированной и ролевой задачи
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Элементы.ДекорацияДелегированнаяЗадача.Видимость = Ложь;
	Элементы.ДекорацияРолеваяЗадача.Видимость = Ложь;
	
	ЗадачаДелегированаТекущемуПользователю = 
		РегистрыСведений.ИсполнителиРолейИДелегаты.ИсполнительЯвляетсяДелегатом(
			Объект.ТекущийИсполнитель,
			ТекущийПользователь,
			"ПроцессыИЗадачи");
	
	Если ЗадачаДелегированаТекущемуПользователю Тогда
		Элементы.ДекорацияДелегированнаяЗадача.Видимость = Истина;
	ИначеЕсли ТипЗнч(Объект.ТекущийИсполнитель) = Тип("СправочникСсылка.ПолныеРоли") Тогда
		Элементы.ДекорацияРолеваяЗадача.Видимость = Истина;
	КонецЕсли;
	
	// Заполняем поле "Исполнитель"
	Если НЕ Объект.Исполнитель.Пустая() Тогда
		ИсполнительСтрокой = Объект.Исполнитель;
		Элементы.ИсполнительСтрокой.КнопкаОткрытия = Истина;
	Иначе
		ИсполнительСтрокой = Строка(Объект.РольИсполнителя);
		Элементы.ИсполнительСтрокой.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
	ЗаполнитьТрудозатраты();
	
	// Настраиваем формат дат
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.СрокИсполнения);
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.Дата);
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.ДатаИсполнения);
	
	// Настраиваем видимость проекта и проектной задачи
	Если НЕ ПолучитьФункциональнуюОпциюФормы("ВестиУчетПоПроектам") Тогда
		Элементы.ГруппаПроекты.Видимость = Ложь;
		
		// Настраиваем другие элементы, чтобы получить правильное выравнивание.
		Элементы.Исполнитель_Заголовок.Ширина = 9;
	КонецЕсли;
	
	// Добавление доп. реквизитов формы
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	РаботаСБизнесПроцессамиВызовСервера.ЗаблокироватьНаФормеСкопированныеДопРеквизиты(
		ЭтаФорма, Объект.БизнесПроцесс);
	
	// Заполнение дерева приложений
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	РаботаСБизнесПроцессамиВызовСервера.ОбновитьДоступностьКомандДереваПриложений(ЭтаФорма);
	
	// Заполнение истории выполнения
	ИсторияВыполнения = РегистрыСведений.ИсторияВыполненияЗадач.
		ИсторияПоБизнесПроцессу(Объект.БизнесПроцесс);
	
	// Установка доступности элементов формы
	ТолькоПросмотр = Истина;
	Элементы.ИсполнительСтрокой.ТолькоПросмотр = Истина;
	Элементы.ТрудозатратыПлан.ТолькоПросмотр = Истина;
	Элементы.ТрудозатратыФакт.ТолькоПросмотр = Истина;
	Элементы.ИсторияВыполнения.ТолькоПросмотр = Истина;
	Элементы.КонтролерыСтрокой.ТолькоПросмотр = Истина;
	Элементы.ВажностьСтрокой.ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОписаниеНажатие(Элемент)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПоказатьПричинуПрерывания(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОткрытьИсполнителя(Объект.ТекущийИсполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерыСтрокойОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КонтрольКлиент.ОбработкаКомандыКонтроль(Объект.БизнесПроцесс, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоПриложений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяПредмета) И НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура();
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ДеревоПриложенийВыборПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);         
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(
			ЭтаФорма, СообщениеОбОшибке,ТекущиеДанные.ИмяПредмета,
			ТекущиеДанные.Ссылка, СтандартнаяОбработка, ОписаниеОповещения) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	Иначе
		РаботаСБизнесПроцессамиКлиент.ДеревоПриложенийВыбор(
			ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийВыборПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("Предмет", НСтр("ru = 'Предмет'"));
	СписокВыбора.Добавить("Файл", НСтр("ru = 'Файл'"));
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ДеревоПриложенийПередНачаломДобавления_Завершение", ЭтаФорма);
	
	СписокВыбора.ПоказатьВыборЭлемента(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления_Завершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Предмет = Неопределено;
	
	Если РезультатВыбора.Значение = "Файл" Тогда
		Предмет = ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка");
	КонецЕсли;
	
	ДеревоПриложенийДобавлениеНаКлиенте(Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПроверкаПеретаскивания(
	Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПеретаскивание(
	Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтаФорма.ТолькоПросмотр Или Элементы.ДеревоПриложений.ТолькоПросмотр Или Объект.Выполнена Тогда 
		Возврат;
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(
		ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы_ДеревоПриложений

&НаКлиенте
Процедура ДобавитьПредмет(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте(ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляПросмотра(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьТекущийФайлДляПросмотра(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.РедактироватьТекущийФайл(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗакончитьРедактированиеТекущегоФайла(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	РаботаСБизнесПроцессамиКлиент.СохранитьТекущийФайл(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура КомандаОбновитьДеревоПриложений(Команда)
	
	ОбновитьДеревоПриложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеПриложения(Команда)
	
	ОтображатьУдаленныеПриложения = Не ОтображатьУдаленныеПриложения;
	Элементы.ДеревоПриложенийКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПриложения;
	
	ТекущаяСсылкаВДереве = Неопределено;
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ОтображатьУдаленныеПриложенияСервер();
	
	Если ТекущаяСсылкаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТрудозатраты() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Заполняем ед. измерения трудозатрат
	Если ЗначениеЗаполнено(Объект.ПроектнаяЗадача) Тогда 
		ЕдиницаТрудозатрат = Строка(ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
			Объект.ПроектнаяЗадача, "ЕдиницаТрудозатратФакт"));
	ИначеЕсли ЗначениеЗаполнено(Объект.Проект) Тогда 
		ЕдиницаТрудозатрат = Строка(ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
				Объект.Проект, "ЕдиницаТрудозатратЗадач"));
	Иначе
		ЕдиницаТрудозатрат = Строка(Константы.ОсновнаяЕдиницаТрудозатрат.Получить());
	КонецЕсли;
	
	// Заполняем фактические трудозатраты
	Если ПолучитьФункциональнуюОпцию("ВестиУчетФактическихТрудозатрат") Тогда
		
		УчитыватьИсполнителя = Ложь;
		
		ТочкиМаршрутаПроцессовСНесколькимиИсполнителями = Новый Массив;
		ТочкиМаршрутаПроцессовСНесколькимиИсполнителями.Добавить(
			БизнесПроцессы.Исполнение.ТочкиМаршрута.ОтветственноеИсполнение);
		ТочкиМаршрутаПроцессовСНесколькимиИсполнителями.Добавить(
			БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить);
		ТочкиМаршрутаПроцессовСНесколькимиИсполнителями.Добавить(
			БизнесПроцессы.Ознакомление.ТочкиМаршрута.Ознакомиться);
		ТочкиМаршрутаПроцессовСНесколькимиИсполнителями.Добавить(
			БизнесПроцессы.Приглашение.ТочкиМаршрута.Пригласить);
		ТочкиМаршрутаПроцессовСНесколькимиИсполнителями.Добавить(
			БизнесПроцессы.Согласование.ТочкиМаршрута.Согласовать);
		
		Если ТочкиМаршрутаПроцессовСНесколькимиИсполнителями.Найти(
			Объект.ТочкаМаршрута) <> Неопределено Тогда
			
			УчитыватьИсполнителя = Истина;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
			|ГДЕ
			|	ЗадачаИсполнителя.Ссылка <> &Ссылка
			|	И ЗадачаИсполнителя.Дата < &Дата
			|	И ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
			|	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		Запрос.УстановитьПараметр("Дата", Объект.Дата);
		Запрос.УстановитьПараметр("БизнесПроцесс", Объект.БизнесПроцесс);
		Запрос.УстановитьПараметр("ТочкаМаршрута", Объект.ТочкаМаршрута);
		
		Если УчитыватьИсполнителя Тогда 
			Если ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
				Запрос.Текст = Запрос.Текст + 
				" И ЗадачаИсполнителя.Исполнитель = &Исполнитель ";
				Запрос.УстановитьПараметр("Исполнитель", Объект.Исполнитель);
			Иначе
				Запрос.Текст = Запрос.Текст + 
				" И ЗадачаИсполнителя.РольИсполнителя = &РольИсполнителя";
				Запрос.УстановитьПараметр("РольИсполнителя", Объект.РольИсполнителя);
			КонецЕсли;
		КонецЕсли;
		
		ТрудозатратыФакт = РаботаСБизнесПроцессамиВызовСервера.ПолучитьФактическиеТрудозатратыПоЗадаче(Объект.Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл 
			ТрудозатратыФакт = ТрудозатратыФакт + 
				РаботаСБизнесПроцессамиВызовСервера.ПолучитьФактическиеТрудозатратыПоЗадаче(Выборка.Ссылка);
		КонецЦикла;
		
		// Заполняем плановые трудозатраты
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПлановыхТрудозатратВБизнесПроцессах") Тогда
			ТрудозатратыПлан = РаботаСБизнесПроцессамиВызовСервера.ПолучитьПлановыеТрудозатратыПоЗадаче(
			Объект.БизнесПроцесс, Объект.Ссылка, Объект.ТочкаМаршрута);
		Иначе
			Элементы.ГруппаТрудозатратыПлан.Видимость = Ложь;
		КонецЕсли;
		
		Если ТрудозатратыПлан <= ТрудозатратыФакт И ЗначениеЗаполнено(ТрудозатратыПлан) Тогда 
			ЭтаФорма.Элементы.ТрудозатратыПлан.ЦветТекста = ЦветаСтиля.ОтметкаОтрицательногоВыполненияЗадачи;
		КонецЕсли;
		
	Иначе
		Элементы.ГруппаТрудозатратыФакт.Видимость = Ложь;
		Элементы.ГруппаТрудозатратыПлан.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДеревоПриложений

&НаСервере
Процедура ОтображатьУдаленныеПриложенияСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		ИмяФормы,
		"ОтображатьУдаленныеПриложения",
		ОтображатьУдаленныеПриложения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоПриложений(ТекущееИмяПредметаВДереве = Неопределено)
	
	ТекущаяСсылкаВДереве = Неопределено;
	
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено
		И ТекущееИмяПредметаВДереве = Неопределено Тогда
		
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
		ТекущееИмяПредметаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.ИмяПредмета;
	КонецЕсли;
	
	Если Элементы.Найти("ДеревоПриложений") <> Неопределено  Тогда
		ОбновитьДеревоПриложенийСервер();
	КонецЕсли;
	
	Если ТекущаяСсылкаВДереве <> Неопределено ИЛИ ТекущееИмяПредметаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве, ТекущееИмяПредметаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоПриложенийСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьПредметСервер()
	
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(
		ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиенте(Предмет = Неопределено)

	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	НовыйИмяПредмета = Неопределено;
	
	ПараметрыОбработчикаОповещения = Новый Структура();
	ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийВыборПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, НовыйИмяПредмета, Предмет,,ОписаниеОповещения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиенте()
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	Иначе
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьКарточкуНаКлиентеПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(
			ЭтаФорма,
			СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета,
			ТекущиеДанные.Ссылка,,
			ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиенте()
	
	ВыделенныеСтрокиПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из Элементы.ДеревоПриложений.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ДеревоПриложений.ДанныеСтроки(ВыделеннаяСтр);
		ВыделенныеСтрокиПредметов.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийУдалениеНаКлиентеПродолжение",
		ЭтотОбъект,
		ВыделенныеСтрокиПредметов);
		
	МультипредметностьКлиент.ПолученоПодтверждениеОбУдаленииПредмета(
		Объект, ВыделенныеСтрокиПредметов, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиентеПродолжение(Результат, ВыделенныеСтрокиПредметов) Экспорт
	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	ИменаУдаляемыхПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из ВыделенныеСтрокиПредметов Цикл
		Если ВыделеннаяСтр.ДоступноУдаление Тогда
			ИменаУдаляемыхПредметов.Добавить(ВыделеннаяСтр.ИмяПредмета);
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаУдаляемыхПредметов.Количество() = 0 Тогда
		
		КоличествоВыделенныхСтрок = ВыделенныеСтрокиПредметов.Количество();
		Если КоличествоВыделенныхСтрок = 1 Тогда
			ТекстСообщения = НСтр("ru = 'Удалить текущего предмет можно только в карточке процесса.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Удалить выделенные предметы можно только в карточке процесса.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	Если Не МультипредметностьКлиент.УдалитьПредметыЗадачи(
		ЭтаФорма, СообщениеОбОшибке, ИменаУдаляемыхПредметов) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПриложений();
	УстановитьПредметСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ПодсистемаСвойств

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
      УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
