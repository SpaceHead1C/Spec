﻿
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	РассчитатьСуммуВСтроке();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	РассчитатьСуммуВСтроке();
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСуммуВСтроке()
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
КонецПроцедуры
