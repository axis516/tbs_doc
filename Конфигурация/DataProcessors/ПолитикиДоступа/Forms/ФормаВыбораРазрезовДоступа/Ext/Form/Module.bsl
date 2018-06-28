﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДеревоЗначенийДоступа = ДокументооборотПраваДоступаПовтИсп.ДеревоЗначенийДоступа().Скопировать();
	ДеревоЗначенийДоступа.Колонки.Добавить("Пометка");
	
	Для Каждого Стр Из ДеревоЗначенийДоступа.Строки Цикл
		Стр.Представление = Стр.Представление + " (" + НСтр("ru = 'все'") + ")";
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоЗначенийДоступа, "РазрезыДоступа");
	
	Элементы.ОписаниеОперации.Заголовок = СтрШаблон(
		НСтр("ru = 'Разрешения для выбранных разрезов доступа будут заменены
			|разрешениями для ""%1""'"),
		Параметры.ПредставлениеИсточника);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодтвердитьВыбор(Команда)
	
	ВыбранныеСтроки = ОбщегоНазначенияДокументооборотКлиентСервер.НайтиСтрокиДерева(
		РазрезыДоступа, Новый Структура("Пометка", Истина));
		
	Закрыть(ВыбранныеСтроки);
	
КонецПроцедуры

#КонецОбласти
