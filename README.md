# IRL Killer

## Gameplay Video

<a href="http://www.youtube.com/watch?feature=player_embedded&v=YZDEiRTK-sw" target="_blank"><img src="http://img.youtube.com/vi/YZDEiRTK-sw/0.jpg" 
alt="IRLKiller Gameplay Video" width="360" height="280" border="10" /></a>

## Предпосылки

Многим хотелось бы совместить онлайн игру с реальной жизнью, поэтому IRLKiller это отличный способ провести время играя не лёжа на диване, а активно двигаясь и перемещаясь по своему городу.

## Идея

В целом данная онлайн игра представляет собой карту на которой обозначены твое местоположение и местоположение других людей испозующих данное приложение. Если ты подходишь к другому игроку на определенный радиус(который будет зависеть от дальности стрельбы твоего оружия) - то можешь его убить выстрелом, тем самым ты получишь прибавление твоего рейтинга, а противник возродится через некоторое количество времени при этом потеряв рейтинг. Когда ты не используешь приложение твое место на карте будет отображаться последним зафиксированным приложением. Опциально: на карте будут не только реальные люди но и боты, за убийство которых будут даваться оружия или монеты для покупки оружия.

## Интерфейс

Приложение состоит из трёх табов: "Карта", "Инвентарь" и "Профиль". Стартовый – "Карта".  Дополнительные экраны логина открываются только при первом изпользовании приложения.

### Экраны

#### Карта

Показывает реальную 3D карту, но с местоположениями всех игроков.

#### Инвентарь

Показывает оружие в виде таблицы, и также там можно экипировать текущее.
Опциально: Будет не только оружие, но и различные гранаты, улучшения твоего персонажа.

#### Профиль

Показывает статистику игрока, текущий логин пользователя, а также ТОП-10 игроков по рейтингу.

#### Экран логина

Запускается только при первом запуске приложения,нужно ввести только уникальный логин и затем окно уже не будет открываться.


## Работа с сетью

Определяет местоположение других игроков на карте с помощью выгрузки координат из базы данных(Firebase) 

## Работа с БД

Приложение сохраняет здоровье,рейтинг игрока,текущее местоположение если ты онлайн или последнее зафиксированное если оффлайн.

### Авторы

Воробьев Александр и Королев Даниил

