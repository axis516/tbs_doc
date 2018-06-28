﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает массив имен ключевых реквизитов
Функция ПолучитьИменаКлючевыхРеквизитов(Версия = Неопределено) Экспорт
	
	МассивИмен = Новый Массив;
	
	Если Версия = 1 Тогда
		МассивИмен.Добавить("Документ");
		МассивИмен.Добавить("ДатаИсполнения");
		МассивИмен.Добавить("РезультатСогласования");
		МассивИмен.Добавить("Исполнитель");
		МассивИмен.Добавить("Наименование");
	Иначе
		МассивИмен.Добавить("Документ");
		МассивИмен.Добавить("ДатаИсполнения");
		МассивИмен.Добавить("РезультатСогласования");
		МассивИмен.Добавить("Исполнитель");
	КонецЕсли;
	
	Возврат МассивИмен;
	
КонецФункции

// Возвращает массив авторов виз по указанному документу
Функция ПолучитьМассивАвторовВизПоДокументу(Документ) Экспорт
	
	Результат = Новый Массив;
	
	Выборка = РаботаСВизамиСогласования.ПолучитьАктивныеВизыДокумента(Документ);
	
	Для Каждого Элемент Из Выборка Цикл
		Результат.Добавить(Элемент.Исполнитель);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли