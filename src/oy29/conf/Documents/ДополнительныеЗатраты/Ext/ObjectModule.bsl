﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДополнительныеЗатратыПартии.Партия КАК Партия
		|ПОМЕСТИТЬ втТЧ
		|ИЗ
		|	Документ.ДополнительныеЗатраты.Партии КАК ДополнительныеЗатратыПартии
		|ГДЕ
		|	ДополнительныеЗатратыПартии.Ссылка = &Ссылка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Партия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТЧ.Партия КАК Партия
		|ИЗ
		|	втТЧ КАК втТЧ");
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ОстаткиНоменклатуры");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = РезультатЗапроса;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Партия", "Партия");
	Блокировка.Заблокировать();
	
	Движения.ОстаткиНоменклатуры.Очистить();
	Движения.ОстаткиНоменклатуры.Записать(); // флаг Движения.ОстаткиНоменклатуры.Записывать всё ещё взведён
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиНоменклатурыОбороты.Номенклатура КАК Номенклатура,
		|	ОстаткиНоменклатурыОбороты.Партия КАК Партия,
		|	ОстаткиНоменклатурыОбороты.Период КАК Период,
		|	ОстаткиНоменклатурыОбороты.КоличествоПриход КАК КоличествоПриход,
		|	ОстаткиНоменклатурыОбороты.КоличествоРасход КАК КоличествоРасход
		|ИЗ
		|	РегистрНакопления.ОстаткиНоменклатуры.Обороты(
		|			,
		|			,
		|			Секунда,
		|			Партия В
		|				(ВЫБРАТЬ
		|					втТЧ.Партия
		|				ИЗ
		|					втТЧ)) КАК ОстаткиНоменклатурыОбороты
		|ИТОГИ
		|	СУММА(КоличествоПриход)
		|ПО
		|	ОБЩИЕ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ВыборкаОбщая = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщая.Следующий();
	
	КоличествоВсего = ВыборкаОбщая.КоличествоПриход;
	Если КоличествоВсего = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = ВыборкаОбщая.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.КоличествоПриход <> 0 Тогда
			Движение = Движения.ОстаткиНоменклатуры.ДобавитьПриход();
			Движение.Период			 = Выборка.Период;
			Движение.Номенклатура	 = Выборка.Номенклатура;
			Движение.Партия			 = Выборка.Партия;
			Движение.Стоимость		 = СуммаЗатрат * Выборка.КоличествоПриход / КоличествоВсего;
		КонецЕсли;
		
		Если Выборка.КоличествоРасход <> 0 Тогда
			Движение = Движения.ОстаткиНоменклатуры.ДобавитьРасход();
			Движение.Период			 = Выборка.Период;
			Движение.Номенклатура	 = Выборка.Номенклатура;
			Движение.Партия			 = Выборка.Партия;
			Движение.Стоимость		 = СуммаЗатрат * Выборка.КоличествоРасход / КоличествоВсего;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
