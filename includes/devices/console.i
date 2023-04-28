	IFND	DEVICES_CONSOLE_I
DEVICES_CONSOLE_I	SET	1
**
**	$VER: console.i 47.2 (12.01.2020)
**
**	Console device command definitions
**
**	Copyright (C) 2019 Hyperion Entertainment CVBA.
**	    Developed under license.
**

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC

	IFND	EXEC_IO_I
	INCLUDE	"exec/io.i"
	ENDC	; EXEC_IO_I

******* Console commands *******
	DEVINIT

	DEVCMD	CD_ASKKEYMAP
	DEVCMD	CD_SETKEYMAP
	DEVCMD	CD_ASKDEFAULTKEYMAP
	DEVCMD	CD_SETDEFAULTKEYMAP
	DEVCMD	CD_SETUPSCROLLBACK
	DEVCMD	CD_SETSCROLLBACKPOSITION

******* SGR parameters

SGR_PRIMARY	EQU	0
SGR_BOLD	EQU	1
SGR_ITALIC	EQU	3
SGR_UNDERSCORE	EQU	4
SGR_NEGATIVE	EQU	7

SGR_NORMAL	EQU	22	; default foreground color, not bold
SGR_NOTITALIC	EQU	23
SGR_NOTUNDERSCORE EQU	24
SGR_POSITIVE	EQU	27

*  these names refer to the ANSI standard, not the implementation
SGR_BLACK	EQU	30
SGR_RED		EQU	31
SGR_GREEN	EQU	32
SGR_YELLOW	EQU	33
SGR_BLUE	EQU	34
SGR_MAGENTA	EQU	35
SGR_CYAN	EQU	36
SGR_WHITE	EQU	37
SGR_DEFAULT	EQU	39

SGR_BLACKBG	EQU	40
SGR_REDBG	EQU	41
SGR_GREENBG	EQU	42
SGR_YELLOWBG	EQU	43
SGR_BLUEBG	EQU	44
SGR_MAGENTABG	EQU	45
SGR_CYANBG	EQU	46
SGR_WHITEBG	EQU	47
SGR_DEFAULTBG	EQU	49

*  these names refer to the implementation, they are the preferred
*  names for use with the Amiga console device.
SGR_CLR0	EQU	30
SGR_CLR1	EQU	31
SGR_CLR2	EQU	32
SGR_CLR3	EQU	33
SGR_CLR4	EQU	34
SGR_CLR5	EQU	35
SGR_CLR6	EQU	36
SGR_CLR7	EQU	37

SGR_CLR0BG	EQU	40
SGR_CLR1BG	EQU	41
SGR_CLR2BG	EQU	42
SGR_CLR3BG	EQU	43
SGR_CLR4BG	EQU	44
SGR_CLR5BG	EQU	45
SGR_CLR6BG	EQU	46
SGR_CLR7BG	EQU	47


******   DSR parameters

DSR_CPR		EQU	6

******   CTC parameters
CTC_HSETTAB	EQU	0
CTC_HCLRTAB	EQU	2
CTC_HCLRTABSALL	EQU	5

******   TBC parameters
TBC_HCLRTAB	EQU	0
TBC_HCLRTABSALL	EQU	3

******   SM and RM parameters
M_LNM		EQU	20	; linefeed newline mode
M_ASM	MACRO
		DC.B	'>1'	; auto scroll mode
	ENDM
M_AWM	MACRO
		DC.B	'?7'	; auto wrap mode
	ENDM

******   ConsoleScrollback structure for setting up scrollback
 STRUCTURE  ConsoleScrollback,0
   APTR    cs_ScrollerGadget		; Pointer to scroller.gadget BOOPSI gadget
   UWORD   cs_NumLines		; Number of scrollback lines to reserve space for

   ALIGNWORD
   LABEL   ConsoleScrollback_SIZEOF


	ENDC	; DEVICES_CONSOLE_I
