﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Движения.ОстаткиНоменклатуры.Очистить();
	
	Движения.ПартииТоваров.Записывать = Истина;
	Движения.ПартииТоваров.Очистить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПриходнаяНакладнаяТовары.Номенклатура КАК Номенклатура,
		|	СУММА(ПриходнаяНакладнаяТовары.Количество) КАК Количество,
		|	СУММА(ПриходнаяНакладнаяТовары.Сумма) КАК Сумма
		|ИЗ
		|	Документ.ПриходнаяНакладная.Товары КАК ПриходнаяНакладнаяТовары
		|ГДЕ
		|	ПриходнаяНакладнаяТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяНакладнаяТовары.Номенклатура");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		// регистр ОстаткиНоменклатуры Приход
		Движение = Движения.ОстаткиНоменклатуры.ДобавитьПриход();
		Движение.Период			 = Дата;
		Движение.Номенклатура	 = Выборка.Номенклатура;
		Движение.Склад			 = Склад;
		Движение.Количество		 = Выборка.Количество;

		// регистр ПартииТоваров Приход
		Движение = Движения.ПартииТоваров.ДобавитьПриход();
		Движение.Период			 = Дата;
		Движение.Номенклатура	 = Выборка.Номенклатура;
		Движение.Склад			 = Склад;
		Движение.Партия			 = Ссылка;
		Движение.Количество		 = Выборка.Количество;
		Движение.Стоимость		 = Выборка.Сумма;
	КонецЦикла;
КонецПроцедуры
