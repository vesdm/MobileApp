
Функция WebSearchPOST(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","text/xml; charset=UTF-8");
	
	Ответ.Заголовки.Вставить("Access-Control-Allow-Origin","*");
	Ответ.Заголовки.Вставить("Access-Control-Allow-Headers","origin, x-requested-with, content-type");
	Ответ.Заголовки.Вставить("Access-Control-Allow-Methods","POST");

	Ответ.УстановитьТелоИзСтроки(НайтиЭлементы(Запрос));
	Возврат Ответ;
КонецФункции

Функция WebSearchGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","text/html; charset=UTF-8");
	Если Запрос.ПараметрыЗапроса.Количество() = 0 Тогда
		Ответ.УстановитьТелоИзСтроки(КодСтраницы());
	Иначе
		Тело = НайтиЭлементы(Запрос);
		Ответ.УстановитьТелоИзСтроки("<html>" + ПолучитьСтильТаблицы() + Тело + "</html>");
	КонецЕсли;
	Возврат Ответ;
КонецФункции

Функция НайтиЭлементы(ЗапросHTTP)
	СтрПоиска = "";
	Если ЗапросHTTP.ПараметрыЗапроса.Количество() = 0 Тогда
		СтрПоиска = "ИЛИ ИСТИНА";
	Иначе
		Для Каждого Стр Из ЗапросHTTP.ПараметрыЗапроса Цикл
		СтрПоиска = СтрПоиска + "
		|	ИЛИ ТестированиеИнтентов.Наименование ПОДОБНО """ + "%" + Стр.Ключ + "%" + """
		|	ИЛИ ТестированиеИнтентов.Действие ПОДОБНО """  + "%" + Стр.Ключ + "%"""
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТестированиеИнтентов.Наименование КАК Наименование,
		|	ТестированиеИнтентов.Код,
		|	ТестированиеИнтентов.Действие,
		|	ТестированиеИнтентов.Данные,
		|	ТестированиеИнтентов.Тип,
		|	ТестированиеИнтентов.Категория,
		|	ТестированиеИнтентов.ИмяКласса,
		|	ТестированиеИнтентов.Приложение,
		|	ТестированиеИнтентов.Комментарий,
		|	ТестированиеИнтентов.URL
		|ИЗ
		|	Справочник.ТестированиеИнтентов КАК ТестированиеИнтентов
		|ГДЕ
		|	ЛОЖЬ " + СтрПоиска;
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Массив = Новый Массив;
	Для Каждого Стр Из РезультатЗапроса Цикл
		Нов = Новый Структура;
		Для Каждого Кол Из РезультатЗапроса.Колонки Цикл
			Нов.Вставить(Кол.Имя, Стр[Кол.Имя]);
		КонецЦикла;
		Массив.Добавить(Нов);		
	КонецЦикла;
	
	НачальныйXML = СервисныйМодуль.Сериализовать(Массив);
	
	ОписаниеХSL = СхемаXSL();

	
	Преобразование = Новый ПреобразованиеXSL; 
	Преобразование.ЗагрузитьИзСтроки(ОписаниеХSL); 
	РезультатXML=Преобразование.ПреобразоватьИзСтроки(НачальныйXML); 

	Возврат РезультатXML;
КонецФункции

Функция КодСтраницы()
Возврат "<?xml version='1.0' encoding='UTF-8'?>
|<!DOCTYPE html PUBLIC '-//WAPFORUM//DTD XHTML Mobile 1.0//EN' 'http://www.wapforum.org/DTD/xhtml-mobile10.dtd'>
|<html lang='en'>
| <head>                      
|  <meta charset='utf-8'>
|  <meta name=viewport content='width=700'>
| </head>" + ПолучитьСтильТаблицы() + "
|<body onselectstart='return false'>
|<form>
|	<table id='SearchTable'>
|		<tr>
|			<td>
|				<span>Строка поиска</span>
|			</td>
|			<td>
|				<input type='text' value='' id='sstring' autocorrect=off autocapitalize=words />
|				<input type='button' value='Найти' id='sbut' onclick='SearchFunc()'/>
|			</td>
|		</tr>
|	</table>
|	<div id='sfind'/>
|</form>
|<script type='text/javascript'>
|	function SearchFunc(){
|		var quantity = document.getElementById('sstring').value;

|		var xhr = getXmlHttp();
|		xhr.onreadystatechange = function() {

|			if (xhr.readyState == 4) {
|				if (xhr.status >= 400) {
|					alert( 'Возникла ошибка!' ); // пример вывода: 404: Not Found
|					} else {
|						var div = document.getElementById('sfind');
|						div.innerHTML = xhr.responseText;
|					}
|				}
|			}
|		xhr.open('POST', 'http://192.168.0.58:8080/empty83/hs/WS?' + quantity);
|		xhr.send();
|			
|	}

|	function getXmlHttp(){
|	  var xmlhttp;
|	  try {
|		xmlhttp = new ActiveXObject('Msxml2.XMLHTTP');
|	  } catch (e) {
|		try {
|		  xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
|		} catch (E) {
|		  xmlhttp = false;
|		}
|	  }
|	  if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
|		xmlhttp = new XMLHttpRequest();
|	  }
|	  return xmlhttp;
|	}

|</script>

|</body>
|</html>";

КонецФункции

Функция СхемаXSL()
	
	Возврат
	"<?xml version='1.0' encoding='ISO-8859-1'?>
	|<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:a='http://v8.1c.ru/8.1/data/core'>
	|	<xsl:output method='html' indent='yes'/>
	|	<xsl:template match='/'>
	|		<body>
	|			<xsl:for-each select='a:Array/a:Value'>
	|				<p>
	|					<TABLE class='tg'>
	|						<TBODY>
	|							<xsl:for-each select='a:Property'>
	|								<TR>
	|									<xsl:choose>
	|										<xsl:when test='position()=1'>
	|											<td class='tg-ft'>
	|												<xsl:value-of select='@name'/>
	|											</td>
	|										</xsl:when>
	|										<xsl:when test='(position() mod 2)=0'>
	|											<td class='tg-frc'>
	|												<xsl:value-of select='@name'/>
	|											</td>
	|										</xsl:when>
	|										<xsl:otherwise>
	|											<td class='tg-fr'>
	|												<xsl:value-of select='@name'/>
	|											</td>
	|										</xsl:otherwise>
	|									</xsl:choose> 
	|									<xsl:choose>
	|										<xsl:when test='position()=1'>
	|											<td class='tg-st'>
	|												<xsl:value-of select='a:Value'/>
	|											</td>
	|										</xsl:when>
	|										<xsl:when test='(position() mod 2)=0'>
	|											<td class='tg-src'>
	|												<xsl:value-of select='a:Value'/>
	|											</td>
	|										</xsl:when>
	|										<xsl:otherwise>
	|											<td class='tg-sr'>
	|												<xsl:value-of select='a:Value'/>
	|											</td>
	|										</xsl:otherwise>
	|									</xsl:choose> 
	|								</TR>
	|							</xsl:for-each>
	|						</TBODY>
	|					</TABLE>
	|				</p>
	|			</xsl:for-each>
	|		</body>
	|	</xsl:template>
	|</xsl:stylesheet>";
КонецФункции

Функция ПолучитьСтильТаблицы()
	Возврат "<style type='text/css'>
		|input, textarea {max-width:100%}
		|.tg  {border-collapse:collapse;border-spacing:0;width:100%;}
		|.tg td{font-family:Arial, sans-serif;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-top-width:1px;border-bottom-width:1px}
		|.tg th{font-family:Arial, sans-serif;font-weight:normal;padding:10px 5px;border-style:solid;border-width:0px;overflow:hidden;word-break:normal;border-top-width:1px;border-bottom-width:1px}
		|.tg .tg-frc{font-size:16;text-size-adjust:none; width:25%; font-weight:bold;background-color:#ecf4ff;vertical-align:top}
		|.tg .tg-ft {font-size:16;text-size-adjust:none;            font-weight:bold;background-color:#cbcefb;vertical-align:top}
		|.tg .tg-st {font-size:16;text-size-adjust:none;                             background-color:#cbcefb;vertical-align:top;text-align:center}
		|.tg .tg-src{font-size:16;text-size-adjust:none;                             background-color:#ecf4ff;vertical-align:top}
		|.tg .tg-fr {font-size:16;text-size-adjust:none;            font-weight:bold;                         vertical-align:top}
		|.tg .tg-sr {font-size:16;text-size-adjust:none;                                                      vertical-align:top}
		|</style>"
КонецФункции