﻿
&НаСервере
Процедура ОбновитьКартуНаСервере()
	Карта = ?(ЗначениеЗаполнено(БП), БП.ПолучитьОбъект().ПолучитьКартуМаршрута(), Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКарту(Команда)
	ОбновитьКартуНаСервере();
КонецПроцедуры
