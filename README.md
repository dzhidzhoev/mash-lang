# Mash lang

Нетипизированный кроссплатформенный язык программирования,
поддерживающий базовые парадигмы ООП.
Офф сайт: mash-lang.tech

# Предисловие
[!] Данный проект разрабатывается исключительно на моей инициативе, 
для собственного повышения скилла кодинга. Данный проект, каждая строчка кода,
которую вы можете увидеть продумана и написана с абсолютно чистого листа и
является результатом множества проб, ошибок и огромной исследовательской и
мыслительной деятельности. 

Среди прочитанных мной документаций к подобным проектам - я не увидел чего-либо похожего
на данный проект.

# Основные цели и идеи проекта:
1. Создать максимально простую для разработчиков (и главное - для конечных пользователей!) 
среду разработки и выполнения кода.
2. Создать максимально простой, удобный, гибкий, функционально полный, кроссплатформенный и быстрый язык.
3. Обеспечить масштабируемость технологии.

# Проект разделен на несколько частей:
- Виртуальная машина + окружение (среда выполнения).
- Транслятор с языка в абстрактный байт-код для ВМ.
- Языковые библиотеки и библиотеки окружения.

# Архитектура ВМ и языка тесно переплетаются и открывают следующие возможности:
- Полуавтоматический сборщик мусора.
- Легкое взаимодействие с кодом на других (нативных) языках.
- Поддержка многопоточности "из коробки".
- Автоматическая типизация, плавающая типизация для числовых типов данных, 
архитектура организации плавающей типизации для классов.

# На данный момент проект находится в стадии активной разработки.
В этом репозитории могут лежать не самые последние версии кода.
Ждите релиза, дамы и господа.

[!] Проект лицензирован на основе BSD-2 текста лицензии.
При использовании копии или частичной копии одной или нескольких частей
данного проекта указание копирайта, названия проекта и автора обязательно.
