#language: ru

Функционал: Отчет ФРД

Как Сотрудник
Я хочу сформировать отчет фотографию рабочего времени за период
Чтобы проанализировать фотографию рабочего времени 

Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: Фотография рабочего времени

	И В командном интерфейсе я выбираю 'Фотография рабочего времени' 'Фотография рабочего времени'
	Тогда открылось окно 'Фотография рабочего времени (Табель учета рабочего времени)'
	@ И в поле 'Дата с' я ввожу текст '  .  .       :  :  '
	@ И в поле 'по' я ввожу текст '  .  .       :  :  '
	И в табличном документе 'Результат' я перехожу к ячейке "R1C1"
	И я нажимаю кнопку выбора у поля "Дата с"
	И в поле 'Дата с' я ввожу текст '01.06.2018  0:00:00'
	И в поле 'Дата с' я ввожу текст '01.07.2018  0:00:00'
	И я перехожу к следующему реквизиту
	И в поле 'по' я ввожу текст '31.07.2018  0:00:00'
	И я перехожу к следующему реквизиту
	И я нажимаю на кнопку 'Выбрать вариант...'
	Тогда открылось окно 'Выбор варианта отчета'
	И в таблице "SettingsList" я выбираю текущую строку
	Тогда открылось окно 'Фотография рабочего времени (Табель учета рабочего времени)'
	И я нажимаю на кнопку 'Сформировать'
