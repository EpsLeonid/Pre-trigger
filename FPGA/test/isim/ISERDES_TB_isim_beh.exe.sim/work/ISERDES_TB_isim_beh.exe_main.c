/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *IEEE_P_1242562249;
char *IEEE_P_3972351953;
char *WORK_P_4063998017;
char *UNISIM_P_0947159679;
char *STD_TEXTIO;
char *IEEE_P_2717149903;
char *IEEE_P_1367372525;
char *UNISIM_P_3222816464;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    ieee_p_1242562249_init();
    unisim_p_0947159679_init();
    ieee_p_3972351953_init();
    work_p_4063998017_init();
    std_textio_init();
    ieee_p_2717149903_init();
    ieee_p_1367372525_init();
    unisim_p_3222816464_init();
    work_a_4045686629_0723146391_init();
    unisim_a_0780662263_2014779070_init();
    unisim_a_0024261610_3824467259_init();
    work_a_1726107589_0723146391_init();
    work_a_1668651142_3212880686_init();
    unisim_a_1490675510_1976025627_init();
    unisim_a_4167558488_0695499473_init();
    unisim_a_0897948483_3703648270_init();
    unisim_a_0420191103_3703648270_init();
    unisim_a_0435408399_0783196562_init();
    unisim_a_2135327287_0551479669_init();
    work_a_1083492987_3212880686_init();
    work_a_2488165853_0723146391_init();
    work_a_2428705135_0723146391_init();
    work_a_2034482155_0723146391_init();
    work_a_2010541152_0723146391_init();
    unisim_a_2980906280_0725860537_init();
    unisim_a_0829869457_4066649594_init();
    work_a_2432791384_0723146391_init();
    work_a_3919356867_3212880686_init();
    work_a_1951916075_0723146391_init();
    work_a_1570451216_3212880686_init();
    work_a_0607142070_2372691052_init();


    xsi_register_tops("work_a_0607142070_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    IEEE_P_3972351953 = xsi_get_engine_memory("ieee_p_3972351953");
    WORK_P_4063998017 = xsi_get_engine_memory("work_p_4063998017");
    UNISIM_P_0947159679 = xsi_get_engine_memory("unisim_p_0947159679");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_2717149903 = xsi_get_engine_memory("ieee_p_2717149903");
    IEEE_P_1367372525 = xsi_get_engine_memory("ieee_p_1367372525");
    UNISIM_P_3222816464 = xsi_get_engine_memory("unisim_p_3222816464");

    return xsi_run_simulation(argc, argv);

}
