
Функция SGGetSign(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	//Если не указать, будет просто как текст выведено
	Ответ.Заголовки.Вставить("Content-Type","text/html; charset=UTF-8");
	Ответ.Заголовки.Вставить("Access-Control-Allow-Origin","*");
	Ответ.Заголовки.Вставить("Access-Control-Allow-Headers","origin, x-requested-with, content-type");
	Ответ.Заголовки.Вставить("Access-Control-Allow-Methods","POST");

	Шаблон = Обработки.СделатьПодпись.ПолучитьМакет("ШаблонДокументаДляВеб");
	КодСтраницы = Шаблон.Область(1,1).Текст;
	КодСтраницы = СтрЗаменить(КодСтраницы,"%Адрес%",Запрос.БазовыйURL + Запрос.ОтносительныйURL);
	Ответ.УстановитьТелоИзСтроки(КодСтраницы);
	Возврат Ответ;
КонецФункции

Функция SGPostSign(Запрос)
	Ответ = Новый HTTPСервисОтвет(201);
	//Ответ.Заголовки.Вставить("Content-Type","text/html; charset=UTF-8");
	
	//Так как мы работаем с картинкой, то нас интересует ее объем.
	ОбъемДанных = Запрос.Заголовки.Получить("Content-Length");
	//проверяем, есть ли в заголовках параметр длины контента.
	Если НЕ ЗначениеЗаполнено(ОбъемДанных) Тогда
		СтрОшибки = "Ошибка: Не указан в заголовках Content-Length, или он пустой!";
		Ответ.КодСостояния = 411; //411 Length Required — для указанного ресурса клиент должен указать Content-Length в заголовке запроса.
		Ответ.УстановитьТелоИзСтроки(СтрОшибки);
		Возврат Ответ;	
	КонецЕсли;	
	//Преобразуем его в число, проверив таким образом его валидность
	Попытка
		ОбъемДанныхЧисло = Число(ОбъемДанных);	
	Исключение
		СтрОшибки = "Ошибка чтения: Content-Length. " + ОписаниеОшибки();
		Ответ.КодСостояния = 400; //400 Bad Request — сервер обнаружил в запросе клиента синтаксическую ошибку.
		Ответ.УстановитьТелоИзСтроки(СтрОшибки);
		Возврат Ответ;	
	КонецПопытки;	
	//Мы знаем, что обычно наши даные не привышают 20кб, ну плюс запас.
	Если ОбъемДанныхЧисло > 25000 Тогда
		СтрОшибки = "Слишком большой запрос. Максимум до 20кб";
		Ответ.КодСостояния = 413; // 413 Request Entity Too Large — возвращается в случае, если сервер отказывается обработать запрос по причине слишком большого размера тела запроса.
		Ответ.УстановитьТелоИзСтроки(СтрОшибки + ", " + ОбъемДанныхЧисло);
		Возврат Ответ;	
	КонецЕсли;
	
	//Только теперь мы получаем тело запроса
	Тело = Запрос.ПолучитьТелоКакСтроку();
	//Мы знаем, что в общем виде, тело должно выглядить так: data:image/png;base64,iVBORw0K....
	//Проверяем, что оно соответстует ему:
	Если НЕ Лев(Тело,22) = "data:image/png;base64," Тогда
		СтрОшибки = "Не поддерживаемый формат данных!";
		Ответ.КодСостояния = 415; //415 Unsupported Media Type — сервер отказывается работать с указанным типом данных при данном методе.
		Ответ.УстановитьТелоИзСтроки(СтрОшибки);
		Возврат Ответ;	
	КонецЕсли;
	ТелоДД = СтрЗаменить(Тело, "data:image/png;base64,","");
	Попытка
		ТелоДД = Base64Значение(ТелоДД);
		КартинкаПодписи = Новый Картинка(ТелоДД, Истина);
		//Теперь можно добавить картинку куда надо
	Исключение
		СтрОшибки = "Не поддерживаемый формат данных!" + ОписаниеОшибки();
		Ответ.КодСостояния = 415; //415 Unsupported Media Type — сервер отказывается работать с указанным типом данных при данном методе.
		Ответ.УстановитьТелоИзСтроки(СтрОшибки);
		Возврат Ответ;	
	КонецПопытки;	
	
	Ответ.УстановитьТелоИзСтроки("Подпись успешно добавлена!");
	Возврат Ответ;
КонецФункции

Функция SGOptions(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Allow","GET,POST");
	Возврат Ответ;
КонецФункции

