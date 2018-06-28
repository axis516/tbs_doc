﻿
&НаКлиенте
Процедура ПроверитьКод(Команда)
	
	ОчиститьСообщения();
	
	ТекстУспешногоЗавершения = "";
	Если ПроверитьКодНаСервере(ТекстУспешногоЗавершения) Тогда
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ТекстУспешногоЗавершения);
		ТекстовыйДокумент.Показать("Результат выполнения выражения на встроенном языке");
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПроверитьКодНаСервере(ТекстУспешногоЗавершения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Ложь; 
	ПараметрыВозврата = Новый Структура;
	
	Попытка
		
		Выполнить(Объект.ВыполняемыйКод);
		
		ТекстУспешногоЗавершения = НСтр("ru = 'Результат='") + Строка(Результат) + Символы.ПС;
		
		СтрокаПараметров = "";
		Для Каждого Пара Из ПараметрыВозврата Цикл
			
			Если Не ПустаяСтрока(СтрокаПараметров) Тогда
				СтрокаПараметров = СтрокаПараметров + Символы.ПС;
			КонецЕсли;	
			
			СтрокаПараметров = СтрокаПараметров + Строка(Пара.Ключ) + "=" + Строка(Пара.Значение);
			
		КонецЦикла;	
		
		ТекстУспешногоЗавершения = ТекстУспешногоЗавершения + 
			НСтр("ru = 'ПараметрыВозврата:'") + 
			Символы.ПС + 
			Строка(СтрокаПараметров);
		Возврат Истина;
		
	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(СообщениеОбОшибке);
		Возврат Ложь;
		
	КонецПопытки;	
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Включен = Истина;
		
		Если Не ЗначениеЗаполнено(Объект.ВыполняемыйКод) Тогда
			Объект.ВыполняемыйКод = 
		    "// Этот фрагмент кода на встроенном языке будет выполняться 
			|// автоматически регламентным заданием 
			|//  ""Обработка детекторов бизнес-событий"" раз в минуту.
			|// Если при выполнении этого кода возникнет ошибка, то информация об этом
			|// будет записана в журнал регистрации.
			|// Следите за тем, чтобы в этом коде не было бесконечных циклов,
			|// т.к. это может привести к замедлению работы сервера.
			|// Не выполняйте в этом коде длительные операции, т.к. это может
			|// привести к замедлению работы сервера.
			| 
			|//Пример обработки
			|//Если СобытиеПроизошло Тогда
			|//Результат = Истина;
			|//Иначе
			|//Результат = Ложь;
			|//КонецЕсли;";
		КонецЕсли;		
		
	КонецЕсли;	
		
КонецПроцедуры
