library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab2tb is
end entity Lab2tb;

architecture behavior of Lab2tb is

    component Lab2 is
        port (
            i_sw1 : in  STD_LOGIC;
            i_sw2 : in  STD_LOGIC;
            o_led : out STD_LOGIC
        );
    end component;

    signal i_sw1 : STD_LOGIC := '1';
    signal i_sw2 : STD_LOGIC := '1';
    signal o_led : STD_LOGIC;

begin

    uut: Lab2 port map (
        i_sw1 => i_sw1,
        i_sw2 => i_sw2,
        o_led => o_led
    );

    stim_proc: process
    begin

        -- Không nhấn SW1, không nhấn SW2
        i_sw1 <= '1';
        i_sw2 <= '1';
        wait for 10 ns;

        -- Nhấn SW1
        i_sw1 <= '0';
        i_sw2 <= '1';
        wait for 10 ns;

        -- Nhấn SW2
        i_sw1 <= '1';
        i_sw2 <= '0';
        wait for 10 ns;

        -- Nhấn cả SW1 và SW2
        i_sw1 <= '0';
        i_sw2 <= '0';
        wait for 10 ns;

        wait;
    end process;

end architecture behavior;