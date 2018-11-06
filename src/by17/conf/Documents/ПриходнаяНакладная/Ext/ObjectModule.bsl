﻿
Процедура ОбработкаПроведения(Отказ, Режим) 
	Движения.Проводки.Записывать = Истина;
	
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		// регистр Проводки
		Движение = Движения.Проводки.Добавить();
		Движение.СчетДт			 = ПланыСчетов.Управленческий.Товары;
		Движение.СчетКт			 = ПланыСчетов.Управленческий.Поставщики;
		Движение.Период			 = Дата;
		Движение.Сумма			 = ТекСтрокаТовары.Сумма;
		Движение.КоличествоДт	 = ТекСтрокаТовары.Количество;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура]	 = ТекСтрокаТовары.Номенклатура;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Склады]		 = Склад;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Партии]		 = Ссылка;
	КонецЦикла;
КонецПроцедуры
