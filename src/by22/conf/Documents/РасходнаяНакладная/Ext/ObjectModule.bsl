﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.ОстаткиНоменклатуры.Очистить();
	Движения.ПартииТоваров.Очистить();
	Движения.Продажи.Очистить();
	
	МВТ = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РасходнаяНакладнаяТовары.Номенклатура КАК Номенклатура,
		|	РасходнаяНакладнаяТовары.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
		|	СУММА(РасходнаяНакладнаяТовары.Количество) КАК Количество,
		|	СУММА(РасходнаяНакладнаяТовары.Сумма) КАК Сумма
		|ПОМЕСТИТЬ втТЧ
		|ИЗ
		|	Документ.РасходнаяНакладная.Товары КАК РасходнаяНакладнаяТовары
		|ГДЕ
		|	РасходнаяНакладнаяТовары.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	РасходнаяНакладнаяТовары.Номенклатура,
		|	РасходнаяНакладнаяТовары.Номенклатура.ВидНоменклатуры
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура");
	
	Запрос.МенеджерВременныхТаблиц = МВТ;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Выполнить();
	
	ПроведениеДокументов.ПроверкаОперативногоСписания(ЭтотОбъект, РежимПроведения, МВТ, Отказ);
	Если Отказ Тогда Возврат; КонецЕсли;
	
	ПроведениеДокументов.СформироватьПартионноеСписание(ЭтотОбъект, РежимПроведения, МВТ, Отказ);
	Если Отказ Тогда Возврат; КонецЕсли;
	
	Движения.Записать();
	
	Движения.Продажи.Записывать = Истина;
	
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("Период", Дата);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	&Период КАК Период,
		|	втТЧ.Номенклатура КАК Номенклатура,
		|	втТЧ.Количество КАК Количество,
		|	втТЧ.Сумма КАК Выручка,
		|	ЕСТЬNULL(ПартииТоваровОбороты.СтоимостьРасход, 0) КАК Себестоимость
		|ИЗ
		|	втТЧ КАК втТЧ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПартииТоваров.Обороты(&МоментВремени, &МоментВремени, Регистратор, ) КАК ПартииТоваровОбороты
		|		ПО втТЧ.Номенклатура = ПартииТоваровОбороты.Номенклатура
		|			И (ПартииТоваровОбороты.Регистратор = &Ссылка)";
	
	Движения.Продажи.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры
