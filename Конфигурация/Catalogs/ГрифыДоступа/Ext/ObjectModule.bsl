﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ДокументооборотПраваДоступа.ПриЗаписиРазрезаДоступа(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецЕсли