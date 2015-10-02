LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY arbiter_behav_2cons IS
	PORT(
		REQ_01 : IN		std_logic;
		REQ_02 : IN		std_logic;
		clk	: IN		std_logic;
		rst : IN		std_logic;
		ACK_01 : OUT	std_logic;
		ACK_02 : OUT	std_logic;
		);
END arbiter_behav_2cons;

ARCHITECTURE behav_q2 OF arbiter_behav_2cons IS
	
	SUBTYPE STATE_TYPE IS
		std_logic_vector(1 DOWNTO 0);
		
	CONSTANT NO_ACCESS : STATE_TYPE := "00" ;
	CONSTANT Con_01 : STATE_TYPE := "10" ;
	CONSTANT Con_02 : STATE_TYPE := "01" ;
	CONSTANT Unused : STATE_TYPE := "11" ;
	
	--Declare current and next state signals
	SIGNAL current_state : STATE_TYPE;
	SIGNAL next_state	  : STATE_TYPE;
	
	SIGNAL REQ_VEC : std_logic_vector(1 TO 2);
	
BEGIN

	REQ_VEC <= (REQ_01 & REQ_02);

	memory_elements : PROCESS(clk, rst)
	
	BEGIN
		IF (rst = '1') THEN
			current_state <= NO_ACCESS;
		ELSIF (clk'EVENT AND clk = '1') THEN
			current_state <= next_state;
		END IF;
	END PROCESS memory_elements;
	
	std_logic : PROCESS (REQ_VEC, current_state)
	BEGIN
		CASE current_state IS
		WHEN NO_ACCESS =>
			next_state <= NO_ACCESS;
			IF(REQ_VEC = "10") THEN
				next_state <= Con_01;
			END IF;
			IF (REQ_VEC = "01") THEN
				next_state <= Con_02;
			END IF;
			IF (REQ_VEC = "11") THEN
				next_state <= Con_01;
			END IF;
		WHEN Con_01 =>
			next_state <= Con_01;
			IF (REQ_VEC(1) = '0') THEN
				next_state <= NO_ACCESS;
			END IF;
		WHEN Con_02 =>
			next_state <= Con_02;
			IF (REQ_VEC(2) = '0') THEN
				next_state <= NO_ACCESS;
			END IF;
		WHEN OTHERS =>
			next_state <= NO_ACCESS;
		END CASE;
	END PROCESS state_logic;
	
	
	output_logic : PROCESS (current_state)
	
	
	BEGIN
		CASE current_state IS
		WHEN Con_01 =>
			ACK_01 <= '1';
			ACK_02 <= '0';
		WHEN Con_02 =>
			ACK_01 <= '0';
			ACK_02 <= '1';
		WHEN Con_02 AND Con_01 =>
			ACK_01 <= '1';
			ACK_02 <= '0';
		WHEN OTHERS =>
			ACK_01 <= '0';
			ACK_02 <= '0';
		END CASE;
	END PROCESS output_logic;
END behav_q2;
	