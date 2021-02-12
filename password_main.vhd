library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
entity keyboardbuttontrainer is
    Port (        
           CLK100MHZ : in STD_LOGIC;
           PS2_DATA : in std_logic;
           PS2_CLK : in std_logic;
           BTNC : in std_logic;
           BTNU : in std_logic;
           BTND : in std_logic;
           SW : in std_logic_vector(8 downto 0);
           LED16_B : out std_logic;
           LED16_G : out std_logic;
           LED16_R : out std_logic;
           LED : out STD_LOGIC_VECTOR(15 downto 0));

end keyboardbuttontrainer;

architecture Behavioral of keyboardbuttontrainer is
    TYPE machine IS(showthesevenbit, oldbitfall, passwort,kontoistaktiv);
    signal state       : machine;
    signal keyboardclk1  : std_logic;
    signal keyboardclk2  : std_logic;
    signal keyboardcounter : unsigned(7 downto 0);
    signal psbitplace : std_logic_vector(7 downto 0);
    signal bitadder : std_logic_vector(15 downto 0):="0000011111010000";
    signal firstfall : std_logic_vector(15 downto 0):="0000011111010000";
    signal fiftyadder : std_logic_vector(15 downto 0):="0000000000110010";
    signal locker  : std_logic_vector(3 downto 0);
    signal a_neuer1, a_alter1: std_logic;
    signal a_neuer2, a_alter2, finisher: std_logic;


begin
    Counterprozess: process(CLK100MHZ,SW,keyboardcounter,psbitplace)
    begin
        if rising_edge(CLK100MHZ) then
                    keyboardclk2  <= keyboardclk1;
                    keyboardclk1  <= PS2_CLK;
                    if keyboardclk1 = '1' and keyboardclk2 = '0' then
                        keyboardcounter <= keyboardcounter + 1;     
                        if    keyboardcounter = 0  then
                            elsif keyboardcounter = 1  then
                                psbitplace(0) <= PS2_DATA;
                            elsif keyboardcounter = 2  then
                                psbitplace(1) <= PS2_DATA;
                            elsif keyboardcounter = 3  then
                                psbitplace(2) <= PS2_DATA;
                            elsif keyboardcounter = 4  then
                                psbitplace(3) <= PS2_DATA;
                            elsif keyboardcounter = 5  then
                                psbitplace(4) <= PS2_DATA;
                            elsif keyboardcounter = 6  then
                                psbitplace(5) <= PS2_DATA;
                            elsif keyboardcounter = 7  then
                                psbitplace(6) <= PS2_DATA;
                            elsif keyboardcounter = 8  then
                                psbitplace(7) <= PS2_DATA;
                            elsif keyboardcounter = 9  then
                            elsif keyboardcounter = 10 then
                                keyboardcounter <= (others => '0');           
                            end if;
                        end if;
                        a_alter1 <= a_neuer1;
                        a_neuer1 <= BTNU;
                        a_alter2<=a_neuer2;
                        a_neuer2<=BTND;
                        if ( (a_alter1='0') and (a_neuer1='1') ) then
                                bitadder<=bitadder+fiftyadder;
                                end if;
                            if ( (a_alter2='0') and (a_neuer2='1') ) then
                                bitadder<=bitadder-fiftyadder;
                            end if;                    		                         
  
    if SW(3 downto 0)="0010"then
        state<=showthesevenbit;
    
    elsif SW(3 downto 0)="0100"then
        state<=oldbitfall;
    end if;
    		case psbitplace(7 downto 0) IS
				when "11101010" => --pageup
					bitadder<=bitadder + fiftyadder;
				when "11100100" => --pagedown
					bitadder<=bitadder-fiftyadder;
				when "10110100" => --enter
					bitadder<=bitadder;
				when "01011000" => --t
				    locker(3)<='1';
				when "00111000" => --a
				    locker(2)<='1';
				when "01011010" => --r
				    locker(1)<='1';	
				when "10000100" => --k
				    locker(0)<='1';
				when others =>
					psbitplace(7 downto 0) <=(others=> '0');
				end case;
    case state is      
        when showthesevenbit=>          
             LED <= std_logic_vector(bitadder(15 downto 0));
             if BTNC = '1' then
                state<=passwort;
                end if;
        when oldbitfall=>
                LED16_B <='1';
                LED16_G <='0';
                LED16_R <='0';
                LED<=std_logic_vector(firstfall(15 downto 0));  
                if BTNC='1' then
                    state<=passwort;
                    end if;            
        when passwort =>
                LED16_B <='0';
                LED16_G <='0';
                LED16_R <='1'; 
                if(SW(7 downto 4)="1001") or locker(3 downto 0)="1111"then 
                    locker(3 downto 0)<="0000";
                    state <=kontoistaktiv;
                    end if;
        
        when kontoistaktiv=>
                if SW(8 downto 4)="11001" then
                    state<=showthesevenbit;
                    end if;
        end case;                   
        end if;       
end process;
end Behavioral;
