%
	Файл содержит декларацию констант чтения траггерного модуля системы ecal COMET, и предназначен 
для включения в файлы унифицированных реализаций.
-- Эпштейн.
%

-- Transaction Layer Constants, text description file - DAQ_DTR.doc
-- Константы - прервичные параметры протокола последовательной связи, определяемые протоколом обмена КМД-3
CONSTANT  Link_Clock    =  25;  -- частота в МГц-ах (целых), на которой дается синхронизация
CONSTANT  Link_Speed    =  25;  -- Скорость в Мбитах в секунду (целых), на которой работает Линк
CONSTANT  WordsToGoDown =   8;  -- число слов данных в Командной_Посылке, кроме InData
CONSTANT  WordsToGoUp   =  63;  -- число слов данных в Ответной_Посылке, кроме InData
CONSTANT  Command_Size  = 1+5+2;-- размер команды ( 1_Start + 5_OpCode + 2 доп.до нечетности/его инверсия)
CONSTANT  Word_Width    =  16;  -- размер слова данных
--CONSTANT  Pause         =   2;    -- задержка между данными
CONSTANT  Pause         =   0;  -- пауза между словами данными

CONSTANT  CRC_Check     = "CCITT"; --  Тип Проверки по CRC
CONSTANT	PolinomPower	=	16;

--****************************************************************************
-- Константы - параметры протокола последовательной связи, типично вычисляемые,
-- вторично (неявно) определяемые протоколом обмена Линка КМД-3
-- Common Constants :
--   DownLink может деактивировать свой передатчик СРАЗУ после передачи пос-
-- леднего бита Командной_Посылки; однако, сейчас (март2008) сделано, что он 
-- деактивирует свой передатчик через "TimeGap" тактов Линка после передачи 
-- последнего бита Командной_Посылки.  
--   UpLink активирует свой выход через "TimeGap" тактов Линка (по своему 
-- счетчику) после получения последнего бита Командной_Посылки.  Учитывая, что
-- в UpLink-е счетчик запускается после того, как ВЕСЬ OpCode (сейчас - 8бит) 
-- всосётся во входной сдвиговый регистр, счет тактов в UpLink-е отстает от 
-- счета тактов в DnLink-е !  
CONSTANT  TimeGap       = 8;  -- зазор от деактивации выхода Передатчика до активации выхода Приемника
CONSTANT  BitOfReverse  = Command_Size + Pause +    --\ Command is transmitted
        ((WordsToGoDown + 1 ) * (Word_Width+Pause)) -- >InData,[Data words] are transmitted
        + TimeGap ;                                 --/ Time gap 
    --  ^^^^^^^^ DnLink disables its transmitter by "TimeGap" clocks after 
    --  last bit of CommandSequience is transmitted.
    --  Since clock count in UpLink is delayed from that in DnLink, then 
    --  UpLink actually enables its transmitter by 8clocks later than DnLink
    --  disables its transmitter. 

    --CONSTANT BitOfAnswerStart = BitOfReverse + COMMAND_SIZE; -- Номер бита обмена соответствующий стартовому биту ответной посылки
    --   TimeGap must be instead of CommandSize ! ^^^^^^^^^^
-- Когда UpLink активирует свой выход, в этот момент может возникнуть помеха =>
-- => Ответная_Посылка должна начинаться еще через "TimeGap" тактов после 
-- активации выхода UpLink-а;  и с этого момента (+ пара тактов задержки) 
-- DownLink должен начинать ловить Ответную_Посылку.
CONSTANT BitOfAnswerStart = BitOfReverse + TimeGap; -- Номер бита обмена соответствующий стартовому биту ответной посылки

CONSTANT HeaderSize     = Command_Size + Pause      --\ size of ..
                        + Word_Width + Pause ;      --/ .. RE-TRANSMITTED part of the Reply_Sequience
CONSTANT MaxNumberOfBit = BitOfAnswerStart+HeaderSize+WordsToGoUp*(WORD_WIDTH+PAUSE); -- конец цикла работы
CONSTANT OrderOfBitNumber = FLOOR(LOG2(MaxNumberOfBit))+1;  -- определение размера счетчика

--************ UpLink ************
Constant  Dead_Time     = 200;  -- ns, Мертвое время - защитный промежуток от конца цикла до начала следующего, периодов RefClock. 
CONSTANT  Bit_of_Header_UP_Reload = BitOfAnswerStart + COMMAND_SIZE + PAUSE; -- Номер бита с точки зрения счетчика Up Link-а, по которому начинается передача первого слова. Счетчик Up Link-а начинает считать после опознания команды
CONSTANT  Bit_of_CRC_Reload = BitOfAnswerStart+HeaderSize+(WordsToGoUp-1)*((WORD_WIDTH+PAUSE)); -- Номер бита с точки зрения счетчика Up Link-а, по которому начинается передача контрольной суммы (CRC)

--************ DownLink ************
CONSTANT Bit_of_Header_DOWN_Reload = COMMAND_SIZE+PAUSE + 1 ;

-- Номер бита по счетчику DownLink-а, с которого начинать ожидание Отв.Посылки. 
--CONSTANT BitOfAnswerWindowStart = BitOfReverse + COMMAND_SIZE*2; -- Номер бита с точки зрения счетчика Down Link-а, по которому начинается ожидание ответной посылки. 
CONSTANT BitOfAnswerWindowStart = BitOfAnswerStart+2  -- UpLink starts to reply 
                    + (Command_Size+Pause) ;    -- delay of UpLink's countdown

-- Номер бита по счетчику DownLink-а, по кот. заканчивать ожидание Отв.Посылки. 
-- Константа подобрана с для длины кабеля не более ?15 метров.
--CONSTANT BitOfAnswerWindowEnd   = BitOfAnswerStart + COMMAND_SIZE*3;-- Номер бита с точки зрения счетчика Down Link-а, по которому заканчивается ожидание ответной посылки. Константа подобрана с для длины кабеля не более 15 метров.
CONSTANT BitOfAnswerWindowEnd   = BitOfAnswerStart+10
                    + (COMMAND_SIZE+Pause)      -- catch OpCode into Register
                    + (COMMAND_SIZE+Pause) ;    -- delay of UpLink's countdown


--****************************************************************************
-- Command Layer Constants, text description continued
-- Команды, обрабатываемые модулями, паузы включены
-- Полный набор команд, который должны понимать платы в ССД КМД-3
Constant CMDL_Cfg_Read		=	B"10000010";    -- Чтение памати редиректора
Constant CMDL_Cfg_Write		=	B"10001001";	-- Запись в память редиректора

Constant CMDL_Exe_Read_000	=	B"11000001";	-- Чтение 0
Constant CMDL_Exe_Read_010	=	B"11010010";	-- Чтение 1  Start_Regular
Constant CMDL_Exe_Read_100	=	B"11100010";	-- Чтение 2  Start_Alternative
Constant CMDL_Exe_Read_110	=	B"11110001";	-- Чтение 3

Constant CMDL_Exe_Write_001	=	B"11001010";	-- Запись 0
Constant CMDL_Exe_Write_011	=	B"11011001";	-- Запись 1
Constant CMDL_Exe_Write_101	=	B"11101001";	-- Запись 2
Constant CMDL_Exe_Write_111	=	B"11111010";	-- Запись 3
-- CMDL is acronim of CoMmanD Layer
% Первый бит (В6) (после стартового) определяет HIHG=> исполняемая команда LOW=>конфигурационная
Два бита (В5 и В4) дают номер Командного Листа и, соответственно, бит В3 - тип Листа на чтение/запись.
Бит В2 зарезервирован под расширение поля команд.
%

--============================================================================
-- А теперь копируем значения констант в значения констант с УДОБНЫМИ именами:

-- Transaction Layer Constants - первичные параметры протокола последовательного
--  Линка, text description file - DAQ_DTR.doc
CONSTANT  CommandSize   = Command_Size; -- размер команды ( 1_Start + 5_OpCode + 2 доп.до нечетности/его инверсия)
CONSTANT  WordSize      =   Word_Width; -- размер слова данных
CONSTANT  DeadTime      =    Dead_Time; -- ns, Мертвое время - защитный промежуток от конца цикла до начала следующего, периодов RefClock. 

-- Константы - параметры протокола последовательной связи, типично вычисляемые,
-- вторично (неявно) определяемые протоколом обмена СМД-3
-- Common Constants
CONSTANT Bit_Rx2Tx      = BitOfReverse ;     -- Активация выхода UpLink-а
CONSTANT Bit_ReplyStart = BitOfAnswerStart;  -- Номер такта, на котором расположен StartBit ответной посылки


-- Command Layer Constants, text description continued
-- Команды, обрабатываемые модулями, паузы включены
-- Полный набор команд, который должны понимать платы в ССД КМД-3
Constant Read   = CMDL_Cfg_Read;    --B"10000010"=130 Read 62 words from Object(s)
Constant Write  = CMDL_Cfg_Write;   --B"10001001"=137 Write 8 words to Object(s)
Constant Read1  = B"10010001";      -- =145 Read 1 word from an Object
Constant Write1 = B"10011010";      -- =153 Write 1 word to an Object

Constant StartRegul     = CMDL_Exe_Read_000;--B"11000001"=193 Чтение 0  Start_Regular
Constant StartAlter     = CMDL_Exe_Read_010;--B"11010010"=210 Чтение 1  Start_Alternative
Constant CommdLst_Rd100 = CMDL_Exe_Read_100;--B"11100010"=226 Чтение 2
Constant CommdLst_Rd110 = CMDL_Exe_Read_110;--B"11110001"=241 Чтение 3

Constant CommdLst_Wr001 = CMDL_Exe_Write_001;   --B"11001010"=202 Запись 0
Constant CommdLst_Wr011 = CMDL_Exe_Write_011;   --B"11011001"=217 Запись 1
Constant CommdLst_Wr101 = CMDL_Exe_Write_101;   --B"11101001"=233 Запись 2
Constant CommdLst_Wr111 = CMDL_Exe_Write_111;   --B"11111010"=250 Запись 3

