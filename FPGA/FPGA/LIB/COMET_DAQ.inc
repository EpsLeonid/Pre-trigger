%
	���� �������� ���������� �������� ������ ����������� ������ ������� ecal COMET, � ������������ 
��� ��������� � ����� ��������������� ����������.
-- �������.
%

-- Transaction Layer Constants, text description file - DAQ_DTR.doc
-- ��������� - ���������� ��������� ��������� ���������������� �����, ������������ ���������� ������ ���-3
CONSTANT  Link_Clock    =  25;  -- ������� � ���-�� (�����), �� ������� ������ �������������
CONSTANT  Link_Speed    =  25;  -- �������� � ������ � ������� (�����), �� ������� �������� ����
CONSTANT  WordsToGoDown =   8;  -- ����� ���� ������ � ���������_�������, ����� InData
CONSTANT  WordsToGoUp   =  63;  -- ����� ���� ������ � ��������_�������, ����� InData
CONSTANT  Command_Size  = 1+5+2;-- ������ ������� ( 1_Start + 5_OpCode + 2 ���.�� ����������/��� ��������)
CONSTANT  Word_Width    =  16;  -- ������ ����� ������
--CONSTANT  Pause         =   2;    -- �������� ����� �������
CONSTANT  Pause         =   0;  -- ����� ����� ������� �������

CONSTANT  CRC_Check     = "CCITT"; --  ��� �������� �� CRC
CONSTANT	PolinomPower	=	16;

--****************************************************************************
-- ��������� - ��������� ��������� ���������������� �����, ������� �����������,
-- �������� (������) ������������ ���������� ������ ����� ���-3
-- Common Constants :
--   DownLink ����� �������������� ���� ���������� ����� ����� �������� ���-
-- ������� ���� ���������_�������; ������, ������ (����2008) �������, ��� �� 
-- ������������ ���� ���������� ����� "TimeGap" ������ ����� ����� �������� 
-- ���������� ���� ���������_�������.  
--   UpLink ���������� ���� ����� ����� "TimeGap" ������ ����� (�� ������ 
-- ��������) ����� ��������� ���������� ���� ���������_�������.  ��������, ���
-- � UpLink-� ������� ����������� ����� ����, ��� ���� OpCode (������ - 8���) 
-- ������� �� ������� ��������� �������, ���� ������ � UpLink-� ������� �� 
-- ����� ������ � DnLink-� !  
CONSTANT  TimeGap       = 8;  -- ����� �� ����������� ������ ����������� �� ��������� ������ ���������
CONSTANT  BitOfReverse  = Command_Size + Pause +    --\ Command is transmitted
        ((WordsToGoDown + 1 ) * (Word_Width+Pause)) -- >InData,[Data words] are transmitted
        + TimeGap ;                                 --/ Time gap 
    --  ^^^^^^^^ DnLink disables its transmitter by "TimeGap" clocks after 
    --  last bit of CommandSequience is transmitted.
    --  Since clock count in UpLink is delayed from that in DnLink, then 
    --  UpLink actually enables its transmitter by 8clocks later than DnLink
    --  disables its transmitter. 

    --CONSTANT BitOfAnswerStart = BitOfReverse + COMMAND_SIZE; -- ����� ���� ������ ��������������� ���������� ���� �������� �������
    --   TimeGap must be instead of CommandSize ! ^^^^^^^^^^
-- ����� UpLink ���������� ���� �����, � ���� ������ ����� ���������� ������ =>
-- => ��������_������� ������ ���������� ��� ����� "TimeGap" ������ ����� 
-- ��������� ������ UpLink-�;  � � ����� ������� (+ ���� ������ ��������) 
-- DownLink ������ �������� ������ ��������_�������.
CONSTANT BitOfAnswerStart = BitOfReverse + TimeGap; -- ����� ���� ������ ��������������� ���������� ���� �������� �������

CONSTANT HeaderSize     = Command_Size + Pause      --\ size of ..
                        + Word_Width + Pause ;      --/ .. RE-TRANSMITTED part of the Reply_Sequience
CONSTANT MaxNumberOfBit = BitOfAnswerStart+HeaderSize+WordsToGoUp*(WORD_WIDTH+PAUSE); -- ����� ����� ������
CONSTANT OrderOfBitNumber = FLOOR(LOG2(MaxNumberOfBit))+1;  -- ����������� ������� ��������

--************ UpLink ************
Constant  Dead_Time     = 200;  -- ns, ������� ����� - �������� ���������� �� ����� ����� �� ������ ����������, �������� RefClock. 
CONSTANT  Bit_of_Header_UP_Reload = BitOfAnswerStart + COMMAND_SIZE + PAUSE; -- ����� ���� � ����� ������ �������� Up Link-�, �� �������� ���������� �������� ������� �����. ������� Up Link-� �������� ������� ����� ��������� �������
CONSTANT  Bit_of_CRC_Reload = BitOfAnswerStart+HeaderSize+(WordsToGoUp-1)*((WORD_WIDTH+PAUSE)); -- ����� ���� � ����� ������ �������� Up Link-�, �� �������� ���������� �������� ����������� ����� (CRC)

--************ DownLink ************
CONSTANT Bit_of_Header_DOWN_Reload = COMMAND_SIZE+PAUSE + 1 ;

-- ����� ���� �� �������� DownLink-�, � �������� �������� �������� ���.�������. 
--CONSTANT BitOfAnswerWindowStart = BitOfReverse + COMMAND_SIZE*2; -- ����� ���� � ����� ������ �������� Down Link-�, �� �������� ���������� �������� �������� �������. 
CONSTANT BitOfAnswerWindowStart = BitOfAnswerStart+2  -- UpLink starts to reply 
                    + (Command_Size+Pause) ;    -- delay of UpLink's countdown

-- ����� ���� �� �������� DownLink-�, �� ���. ����������� �������� ���.�������. 
-- ��������� ��������� � ��� ����� ������ �� ����� ?15 ������.
--CONSTANT BitOfAnswerWindowEnd   = BitOfAnswerStart + COMMAND_SIZE*3;-- ����� ���� � ����� ������ �������� Down Link-�, �� �������� ������������� �������� �������� �������. ��������� ��������� � ��� ����� ������ �� ����� 15 ������.
CONSTANT BitOfAnswerWindowEnd   = BitOfAnswerStart+10
                    + (COMMAND_SIZE+Pause)      -- catch OpCode into Register
                    + (COMMAND_SIZE+Pause) ;    -- delay of UpLink's countdown


--****************************************************************************
-- Command Layer Constants, text description continued
-- �������, �������������� ��������, ����� ��������
-- ������ ����� ������, ������� ������ �������� ����� � ��� ���-3
Constant CMDL_Cfg_Read		=	B"10000010";    -- ������ ������ �����������
Constant CMDL_Cfg_Write		=	B"10001001";	-- ������ � ������ �����������

Constant CMDL_Exe_Read_000	=	B"11000001";	-- ������ 0
Constant CMDL_Exe_Read_010	=	B"11010010";	-- ������ 1  Start_Regular
Constant CMDL_Exe_Read_100	=	B"11100010";	-- ������ 2  Start_Alternative
Constant CMDL_Exe_Read_110	=	B"11110001";	-- ������ 3

Constant CMDL_Exe_Write_001	=	B"11001010";	-- ������ 0
Constant CMDL_Exe_Write_011	=	B"11011001";	-- ������ 1
Constant CMDL_Exe_Write_101	=	B"11101001";	-- ������ 2
Constant CMDL_Exe_Write_111	=	B"11111010";	-- ������ 3
-- CMDL is acronim of CoMmanD Layer
% ������ ��� (�6) (����� ����������) ���������� HIHG=> ����������� ������� LOW=>����������������
��� ���� (�5 � �4) ���� ����� ���������� ����� �, ��������������, ��� �3 - ��� ����� �� ������/������.
��� �2 �������������� ��� ���������� ���� ������.
%

--============================================================================
-- � ������ �������� �������� �������� � �������� �������� � �������� �������:

-- Transaction Layer Constants - ��������� ��������� ��������� �����������������
--  �����, text description file - DAQ_DTR.doc
CONSTANT  CommandSize   = Command_Size; -- ������ ������� ( 1_Start + 5_OpCode + 2 ���.�� ����������/��� ��������)
CONSTANT  WordSize      =   Word_Width; -- ������ ����� ������
CONSTANT  DeadTime      =    Dead_Time; -- ns, ������� ����� - �������� ���������� �� ����� ����� �� ������ ����������, �������� RefClock. 

-- ��������� - ��������� ��������� ���������������� �����, ������� �����������,
-- �������� (������) ������������ ���������� ������ ���-3
-- Common Constants
CONSTANT Bit_Rx2Tx      = BitOfReverse ;     -- ��������� ������ UpLink-�
CONSTANT Bit_ReplyStart = BitOfAnswerStart;  -- ����� �����, �� ������� ���������� StartBit �������� �������


-- Command Layer Constants, text description continued
-- �������, �������������� ��������, ����� ��������
-- ������ ����� ������, ������� ������ �������� ����� � ��� ���-3
Constant Read   = CMDL_Cfg_Read;    --B"10000010"=130 Read 62 words from Object(s)
Constant Write  = CMDL_Cfg_Write;   --B"10001001"=137 Write 8 words to Object(s)
Constant Read1  = B"10010001";      -- =145 Read 1 word from an Object
Constant Write1 = B"10011010";      -- =153 Write 1 word to an Object

Constant StartRegul     = CMDL_Exe_Read_000;--B"11000001"=193 ������ 0  Start_Regular
Constant StartAlter     = CMDL_Exe_Read_010;--B"11010010"=210 ������ 1  Start_Alternative
Constant CommdLst_Rd100 = CMDL_Exe_Read_100;--B"11100010"=226 ������ 2
Constant CommdLst_Rd110 = CMDL_Exe_Read_110;--B"11110001"=241 ������ 3

Constant CommdLst_Wr001 = CMDL_Exe_Write_001;   --B"11001010"=202 ������ 0
Constant CommdLst_Wr011 = CMDL_Exe_Write_011;   --B"11011001"=217 ������ 1
Constant CommdLst_Wr101 = CMDL_Exe_Write_101;   --B"11101001"=233 ������ 2
Constant CommdLst_Wr111 = CMDL_Exe_Write_111;   --B"11111010"=250 ������ 3

