﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Наименование");
	ЭтотОбъект.Элементы.Список.Отображение = ОтображениеТаблицы.ИерархическийСписок;	
	
КонецПроцедуры

#КонецОбласти
