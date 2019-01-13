﻿
Процедура РасчитатьСебестоимость() Экспорт
	Запись = РегистрыСведений.ГраницаРасчетаСебестоимости.СоздатьМенеджерЗаписи();
	Запись.Прочитать();
	
	ГраницаРасчетаСебестоимости = ?(Запись.Значение.Пустая(), Новый МоментВремени('00010101', Запись.Значение), Запись.Значение.МоментВремени());
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДокРасходнаяНакладная.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.РасходнаяНакладная КАК ДокРасходнаяНакладная
		|ГДЕ
		|	ДокРасходнаяНакладная.МоментВремени > &Граница
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДокРасходнаяНакладная.МоментВремени");
	
	Запрос.УстановитьПараметр("Граница", ГраницаРасчетаСебестоимости);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
		
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ГраницаРасчетаСебестоимости");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Пока Выборка.Следующий() Цикл
				Документы.РасходнаяНакладная.РассчитатьСебестоимость(Выборка.Ссылка);
			КонецЦикла;
			
			Запись.Значение = Выборка.Ссылка;
			Запись.Записать();
		Исключение
			ОтменитьТранзакцию();
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
			
			Возврат;
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Расчет себестоимости успешно завершен";
	Сообщение.Сообщить();
КонецПроцедуры
