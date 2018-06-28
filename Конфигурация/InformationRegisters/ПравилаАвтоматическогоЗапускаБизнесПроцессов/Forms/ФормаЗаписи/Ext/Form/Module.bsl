﻿
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(Запись.ШаблонБизнесПроцесса) Тогда
		
		ДоступностьШаблона = ШаблоныБизнесПроцессов.ДоступностьШаблона(Запись.ШаблонБизнесПроцесса);
		Если Не ДоступностьШаблона.АвтоматическийЗапуск Тогда
			Текст = НСтр("ru = 'Шаблон недоступен для автоматического запуска процессов.
				|Выполните проверку в карточке шаблона.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,,
				"Запись.ШаблонБизнесПроцесса");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
