﻿// Возвращает Истина, если указанная папка отмечена как папка быстрого
// доступа для текущего пользователя
Функция ЭтоПапкаПисемБыстрогоДоступа(ПапкаПисем) Экспорт
	
	Если Не ЗначениеЗаполнено(ПапкаПисем) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	РегистрСведений.ПапкиПисемБыстрогоДоступа КАК ПапкиПисемБыстрогоДоступа
		|ГДЕ
		|	ПапкиПисемБыстрогоДоступа.Папка = &Папка
		|	И ПапкиПисемБыстрогоДоступа.Пользователь = &Пользователь");
		
	Запрос.УстановитьПараметр("Папка", ПапкаПисем);
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Выборка.Количество > 0 Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции

// Сохраняет указанную отметку бвстрого доступа для указанной папки
// для текущего пользователя
Процедура УстановитьБыстрыйДоступДляПапки(Папка, БыстрыйДоступ) Экспорт
	
	Если Не ЗначениеЗаполнено(Папка) Тогда
		Возврат;
	КонецЕсли;
	
	Если БыстрыйДоступ Тогда
		
		Если ЭтоПапкаПисемБыстрогоДоступа(Папка) Тогда
			Возврат;
		КонецЕсли;	
		
		НаборЗаписей = РегистрыСведений.ПапкиПисемБыстрогоДоступа.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Папка.Значение = Папка;
		НаборЗаписей.Отбор.Папка.Использование = Истина;
		НаборЗаписей.Отбор.Пользователь.Значение = ПользователиКлиентСервер.ТекущийПользователь();
		НаборЗаписей.Отбор.Пользователь.Использование = Истина;
		
		Запись = НаборЗаписей.Добавить();
		Запись.Папка = Папка;
		Запись.Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
		
		НаборЗаписей.Записать();
		
	Иначе	
		
		Если Не ЭтоПапкаПисемБыстрогоДоступа(Папка) Тогда
			Возврат;
		КонецЕсли;	
		
		НаборЗаписей = РегистрыСведений.ПапкиПисемБыстрогоДоступа.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Папка.Значение = Папка;
		НаборЗаписей.Отбор.Папка.Использование = Истина;
		НаборЗаписей.Отбор.Пользователь.Значение = ПользователиКлиентСервер.ТекущийПользователь();
		НаборЗаписей.Отбор.Пользователь.Использование = Истина;
		
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() > 0 Тогда
			НаборЗаписей.Удалить(0);
			НаборЗаписей.Записать();
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры	
