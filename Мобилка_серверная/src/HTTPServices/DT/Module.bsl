Функция SomeDataPostData(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","text/plain; charset=UTF-8");
	Ответ.УстановитьТелоИзСтроки("Был выполнен POST запрос!");
	Возврат Ответ;
КонецФункции

Функция SomeDataGetData(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","text/plain; charset=UTF-8");
	Ответ.УстановитьТелоИзСтроки(ВернутьДанныеЗапросаОтКлиента(Запрос));
	Возврат Ответ;
КонецФункции

//Пингуем сервер и ловим все не верные УРЛ
Функция TestConnection(Запрос)
	Ответ = Новый HTTPСервисОтвет(404);
	Ответ.Заголовки.Вставить("Content-Type","text/plain; charset=UTF-8");   
	СтрОтвет = ВернутьДанныеЗапросаОтКлиента(Запрос);
	СтрОтвет = "Вы указали не верный URL!" + Символы.ПС + СтрОтвет;
	Ответ.УстановитьТелоИзСтроки(СтрОтвет);
	Возврат Ответ;
КонецФункции

Функция ВернутьДанныеЗапросаОтКлиента(Запрос)
	СтрОтвет = "";
	СтрОтвет = СтрОтвет + "HTTPМетод: " + Запрос.HTTPМетод + Символы.ПС;
	СтрОтвет = СтрОтвет + "БазовыйURL: " + Запрос.БазовыйURL + Символы.ПС;
	СтрОтвет = СтрОтвет + "ОтносительныйURL: " + Запрос.ОтносительныйURL + Символы.ПС;
	СтрОтвет = СтрОтвет + Символы.ПС;
	СтрОтвет = СтрОтвет + "Заголовки: " + Символы.ПС;	
	Для Каждого Стр Из Запрос.Заголовки Цикл
		СтрОтвет = СтрОтвет + "	" + Стр.Ключ + ": " + Стр.Значение + Символы.ПС;
	КонецЦикла;
	
	СтрОтвет = СтрОтвет + Символы.ПС;
	СтрОтвет = СтрОтвет + "ПараметрыURL: " + Символы.ПС;
	Для Каждого Стр Из Запрос.ПараметрыURL Цикл
		СтрОтвет = СтрОтвет + "	" + Стр.Ключ + ": " + Стр.Значение + Символы.ПС;
	КонецЦикла;
	
	СтрОтвет = СтрОтвет + Символы.ПС;
	СтрОтвет = СтрОтвет + "ПараметрыЗапроса: " + Символы.ПС;
	Для Каждого Стр Из Запрос.ПараметрыЗапроса Цикл
		СтрОтвет = СтрОтвет + "	" + Стр.Ключ + ": " + Стр.Значение + Символы.ПС;
	КонецЦикла;
	Возврат СтрОтвет
КонецФункции
