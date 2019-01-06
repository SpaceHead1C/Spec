﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	НаборОсновныеНачисления			 = Движения.ОсновныеНачисления;
	НаборДополнительныеНачисления	 = Движения.ДополнительныеНачисления;
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	СведенияОСотрудникахСрезПоследних.Период КАК Период,
		|	СведенияОСотрудникахСрезПоследних.Сотрудник КАК Сотрудник,
		|	СведенияОСотрудникахСрезПоследних.Оклад КАК Оклад
		|ПОМЕСТИТЬ втИзменениеОклада
		|ИЗ
		|	РегистрСведений.СведенияОСотрудниках.СрезПоследних(&ДатаНачала, ) КАК СведенияОСотрудникахСрезПоследних
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	СведенияОСотрудниках.Период,
		|	СведенияОСотрудниках.Сотрудник,
		|	СведенияОСотрудниках.Оклад
		|ИЗ
		|	РегистрСведений.СведенияОСотрудниках КАК СведенияОСотрудниках
		|ГДЕ
		|	СведенияОСотрудниках.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.ПериодРегистрации КАК ПериодРегистрации,
		|	ВложенныйЗапрос.Сотрудник КАК Сотрудник,
		|	ВложенныйЗапрос.Подразделение КАК Подразделение,
		|	ВложенныйЗапрос.ВидРасчета КАК ВидРасчета,
		|	ВЫБОР
		|		КОГДА ВложенныйЗапрос.Период1 ЕСТЬ NULL
		|				ИЛИ ВложенныйЗапрос.Период1 < ВложенныйЗапрос.ПериодДействияНачало
		|			ТОГДА ВложенныйЗапрос.ПериодДействияНачало
		|		ИНАЧЕ ВложенныйЗапрос.Период1
		|	КОНЕЦ КАК ПериодДействияНачало,
		|	ВЫБОР
		|		КОГДА ВложенныйЗапрос.Период2 ЕСТЬ NULL
		|			ТОГДА КОНЕЦПЕРИОДА(ВложенныйЗапрос.ПериодДействияКонец, ДЕНЬ)
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ВложенныйЗапрос.Период2, СЕКУНДА, -1)
		|	КОНЕЦ КАК ПериодДействияКонец,
		|	ВложенныйЗапрос.БазовыйПериодНачало КАК БазовыйПериодНачало,
		|	ВложенныйЗапрос.БазовыйПериодКонец КАК БазовыйПериодКонец,
		|	ВложенныйЗапрос.Размер КАК Размер,
		|	ВложенныйЗапрос.График КАК График
		|ИЗ
		|	(ВЫБРАТЬ
		|		ОсновныеНачисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|		ОсновныеНачисления.Сотрудник КАК Сотрудник,
		|		ОсновныеНачисления.Подразделение КАК Подразделение,
		|		ОсновныеНачисления.ВидРасчета КАК ВидРасчета,
		|		ВЫБОР ОсновныеНачисления.ВидРасчета
		|			КОГДА ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад)
		|				ТОГДА втИзменениеОклада1.Оклад
		|			ИНАЧЕ ОсновныеНачисления.Размер
		|		КОНЕЦ КАК Размер,
		|		ОсновныеНачисления.ПериодДействияНачало КАК ПериодДействияНачало,
		|		КОНЕЦПЕРИОДА(ОсновныеНачисления.ПериодДействияКонец, ДЕНЬ) КАК ПериодДействияКонец,
		|		втИзменениеОклада1.Период КАК Период1,
		|		МИНИМУМ(втИзменениеОклада2.Период) КАК Период2,
		|		ОсновныеНачисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
		|		ВЫБОР
		|			КОГДА ОсновныеНачисления.БазовыйПериодКонец <> ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА КОНЕЦПЕРИОДА(ОсновныеНачисления.БазовыйПериодКонец, ДЕНЬ)
		|			ИНАЧЕ ОсновныеНачисления.БазовыйПериодКонец
		|		КОНЕЦ КАК БазовыйПериодКонец,
		|		ОсновныеНачисления.График КАК График
		|	ИЗ
		|		Документ.НачислениеЗарплаты.ОсновныеНачисления КАК ОсновныеНачисления
		|			ЛЕВОЕ СОЕДИНЕНИЕ втИзменениеОклада КАК втИзменениеОклада1
		|			ПО ОсновныеНачисления.Сотрудник = втИзменениеОклада1.Сотрудник
		|				И (ОсновныеНачисления.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад))
		|			ЛЕВОЕ СОЕДИНЕНИЕ втИзменениеОклада КАК втИзменениеОклада2
		|			ПО (втИзменениеОклада1.Сотрудник = втИзменениеОклада2.Сотрудник)
		|				И (втИзменениеОклада1.Период < втИзменениеОклада2.Период)
		|	ГДЕ
		|		ОсновныеНачисления.Ссылка = &Ссылка
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ОсновныеНачисления.Ссылка.ПериодРегистрации,
		|		ОсновныеНачисления.Сотрудник,
		|		ОсновныеНачисления.Подразделение,
		|		ОсновныеНачисления.ВидРасчета,
		|		ОсновныеНачисления.ПериодДействияНачало,
		|		втИзменениеОклада1.Период,
		|		КОНЕЦПЕРИОДА(ОсновныеНачисления.ПериодДействияКонец, ДЕНЬ),
		|		ОсновныеНачисления.БазовыйПериодНачало,
		|		ВЫБОР
		|			КОГДА ОсновныеНачисления.БазовыйПериодКонец <> ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА КОНЕЦПЕРИОДА(ОсновныеНачисления.БазовыйПериодКонец, ДЕНЬ)
		|			ИНАЧЕ ОсновныеНачисления.БазовыйПериодКонец
		|		КОНЕЦ,
		|		ОсновныеНачисления.График,
		|		ВЫБОР ОсновныеНачисления.ВидРасчета
		|			КОГДА ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисления.Оклад)
		|				ТОГДА втИзменениеОклада1.Оклад
		|			ИНАЧЕ ОсновныеНачисления.Размер
		|		КОНЕЦ) КАК ВложенныйЗапрос
		|
		|УПОРЯДОЧИТЬ ПО
		|	Сотрудник,
		|	Подразделение,
		|	ПериодДействияНачало
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Расчеты.ЗаполнитьНаборЗаписей(ТекстЗапроса, Ссылка, НаборОсновныеНачисления);
	НаборОсновныеНачисления.Записать(, Ложь);
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДополнительныеНачисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|	ДополнительныеНачисления.Сотрудник КАК Сотрудник,
		|	ДополнительныеНачисления.Подразделение КАК Подразделение,
		|	ДополнительныеНачисления.ВидРасчета КАК ВидРасчета,
		|	ДополнительныеНачисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
		|	ВЫБОР ДополнительныеНачисления.БазовыйПериодКонец
		|		КОГДА ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДополнительныеНачисления.БазовыйПериодКонец
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ДополнительныеНачисления.БазовыйПериодКонец, ДЕНЬ)
		|	КОНЕЦ КАК БазовыйПериодКонец,
		|	ДополнительныеНачисления.Размер КАК Размер
		|ИЗ
		|	Документ.НачислениеЗарплаты.ДополнительныеНачисления КАК ДополнительныеНачисления
		|ГДЕ
		|	ДополнительныеНачисления.Ссылка = &Ссылка";
	
	Расчеты.ЗаполнитьНаборЗаписей(ТекстЗапроса, Ссылка, НаборДополнительныеНачисления);
	НаборДополнительныеНачисления.Записать(, Ложь);
	
	// Получение необходимых данных, расчёт и запись
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	Измерения.Добавить("Подразделение");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Измерения", Измерения);
	
	РассчитатьОсновныеНачисления(НаборОсновныеНачисления, Запрос);
КонецПроцедуры

Процедура РассчитатьОсновныеНачисления(НаборОсновныеНачисления, Запрос)
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ОсновныеНачисления.ВидРасчета.СпособРасчета КАК СпособРасчета,
		|	ЕСТЬNULL(ДанныеГрафика.ЗначениеПериодДействия, 0) КАК План,
		|	ЕСТЬNULL(ДанныеГрафика.ЗначениеФактическийПериодДействия, 0) КАК Факт,
		|	ЕСТЬNULL(БазаОсновныеНачисления.РезультатБаза, 0) КАК РезультатБаза,
		|	ЕСТЬNULL(БазаОсновныеНачисления.ОтработаноЧасовБаза, 0) КАК ОтработаноЧасовБаза
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(Регистратор = &Регистратор) КАК ДанныеГрафика
		|		ПО ОсновныеНачисления.НомерСтроки = ДанныеГрафика.НомерСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисления.БазаОсновныеНачисления(&Измерения, &Измерения, , Регистратор = &Регистратор) КАК БазаОсновныеНачисления
		|		ПО ОсновныеНачисления.НомерСтроки = БазаОсновныеНачисления.НомерСтроки
		|ГДЕ
		|	ОсновныеНачисления.Регистратор = &Регистратор";
	
	Выборка = Запрос.Выполнить().Выбрать();

	Расчеты.РассчитатьЗаписиРегистраРасчета(НаборОсновныеНачисления, Выборка);
	НаборОсновныеНачисления.Записать(, Истина);
КонецПроцедуры
