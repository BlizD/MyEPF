﻿&НаКлиенте
Процедура ФорматированиеТекста(Команда)
	ТекстHTMLМакет = ФорматированиеТекстаНаСервере(Текст);
	ТекстJS = Новый ТекстовыйДокумент;
	ПолученныйТекстJS = ПолучитьТекстJS(); 
	ТекстJS.УстановитьТекст(ПолученныйТекстJS);
	ВременныйФайлПуть=ПолучитьИмяВременногоФайла("js");
	ТекстJS.Записать(ВременныйФайлПуть);
	ТекстHTMLМакет = СтрЗаменить(ТекстHTMLМакет,"...АдресJS...",ВременныйФайлПуть);

	ОбъектHTML=ТекстHTMLМакет;
	ПроцедураНаСервере();
КонецПроцедуры

&НаСервере
Функция ФорматированиеТекстаНаСервере(Текст)
	//ТекстСкрипJS = "window.onload=function(){"+
	//				"document.body.innerHTML = document.body.innerHTML.replace(/<SCRIPT src.*SCRIPT>/g, '');"+
	//				"}";
	ТекстСкрипJS = "";
	ТекстHTMLМакет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетHTML").ПолучитьТекст();
	ТекстCSSМакет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетCSS").ПолучитьТекст();	

	ТекстNew = СтрЗаменить(Текст,Символы.ПС,"\n"); 
	ТекстNew = СтрЗаменить(ТекстNew,"'",""""); //&quot
	ТекстHTMLМакет = СтрЗаменить(ТекстHTMLМакет,"...ТекстJS...",ТекстСкрипJS);
	ТекстHTMLМакет = СтрЗаменить(ТекстHTMLМакет,"...ТекстCSS...",ТекстCSSМакет);
	ТекстHTMLМакет = СтрЗаменить(ТекстHTMLМакет,"...ТекстHTML...",ТекстNew);
	Возврат ТекстHTMLМакет;
КонецФункции

&НаСервере
Функция ПолучитьТекстJS()
	Возврат РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетJS").ПолучитьТекст();
КонецФункции	
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
	
КонецПроцедуры

&НаСервере
Процедура  ПроцедураНаСервере()
	
КонецПроцедуры	



