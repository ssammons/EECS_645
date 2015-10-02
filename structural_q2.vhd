LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY arbiter_struct_2cons IS
	PORT(
		REQ_01 : IN		std_logic;
		REQ_02 : IN		std_logic;
		clk	: IN		std_logic;
		rst : IN		std_logic;
		ACK_01 : OUT	std_logic;
		ACK_02 : OUT	std_logic;
		);
END arbiter_struct_2cons;

ARCHITECTURE struct_q1 OF arbiter_struct_2cons IS

	--Declare current and next state signals
	SIGNAL s1_current, s2_current : std_logic;
	SIGNAL s1_next   , s2_next	  : std_logic;
	
BEGIN

	memory_elements : PROCESS(clk, rst)
	
	BEGIN
		IF (rst = '1') THEN
			s1_current <= '0';
			s2_current <= '0';
		ELSEIF (clk'EVENT AND clk = '1') THEN
			s1_current <= s1_next;
			s2_current <= s2_next;
		END IF;
	END PROCESS memory_elements;
	
	s1_next <= (REQ_01 and (not s1_current) and (not s2_current)) or
				(REQ_01 and s1_current and (not s2_current));
	s2_next <= (REQ_02 and (not REQ_01) and (not s1_current)) or
				(REQ_02 and s2_current and (not s1_current));
				
				
	ACK_01 <= s1_current and (not s2_current);
	ACK_02 <= s2_current and (not s1_current);
	
END struct_q1;
	