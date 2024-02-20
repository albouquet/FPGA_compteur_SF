   
Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lab2 is
	port (
		clk_clk       : in std_logic ;
		reset_reset_n : in std_logic ;  -- reset_n
		afficheur1    : out std_logic_vector(6 downto 0);
		afficheur2    : out std_logic_vector(6 downto 0);
		afficheur3    : out std_logic_vector(6 downto 0)
	);
end entity lab2;


architecture arch_albouquet_lab2 of lab2 is


	component qsys_lab2 is
        port (
            clk_clk                          : in  std_logic                    := 'X'; -- clk
            pio_0_external_connection_export : out std_logic_vector(3 downto 0);        -- export
            pio_1_external_connection_export : out std_logic_vector(3 downto 0);        -- export
            pio_2_external_connection_export : out std_logic_vector(3 downto 0);        -- export
            reset_reset_n                    : in  std_logic                    := 'X'  -- reset_n
        );
    end component qsys_lab2;
	 
	component segdecod is
		port (
				Entree:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
				Sortie:OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
			);
	end component segdecod;

    signal segment_vers_decod1 : std_logic_vector(3 downto 0);
    signal segment_vers_decod2 : std_logic_vector(3 downto 0);
    signal segment_vers_decod3 : std_logic_vector(3 downto 0);

    begin

    u0 : component qsys_lab2
        port map (
            clk_clk                          => clk_clk,                          --                       clk.clk
            pio_0_external_connection_export => segment_vers_decod1, -- pio_0_external_connection.export
            pio_1_external_connection_export => segment_vers_decod2, -- pio_1_external_connection.export
            pio_2_external_connection_export => segment_vers_decod3, --pio_2_external_connection.export
            reset_reset_n                    => reset_reset_n                     --                     reset.reset_n
        );

	u1 : component segdecod
		port map(
			  Entree => segment_vers_decod1,
			  Sortie => afficheur1
	);

	u2 : component segdecod
		port map(
			  Entree => segment_vers_decod2,
			  Sortie => afficheur2
	);

	u3 : component segdecod
		port map(
			  Entree => segment_vers_decod3,
			  Sortie => afficheur3
	);

end architecture arch_albouquet_lab2;