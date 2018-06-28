﻿
Процедура ЗаписатьСловаДляПоиска(ТекстПисьма, Письмо) Экспорт
	
	УникальныеСловаПисем = ВстроеннаяПочтаСервер.ТекстПисьмаВСлова(ТекстПисьма);
	
	Набор = РегистрыСведений.СловаПисем.СоздатьНаборЗаписей();
	Набор.Отбор.Письмо.Установить(Письмо);
	НомерСлова = 1;
	
	Для Каждого КлючИЗначение Из УникальныеСловаПисем Цикл
		
		Слово = КлючИЗначение.Ключ;
		
		Запись = Набор.Добавить();
		Запись.Письмо = Письмо;
		Запись.НомерСлова = НомерСлова;
		Запись.Слово = Слово;
		
		НомерСлова = НомерСлова + 1;
		
	КонецЦикла;
	
	Набор.Записать(Истина);
	
КонецПроцедуры
