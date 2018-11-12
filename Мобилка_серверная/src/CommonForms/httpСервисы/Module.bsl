
&НаКлиенте
Процедура Подключиться(Команда)
	Попытка
		Если SSL Тогда
			Защита = Новый ЗащищенноеСоединениеOpenSSL();
		Иначе
			Защита = Неопределено;
		КонецЕсли;
		
		ХТТП = Новый HTTPСоединение(АдресСервера, Порт, Логин, Пароль,,,Защита);
		
		ХТТПЗапрос = Новый HTTPЗапрос(ИмяБазы + "/hs/" + URLСсылка);
		
		
		Ответ = ХТТП.ВызватьHTTPМетод(Метод,ХТТПЗапрос);
		
		КодСостояния = Ответ.КодСостояния;
		
		СтрОтвет = "";
		Для Каждого Стр Из Ответ.Заголовки Цикл
			СтрОтвет = СтрОтвет + Стр.Ключ + ": " + Стр.Значение + Символы.ПС;
		КонецЦикла;
		
		Заголовки = СтрОтвет;
		Тело = Ответ.ПолучитьТелоКакСтроку("UTF-8");
		
		Имя = ПолучитьИмяВременногоФайла("html");

		ТХТ = Новый ЗаписьТекста(Имя, "UTF-8");
		ТХТ.Записать(Тело);
		ТХТ.Закрыть();
		
		ТелоHTML = Имя;

	Исключение
		Заголовки = "" + ТекущаяДата() + Символы.ПС + ОписаниеОшибки();
		Тело = "" + ТекущаяДата() + Символы.ПС + ОписаниеОшибки();
	КонецПопытки
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтраницу(Команда)
	ДокументHTML = АдресСайта;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	АдресСервера = "192.168.0.58";
	Порт = 44443;
	ИмяБазы = "mobilka";
	URLСсылка = "WS?r"; 
	SSL = Истина;
КонецПроцедуры

