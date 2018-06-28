﻿
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ТаблицаРазрезовДоступа = Новый ТаблицаЗначений;
	ТаблицаРазрезовДоступа.Колонки.Добавить("РазрезДоступаИсп");
	ТаблицаРазрезовДоступа.Колонки.Добавить("РазрезИспользуется");
	
	НастройкиИспользованияРазрезов = Константы.ИспользованиеРазрезовДоступа.Получить().Получить();
	ОтключенныеРазрезы = ДокументооборотПраваДоступаПовтИсп.ОтключенныеРазрезыДоступа();
	
	Для Каждого Эл Из НастройкиИспользованияРазрезов Цикл
		Стр = ТаблицаРазрезовДоступа.Добавить();
		Стр.РазрезДоступаИсп = Эл.Значение;
		Стр.РазрезИспользуется = ОтключенныеРазрезы.Найти(Эл.Значение) = Неопределено;
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
	//Связь между таблицей значений и именами в СКД
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаРазрезовДоступа", ТаблицаРазрезовДоступа);
	
	//Макет компоновки
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		ЭтотОбъект.СхемаКомпоновкиДанных,
		ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки(),
		ДанныеРасшифровки);
		
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	//Вывод результата
	ДокументРезультат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти
