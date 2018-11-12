
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТабДок = Параметры.ТабДок;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	Путь = КаталогВременныхФайлов() + Новый УникальныйИдентификатор;
	ТабДок.Записать(Путь,ТипФайлаТабличногоДокумента.MXL);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПоПути(Команда)
	ПутьСохранения = ОткрытьФормуМодально("ОбщаяФорма.ВыбратьФайл",Новый Структура("ВыборПутиСохранения,ИмяФайла,Расширение,НачальныйПуть", Истина, "Тестовое имя файла", "html", "/storage/sdcard0/Download"));
	ЗаписатьВФайл();
КонецПроцедуры

//Конвертация Табличного Документа в HTML
&НаСервере
Процедура ЗаписатьВФайл()	
    ПреобразованиеMXL_В_HTML.КонвертацияXML_в_HTML(ТабДок,ПутьСохранения);
КонецПроцедуры

&НаКлиенте
Процедура ПутьСохраненияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(ПутьСохранения);
КонецПроцедуры
