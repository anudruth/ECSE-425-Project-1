library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Do not modify the port map of this structure
entity comments_fsm is
port (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
      output : out std_logic
  );
end comments_fsm;

architecture behavioral of comments_fsm is

-- The ASCII value for the '/', '*' and end-of-line characters
constant SLASH_CHARACTER : std_logic_vector(7 downto 0) := "00101111";
constant STAR_CHARACTER : std_logic_vector(7 downto 0) := "00101010";
constant NEW_LINE_CHARACTER : std_logic_vector(7 downto 0) := "00001010";

type state is (s0, s1, s2, s3, s4);
signal current_state: state;

begin

-- Insert your processes here
process (clk, reset)
begin
    if (reset = '1') then 
	current_state <= s0;
    elsif rising_edge(clk) then
	case current_state is
		when s0 =>
			if (input = SLASH_CHARACTER) then			--first slash of a comment
				current_state <= s1;
			end if;
			output <= '0';
		when s1 => 
			if (input = SLASH_CHARACTER) then			--second slash of a comment
				current_state <= s2;
			elsif (input = STAR_CHARACTER) then			--star after slash of a comment
				current_state <= s3;
			else 
				current_state <= s0;
			end if;
			output <= '0';
		when s2 =>
			if (input = NEW_LINE_CHARACTER) then			-- newline char end of single line comment
				current_state <= s0;
			end if;
			output <= '1';
		when s3 =>
			if (input = STAR_CHARACTER) then			-- star of comment close
				current_state <= s4;
			end if;
			output <= '1';
		when s4 =>
			if (input = SLASH_CHARACTER) then			-- slash of comment close
				current_state <= s0;
			else
				current_state <= s3;
			end if;
			output <= '1';
	end case;
    end if;
end process;

end behavioral;