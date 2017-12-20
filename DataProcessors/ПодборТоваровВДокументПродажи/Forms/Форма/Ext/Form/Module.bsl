﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПодборТоваров_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Документ = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие обработки только из документов.'");
	КонецЕсли;
	
	КодФормы = "Обработка_ПодборТоваровВДокументПродажи_Форма";
	
	Если Параметры.Документ <> Неопределено Тогда
		ТипДокумента = ТипЗнч(Параметры.Документ);
		Если ТипДокумента =  Тип("ДокументСсылка.ЗаказКлиента")
			Или ТипДокумента =  Тип("ДокументСсылка.ПеремещениеТоваров")
			Или ТипДокумента =  Тип("ДокументСсылка.ЗаказНаПеремещение")
			Или ТипДокумента =  Тип("ДокументСсылка.РеализацияТоваровУслуг")
			Или ТипДокумента =  Тип("ДокументСсылка.ЧекККМ") Тогда
			ЭтоРасширеннаяФорма = Истина;
		КонецЕсли;
		Если ТипДокумента = Тип("ДокументСсылка.ПеремещениеТоваров") Или ТипДокумента = Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
			Параметры.РежимПодбораБезСуммовыхПараметров = Ложь;
			ВидЦеныПоСкладу                             = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Склад, "УчетныйВидЦены");
			Если ЗначениеЗаполнено(ВидЦеныПоСкладу) Тогда
				Валюта                                      = ВидЦеныПоСкладу.ВалютаЦены;
				ВалютаПоУмолчанию                           = Валюта;
			Иначе
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ ПЕРВЫЕ 1
					|	Валюты.Ссылка
					|ИЗ
					|	Справочник.Валюты КАК Валюты
					|
					|УПОРЯДОЧИТЬ ПО
					|	Валюты.Код";
				
				РезультатЗапроса = Запрос.Выполнить();
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					Валюта            = ВыборкаДетальныеЗаписи.Ссылка;
					ВалютаПоУмолчанию = Валюта;
				КонецЦикла;
			КонецЕсли;
			Параметры.Валюта                                    = Валюта;
			Элементы.ВидЦеныПоСкладу.Видимость                  = Истина;
		КонецЕсли;
	КонецЕсли;
		
	ПодборТоваровСервер.ПриСозданииФормыПодбораНаСервере(ЭтаФорма);
	
	Если Не Параметры.Свойство("ПараметрыУказанияСерий",ПараметрыУказанияСерий) Тогда
		Элементы.КорзинаСерия.Видимость = Ложь;
	КонецЕсли;
	
	Параметры.Свойство("ТолькоОбособленно", ТолькоОбособленно);
	Параметры.Свойство("ПодборВариантовОбеспечения", ПодборВариантовОбеспечения);
	ПодборВариантовОбеспечения = ПодборВариантовОбеспечения
		И ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента")
		И ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	
	Если ПодборВариантовОбеспечения Тогда
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Очистить();
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.ОтгрузитьОбособленно);
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.Обособленно);
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.Отгрузить);
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.СоСклада);
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.ИзЗаказов);
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.Требуется);
		Элементы.КорзинаВариантОбеспечения.СписокВыбора.Добавить(Перечисления.ВариантыОбеспечения.НеТребуется);
	Иначе
		Элементы.КорзинаВариантОбеспечения.Видимость = Ложь;
	КонецЕсли;
	
	ДокументСсылка = Параметры.Документ;
	Параметры.Свойство("Назначение",Назначение);
	Параметры.Свойство("Подразделение",Подразделение);
	Параметры.Свойство("Организация",Организация);
	
	Склад = Параметры.Склад;
	
	Элементы.ГруппаСкладов.Видимость = ЭтоРасширеннаяФорма И Склады.Количество() <> 0;
	Если ЭтоРасширеннаяФорма Тогда
		СкладДляСоединения = Параметры.Склад;
		ИзменитьТекстЗапроса();
		ЕстьПравоДоступаКОтчету = ПравоДоступа("Использование", Метаданные.Отчеты.ПоступлениеИОтгрузкаТоваров);
		ПодборТоваров_УстановитьУсловноеОформлениеДинамическихСписков(ЭтаФорма, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодборТоваров_ИспользоватьФильтрыПриИзмененииВместо(Элемент)
	ПодборТоваров_ИспользоватьФильтрыПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_ИспользоватьФильтрыПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииИспользованияФильтров(ЭтаФорма);
	ИзменитьТекстЗапроса();
		
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ИзменитьВариантНавигацииВместо(Команда)
	
	СписокВыбораВариантовНавигации = Новый СписокЗначений;
	СписокВыбораВариантовНавигации.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам"),
											НСтр("ru = 'Навигация по видам и свойствам'"));
	СписокВыбораВариантовНавигации.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоИерархии"),
											НСтр("ru = 'Навигация по иерархии'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодборТоваров_ИзменитьВариантНавигацииЗавершение", ЭтотОбъект);
	
	ЭтаФорма.ПоказатьВыборИзМеню(ОписаниеОповещения,
								СписокВыбораВариантовНавигации,
								Элементы.КоманднаяПанельВариантНавигации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ГруппаСкладовПриИзмененииВместо(Элемент)
	
	Если ЭтоРасширеннаяФорма Тогда
		ПодключитьОбработчикОжидания("ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания",0.1,Истина);
	Иначе
		ПодключитьОбработчикОжидания("ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания",0.1,Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ВидЦеныПриИзмененииВместо(Элемент)
	ПодборТоваров_ВидЦеныПриИзмененииСервер();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыСписокРасширенныйПоискНоменклатура

&НаКлиенте
Процедура ПодборТоваров_СписокРасширенныйПоискНоменклатураПриАктивизацииСтрокиВместо(Элемент)
	
	ИмяСпискаНоменклатуры = ПодборТоваровКлиентСервер.ИмяСпискаНоменклатурыПоВариантуПоиска(ЭтаФорма);
	
	Если Элемент.Имя <> ИмяСпискаНоменклатуры Тогда
		Возврат;
	КонецЕсли;
	
	Если НавигацияПоХарактеристикам Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицыНоменклатуры = Элемент.ТекущиеДанные;
	
	Если СтрокаТаблицыНоменклатуры = Неопределено Тогда
		
		ПодборТоваровКлиентСервер.ОчиститьТаблицуОстатков(ЭтаФорма);
		ТекущаяСтрокаНоменклатуры = ПодборТоваровКлиентСервер.СтруктураСтрокиНоменклатуры();
		
	Иначе
		
		Если ТекущаяСтрокаНоменклатуры <> Неопределено Тогда
			
			Если (ТекущаяСтрокаНоменклатуры.Номенклатура = СтрокаТаблицыНоменклатуры.Номенклатура) Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		ТекущаяСтрокаНоменклатуры = ПодборТоваровКлиентСервер.СтруктураСтрокиНоменклатуры();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрокаНоменклатуры, СтрокаТаблицыНоменклатуры);
		
		ПодборТоваровКлиент.УстановитьТекущуюСтрокуИерархииНоменклатуры(ЭтаФорма);
		
		Если ОтображатьОстатки Тогда
			Если ЭтоРасширеннаяФорма Тогда
				ПодключитьОбработчикОжидания("ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
			Иначе
				ПодключитьОбработчикОжидания("ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_СписокРасширенныйПоискНоменклатураВыборВместо(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Если выбрана колонка "Ожидается", тогда открываем отчет, иначе стандартное поведение.
	Если Поле.Имя = "СписокРасширенныйПоискНоменклатураОжидается" Тогда
		ОткрытьОтчетПоступлениеИОтгрузкаТоваров();
	Иначе
		// Проверить выбранную строку номенклатуры.
		Оповещение = Новый ОписаниеОповещения("ПодборТаблицаНоменклатураВыборЗавершение", ЭтотОбъект, 
			Новый Структура("Элемент", Элемент));
		ПодборТоваровКлиент.ПриВыбореСтрокиТаблицыНоменклатуры(ЭтаФорма, Оповещение);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыНоменклатуры

&НаКлиенте
Процедура ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиВместо(Элемент)
		
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"ОбщийМодуль.ПодборТоваровКлиент.ПриАктивизацииСтрокиСпискаВидыНоменклатуры");
	
	Если Не (ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоСвойствам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидамИСвойствам")
		Или ВариантНавигации = ПредопределенноеЗначение("Перечисление.ВариантыНавигацииВФормахНоменклатуры.ПоВидам")) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено
		Или ВидНоменклатуры = ТекущиеДанные.Ссылка Тогда
		Возврат;
	КонецЕсли;
	
	ВидНоменклатуры = ТекущиеДанные.Ссылка;

	Если Не ИспользоватьФильтры Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоРасширеннаяФорма Тогда
		ПодключитьОбработчикОжидания("ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	Иначе
		ПодключитьОбработчикОжидания("ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОстаткиТоваров

&НаКлиенте
Процедура ПодборТоваров_ОстаткиТоваровВыборПеред(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТекущаяСтрокаНоменклатуры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицыОстатков = ОстаткиТоваров.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если СтрокаТаблицыОстатков = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаТаблицыОстатков.СкладОписание = "Итого по складам" Тогда
		УстановитьВыполнениеОбработчиковСобытия(Ложь);
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияНоменклатуры

&НаКлиенте
Процедура ПодборТоваров_ИерархияНоменклатурыВыборПеред(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Элементы.ИерархияНоменклатуры.Развернут(ВыбраннаяСтрока) Тогда
		Элементы.ИерархияНоменклатуры.Свернуть(ВыбраннаяСтрока);
	Иначе
		Элементы.ИерархияНоменклатуры.Развернуть(ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодборТоваров_ВидЦеныПриИзмененииСервер()
	
	Если Не ВидЦеныИзменился() Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = Справочники.Валюты.ПустаяСсылка();
	Если ЗначениеЗаполнено(ВидЦеныПоСкладу) Тогда
		ВидыЦенПараметр = ВидЦеныПоСкладу;
		Валюта = ВидыЦенПараметр.ВалютаЦены;
	ИначеЕсли ВидыЦен.Количество() = 0 Тогда
		ВидыЦенПараметр = Справочники.ВидыЦен.ПустаяСсылка();
	ИначеЕсли ВидыЦен.Количество() = 1 Тогда
		ВидыЦенПараметр = ВидыЦен[0].Значение;
		Валюта = ВидыЦенПараметр.ВалютаЦены;
	Иначе
		ВидыЦенПараметр = ВидыЦен.ВыгрузитьЗначения();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ВалютаПоУмолчанию;
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "ВидыЦен", ВидыЦенПараметр);
	ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "Валюта",  Валюта);
	ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "Дата",    Дата);
	
	// Установить свойства элементов формы по переданным параметрам.
	Элементы.СписокРасширенныйПоискНоменклатураЦена.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Цена (%1)'"), Валюта);
	
КонецПроцедуры

// Возвращает Истина, если условие цены поставщика на форме подбора был изменен
// по сравнению с ранее установленным значением.
//
&НаСервере
Функция ВидЦеныИзменился()
	
	ИмяПараметра = "ВидыЦен";
	
	ЗначениеПараметра = СписокНоменклатура.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	
	Если ЗначениеПараметра = Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(ВидЦеныПоСкладу) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Не (ЗначениеПараметра.Значение = ВидЦеныПоСкладу);
	
КонецФункции


&НаКлиенте
Процедура ПодборТоваров_ПодборТаблицаПриАктивизацииСтрокиОбработчикОжидания()
	
	ПолучитьИнформациюОТовареПриПродаже(ЭтаФорма);
	
КонецПроцедуры

// Получает информацию товаре - цене продажи и остатках товара.
// Используется в формах подборов.
//
// Параметры:
//	Форма - УправляемаяФорма - форма подбора.
//
&НаКлиенте
// Получает информацию товаре - цене продажи и остатках товара.
// Используется в формах подборов.
//
// Параметры:
//	Форма - УправляемаяФорма - форма подбора.
//
Процедура ПолучитьИнформациюОТовареПриПродаже(Форма) Экспорт
	
	Если Не Форма.ОтображатьОстатки Или
		Форма.ИспользоватьРасширеннуюФормуПодбораКоличестваИВариантовОбеспечения
		И Не ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		Возврат;
	КонецЕсли;
	
	ОстаткиПоСкладам = Форма.ОстаткиТоваров.ПолучитьЭлементы();
	ОстаткиПоСкладам.Очистить();
	
	Если Форма.РежимПодбораБезСуммовыхПараметров И Не Форма.ОтображатьОстатки Тогда
		Возврат;
	КонецЕсли;
	
	ХарактеристикиИспользуются = Форма.ТекущаяСтрокаНоменклатуры.ХарактеристикиИспользуются;
	ЭтоТовар = Форма.ТекущаяСтрокаНоменклатуры.ЭтоТовар;
	
	Если Не ЭтоТовар Тогда
		Возврат;
	КонецЕсли;
	
	Валюта = Форма.Валюта;
	Соглашение = Форма.Соглашение;
	
	Если Форма.НавигацияПоХарактеристикам Тогда
		
		Если Не ЗначениеЗаполнено(Форма.ТекущаяСтрокаХарактеристик.Характеристика) Тогда
			Возврат;
		КонецЕсли;
		
		ИнформацияОТоваре = ЦенаПродажиИОстаткиТовара(Форма.ТекущаяСтрокаНоменклатуры.Номенклатура, 
			Форма.ТекущаяСтрокаХарактеристик.Характеристика, Соглашение, Валюта, Форма.Склады, Форма.ВидыЦен);
		
	Иначе
		
		ИнформацияОТоваре = ЦенаПродажиИОстаткиТовара(Форма.ТекущаяСтрокаНоменклатуры.Номенклатура, 
			Неопределено, Соглашение, Валюта, Форма.Склады, Форма.ВидыЦен);
		
	КонецЕсли;
	
	ЦенаПродажиТовара = ИнформацияОТоваре.Цена;
	
	НаименованиеУпаковкиЕдиницыИзмерения = ?(ЗначениеЗаполнено(ЦенаПродажиТовара.Упаковка), 
		Строка(ЦенаПродажиТовара.Упаковка), 
		Строка(ЦенаПродажиТовара.ЕдиницаИзмерения));
	
	Для Каждого СтрокаТбл Из ИнформацияОТоваре.ТекущиеОстатки Цикл
			
		СтрокаОстаткиПоСкладам = ОстаткиПоСкладам.Добавить();
		
		СтрокаОстаткиПоСкладам.Период = ТекущаяДата();
		СтрокаОстаткиПоСкладам.ПериодОписание = НСтр("ru = 'Сейчас'");
		СтрокаОстаткиПоСкладам.Доступно = СтрокаТбл.Свободно;
		
		СтрокаОстаткиПоСкладам.ДоступноОписание = ОписаниеДоступногоКоличества(
			СтрокаОстаткиПоСкладам.Доступно,
			НаименованиеУпаковкиЕдиницыИзмерения,
			ХарактеристикиИспользуются,
			Форма.НавигацияПоХарактеристикам);
		
		СтрокаОстаткиПоСкладам.Склад = СтрокаТбл.Склад;
		СтрокаОстаткиПоСкладам.СкладОписание = Строка(СтрокаТбл.Склад);
		СтрокаОстаткиПоСкладам.СкладДоступенДляВыбора = СкладДоступенДляВыбора(Форма, СтрокаОстаткиПоСкладам.Склад);
		
		ПланируемыеОстаткиПоДатам = СтрокаОстаткиПоСкладам.ПолучитьЭлементы();
			
		ЕстьПланируемыеОстатки = Ложь;
		Для Каждого СтрокаТбл Из ИнформацияОТоваре.ПланируемыеОстатки Цикл
			
			Если Не (СтрокаТбл.Склад = СтрокаОстаткиПоСкладам.Склад) Тогда
				Продолжить;
			КонецЕсли;
			
			ЕстьПланируемыеОстатки = Истина;
			
			СтрокаПланируемыеОстаткиПоДатам = ПланируемыеОстаткиПоДатам.Добавить();
			
			СтрокаПланируемыеОстаткиПоДатам.Период = СтрокаТбл.Период;
			СтрокаПланируемыеОстаткиПоДатам.ПериодОписание = Формат(СтрокаТбл.Период, "ДФ=dd.MM.yyyy");
			СтрокаПланируемыеОстаткиПоДатам.Доступно = СтрокаТбл.Доступно;
			
			СтрокаПланируемыеОстаткиПоДатам.ДоступноОписание = ОписаниеДоступногоКоличества(
				СтрокаПланируемыеОстаткиПоДатам.Доступно,
				НаименованиеУпаковкиЕдиницыИзмерения,
				ХарактеристикиИспользуются,
				Форма.НавигацияПоХарактеристикам);
			
			СтрокаПланируемыеОстаткиПоДатам.Склад = СтрокаТбл.Склад;
			СтрокаПланируемыеОстаткиПоДатам.СкладОписание = "";
			СтрокаПланируемыеОстаткиПоДатам.СкладДоступенДляВыбора = СкладДоступенДляВыбора(Форма, СтрокаПланируемыеОстаткиПоДатам.Склад);
			
		КонецЦикла;
		
		Если СтрокаОстаткиПоСкладам.Доступно <= 0  И Не ЕстьПланируемыеОстатки Тогда
			ОстаткиПоСкладам.Удалить(СтрокаОстаткиПоСкладам);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Форма.НавигацияПоХарактеристикам Тогда
		// Вывод итогов по всем складам.
		СвободныеОстаткиПоСкладам = ОстаткиПоВСемСкладам(Форма.ТекущаяСтрокаНоменклатуры.Номенклатура);
		Если СвободныеОстаткиПоСкладам <> 0 Тогда
			СтрокаОстаткиПоСкладам = ОстаткиПоСкладам.Добавить();
			СтрокаОстаткиПоСкладам.СкладОписание = НСтр("ru = 'Итого по складам'");
			СтрокаОстаткиПоСкладам.Доступно      = СвободныеОстаткиПоСкладам;
			СтрокаОстаткиПоСкладам.ДоступноОписание = ОписаниеДоступногоКоличества(
				СвободныеОстаткиПоСкладам,
				НаименованиеУпаковкиЕдиницыИзмерения, 
				ХарактеристикиИспользуются,
				НавигацияПоХарактеристикам);
			СтрокаОстаткиПоСкладам.СкладДоступенДляВыбора = Ложь;
			СтрокаОстаткиПоСкладам.Период = ТекущаяДата();
			СтрокаОстаткиПоСкладам.ПериодОписание = НСтр("ru = 'Сейчас'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает признак доступности склада для выбора.
//
// Параметры:
//	Форма - УправляемаяФорма - форма подбора товаров.
//
// Возвращаемое значение:
//	Булево.
//
&НаКлиенте
Функция СкладДоступенДляВыбора(Форма, Склад)

	Возврат Не (Форма.Склады.НайтиПоЗначению(Склад) = Неопределено);

КонецФункции

// Возвращает строковое описание доступного количества. Используется при выводе
// строк в таблицу остатков в формах подбора товаров в документ продажи, документ
// закупки.
//
// Параметры
//  КоличествоДоступно (Число) - количество товаров,
//	НаименованиеУпаковкиЕдиницыИзмерения (Строка) - наименование упаковки, единицы измерения,
//	ХарактеристикиИспользуются (Булево) - признак ведения учета по характеристикам у товара,
//	НавигацияПоХарактеристикам (Булево) - признак навигации по характеристикам на форме подбора.
//
// Возвращаемое значение:
//	Строка. Описание доступного количества товаров для текущей строки в форме подбора.
//
&НаСервере
Функция ОписаниеДоступногоКоличества(КоличествоДоступно, НаименованиеУпаковкиЕдиницыИзмерения, 
	ХарактеристикиИспользуются, НавигацияПоХарактеристикам)
	
	ДоступноОписание = "";
	
	Если ЗначениеЗаполнено(КоличествоДоступно) Тогда
			ДоступноОписание = Формат(КоличествоДоступно,"ЧДЦ=3") + " " + НаименованиеУпаковкиЕдиницыИзмерения;
	КонецЕсли;
	
	Возврат ДоступноОписание;
	
КонецФункции

&НаСервере
Функция ОстаткиПоВСемСкладам(Номенклатура)
	
	// Вывод строки с итогами по всем складам.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	""Итого по складам"" КАК Склад,
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток,
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток - ТоварыНаСкладахОстатки.КОтгрузкеОстаток КАК Свободно
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(, Номенклатура = &Номенклатура) КАК ТоварыНаСкладахОстатки
		|ГДЕ
		|	ТоварыНаСкладахОстатки.ВНаличииОстаток <> 0";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Возврат ВыборкаДетальныеЗаписи.Свободно;

	КонецЦикла;
		
	Возврат 0;

КонецФункции

// Возвращает структуру - информацию о цене продажи и остатках товара.
//
// Параметры:
//	Номенклатура, Характеристика, Соглашение, Валюта, Склады, ВидыЦен
//
// Возвращаемое значение:
//	Структура. Структура с информацией о цене продажи и остатках товара.
//
&НаСервере
Функция ЦенаПродажиИОстаткиТовара(Номенклатура, Характеристика, Соглашение, Валюта, Склады, ВидыЦен) Экспорт
	
	Перем СоставРазделовЗапроса;
	
	Если ЭтоРасширеннаяФорма Тогда
		Склады = Новый СписокЗначений;
		// Определение списка складов.
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Склады.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Склады КАК Склады
			|ГДЕ
			|	Склады.Ссылка В ИЕРАРХИИ(&Склад)";
		
		Запрос.УстановитьПараметр("Склад", ГруппаСкладов);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Склады.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ИспользованиеХарактеристик");
	НесколькоХарактеристик = ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать;

	Запрос.Текст = ПодборТоваровСервер.ТекстЗапросаДоступныхОстатковПоДатамДляПодбора(
		ЗначениеЗаполнено(Характеристика), НесколькоХарактеристик, СоставРазделовЗапроса)
		+ ПодборТоваровСервер.РазделительПакетаЗапросов()
		+ ПодборТоваровСервер.ТекстЗапросаЦенаПродажиТовара(СоставРазделовЗапроса);
	
	Если ЗначениеЗаполнено(Характеристика) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{(Номенклатура)}", "И Номенклатура = &Номенклатура И Характеристика = &Характеристика");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{(Номенклатура)}", "И Номенклатура = &Номенклатура");
		Характеристика =  Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Склады", Склады);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("ВидыЦен", ВидыЦен);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(ТекущаяДатаСеанса()));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Цена продажи.
	Коэффициент = 1;
	
	ЦенаПродажи = Новый Структура("ВидЦены, Цена, Упаковка, ЕдиницаИзмерения, Описание, СрокПоставки");
	
	ЦенаПродажи.ВидЦены = Справочники.ВидыЦен.ПустаяСсылка();
	ЦенаПродажи.Цена = 0;
	ЦенаПродажи.Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	ЦенаПродажи.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	ЦенаПродажи.Описание = "";
	ЦенаПродажи.СрокПоставки = '00010101';
	
	Выборка = Результат[СоставРазделовЗапроса.Найти("ЦенаПродажиТовара")].Выбрать();
	Если Выборка.Следующий() Тогда
		
		Коэффициент = Выборка.Коэффициент;
		ЗаполнитьЗначенияСвойств(ЦенаПродажи, Выборка);
		
	КонецЕсли;
	
	// Планируемые остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ПланируемыеОстатки")].Выбрать();
	ПланируемыеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Новый Структура("Склад, Период, Доступно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.Доступно = НоваяСтрока.Доступно / Коэффициент;
		ПланируемыеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	// Текущие остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ДоступныеТовары")].Выбрать();
	ТекущиеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Новый Структура("Склад, ВНаличии, Свободно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.ВНаличии = НоваяСтрока.ВНаличии / Коэффициент;
		НоваяСтрока.Свободно = НоваяСтрока.Свободно / Коэффициент;
		
		ТекущиеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Новый Структура("ТекущиеОстатки, ПланируемыеОстатки, Цена", ТекущиеОстатки, ПланируемыеОстатки, ЦенаПродажи);
	
КонецФункции

&НаКлиенте
Процедура ПодборТоваров_ИзменитьВариантНавигацииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено 
		Или ВариантНавигации = Результат.Значение Тогда
		Возврат;
	КонецЕсли;
	
	ВариантНавигации = Результат.Значение;
	ПодборТоваров_ВариантНавигацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_ВариантНавигацииПриИзмененииНаСервере()
	
	ПодборТоваровСервер.ПриИзмененииВариантаНавигации(ЭтаФорма);
	Если ЭтоРасширеннаяФорма Тогда
		ИзменитьТекстЗапроса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиОбработчикОжидания()
	
	ТекущиеДанные = Элементы.ВидыНоменклатуры.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
	
		ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиПослеНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_ВидыНоменклатурыПриАктивизацииСтрокиПослеНаСервере()

	ПодборТоваровСервер.ПриИзмененииВидаНоменклатуры(ЭтаФорма);
	
	Если СтрНайти(СписокНоменклатура.ТекстЗапроса, "ГрафикПоступленияТоваровОстатки") > 0 Тогда
		Возврат;
	КонецЕсли;
	ИзменитьТекстЗапроса();

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПоступлениеИОтгрузкаТоваров()
	
	Если Не ЕстьПравоДоступаКОтчету Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанныеИнформацииПоСкладам = Элементы.СписокРасширенныйПоискНоменклатура.ТекущиеДанные;
	Если ТекущиеДанныеИнформацииПоСкладам = Неопределено ИЛИ ТекущиеДанныеИнформацииПоСкладам.Ожидается = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ТекущиеДанныеСписка();
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Номенклатура = ТекущиеДанные.Номенклатура;
	Склад        = СкладДляСоединения;
	Отбор        = Новый Структура("Номенклатура", Номенклатура);
	
	Если ЗначениеЗаполнено(Склад) Тогда
		Отбор.Вставить("Склад", Склад);
	КонецЕсли;
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", Отбор, Истина);
	
	ОткрытьФорму("Отчет.ПоступлениеИОтгрузкаТоваров.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Функция ТекущиеДанныеСписка()
	
	Если Элементы.СтраницыСписков.ТекущаяСтраница = Элементы.СтраницаРасширенныйПоискНоменклатура Тогда
		ТекущиеДанные = Элементы.СписокРасширенныйПоискНоменклатура.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.СписокСтандартныйПоискНоменклатура.ТекущиеДанные;
	КонецЕсли;
	
	Возврат ТекущиеДанные;
	
КонецФункции

&НаСервере
Процедура ИзменитьТекстЗапроса()
	
	Если Не ЭтоРасширеннаяФорма Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(СписокНоменклатура.ТекстЗапроса, "ГрафикПоступленияТоваровОстатки") > 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СкладДляСоединения) Тогда
		Возврат;
	КонецЕсли;
	
	ТипДокумента = ТипЗнч(Параметры.Документ);
	Если ТипДокумента = Тип("ДокументСсылка.ПеремещениеТоваров")
		Или ТипДокумента =  Тип("ДокументСсылка.ЗаказНаПеремещение") Тогда
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,", "ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка,
			|	ЕСТЬNULL(ГрафикПоступленияТоваровОстатки.КоличествоИзЗаказовОстаток, 0) КАК Ожидается,");
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "И (СвободныеОстатки.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))", "И (СвободныеОстатки.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ГрафикПоступленияТоваров.Остатки(, Склад В ИЕРАРХИИ (&Склад)) КАК ГрафикПоступленияТоваровОстатки
			|		ПО СправочникНоменклатура.Ссылка = ГрафикПоступленияТоваровОстатки.Номенклатура");
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "0 КАК Цена,", "ВЫРАЗИТЬ(ЕСТЬNULL(ЦеныНоменклатуры.Цена, 0) * ВЫБОР
			|			КОГДА &Валюта <> ЦеныНоменклатуры.Валюта
			|				ТОГДА ВЫБОР
			|						КОГДА ЕСТЬNULL(КурсыСрезПоследнихВалютаЦены.Кратность, 0) > 0
			|								И ЕСТЬNULL(КурсыСрезПоследнихВалютаЦены.Курс, 0) > 0
			|								И ЕСТЬNULL(КурсыСрезПоследнихВалютаДокумента.Кратность, 0) > 0
			|								И ЕСТЬNULL(КурсыСрезПоследнихВалютаДокумента.Курс, 0) > 0
			|							ТОГДА КурсыСрезПоследнихВалютаЦены.Курс * КурсыСрезПоследнихВалютаДокумента.Кратность / (КурсыСрезПоследнихВалютаДокумента.Курс * КурсыСрезПоследнихВалютаЦены.Кратность)
			|						ИНАЧЕ 0
			|					КОНЕЦ
			|			ИНАЧЕ 1
			|		КОНЕЦ КАК ЧИСЛО(15, 2)) КАК Цена,");
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "ЗНАЧЕНИЕ(Справочник.ВидыЦен.ПустаяСсылка) КАК ВидЦены,", "&ВидыЦен КАК ВидЦены,"); 
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "И (СвободныеОстатки.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))", "И (СвободныеОстатки.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			|				,
			|				ВидЦены = &ВидыЦен
			|					И Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) {(Номенклатура).* КАК Номенклатура}) КАК ЦеныНоменклатуры
			|		ПО (ЦеныНоменклатуры.Номенклатура = СправочникНоменклатура.Ссылка)
			|			И (ЦеныНоменклатуры.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
			|			И (ЦеныНоменклатуры.ВидЦены = &ВидыЦен)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, ) КАК КурсыСрезПоследнихВалютаЦены
			|		ПО (КурсыСрезПоследнихВалютаЦены.Валюта = ЦеныНоменклатуры.Валюта)
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыСрезПоследнихВалютаДокумента
			|		ПО (ИСТИНА)");
		Валюта = Справочники.Валюты.ПустаяСсылка();
		Если ЗначениеЗаполнено(ВидЦеныПоСкладу) Тогда
			ВидыЦенПараметр = ВидЦеныПоСкладу;
			Валюта = ВидыЦенПараметр.ВалютаЦены;
		ИначеЕсли ВидыЦен.Количество() = 0 Тогда
			ВидыЦенПараметр = Справочники.ВидыЦен.ПустаяСсылка();
		ИначеЕсли ВидыЦен.Количество() = 1 Тогда
			ВидыЦенПараметр = ВидыЦен[0].Значение;
			Валюта = ВидыЦенПараметр.ВалютаЦены;
		Иначе
			ВидыЦенПараметр = ВидыЦен.ВыгрузитьЗначения();
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			Валюта = ВалютаПоУмолчанию;
		КонецЕсли;
		ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "ВидыЦен", ВидыЦенПараметр);
		ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "Валюта",  Валюта);
		ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "Дата",    Дата);
		
	Иначе
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "СправочникНоменклатура.Артикул КАК Артикул,", "СправочникНоменклатура.Артикул КАК Артикул,
			|	ЕСТЬNULL(ГрафикПоступленияТоваровОстатки.КоличествоИзЗаказовОстаток, 0) КАК Ожидается,");
		СписокНоменклатура.ТекстЗапроса = СтрЗаменить(СписокНоменклатура.ТекстЗапроса, "Справочник.Номенклатура КАК СправочникНоменклатура", "Справочник.Номенклатура КАК СправочникНоменклатура
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ГрафикПоступленияТоваров.Остатки(, Склад В ИЕРАРХИИ (&Склад)) КАК ГрафикПоступленияТоваровОстатки
			|		ПО СправочникНоменклатура.Ссылка = ГрафикПоступленияТоваровОстатки.Номенклатура");
	КонецЕсли;
	
	Если СкладДляСоединения = Справочники.Склады.ПустаяСсылка() Тогда
		ПодборТоваровКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокНоменклатура, "Склад", Справочники.Склады.ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодборТоваров_УстановитьУсловноеОформлениеДинамическихСписков(Форма, ЭтоФормаПодбораВДокументыЗакупки = Ложь)
	ЭтоПартнер = ПраваПользователяПовтИсп.ЭтоПартнер();
	
	Если Не ЭтоПартнер Тогда
		
		Элемент = УсловноеОформление.Элементы.Добавить();
	
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОстаткиТоваров.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОстаткиТоваров.СкладОписание");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = "Итого по складам";
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ИтогиФон);
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРасширенныйПоискНоменклатураОжидается.Имя);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Формат", "ЧДЦ=3");
		Элемент.Оформление.УстановитьЗначениеПараметра("ВыделятьОтрицательные", Истина);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
