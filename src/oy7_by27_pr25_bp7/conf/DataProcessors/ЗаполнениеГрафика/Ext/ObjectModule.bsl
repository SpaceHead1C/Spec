﻿Процедура ЗаполнитьГрафик(ДатаНачала, ДатаОкончания, ВыходныеДни) Экспорт 
	
	Набор = РегистрыСведений.ГрафикиРаботы.СоздатьНаборЗаписей();
	Набор.Отбор.График.Установить(График);
	Набор.Прочитать();
	
	ЧислоСекундВСутках = 86400;
	
	Дат = ДатаНачала;
	Для к = 0 По Набор.Количество()-1 Цикл
		
		Запись = Набор[к];
		Если Запись.Дата < ДатаНачала Тогда
		    Продолжить;
		ИначеЕсли Запись.Дата = Дат Тогда
			Запись.Значение = ?(Найти(ВыходныеДни, Строка(ДеньНедели(Дат))), 0, 8);
			Дат = Дат + ЧислоСекундВСутках;
		Иначе
			Пока Дат < Мин(Запись.Дата, ДатаОкончания) Цикл
				НоваяЗапись = Набор.Добавить();
				НоваяЗапись.Дата	 = Дат;
				НоваяЗапись.Значение = ?(Найти(ВыходныеДни, Строка(ДеньНедели(Дат))), 0, 8);
				
				Дат = Дат + ЧислоСекундВСутках;
			КонецЦикла; 
			Если Запись.Дата > ДатаОкончания Тогда
				Прервать;
			Иначе
				Запись.Значение = ?(Найти(ВыходныеДни, Строка(ДеньНедели(Дат))), 0, 8);
			КонецЕсли;
			Дат = Дат + ЧислоСекундВСутках;
		КонецЕсли; 
	КонецЦикла;
	Набор.Записать();
	
	Пока Дат <= ДатаОкончания Цикл
		Запись = Набор.Добавить();
		Запись.Дата		 = Дат;
		Запись.График	 = График;
		Запись.Значение	 = ?(Найти(ВыходныеДни, Строка(ДеньНедели(Дат))), 0, 8);
		
		Дат = Дат + ЧислоСекундВСутках;
	КонецЦикла; 
	Набор.Записать();
КонецПроцедуры
