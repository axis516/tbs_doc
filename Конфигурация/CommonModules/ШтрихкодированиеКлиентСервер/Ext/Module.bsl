﻿#Если НЕ ВебКлиент Тогда
Функция ВставитьШтрихкодВФайлMSWordВместоТэга(Расширение, ДвоичныеДанныеКартинки, ДвоичныеДанныеФайла, Тэг, WordApp = Неопределено)
	
	ЗакрыватьПриложение = Ложь;
	Если WordApp = Неопределено Тогда 
		
		СисИнфо = Новый СистемнаяИнформация;
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			Попытка
				WordApp = Новый COMОбъект("Word.Application");
			Исключение
				ВызватьИсключение(НСтр("ru = 'Ошибка работы с приложением MS Word. Необходимо проверить правильность установки приложения.'"));
			КонецПопытки;
		Иначе
			ВызватьИсключение(НСтр("ru = 'Вставка штрихкода в файл MS Word возможна только в Windows. Обратитесь к администратору.'"));	
		КонецЕсли;
		ЗакрыватьПриложение = Истина;
		
	КонецЕсли;

	ИмяВременногоФайлаКартинки = ПолучитьИмяВременногоФайла("JPG");
	ДвоичныеДанныеКартинки.Записать(ИмяВременногоФайлаКартинки);
	
	ИмяВременногоФайлаOffice = ПолучитьИмяВременногоФайла(Расширение);
	НовыйПутьКФайлу = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайлаOffice);
	
	Док = WordApp.Documents.Add(ИмяВременногоФайлаOffice);
	
	//Выполним поиск тэга для вставки изображения вместо него
    НайденТэг = WordApp.Selection.Find.Execute(Тэг);
	Если НайденТэг Тогда
		//если найден, то вместо тэга вставляется картинка
		oGraphicObject = WordApp.Selection.InlineShapes.AddPicture(ИмяВременногоФайлаКартинки);
		oGraphicObject.AlternativeText = Тэг;
	Иначе
		//тэг не найден, проверим изображения
		Для Каждого InlineShape Из WordApp.ActiveDocument.InlineShapes Цикл
			Если InlineShape.AlternativeText = Тэг Тогда
				InlineShape.Select();
				oGraphicObject = WordApp.Selection.InlineShapes.AddPicture(ИмяВременногоФайлаКартинки);
				oGraphicObject.AlternativeText = Тэг;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
	КонецЕсли;
	
	Если Найти(WordApp.Build, "12.") > 0 Тогда
		Если Расширение = "docx" Тогда
			Док.SaveAs(НовыйПутьКФайлу, 12);                        
		Иначе
			Док.SaveAs(НовыйПутьКФайлу, 0);
		КонецЕсли;
	Иначе
	    Если Расширение = "docx" Тогда
			Док.SaveAs(НовыйПутьКФайлу, 109);                        
		Иначе
			Док.SaveAs(НовыйПутьКФайлу);
		КонецЕсли;
	КонецЕсли;
	
	Док.Saved = Истина;
	Док.Close();
	Если ЗакрыватьПриложение Тогда
		WordApp.Close();
		WordApp.Quit();
	КонецЕсли;
	УдалитьФайлы(ИмяВременногоФайлаКартинки);
	УдалитьФайлы(ИмяВременногоФайлаOffice);
	
	Возврат НовыйПутьКФайлу;
	
КонецФункции

Функция ВставитьКартинкуВФайлDocСУказаниемПоложения(Расширение, ДвоичныеДанныеФайла, ДвоичныеДанныеКартинки, ДанныеОПоложении)
			
	СисИнфо = Новый СистемнаяИнформация;
	Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Попытка
			WordApp = Новый COMОбъект("Word.Application");
		Исключение
			ВызватьИсключение(НСтр("ru = 'Ошибка работы с приложением MS Word. Необходимо проверить правильность установки приложения.'"));
		КонецПопытки;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Вставка штрихкода в файл MS Word возможна только в Windows. Обратитесь к администратору.'"));	
	КонецЕсли;
	
	ИмяВременногоФайлаOffice = ПолучитьИмяВременногоФайла(Расширение);
	НовыйПутьКФайлу = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайлаOffice);
	
	ИмяВременногоФайлаКартинки = ПолучитьИмяВременногоФайла("JPG");
	ДвоичныеДанныеКартинки.Записать(ИмяВременногоФайлаКартинки);
	
	Док = WordApp.Documents.Add(ИмяВременногоФайлаOffice);
	   
	oGraphicObject = Док.Shapes.AddTextBox(1, 100, 100, 100, 50);
	
	//устанавливаем привязку положения к печатной области
	oGraphicObject.RelativeHorizontalPosition = 0;
	oGraphicObject.RelativeVerticalPosition = 0;  
	
	ПоложениеНаСтранице = ДанныеОПоложении.ПоложениеНаСтранице;
	Если ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПравыйНижний") Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MAX";
	ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПравыйВерхний") Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ЛевыйВерхний") Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ЛевыйНижний") Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MAX";
	КонецЕсли;
	
	Если СмещениеПоГоризонтали = "MAX" Тогда
		//выравнивание к правому краю
		oGraphicObject.Left = -999996;
	ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
		//выравнивание к левому краю
		oGraphicObject.left = -999998;
	Иначе
		//если задано произвольное расположение, то переведем смещение по горизонтали из миллиметров в point'ы
		//1 point = 1/72"
		oGraphicObject.RelativeHorizontalPosition = 1;
		Если НЕ ЗначениеЗаполнено(ДанныеОПоложении.СмещениеПоГоризонтали) Тогда
			ДанныеОПоложении.СмещениеПоГоризонтали = 0;
		КонецЕсли;
		oGraphicObject.left = (ДанныеОПоложении.СмещениеПоГоризонтали / 25.4) * 72;
	КонецЕсли;
	
	Если СмещениеПоВертикали = "MAX" Тогда
		//выравнивание по нижнему краю
		oGraphicObject.Top = -999997;
	ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
		//выравнивание по верхнему краю
		oGraphicObject.Top = -999999;
	Иначе
		//если задано произвольное расположение, то переведем смещение по горизонтали из миллиметров в point'ы
		oGraphicObject.RelativeVerticalPosition = 1;
		Если НЕ ЗначениеЗаполнено(ДанныеОПоложении.СмещениеПоВертикали) Тогда
			ДанныеОПоложении.СмещениеПоВертикали = 0;
		КонецЕсли;
		oGraphicObject.Top =(ДанныеОПоложении.СмещениеПоВертикали / 25.4) * 72;
	КонецЕсли;

	oGraphicObject.Select();

	WordApp.Selection.ShapeRange.Line.Visible = Ложь;
	WordApp.Selection.InlineShapes.AddPicture(ИмяВременногоФайлаКартинки);
	WordApp.Selection.ShapeRange.TextFrame.AutoSize = Истина;
	WordApp.Selection.ShapeRange.Fill.Visible = Ложь;
	WordApp.Selection.Font.Bold = Истина;
	
	Если ДанныеОПоложении.СмещениеПоГоризонтали = "MAX" ИЛИ ДанныеОПоложении.СмещениеПоГоризонтали = "MIN" Тогда 
		oGraphicObject.ConvertToFrame();		
	КонецЕсли;
	
	Если Найти(WordApp.Build, "12.") > 0 Тогда
		Если Расширение = "docx" Тогда
			Док.SaveAs(НовыйПутьКФайлу, 12);                        
		Иначе
			Док.SaveAs(НовыйПутьКФайлу, 0);
		КонецЕсли;
	Иначе
	    Если Расширение = "docx" Тогда
			Док.SaveAs(НовыйПутьКФайлу, 109);                        
		Иначе
			Док.SaveAs(НовыйПутьКФайлу);
		КонецЕсли;
	КонецЕсли;
	Док.Saved = Истина;	
	Док.Close(); 
	WordApp.Quit();
	WordApp = Неопределено;
	
	УдалитьФайлы(ИмяВременногоФайлаOffice);
	
	Возврат НовыйПутьКФайлу;
	
КонецФункции

Функция ВставитьРегистрационныйШтампВФайлDocСУказаниемПоложения(Расширение, ТекстНадписи, ДвоичныеДанныеФайла, ДвоичныеДанныеКартинки, ДанныеОПоложении, ВставлятьШтрихкод)
			
	СисИнфо = Новый СистемнаяИнформация;
	Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 Или СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Попытка
			WordApp = Новый COMОбъект("Word.Application");
		Исключение
			ВызватьИсключение(НСтр("ru = 'Ошибка работы с приложением MS Word. Необходимо проверить правильность установки приложения.'"));
		КонецПопытки;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Вставка штрихкода в файл MS Word возможна только в Windows. Обратитесь к администратору.'"));	
	КонецЕсли;

	ИмяВременногоФайлаOffice = ПолучитьИмяВременногоФайла(Расширение);
	НовыйПутьКФайлу = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайлаOffice);
	
	Если ВставлятьШтрихкод Тогда
		ИмяВременногоФайлаКартинки = ПолучитьИмяВременногоФайла("JPG");
		ДвоичныеДанныеКартинки.Записать(ИмяВременногоФайлаКартинки);
	КонецЕсли;
	
	Док = WordApp.Documents.Add(ИмяВременногоФайлаOffice);
	// Для Word 2010 включается режим совместимости с Word 2007
	Если Найти(WordApp.Build, "14.") = 1 Тогда
		Док.SetCompatibilityMode(12);   
	КонецЕсли;
	oGraphicObject = Док.Shapes.AddTextBox(1, 100, 100, 145, 100);
	
	//устанавливаем привязку положения к печатной области
	oGraphicObject.RelativeHorizontalPosition = 0;
	oGraphicObject.RelativeVerticalPosition = 0;  
	
	ПоложениеНаСтранице = ДанныеОПоложении.ПоложениеНаСтранице;
	Если ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПравыйНижний") Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MAX";
	ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ПравыйВерхний") Тогда
		СмещениеПоГоризонтали = "MAX";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ЛевыйВерхний") Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MIN";
	ИначеЕсли ПоложениеНаСтранице = ПредопределенноеЗначение("Перечисление.ВариантыРасположенияШтрихкода.ЛевыйНижний") Тогда
		СмещениеПоГоризонтали = "MIN";
		СмещениеПоВертикали = "MAX";
	КонецЕсли;
	
	Если СмещениеПоГоризонтали = "MAX" Тогда
		//выравнивание к правому краю
		oGraphicObject.Left = -999996;
	ИначеЕсли СмещениеПоГоризонтали = "MIN" Тогда
		//выравнивание к левому краю
		oGraphicObject.left = -999998;
	Иначе
		//если задано произвольное расположение, то переведем смещение по горизонтали из миллиметров в point'ы
		//1 point = 1/72"
		oGraphicObject.RelativeHorizontalPosition = 1;
		Если НЕ ЗначениеЗаполнено(ДанныеОПоложении.СмещениеПоГоризонтали) Тогда
			ДанныеОПоложении.СмещениеПоГоризонтали = 0;
		КонецЕсли;
		oGraphicObject.left = (ДанныеОПоложении.СмещениеПоГоризонтали / 25.4) * 72;
	КонецЕсли;
	
	Если СмещениеПоВертикали = "MAX" Тогда
		//выравнивание по нижнему краю
		oGraphicObject.Top = -999997;
	ИначеЕсли СмещениеПоВертикали = "MIN" Тогда
		//выравнивание по верхнему краю
		oGraphicObject.Top = -999999;
	Иначе
		//если задано произвольное расположение, то переведем смещение по горизонтали из миллиметров в point'ы
		oGraphicObject.RelativeVerticalPosition = 1;
		Если НЕ ЗначениеЗаполнено(ДанныеОПоложении.СмещениеПоВертикали) Тогда
			ДанныеОПоложении.СмещениеПоВертикали = 0;
		КонецЕсли;
		oGraphicObject.Top =(ДанныеОПоложении.СмещениеПоВертикали / 25.4) * 72;
	КонецЕсли;

	oGraphicObject.Select();

	Если ЗначениеЗаполнено(ТекстНадписи) Тогда
		WordApp.Selection.Font.Bold = Ложь;
		WordApp.Selection.ParagraphFormat.Alignment = 1;
	    WordApp.Selection.TypeText(ТекстНадписи.НазваниеОрганизации + Символы.ВК);
	    WordApp.Selection.TypeText("№ " + ТекстНадписи.РегНомер);
		WordApp.Selection.TypeText(" от ");
	Иначе
		WordApp.Selection.ShapeRange.Line.Visible = Ложь;
	КонецЕсли;
	
	Если ВставлятьШтрихкод Тогда
		Если ЗначениеЗаполнено(ТекстНадписи) Тогда
			WordApp.Selection.TypeText(ТекстНадписи.Регдата + Символы.ВК);
		КонецЕсли;
		WordApp.Selection.InlineShapes.AddPicture(ИмяВременногоФайлаКартинки);
	ИначеЕсли ЗначениеЗаполнено(ТекстНадписи) Тогда
		WordApp.Selection.TypeText(ТекстНадписи.Регдата);
	КонецЕсли;
	
	WordApp.Selection.ShapeRange.TextFrame.AutoSize = Истина;
	WordApp.Selection.ShapeRange.Fill.Visible = Ложь;
	WordApp.Selection.Font.Bold = Истина;
	
	Если ДанныеОПоложении.СмещениеПоГоризонтали = "MAX" ИЛИ ДанныеОПоложении.СмещениеПоГоризонтали = "MIN" Тогда 
		oGraphicObject.ConvertToFrame();
	КонецЕсли;
	
	Если Найти(WordApp.Build, "12.") = 1 Тогда
		Если Расширение = "docx" Тогда
			Док.SaveAs(НовыйПутьКФайлу, 12);                        
		Иначе
			Док.SaveAs(НовыйПутьКФайлу, 0);
		КонецЕсли;
	Иначе
	    Если Расширение = "docx" Тогда
			Док.SaveAs(НовыйПутьКФайлу, 109);                        
		Иначе
			Док.SaveAs(НовыйПутьКФайлу);
		КонецЕсли;
	КонецЕсли;
	Док.Saved = Истина;	
	Док.Close(); 
	WordApp.Quit();
	WordApp = Неопределено;
	
	УдалитьФайлы(ИмяВременногоФайлаOffice);
	
	Возврат НовыйПутьКФайлу;
	
КонецФункции

//Осуществляет поиск тэга для вставки изображения штрихкода в файле MSWord или Open Office Writer
//Параметры:
//			ДвоичныеДанныеФайла - двоичные данные файла, в котором осуществляется поиск тэга
//			Расширение - расширение файла, по нему определяется, с помощью какого приложения осуществлять поиск
//			Тэг - искомый тэг
//			WordApp - COM объект приложения MS Word. Необязательный параметр.
//Возвращает:
//			Истина, если тэг найден
//			Ложь, если тэг не найден или указано неподдерживаемое расширение файла
Функция НайтиТэгДляВставкиКартинки(ДвоичныеДанныеФайла, Расширение, Тэг, WordApp = Неопределено) 
	
	НайденТэгШтрихкода = Ложь;
	
	Если Расширение = "odt" Тогда
		ВременныйФайлИмя = ПолучитьИмяВременногоФайла("odt");
		ДвоичныеДанныеФайла.Записать(ВременныйФайлИмя);
		НайденТэгШтрихкода = АвтозаполнениеШаблоновФайловКлиентСервер.НайтиДанныеВФайлеOpenOfficeWriter(ВременныйФайлИмя, Тэг, "Строка");
		УдалитьФайлы(ВременныйФайлИмя);
	ИначеЕсли АвтозаполнениеШаблоновФайловКлиентСервер.ФорматMSWord(Расширение) Тогда
		ВременныйФайлИмя = ПолучитьИмяВременногоФайла(Расширение);
		ДвоичныеДанныеФайла.Записать(ВременныйФайлИмя);
		Если Расширение = "doc" Тогда
			НайденТэгШтрихкода = АвтозаполнениеШаблоновФайловКлиентСервер.ПроверитьНаличиеСтрокиВФайлеMSWord(ВременныйФайлИмя, Тэг, WordApp);
		ИначеЕсли Расширение = "docx" Тогда
			НайденТэгШтрихкода = АвтозаполнениеШаблоновФайловКлиентСервер.ПроверитьНаличиеСтрокиВФайлеDocX(Тэг, ВременныйФайлИмя);
		КонецЕсли;
		УдалитьФайлы(ВременныйФайлИмя);	
	КонецЕсли;

	Возврат НайденТэгШтрихкода;
	
Конецфункции

//Выполняет вставку изображения штрихкода в файл MSWord или OOWriter вместо тэга
//Параметры:
//			Объект - ссылка на объект, для которого осуществляется вставка
//			Тэг - строка, вместо которой будет выполняться попытка вставки изображения штрихкода
//			НаКлиенте - флаг, показывающий, на клиенте или на сервере выполняется вставка
//			ДвоичныеДанныеИзображения - двоичные данные изображения штрихкода
//			ДвоичныеДанныеФайла - двоичные данные файла, в котором осуществляется поиск тэга и вставка штрихкода
//			ИзменениеФайловMSWordТолькоНаСервере - флаг, показывающий, что вставку штрихкода в файлы MsWord необходимо только на сервере
//Возвращает:
//			Истина, если тэг в файле найден и произведена вставка изображения штрихкода
//			Ложь, если изображение штрихкода не было вставлено
Функция ВставитьШтрихкодВместоТэга(
	Объект, 
	Тэг, 
	НаКлиенте, 
	ДвоичныеДанныеИзображения, 
	ДвоичныеДанныеФайла, 
	Расширение, 
	ФайлРедактируется, 
	ИзменениеФайловMSWordТолькоНаСервере, 
	ВысотаШтрихкода, 
	УникальныйИдентификатор = Неопределено, 
	ОбновитьВерсиюФайла = Истина, 
	ВыдаватьОшибкуЕслиНельзяВставить = Ложь) Экспорт
	
	Результат = Ложь;
	
	WordApp = Неопределено;
	
	Попытка
		ВозможностьВыполнитьВставку = ПроверитьВозможностьВставкиКартинкиНаКлиентеНаСервере(Объект,
			НаКлиенте,
			ИзменениеФайловMSWordТолькоНаСервере,
			Расширение, 
			ФайлРедактируется);
	Исключение
		Если НЕ ВыдаватьОшибкуЕслиНельзяВставить Тогда
			Возврат Ложь;
		Иначе
			Инфо = ИнформацияОбОшибке();
			ВызватьИсключение(Инфо.Описание);
		КонецЕсли;
	КонецПопытки;
				
	Если НЕ ВозможностьВыполнитьВставку Тогда	
		СисИнфо = Новый СистемнаяИнформация;
		Если (СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 
			ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64)
			И ВыдаватьОшибкуЕслиНельзяВставить Тогда
			ВызватьИсключение(НСтр("ru = 'Вставка штрихкода в файл возможна только в Windows. Обратитесь к администратору.'"));	
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
		
	Если Расширение = "odt" Тогда
	    НайденТэгШтрихкода = НайтиТэгДляВставкиКартинки(ДвоичныеДанныеФайла, Расширение, Тэг); 
		Если НайденТэгШтрихкода Тогда
			ДвоичныеДанныеЗаполненногоФайла = ШтрихкодированиеOpenOfficeСервер.ВставитьШтрихкодВФайлODTВместоТэга(ДвоичныеДанныеИзображения, ДвоичныеДанныеФайла, Тэг, ВысотаШтрихкода);
			АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеЗаполненногоФайла, Объект, "Вставка штрихкода", УникальныйИдентификатор);
			Результат = Истина;
		ИначеЕсли ВыдаватьОшибкуЕслиНельзяВставить Тогда
			ВызватьИсключение("ТэгНеНайден");
		КонецЕсли;
	ИначеЕсли АвтозаполнениеШаблоновФайловКлиентСервер.ФорматMSWord(Расширение) Тогда
		Если Расширение = "doc" Тогда
			Попытка
				СисИнфо = Новый СистемнаяИнформация;
				Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
					WordApp = Новый COMОбъект("Word.Application");
				КонецЕсли;
			Исключение
				ВызватьИсключение(НСтр("ru = 'Ошибка работы с приложением MS Word. Необходимо проверить правильность установки приложения.'"));
			КонецПопытки;
		КонецЕсли;
		НайденТэгШтрихкода = НайтиТэгДляВставкиКартинки(ДвоичныеДанныеФайла, Расширение, Тэг, WordApp); 
		Если НайденТэгШтрихкода Тогда
			Если Расширение = "doc" Тогда
				ИмяФайла = ВставитьШтрихкодВФайлMSWordВместоТэга(Расширение, ДвоичныеДанныеИзображения, ДвоичныеДанныеФайла, Тэг, WordApp);	
			  	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
				УдалитьФайлы(ИмяФайла);
				Если ОбновитьВерсиюФайла Тогда
					АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеФайла, Объект, "Вставка штрихкода", УникальныйИдентификатор);
					Результат = Истина;	
				Иначе
					
					Если WordApp <> Неопределено Тогда
						WordApp.Quit();
						WordApp = Неопределено;
					КонецЕсли;
					
					Возврат ДвоичныеДанныеФайла;
					
				КонецЕсли;
				
				WordApp.Quit();
				WordApp = Неопределено;
			Иначе
				ДвоичныеДанныеЗаполненногоФайла = ШтрихкодированиеСервер.ВставитьШтрихкодВместоТэгаВФайлDocx(Тэг, ДвоичныеДанныеИзображения, ДвоичныеДанныеФайла, Расширение, ВысотаШтрихкода);	
				Если ОбновитьВерсиюФайла Тогда
					АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеЗаполненногоФайла, Объект, "Вставка штрихкода", УникальныйИдентификатор);
					Результат = Истина;	
				Иначе
					
					Если WordApp <> Неопределено Тогда
						WordApp.Quit();
						WordApp = Неопределено;
					КонецЕсли;
					
					Возврат ДвоичныеДанныеЗаполненногоФайла;
					
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ВыдаватьОшибкуЕслиНельзяВставить Тогда
			
			Если WordApp <> Неопределено Тогда
				WordApp.Quit();
				WordApp = Неопределено;
			КонецЕсли;
			
			ВызватьИсключение("ТэгНеНайден");
		КонецЕсли;
		
	КонецЕсли;
	
	Если WordApp <> Неопределено Тогда
		WordApp.Quit();
		WordApp = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//Проверяет возможность выполнения вставки изображения штрихкода на клиенте или на сервере
//Параметры:
//			Объект - ссылка на объект, штрихкод которого необходимо вставить
//			НаКлиенте - флаг, показывающий, где планируется вставлять штрихкод. Истина - на клиенте, Ложь - на сервере
//			ИзменениеФайловMSWordТолькоНаСервере - флаг, показывающий, что вставку штрихкода в файлы MsWord необходимо только на сервере
//Возвращает:
//			Истина, если выполнение вставки изображения штрихкода на указанной стороне возможна
//			Ложь, если вставить изображение штрихкода нельзя
Функция ПроверитьВозможностьВставкиКартинкиНаКлиентеНаСервере(Объект, НаКлиенте, ИзменениеФайловMSWordТолькоНаСервере, Расширение, ФайлРедактируется) Экспорт
	
	РезультатПроверки = Ложь;	
	
	СисИнфо = Новый СистемнаяИнформация;
	Если СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 
		ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат Ложь;
	КонецЕсли;
			
	Если ФайлРедактируется Тогда
		ВызватьИсключение(НСтр("ru = 'Данный файл занят. Вставка в файл невозможна.'"));			
	КонецЕсли;
	

	Если НРег(Расширение) <> "odt"
		И НЕ АвтозаполнениеШаблоновФайловКлиентСервер.ФорматMSWord(НРег(Расширение)) Тогда
		ВызватьИсключение(НСтр("ru = 'Вставка штрихкодов осуществляется только в файлы форматов Microsoft Word и OpenOffice Writer'"));
	КонецЕсли;
	
	Если НаКлиенте Тогда
		Если НРег(Расширение) = "doc"
			И НЕ ИзменениеФайловMSWordТолькоНаСервере Тогда
			РезультатПроверки = Истина;
		КонецЕсли;
	Иначе
		Если НРег(Расширение) = "doc"
			И ИзменениеФайловMSWordТолькоНаСервере Тогда
			РезультатПроверки = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ РезультатПроверки Тогда
		РезультатПроверки = (НРег(Расширение) = "docx") ИЛИ (НРег(Расширение) = "odt");
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

//Выполняет вставку изображения штрихкода в файл MSWord или OOWriter, используя настройки расположения
//Параметры:
//			Объект - ссылка на объект, для которого осуществляется вставка
//			НастройкиПоложения - структура
//				СмещениеПоГоризонтали - смещение изображения штрихкода по горизонтали
//				СмещениеПоВертикали - смещение изображения штрихкода по вертикали
//			НаКлиенте - флаг, показывающий, на клиенте или на сервере выполняется вставка
//			ДвоичныеДанныеИзображения - двоичные данные изображения штрихкода
//			ДвоичныеДанныеФайла - двоичные данные файла, в котором осуществляется поиск тэга и вставка штрихкода
//			ИзменениеФайловMSWordТолькоНаСервере - флаг, показывающий, что вставку штрихкода в файлы MsWord необходимо только на сервере
//			УникальныйИдентификатор - уникальный идентификатор формы, с которой вызвана команда. Предназначен для разрешения проблем с 
//				блокировкой объектов при открытии формы объекта.
//Возвращает:
//			Истина, если тэг в файле найден и произведена вставка изображения штрихкода
//			Ложь, если изображение штрихкода не было вставлено
Функция ВставитьШтрихкодСИспользованиемНастроек(Объект, 
		НастройкиПоложения, 
		НаКлиенте, 
		ДвоичныеДанныеИзображения,
		ДвоичныеДанныеФайла, 
		Расширение, 
		ФайлРедактируется, 
		ИзменениеФайловMSWordТолькоНаСервере, 
		УникальныйИдентификатор = Неопределено) Экспорт
	
	Результат = Ложь;
	ВозможностьВыполнитьВставку = ПроверитьВозможностьВставкиКартинкиНаКлиентеНаСервере(Объект,
		НаКлиенте,
		ИзменениеФайловMSWordТолькоНаСервере,
		Расширение, 
		ФайлРедактируется);
				
	Если НЕ ВозможностьВыполнитьВставку Тогда
		СисИнфо = Новый СистемнаяИнформация;
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			ВызватьИсключение(НСтр("ru = 'Вставка штрихкода в файл возможна только в Windows. Обратитесь к администратору.'"));	
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	Если НастройкиПоложения = Неопределено Тогда
		НастройкиПоложения = ШтрихкодированиеСервер.ПолучитьПерсональныеНастройкиПоложенияШтрихкодаНаСтранице();
	КонецЕсли;
	
	Попытка
		Расширение = ?(НаКлиенте, НРег(Объект.ТекущаяВерсияРасширение), НРег(Объект.ТекущаяВерсия.Расширение));
	Исключение
		Расширение =  ШтрихкодированиеСервер.ПолучитьРасширениеФайла(Объект);
	КонецПопытки;
	
	Если Расширение = "odt" Тогда 
   		ДвоичныеДанныеЗаполненногоФайла = ШтрихкодированиеOpenOfficeСервер.ВставитьШтрихкодВФайлODTСУказаниемПоложения(ДвоичныеДанныеИзображения, ДвоичныеДанныеФайла, НастройкиПоложения);
		АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеЗаполненногоФайла, Объект, "Вставка штрихкода", УникальныйИдентификатор);
		Результат = Истина;
	ИначеЕсли АвтозаполнениеШаблоновФайловКлиентСервер.ФорматMSWord(Расширение) Тогда
		Если Расширение = "doc" Тогда 
			ИмяФайла = ВставитьКартинкуВФайлDocСУказаниемПоложения(Расширение, ДвоичныеДанныеФайла, ДвоичныеДанныеИзображения, НастройкиПоложения);
			ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
			АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеФайла, Объект, "Вставка штрихкода", УникальныйИдентификатор);
			Результат = Истина;
		ИначеЕсли Расширение = "docx" Тогда
			ДвоичныеДанныеЗаполненногоФайла = ШтрихкодированиеСервер.ВставитьРегистрационныйШтампВФайлDocxСУказаниемПоложения(Расширение, "", ДвоичныеДанныеФайла, ДвоичныеДанныеИзображения, НастройкиПоложения, Истина);
			АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеЗаполненногоФайла, Объект, "Вставка штрихкода", УникальныйИдентификатор);
			Результат = Истина;
		КонецЕсли;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Вставка штрихкодов осуществляется только в файлы форматов Microsoft Word и OpenOffice Writer'"));
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

//Выполняет вставку регистрационного штампа в файл MSWord или OpenOffice Writer
//Параметры:
//			Объект - ссылка на файл
//			НастройкиПоложения - структура
//				СмещениеПоГоризонтали - смещение изображения штрихкода по горизонтали
//				СмещениеПоВертикали - смещение изображения штрихкода по вертикали
//			НаКлиенте - флаг, показывающий, на клиенте или на сервере выполняется вставка
//			ТекстНадписи - структура, хранящая в себе составляющие части надписи в регистрационном штампе
//			ДвоичныеДанныеФайла - двоичные данные файла, в котором осуществляется поиск тэга и вставка штрихкода
//			ДвоичныеДанныеИзображения - двоичные данные изображения штрихкода
//			ИзменениеФайловMSWordТолькоНаСервере - флаг, показывающий, что вставку штрихкода в файлы MsWord необходимо только на сервере
//			УникальныйИдентификатор - уникальный идентификатор формы, с которой вызвана команда. Предназначен для разрешения проблем с 
//				блокировкой объектов при открытии формы объекта.
//Возвращает:
//			Истина, если вставка регистрационного штампа прошла успешно
//			Ложь, если регистрационный штамп не был вставлен
Функция ВставитьРегистрационныйШтампСИспользованиемНастроек(
	Объект, 
	НастройкиПоложения, 
	НаКлиенте, 
	ТекстНадписи, 
	ДвоичныеДанныеФайла, 
	ДвоичныеДанныеИзображения, 
	Расширение, 
	ФайлРедактируется, 
	ИзменениеФайловMSWordТолькоНаСервере, 
	УникальныйИдентификатор = Неопределено) Экспорт
	
	Результат = Ложь;
	ВозможностьВыполнитьВставку = ПроверитьВозможностьВставкиКартинкиНаКлиентеНаСервере(Объект,
		НаКлиенте,
		ИзменениеФайловMSWordТолькоНаСервере,
		Расширение,
		ФайлРедактируется);
				
	Если НЕ ВозможностьВыполнитьВставку Тогда
		СисИнфо = Новый СистемнаяИнформация;
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			ВызватьИсключение(НСтр("ru = 'Вставка штрихкода в файл возможна только в Windows. Обратитесь к администратору.'"));	
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	Если НастройкиПоложения = Неопределено Тогда
		НастройкиПоложения = ШтрихкодированиеСервер.ПолучитьПерсональныеНастройкиПоложенияШтрихкодаНаСтранице();
	КонецЕсли;
	
	Попытка
		Расширение = ?(НаКлиенте, НРег(Объект.ТекущаяВерсияРасширение), НРег(Объект.ТекущаяВерсия.Расширение));
	Исключение
		Расширение =  ШтрихкодированиеСервер.ПолучитьРасширениеФайла(Объект);
	КонецПопытки;
	
	ВставлятьШтрихкод = ШтрихкодированиеСервер.ПолучитьИспользованиеШтрихкодов();
	
	Если Расширение = "odt" Тогда
		ДвоичныеДанныеКартинки = Неопределено;
   		ДвоичныеДанныеФайлаЗаполненогоФайла = ШтрихкодированиеOpenOfficeСервер.ВставитьРегистрационныйШтампВфайлODTСУказаниемПоложения(ТекстНадписи, ДвоичныеДанныеФайла, ДвоичныеДанныеИзображения, НастройкиПоложения, ВставлятьШтрихкод);
		АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеФайлаЗаполненогоФайла, Объект, "Вставка регистрационного штампа", УникальныйИдентификатор);
		Результат = Истина;
	ИначеЕсли АвтозаполнениеШаблоновФайловКлиентСервер.ФорматMSWord(Расширение) Тогда
		Если Расширение = "doc" Тогда
			ИмяФайла = ВставитьРегистрационныйШтампВФайлDocСУказаниемПоложения(Расширение, ТекстНадписи, ДвоичныеДанныеФайла, ДвоичныеДанныеИзображения, НастройкиПоложения, ВставлятьШтрихкод);	
			ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайла);
			АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеФайла, Объект, "Вставка регистрационного штампа", УникальныйИдентификатор);
			Результат = Истина;
		ИначеЕсли Расширение = "docx" Тогда
			ДвоичныеДанныеЗаполненногоФайла = ШтрихкодированиеСервер.ВставитьРегистрационныйШтампВФайлDocxСУказаниемПоложения(Расширение, ТекстНадписи, ДвоичныеДанныеФайла, ДвоичныеДанныеИзображения, НастройкиПоложения, ВставлятьШтрихкод);	
			АвтозаполнениеШаблоновФайловСервер.ОбновитьВерсиюИзДвоичныхДанных(ДвоичныеДанныеЗаполненногоФайла, Объект, "Вставка регистрационного штампа", УникальныйИдентификатор);
			Результат = Истина;
		КонецЕсли;
	Иначе
		ВызватьИсключение(НСтр("ru = 'Вставка регистрационного штампа осуществляется только в файлы форматов Microsoft Word и OpenOffice Writer'"));
	КонецЕсли;

	Возврат Результат;
	
КонецФункции


#КонецЕсли
