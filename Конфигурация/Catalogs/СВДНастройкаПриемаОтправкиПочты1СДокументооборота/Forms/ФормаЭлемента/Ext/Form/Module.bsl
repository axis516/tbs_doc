﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_НастройкаПриемаОтправки", , Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтправкиПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьПочтыПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование()
	
	Объект.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='""%1"" - ""%2""'"), 
		Строка(Объект.УчетнаяЗаписьПочты), Строка(Объект.АдресОтправки));
	
КонецПроцедуры
