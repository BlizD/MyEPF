
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Перем Пароль;
	Если НЕ ЗначениеЗаполнено(Пароль) Тогда
		ВызватьИсключение "Ошибка! Не указан пароль";
	Конецесли;
	
	ПараметрыУчетнойЗаписи = Новый Структура();
	//ПараметрыУчетнойЗаписи.Вставить("АдресЭлектроннойПочты",УчетнаяЗапись.АдресЭлектроннойПочты);
	//ПараметрыУчетнойЗаписи.Вставить("Пароль",УчетнаяЗапись.Пароль);
	//ПараметрыУчетнойЗаписи.Вставить("СерверИсходящейПочты",УчетнаяЗапись.СерверИсходящейПочты);
	//ПараметрыУчетнойЗаписи.Вставить("ПортСервераИсходящейПочты",УчетнаяЗапись.ПортСервераИсходящейПочты);
	ПараметрыУчетнойЗаписи.Вставить("АдресЭлектроннойПочты","bps_1c@bk.ru");
	ПараметрыУчетнойЗаписи.Вставить("Пароль",Пароль);
	ПараметрыУчетнойЗаписи.Вставить("СерверИсходящейПочты","smtp.bk.ru");
	ПараметрыУчетнойЗаписи.Вставить("ПортСервераИсходящейПочты","465");
	
	ПослатьПоПочте("bps_1c@bk.ru",ТекстПисьма,"Тест альтернатива",,ПараметрыУчетнойЗаписи);	
КонецПроцедуры

//--====== Отправка =======------- через CDO, Адрессаты через ";", СписокВложений - СписокЗначений с именами файлов
Функция ПослатьПоПочте(Знач Адрессаты,ТемаСообщения = "",СообщениеТекст = "" ,СписокВложений = "",ПараметрыУчетнойЗаписи)Экспорт

    Оправитель         = ПараметрыУчетнойЗаписи.АдресЭлектроннойПочты;
    Пароль             = ПараметрыУчетнойЗаписи.Пароль;
	СерверИсходящейПочты = ПараметрыУчетнойЗаписи.СерверИсходящейПочты;
	ПортСервераИсходящейПочты = ПараметрыУчетнойЗаписи.ПортСервераИсходящейПочты;
	
    ТекстСообщения     = ?(СообщениеТекст="","Данные во вложении",СообщениеТекст);

    loConfig         = Новый COMОбъект("CDO.Configuration");
    loCdoMessage     = Новый COMОбъект("CDO.Message");
    loCdoMessage.Configuration = loConfig;
    loCdoMessage.From    = Строка("Служба автоматической рассылки Ромашка"""" <"+Оправитель+">");    //loCdoMessage.From    = "Тест 1C"""" <xxxxxxx@yandex.ru>";
    loCdoMessage.To      = Адрессаты;                                                             //loCdoMessage.To      = "xxxxxxx@gmail.ru>";
    loCdoMessage.Subject = ?(ТемаСообщения="","Автоматическая рассылка ООО ""ромашка""",ТемаСообщения);

	HTMLBody = ТекстСообщения;
    loCdoMessage.BodyPart.Charset = "windows-1251"; // это если делать без извратов с оформлением текста письма
    loCdoMessage.HTMLBody = HTMLBody;

    Если ТипЗнч(СписокВложений) = Тип("Строка") И Не СписокВложений = "" Тогда
        Попытка
            loCdoMessage.AddAttachment(СписокВложений);
        Исключение
        КонецПопытки;
    ИначеЕсли ТипЗнч(СписокВложений) = Тип("СписокЗначений") Тогда
        Для каждого ПутьКВложению Из СписокВложений Цикл
            Попытка
                loCdoMessage.AddAttachment(ПутьКВложению.Значение);
            Исключение
            КонецПопытки;
        КонецЦикла;
    КонецЕсли;
    loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing").            Value = 2;
	loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver").           Value = СерверИсходящейПочты;
	loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport").       Value = ПортСервераИсходящейПочты;
    loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate").     Value = 1;
    loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername").         Value = Оправитель;
    loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword").         Value = Пароль;
    loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl").           Value = 1;
    loConfig.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout").Value = 60;

    loConfig.Fields.Update();   
    Попытка
        loCdoMessage.Send();
    Исключение
        Сообщить(ОписаниеОшибки());
        Возврат Ложь;
    КонецПопытки;

КонецФункции
